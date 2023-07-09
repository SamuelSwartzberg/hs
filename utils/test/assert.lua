

--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @param value any
--- @return boolean
function valuesContainShape(tbl, value)
  for _, v in wdefarg(transf.table.pair_stateless_iter)(tbl) do
    if hsInspectCleaned(v, 5) == hsInspectCleaned(value, 5) then return true end
  end
  return false
end

--- @param a table
--- @param values any[]
--- @return nil
function assertValuesContain(a, values)
  for _, value in transf.array.index_value_stateless_iter(values) do
    assert(
    valuesContainShape(a, value),
    ("Expected \n%s\n to contain \n%s\n\nAll required values:\n%s"):format(hsInspectCleaned(a, 5), hsInspectCleaned(value, 5), hsInspectCleaned(values, 5))
  )
  end
end

--- @param a table
--- @param values any[]
--- @return nil
function assertValuesNotContain(a, values)
  for _, value in transf.array.index_value_stateless_iter(values) do
    assert(
    not valuesContainShape(a, value),
    ("Expected %s to not contain %s, but it does."):format(hsInspectCleaned(a, 5), hsInspectCleaned(value, 5))
  )
  end
end

--- @param a any
--- @param b any
--- @param msg? string
function assertMessage(a, b, msg)
  if is.any.array(a) and is.any.array(b) then 
    if #a ~= #b then
      error(("Expected %s to contain exactly %s, but it does not, because it has %s elements."):format(hsInspectCleaned(a, 5), hsInspectCleaned(b, 5), #a))
    end
    assertValuesContain(a, b)
  else
    if type (a) == "table" then a = hsInspectCleaned(a, 5) end
    if type (b) == "table" then b = hsInspectCleaned(b, 5) end

    assert(a == b, ("Expected \n%s\nbut got \n%s. %s"):format(b, a, msg or ""))
  end
end

--- @param a any
--- @param b any[]
--- @param msg? string
function assertMessageAny(a, b, msg)
  local succ, res
  for _, possibility in transf.array.index_value_stateless_iter(b) do
    succ, res = pcall(assertMessage, a, possibility, msg)
    if succ then return end
  end
  error(res)
end