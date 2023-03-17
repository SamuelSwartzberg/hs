--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @param value any
--- @return boolean
function valuesContainShape(tbl, value)
  for _, v in wdefarg(pairs)(tbl) do
    if hs.inspect(v, {depth = 5}) == hs.inspect(value, {depth = 5}) then return true end
  end
  return false
end

--- @param a table
--- @param values any[]
--- @return nil
function assertValuesContain(a, values)
  for _, value in ipairs(values) do
    assert(
    valuesContainShape(a, value),
    ("Expected %s to contain %s"):format(hs.inspect(a, {depth = 5}), hs.inspect(value, {depth = 5}))
  )
  end
end

--- @param a table
--- @param values any[]
--- @return nil
function assertValuesNotContain(a, values)
  for _, value in ipairs(values) do
    assert(
    not valuesContainShape(a, value),
    ("Expected %s to not contain %s, but it does."):format(hs.inspect(a, {depth = 5}), hs.inspect(value, {depth = 5}))
  )
  end
end

--- @param a table
--- @param values any[]
--- @return nil
function assertValuesContainExactly(a, values)
  if #a ~= #values then
    error(("Expected %s to contain exactly %s, but it does not, because it has %s elements."):format(hs.inspect(a, {depth = 5}), hs.inspect(values, {depth = 5}), #a))
  end
  assertValuesContain(a, values)
end

--- @param a any
--- @param b any
--- @param msg? string
function assertMessage(a, b, msg)
  if type (a) == "table" then a = hs.inspect(a, {depth = 5}) end
  if type (b) == "table" then b = hs.inspect(b, {depth = 5}) end

  assert(a == b, ("Expected \n%s\n, but got \n%s. %s"):format(b, a, msg or ""))
end