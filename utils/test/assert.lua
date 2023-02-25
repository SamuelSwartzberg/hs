
function assertTable(a, b)
  local string_table_a = hs.inspect(a, {depth = 5})
  local string_table_b = hs.inspect(b, {depth = 5})
  assert(string_table_a == string_table_b, ("Expected %s, but got %s"):format(string_table_b, string_table_a))
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

function assertMessage(a, b)
  assert(a == b, ("Expected \n%s\n, but got \n%s"):format(b, a))
end