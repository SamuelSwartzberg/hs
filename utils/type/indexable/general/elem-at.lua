--- Returns the element at the given index of the given indexable.
---@param thing indexable
---@param ind any
---@return any
function elemAt(thing, ind)
  inspPrint(thing)
  if type(thing) == "string" then
    return eutf8.sub(thing, ind, ind)
  elseif type(thing) == "table" then
    if isListOrEmptyTable(thing) then
      return thing[ind]
    else
      if thing.getindex then
        return thing:getindex(ind)
      else
        error("can't get index of table without getindex method")
      end
    end
  end
end