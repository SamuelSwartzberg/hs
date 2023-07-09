--- Copy a table, optionally deep, return other types as-is.  
--- Ensures that changes to the copy do not affect the original.  
--- Handles self-referential tables.
--- @param t any
--- @param deep? boolean
--- @param copied_tables? table @internal use only
--- @return table
function copy(t, deep, copied_tables)
  if type(t) ~= "table" then return t end -- non-tables don't need to be copied
  deep = defaultIfNil(deep, true)
  copied_tables = defaultIfNil(copied_tables, {})
  if not t then return t end
  local new
  if t.isovtable then -- orderedtable
    new = ovtable.new()
  else
    new = {}
  end
  copied_tables[tostring(t)] = new
  for k, v in transf.table.pair_stateless_iter(t) do
    if type(v) == "table" and deep then
      if copied_tables[tostring(v)] then -- we've already copied this table, so just reference it
        new[k] = copied_tables[tostring(v)]
      else -- we haven't copied this table yet, so copy it and reference it
        new[k] = copy(v, deep, copied_tables)
      end
    else
      new[k] = v
    end
  end
  setmetatable(new, getmetatable(t)) -- I don't I currently have any metatables where data is stored and thus copy(getmetatable(t)) would be necessary, but this comment is here so that I remember to add it if I ever do
  return new
end