---@diagnostic disable: duplicate-set-field

--- gets the cache path for a namespace and within that given function and args
--- @param fnid string
--- @param opts_as_str? string
--- @param args? any[]
function getFsCachePath(fnid, opts_as_str, args)
  local path = transf.func

  if opts_as_str then
    path = path .. opts_as_str .. "/"
  end
  if args then 
    -- encode args to json and hash it, to use as the key for the cache
    local hash = transf.not_userdata_or_function.md5_hex_string(args)
    path = path .. hash
  end
  return path
end


-- Define a table with methods for cache storage in memory and filesystem
local gen_cache_methods = {
  mem = {
    put = function(fnid, opts_as_str, params, result, opts)
      memstore[fnid] = memstore[fnid] or {}
      memstore[fnid][opts_as_str] = memstore[fnid][opts_as_str] or {}
      local node = memstore[fnid][opts_as_str]
      for i=1, #params do
        local param = params[i]
        if param == nil then param = nil_singleton 
        elseif opts.stringify_table_params and type(param) == "table" then
          if opts.table_param_subset == "json" then
            param = json.encode(param)
          elseif opts.table_param_subset == "no-fn-userdata-loops" then
            param = shelve.marshal(param)
          elseif opts.table_param_subset == "any" then
            param = hs.inspect(param, { depth = 4 })
          end
        end
        node.children = node.children or {}
        node.children[param] = node.children[param] or {}
        node = node.children[param]
      end
      node.results = get.table.table_by_copy(result, true)
    end,
    get = function(fnid, opts_as_str, params, opts)
      memstore[fnid] = memstore[fnid] or {}
      memstore[fnid][opts_as_str] = memstore[fnid][opts_as_str] or {}
      local node = memstore[fnid][opts_as_str]
      for i=1, #params do
        local param = params[i]
        if param == nil then param = nil_singleton 
        elseif opts.stringify_table_params and type(param) == "table" then
          if opts.table_param_subset == "json" then
            param = json.encode(param)
          elseif opts.table_param_subset == "no-fn-userdata-loops" then
            param = shelve.marshal(param)
          elseif opts.table_param_subset == "any" then
            param = hs.inspect(param, { depth = 4 })
          end
        end
        node = node.children and node.children[param]
        if not node then return nil end
      end
      return get.table.table_by_copy(node.results, true)
    end,
    reset = function(fnid, opts_as_str)
      memstore[fnid] = memstore[fnid] or {}
      memstore[fnid][opts_as_str] = {}
    end,
    get_created_time = function() -- no special functionality here, just needs to exist for polymorphic implementation with fscache
      return os.time()
    end
  },
  fs = {
    put = function(fnid, opts_as_str, params, result, opts)
      local cache_path = getFsCachePath(fnid, opts_as_str, params)
      dothis.absolute_path.write_file(cache_path, json.encode(result))
    end,
    get = function(fnid, opts_as_str, params, opts)
      local cache_path = getFsCachePath(fnid, opts_as_str, params)
      local raw_cnt = transf.file.contents(cache_path)
      if not raw_cnt then return nil end
      return json.decode(raw_cnt)
    end,
    reset = function(fnid, opts_as_str)
      local cache_path = getFsCachePath(fnid, opts_as_str)
      dothis.absolute_path.delete(cache_path)
    end,
    get_created_time = function(fnid, opts_as_str)
      local cache_path = getFsCachePath(fnid, opts_as_str, "~~~created~~~") -- this is a special path that is used to store the time the cache was created
      return get.string_or_number.number_or_nil(transf.file.contents(cache_path)) or os.time() -- if the file doesn't exist, return the current time
    end,
    set_created_time = function(fnid, opts_as_str, created_time)
      dothis.absolute_path.write_file(getFsCachePath(fnid, opts_as_str, "~~~created~~~"), tostring(created_time))
    end
  }
}

--- @class memoOpts
--- @field is_async? boolean whether we are memoizing an async function. Defaults to false
--- @field invalidation_mode? "invalidate" | "reset" | "none" whether and in what way to invalidate the cache. Defaults to "none"
--- @field interval? number how often to invalidate the cache, in seconds. Defaults to 0
--- @field stringify_table_params? boolean whether to stringify table params before using them as keys in the cache. Defaults to false. However, this is ignored if mode = "fs", as we need to stringify the params to use them as a path
--- @field table_param_subset? "json" | "no-fn-userdata-loops" | "any" whether table params that will be stringified will only contain jsonifiable values, anything that a lua table can contain but functions, userdata, and loops, or anything that a lua table can contain. Speed: "json" > "no-fn-userdata-loops" > "any". Defaults to "json"

