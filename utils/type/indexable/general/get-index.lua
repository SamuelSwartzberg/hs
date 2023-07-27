--- @param thing indexable
--- @param k string|integer
--- @param manual_counter? integer
--- @return integer
function getIndex(thing, k, manual_counter)
  if type(thing) == "table" then
    if not is.table.array(thing) and manual_counter then
      return manual_counter
    else
      return k --[[ @as integer ]]
    end
  else
    return k --[[ @as integer ]]
  end
end