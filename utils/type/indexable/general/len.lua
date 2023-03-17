---@param thing indexable
---@return integer
function len(thing)
  if type(thing) == "string" then
    return eutf8.len(thing)
  elseif type(thing) == "table" then
    if isListOrEmptyTable(thing) then
      return #thing
    else
      return #values(thing)
    end
  else
    error("len only works on strings, lists, and tables. got " .. type(thing) .. " when processing:\n\n" .. json.encode(thing))
  end
end