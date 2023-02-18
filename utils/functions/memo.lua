---@diagnostic disable: duplicate-set-field

--- @alias Memoizer { [function]: (MemoizedItem), create: fun(self: Memoizer, fn: function, mode: "invalidate" | "refresh", interval: number): (MemoizedItem), clear: fun(self: Memoizer, fn: function): (nil), getOrCreate: fun(self: Memoizer, fn: function, mode: "invalidate" | "refresh", interval: number): MemoizedItem} 

--- @class GenericMemoizedItem
--- @field memoized function
--- @field original function
--- @field exec function

--- @class InvalidatingMemoizedItem : GenericMemoizedItem
--- @field private created_at number

--- @class RefreshingMemoizedItem : GenericMemoizedItem
--- @field private refresher hs.timer

--- @alias MemoizedItem InvalidatingMemoizedItem | RefreshingMemoizedItem

--- @return Memoizer
function createMemoizer()
  local memoizer = {}

  function memoizer:create(fn, mode, interval) 
    local memoized_item = {
      memoized = memoize(fn),
      original = fn
    }
    if mode == "refresh" then
      memoized_item.refresher = hs.timer.doEvery(interval, function()
        print("memoized item refreshing regularly")
        memoized_item.memoized = memoize(memoized_item.original)
      end)
      memoized_item.exec = function(self, ...)
        return self.memoized(...)
      end
    elseif mode == "invalidate" then
      memoized_item.created_at = os.time()
      memoized_item.exec = function(self, ...)
        print("execing")
        if os.time() - self.created_at > interval then
          print("memoized item expired, refreshing")
          self.memoized = memoize(self.original)
          self.created_at = os.time()
        end
        return self.memoized(...)
      end
    end
    return memoized_item
  end

  function memoizer:clear(fn)
    self[fn] = nil
  end

  function memoizer:getOrCreate(fn, mode, interval)
    if not self[fn] then
      self[fn] = self:create(fn, mode, interval)
    end
    return self[fn]
  end

  return memoizer
end

--- @alias ItemCache { [function]: (MemoizedItem), create: fun(self: Memoizer, const_fn: function, const_fn_args: any, derived_calls: string[], mode: "invalidate" | "refresh", interval: number): (MemoizedItem), clear: fun(self: Memoizer, const_fn: function, const_fn_args: any,derived_calls: string[]): (nil), getOrCreate: fun(self: Memoizer, const_fn: function, const_fn_args: any, derived_calls: string[], mode: "invalidate" | "refresh", interval: number): MemoizedItem} 

--- @return ItemCache
function createItemCache()
  local item_cache = {}
  item_cache.memoizer = createMemoizer()
  item_cache.function_cache = {}

  --- need to cache function so that we can clear it later, since we need the exact pointer, not an identical new function every time
  function item_cache.getFunc(const_fn, const_fn_args, derived_calls)

    local derived_call_string = stringx.join(",", derived_calls)

    if  item_cache.function_cache[const_fn] and item_cache.function_cache[const_fn][const_fn_args] and item_cache.function_cache[const_fn][const_fn_args][derived_call_string] then
      -- do nothing, we'll return at the bottom anyway
    else
      if not item_cache.function_cache[const_fn] then
        item_cache.function_cache[const_fn] = {}
      end
      if not item_cache.function_cache[const_fn][const_fn_args] then
        item_cache.function_cache[const_fn][const_fn_args] = {}
      end
      if not item_cache.function_cache[const_fn][const_fn_args][derived_calls] then 
        item_cache.function_cache[const_fn][const_fn_args][derived_calls] = {}
      end
      item_cache.function_cache[const_fn][const_fn_args][derived_call_string] = function()
        local const_fn_result = const_fn(tableUnpackIfTable(const_fn_args))
        for _, derived_call in ipairs(derived_calls) do
          const_fn_result = const_fn_result:get(derived_call)
        end
        return const_fn_result
      end
    end
    return item_cache.function_cache[const_fn][const_fn_args][derived_call_string]
  end

  function item_cache:create(const_fn, const_fn_args, derived_calls, mode, interval)
    local func = self.getFunc(const_fn, const_fn_args, derived_calls)
    return self.memoizer:getOrCreate(func, mode, interval)
  end

  function item_cache:clear(const_fn, const_fn_args, derived_calls)
    local func = self.getFunc(const_fn, const_fn_args, derived_calls)
    self.memoizer:clear(func)
  end

  function item_cache:getOrCreate(const_fn, const_fn_args, derived_calls, mode, interval)
    return self.memoizer:getOrCreate(self.getFunc(const_fn, const_fn_args, derived_calls), mode, interval)
  end

  return item_cache
end

--- @param name string
--- @param func_id string
--- @param args any[]
function getFsCachePath(name, func_id, args)
  local jsonified_args = json.encode(args)
  local md5 = hashings("md5")
  md5:update(jsonified_args)
  local hash = md5:hexdigest()
  return env.XDG_CACHE_HOME .. "/" .. name .. "/" .. func_id .. "/" .. hash
end

--- @param fn function
--- @param func_id string
--- @return function
function fsmemoize(fn, func_id)
  return function(...)
    local cache_path = getFsCachePath("fsmemoize", func_id, {...})
    if pathExists(cache_path) then
      return table.unpack(json.decode(readFile(cache_path)))
    else
      local res = {fn(...)}
      writeFile(cache_path, json.encode(res))
      return table.unpack(res)
    end
  end
end

--- @alias simpleAsyncFunc fun(arg: any, callback: fun(res: any)): nil

--- @param fn simpleAsyncFunc
--- @param func_id string
--- @return simpleAsyncFunc
function fsmemoizeAsyncFunc(fn, func_id)
  return function(arg, callback)
    local cache_path = getFsCachePath("fsmemoizeAsyncFunc", func_id, arg)
    print(cache_path)
    if pathExists(cache_path) then
      print("path exists")
      callback(json.decode(readFile(cache_path)))
    else
      fn(arg, function(res)
        print "writing to cache"
        writeFile(cache_path, json.encode(res))
        callback(res)
      end)
    end
  end
end
