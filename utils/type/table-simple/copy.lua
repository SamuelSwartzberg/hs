--- @param t table
--- @param deep? boolean
--- @return table
function copy(t, deep)
  deep = defaultIfNil(deep, true)
  if t.revpairs then -- orderedtable
    return t:copy(deep)
  else
    if deep then
      return copy(t)
    else
      return tablex.copy(t)
    end
  end
end