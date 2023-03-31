---@diagnostic disable: duplicate-set-field

--- gets the cache path for a namespace and within that given function and args
--- @param name string
--- @param func_id string
--- @param args? any[]
function getFsCachePath(name, func_id, args)
  local path = env.XDG_CACHE_HOME .. "/" .. name .. "/" .. func_id .. "/"
  if args then 
    -- encode args to json and hash it, to use as the key for the cache
    local jsonified_args = json.encode(args)
    local md5 = hashings("md5")
    md5:update(jsonified_args)
    local hash = md5:hexdigest()
    path = path .. hash
  end
  return path
end


local memstore = {}
memoized = {}

-- Define a table with methods for cache storage in memory and filesystem
local gen_cache_methods = {
  mem = {
    put = function(fnid, params, result)
      local node = memstore[fnid]
      for i=1, #params do
        local param = params[i]
        node.children = node.children or {}
        node.children[param] = node.children[param] or {}
        node = node.children[param]
      end
      node.results = result
    end,
    get = function(fnid, params)
      local node = memstore[fnid]
      for i=1, #params do
        node = node.children and node.children[params[i]]
        if not node then return nil end
      end
      return node.results
    end,
    reset = function(fnid)
      memstore[fnid] = {}
    end,
    get_created_time = function() -- no special functionality here, just needs to exist for polymorphic implementation with fscache
      return os.time()
    end
  },
  fs = {
    put = function(fnid, params, result)
      local cache_path = getFsCachePath("fsmemoize", fnid, params)
      writeFile(cache_path, json.encode(result), "any", true)
    end,
    get = function(fnid, params)
      local cache_path = getFsCachePath("fsmemoize", fnid, params)
      local raw_cnt = readFile(cache_path)
      if not raw_cnt then return nil end
      return json.decode(raw_cnt)
    end,
    reset = function(fnid)
      local cache_path = getFsCachePath("fsmemoize", fnid)
      delete(cache_path)
    end,
    get_created_time = function(fnid)
      local cache_path = getFsCachePath("fsmemoize", fnid, "~~~created~~~") -- this is a special path that is used to store the time the cache was created
      return tonumber(readFile(cache_path)) or os.time() -- if the file doesn't exist, return the current time
    end,
    set_created_time = function(fnid, created_time)
      writeFile(getFsCachePath("fsmemoize", fnid, "~~~created~~~"), tostring(created_time), "any", true)
    end

  }
}


--- @class memoOpts
--- @field mode? "mem" | "fs" whether to use memory or filesystem to store the cache. Fs cache is more persistent, but slower. Defaults to "mem"
--- @field is_async? boolean whether we are memoizing an async function. Defaults to false
--- @field invalidation_mode? "invalidate" | "reset" | "none" whether and in what way to invalidate the cache. Defaults to "none"
--- @field interval? number how often to invalidate the cache. Defaults to 0

--- memoize a function if it's not already memoized, or return the memoized version if it is
--- @generic I, O
--- @param fn fun(...: I): O
--- @param opts? memoOpts
--- @return fun(...: I): O, hs.timer?
function memoize(fn, opts)
  local fnid = tostring(fn) -- get a unique id for the function, using lua's tostring function, which uses the memory address of the function and thus is unique for each function

  if memoized[fnid] then -- if the function is already memoized, return the memoized version. This allows us to use memoized functions immediately as `memoize(fn)(...)` without having to assign it to a variable first
    return memoized[fnid]
  end

  --- set default options
  opts = copy(opts) or {}
  opts.mode = opts.mode or "mem"
  opts.is_async = opts.is_async or false
  opts.invalidation_mode = opts.invalidation_mode or "none"
  opts.interval = opts.interval or 0


  -- initialize the cache if using memory
  if opts.mode == "mem" then
    memstore[fnid] = {}
  end
  
  -- create some variables that will be used later

  local cache_methods = gen_cache_methods[opts.mode]
  local timer
  
  local created_at = cache_methods.get_created_time(fnid)

  -- create a timer to invalidate the cache if needed
  if opts.invalidation_mode == "reset" then
    timer = hs.timer.doEvery(opts.interval, function()
      cache_methods.reset(fnid)
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
        if opts.mode == "fs" then
          cache_methods.set_created_time(fnid, os.time())
        end
        created_at = os.time()
      end

    else

      -- get the result from the cache
      result = cache_methods.get(fnid, params)
    end

    if not opts.is_async then
      if not result then  -- no result yet, so we need to call the original function and store the result in the cache
        result = { fn(...) }
        cache_methods.put(fnid, params, result)
      end
      return table.unpack(result) -- we're sure to have a result now, so we can return it
    else
      if result then -- if we have a result, we can call the callback immediately
        callback(table.unpack(result))
      else -- else we need to call the original function and wrap the callback to store the result in the cache before calling it
        fn(table.unpack(params), function(...)
          local result = {...}
          cache_methods.put(fnid, params, result)
          callback(table.unpack(result))
        end)
      end
    end
  end
  memoized[fnid] = memoized_func
  return memoized_func, timer
end

