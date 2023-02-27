---@diagnostic disable: duplicate-set-field

--- @param name string
--- @param func_id string
--- @param args? any[]
function getFsCachePath(name, func_id, args)
  local path = env.XDG_CACHE_HOME .. "/" .. name .. "/" .. func_id .. "/"
  if args then 
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
    end
  },
  fs = {
    put = function(fnid, params, result)
      local cache_path = getFsCachePath("fsmemoize", fnid, params)
      writeFile(cache_path, json.encode(result), "any", true)
    end,
    get = function(fnid, params)
      local cache_path = getFsCachePath("fsmemoize", fnid, params)
      return json.decode(readFile(cache_path))
    end,
    reset = function(fnid)
      local cache_path = getFsCachePath("fsmemoize", fnid)
      delete(cache_path)
    end

  }
}


--- @class memoOpts
--- @field mode? "mem" | "fs"
--- @field is_async? boolean
--- @field invalidation_mode? "invalidate" | "refresh" | "none"
--- @field interval? number

--- @generic I, O
--- @param fn fun(...: I): O
--- @param opts? memoOpts
--- @return fun(...: I): O
function memoize(fn, opts)
  local fnid = tostring(fn)

  if memoized[fnid] then -- if the function is already memoized, return the memoized version. This allows us to use memoized functions immediately as `memoize(fn)(...)` without having to assign it to a variable first
    return memoized[fnid]
  end

  opts = tablex.deepcopy(opts) or {}
  opts.mode = opts.mode or "mem"
  opts.is_async = opts.is_async or false
  opts.invalidation_mode = opts.invalidation_mode or "none"
  opts.interval = opts.interval or 0


  local created_at = os.time()

  if opts.mode == "mem" then
    memstore[fnid] = {}
  end

  local cache_methods = gen_cache_methods[opts.mode]
  local timer

  if opts.invalidation_mode == "refresh" then
    timer = hs.timer.doEvery(opts.interval, function()
      cache_methods.reset(fnid)
    end)
  end


  local memoized_func = function(...)
    local params = {...}
    local callback = nil
    if opts.is_async then -- assume that async functions always have a callback as the last argument
      callback = params[#params]
      params[#params] = nil
    end 



    local result 

    if opts.invalidation_mode == "invalidate" then
      if created_at + opts.interval < os.time() then
        cache_methods.reset(fnid)
        created_at = os.time()
      end

    else
      result = cache_methods.get(fnid, params)
    end

    if not opts.is_async then
      if not result then 
        result = { fn(...) }
        cache_methods.put(fnid, params, result)
      end
      return table.unpack(result)
    else
      if result then
        callback(table.unpack(result))
      else
        fn(table.unpack(params), function(...)
          local result = {...}
          cache_methods.put(fnid, params, result)
          callback(table.unpack(result))
        end)
      end
    end
  end
  memoized[fnid] = memoized_func
  return memoized_func
end

