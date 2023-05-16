--- @param t table
--- @param deep? boolean
--- @return table
function copy(t, deep)
  deep = defaultIfNil(deep, true)
  if not t then return t end
  if t.isovtable then -- orderedtable
    return t:copy(deep)
  else
    for k, v in prs(t) do
      if type(v) == "table" and deep then
        t[k] = copy(v, deep)
      else
        t[k] = v
      end
    end
  end
  return t
end