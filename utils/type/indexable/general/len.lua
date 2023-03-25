--- Returns the length of an indexable
---@param thing indexable
---@return integer
function len(thing)
  preventInfiniteLoop("len", 1000)

  if type(thing) == "string" then
    return eutf8.len(thing)
  elseif type(thing) == "table" then
    if isListOrEmptyTable(thing) then
      return #thing
    elseif thing.isovtable then
      return thing:len()
    else
      local len = 0
      for k, v in pairs(thing) do
        len = len + 1
      end
      return len
    end
  else
    error("len only works on strings, lists, and tables. got " .. type(thing) .. " when processing:\n\n" .. json.encode(thing))
  end
end