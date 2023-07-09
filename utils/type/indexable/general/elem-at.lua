--- Returns the element at the given index of the given indexable.
---@param thing indexable
---@param ind integer
---@param ret? kv
---@param precalc_keys? any[] if provided, will be used instead of keys(thing) - useful for performance
---@return any, any?
function elemAt(thing, ind, ret, precalc_keys)
  if type(thing) == "string" then
    local value = eutf8.sub(thing, ind, ind)
    if ret == "kv" then
      return ind, value
    else
      return value
    end
  elseif type(thing) == "table" then
    if is.table.array(thing) then
      local value = thing[ind]
      if ret == "kv" then
        return ind, value
      else
        return value
      end
    else
      if thing.isovtable then
        if ret == "kv" then
          return thing:getindex(ind, true)
        else
          return thing:getindex(ind)
        end
      else
        local tblkeys = precalc_keys or keys(thing)
        table.sort(tblkeys, is.a_and_b.b_larger_as_string)
        local key = tblkeys[ind]
        local value = thing[key]
        if ret == "kv" then
          return key, value
        else
          return value
        end
      end
    end
  end
end