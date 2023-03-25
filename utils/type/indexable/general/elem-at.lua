--- Returns the element at the given index of the given indexable.
---@param thing indexable
---@param ind integer
---@param ret? kv
---@return any
function elemAt(thing, ind, ret)
  if type(thing) == "string" then
    local value = eutf8.sub(thing, ind, ind)
    if ret == "kv" then
      return {ind, value}
    else
      return value
    end
  elseif type(thing) == "table" then
    if isListOrEmptyTable(thing) then
      local value = thing[ind]
      if ret == "kv" then
        return {ind, value}
      else
        return value
      end
    else
      if thing.getindex then
        if ret == "kv" then
          return {thing:getindex(ind, true)}
        else
          return thing:getindex(ind)
        end
      else -- TODO: this branch isn't tested yet
        local keys = keys(thing) -- TODO: memoize once initial testing is done
        table.sort(keys, returnStringEquivOrder)
        local key = keys[ind]
        local value = thing[key]
        if ret == "kv" then
          return {key, value}
        else
          return value
        end
      end
    end
  end
end