--- memoize a function if it's not already memoized, or return the memoized version if it is
--- @generic I, O
--- @param fn fun(...: I): O
--- @param opts? memoOpts
--- @param funcname? string the name of the function. Optional, but required if mode = "fs", since we need to use the function name to create a unique cache path. We can't rely on an automatically generated identifier, since this may change between sessions
--- @return fun(...: I): O, hs.timer?
function memoize(fn, opts, funcname)
  local fnid = funcname or transf.fn.fnid(fn) -- get a unique id for the function, using lua's tostring function, which uses the memory address of the function and thus is unique for each function

  local opts_as_str_or_nil
  if memoized[fnid] then 
    return memoized[fnid]
  elseif opts == nil then
    -- no-op: we only need to make the else block isn't executed if opts is nil, since that will result in an infinite loop
  else
    opts_as_str_or_nil = memoize(json.encode)(opts)
    if memoized_w_opts[fnid] then
      if memoized_w_opts[fnid][opts_as_str_or_nil] then -- if the function is already memoized with the same options, return the memoized version.  This allows us to use memoized functions immediately as `memoize(fn)(...)` without having to assign it to a variable first
        return memoized_w_opts[fnid][opts_as_str_or_nil]
      end
    else
      memoized_w_opts[fnid] = {}
    end
  end

  local opts_as_str = opts_as_str_or_nil or "noopts"

  --- set default options
  opts = get.table.table_by_copy(opts) or {}
  local mode = funcname and "fs" or "mem"
  opts.is_async = get.any.default_if_nil(opts.is_async, false)
  opts.invalidation_mode = opts.invalidation_mode or "none"
  opts.interval = opts.interval or 0
  opts.stringify_table_params = get.any.default_if_nil(opts.stringify_table_params, false)
  opts.table_param_subset = opts.table_param_subset or "json"

  -- initialize the cache if using memory
  if mode == "mem" then
    memstore[fnid] = memstore[fnid] or {}
  end
  
  -- create some variables that will be used later

  local cache_methods = gen_cache_methods[mode]
  local timer
  
  local created_at = cache_methods.get_created_time(fnid, opts_as_str)

  -- create a timer to invalidate the cache if needed
  if opts.invalidation_mode == "reset" then
    timer = hs.timer.doEvery(opts.interval, function()
      cache_methods.reset(fnid, opts_as_str)
    end)
  end

  -- create the memoized function
  local memoized_func = function(...)
    local params = {...}
    local callback = nil
    if opts.is_async then -- assume that async functions always have a callback as the last argument
      callback = params[#params]
      params[#params] = nil
    end 



    local result 

    if opts.invalidation_mode == "invalidate" then
      if created_at + opts.interval < os.time() then -- cache is invalid, so we need to recalculate
        cache_methods.reset(fnid)
        if mode == "fs" then
          cache_methods.set_created_time(fnid, opts_as_str, os.time())
        end
        created_at = os.time()
      end

    else

      -- get the result from the cache
      result = cache_methods.get(fnid, opts_as_str, params, opts)
    end

    if not opts.is_async then
      if not result then  -- no result yet, so we need to call the original function and store the result in the cache
        -- print("cache miss for", fnid)
        result = { fn(...) }
        cache_methods.put(fnid, opts_as_str, params, result, opts)
      else
        -- print("cache hit for", fnid)
        -- inspPrint(result)
      end
      return table.unpack(result) -- we're sure to have a result now, so we can return it
    else
      if result then -- if we have a result, we can call the callback immediately
        callback(table.unpack(result))
      else -- else we need to call the original function and wrap the callback to store the result in the cache before calling it
        fn(table.unpack(params), function(...)
          local result = {...}
          cache_methods.put(fnid, opts_as_str, params, result, opts)
          callback(table.unpack(result))
        end)
      end
    end
  end
  if opts_as_str_or_nil == nil then
    memoized[fnid] = memoized_func
  else
    memoized_w_opts[fnid][opts_as_str] = memoized_func
  end
  return memoized_func, timer
end