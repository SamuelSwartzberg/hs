--- saliastable: 
--- key f: matches key f, foo, ...
--- key fb: matches key fb, foo_bar, foo_baz, ...
--- laliastable
--- key foo: matches key foo, f, ...
--- key foo_bar: matches key foo_bar, fb



local function createAliasMetatable(get_longer_shorter_thing)
  return {
    __index = function(t, k)
      local v = rawget(t, k)
      if v then
        return v
      else
        local key
        local function matches(testkey)
          local longer_thing, shorter_thing = get_longer_shorter_thing(testkey, k)
          local longer_parts = stringy.split(longer_thing, "_")
          local shorter_parts = transf.string.bytechars(shorter_thing)
          if not (#longer_parts == #shorter_parts) then
            return false
          end
          for i, key_part in transf.array.index_value_stateless_iter(shorter_parts) do
            if not stringy.startswith(longer_parts[i], key_part) then
              return false
            end
          end
          return true
        end
        for tk, tv in transf.native_table.key_value_stateless_iter(t) do
          if matches(tk) then
            key = tk
            break
          end
        end
        if key then
          return t[key]
        else
          return nil
        end
      end
    end
  }
end

local aliasmetatable = {
  l = createAliasMetatable(function(testkey, k)
    return k, testkey
  end),
  s = createAliasMetatable(function(testkey, k)
    return testkey, k
  end)
}
--- @param t? table
--- @param type? "l" | "s"
--- @return table
function newAliastable(t, type)
  type = type or "s"
  return setmetatable(t or {}, aliasmetatable[type])
end
