--- Returns the length of an indexable
---@param thing indexable
---@return integer
function len(thing)
  if type(thing) == "string" then
    return eutf8.len(thing)
  elseif type(thing) == "table" then
    if thing.isovtable then
      return thing:len()
    elseif is.any.empty_table(thing) then
      return 0
    elseif is.any.array(thing) then
      local largestkey = 0
      for k, v in transf.native_table.key_value_stateless_iter(thing) do
        if type(k) == "number" and k > largestkey then
          largestkey = k
        end
      end
      return largestkey
    else
      local len = 0
      for k, v in transf.native_table.key_value_stateless_iter(thing) do
        len = len + 1
      end
      return len
    end
  else
    error("len only works on strings, lists, and tables. got " .. type(thing) .. " when processing:\n\n" .. json.encode(thing))
  end
end