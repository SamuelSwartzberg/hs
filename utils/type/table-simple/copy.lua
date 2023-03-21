--- @param t table
--- @param deep? boolean
--- @return table
function copy(t, deep)
  deep = defaultIfNil(deep, true)
  if not t then return t end
  if t.revpairs then -- orderedtable
    return t:copy(deep)
  else
    if deep then
      return tablex.deepcopy(t)
    else
      return tablex.copy(t)
    end
  end
end