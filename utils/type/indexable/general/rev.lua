---reverse an indexable
---@generic T : indexable
---@param thing T
---@return T
function rev(thing)
  if type(thing) == "string" then
    return eutf8.reverse(thing)
  elseif type(thing) == "table" then
    if not thing.isovtable then
      return iterToTbl(revpairs(thing)) -- this doesn't work for ovtables, because iterToTbl creates a vanilla lua table
    else
      local new = ovtable.new()
      for k, v in revpairs(thing) do
        new[k] = v
      end
      return new
    end
  else
    error("rev only works on strings, lists, and tables. got " .. type(thing) .. " when processing:\n\n" .. json.encode(thing))
  end
end