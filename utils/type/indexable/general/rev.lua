---reverse an indexable
---@generic T : indexable
---@param thing T
---@return T
function rev(thing)
  if type(thing) == "string" then
    return eutf8.reverse(thing)
  elseif type(thing) == "table" then
    if isListOrEmptyTable(thing) then
      local new_list = {}
      for i = #thing, 1, -1 do
        new_list[#new_list + 1] = thing[i]
      end
      return new_list
    else
      return iterToTbl(thing:revpairs())
    end
  else
    error("rev only works on strings, lists, and tables. got " .. type(thing) .. " when processing:\n\n" .. json.encode(thing))
  end
end