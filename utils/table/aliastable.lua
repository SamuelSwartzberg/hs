--- saliastable: 
--- key f: matches key f, foo, ...
--- key fb: matches key fb, foo_bar, foo_baz, ...
--- laliastable
--- key foo: matches key foo, f, ...
--- key foo_bar: matches key foo_bar, fb


function createAliasMetatable(get_longer_shorter_thing)
  return {
    __index = function(t, k)
      local v = rawget(t, k)
      if v then
        return v
      else
        local key = keyFind(t, function(testkey)
          local longer_thing, shorter_thing = get_longer_shorter_thing(testkey, k)
          local longer_parts = stringy.split(longer_thing, "_")
          local shorter_parts = splitBytes(shorter_thing)
          if not (#longer_parts == #shorter_parts) then
            return false
          end
          for i, key_part in ipairs(shorter_parts) do
            if not stringy.startswith(longer_parts[i], key_part) then
              return false
            end
          end
          return true
        end)
        if key then
          return t[key]
        else
          return nil
        end
      end
    end
  }
end


local laliasmetatable = createAliasMetatable(function(testkey, k)
  return k, testkey
end)
local saliasmetatable = createAliasMetatable(function(testkey, k)
  return testkey, k
end)

--- @param t? table
--- @return table
function newSAliastable(t)
  return setmetatable(t or {}, saliasmetatable)
end


--- @param t? table
--- @return table
function newLAliastable(t)
  return setmetatable(t or {}, laliasmetatable)
end