
--- makes a function that returns an iterator instead return a table
--- @generic T, U, V, W, X
--- @param gen fun(...: `V`): fun(state: `T`, control_var: `U`): (`W`, `X`), T, U
--- @return table<W, X>
function iterToTable(gen, ...)
  local res = ovtable.new()
  for k, v in gen do
    res[k] = v
  end
  return res
end

function iterToList(gen)
  if gen == nil then
    return {}
  end
  local res = {}
  for v in gen do
    table.insert(res, v)
  end
  return res
end