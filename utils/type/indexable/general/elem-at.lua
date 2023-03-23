--- Returns the element at the given index of the given indexable.
---@param thing indexable
---@param ind integer
---@param ret? kv
---@return any
function elemAt(thing, ind, ret)
  if type(thing) == "string" then
    return eutf8.sub(thing, ind, ind)
  elseif type(thing) == "table" then
    if isListOrEmptyTable(thing) then
      return thing[ind]
    else
      if thing.getindex then
        if ret == "kv" then
          return {thing:getindex(ind, true)}
        else
          return thing:getindex(ind)
        end
      else
        error("can't get index of table without getindex method")
      end
    end
  end
end