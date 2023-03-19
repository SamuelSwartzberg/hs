--- Returns the element at the given index of the given indexable.
---@param thing indexable
---@param ind any
---@return any
function elemAt(thing, ind)
  if type(thing) == "string" then
    return eutf8.sub(thing, ind, ind)
  elseif type(thing) == "table" then
    if isListOrEmptyTable(thing) then
      return thing[ind]
    else
      return thing:getindex(ind)
    end
  end
end