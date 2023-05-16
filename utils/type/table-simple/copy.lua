--- @param t table
--- @param deep? boolean
--- @param copied_tables? table
--- @return table
function copy(t, deep, copied_tables)
  deep = defaultIfNil(deep, true)
  copied_tables = defaultIfNil(copied_tables, {})
  preventInfiniteLoop(hs.inspect(t), 10000)

  if not t then return t end
  local new
  if t.isovtable then -- orderedtable
    new = ovtable.new()
  else
    new = {}
  end
  copied_tables[tostring(t)] = new
  inspPrint(t)
  inspPrint(copied_tables)
  for k, v in prs(t) do
    if type(v) == "table" and deep then
      if copied_tables[tostring(v)] then -- we've already copied this table, so just reference it
        print("referencing "..tostring(v))
        new[k] = copied_tables[tostring(v)]
      else -- we haven't copied this table yet, so copy it and reference it
        print("copying "..tostring(v))
        new[k] = copy(v, deep, copied_tables)
      end
    else
      new[k] = v
    end
  end
  return new
end