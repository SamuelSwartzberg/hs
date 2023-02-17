--- stateful generator will create iterators that return values until they are over, at which point they return nil once, and then error on subsequent calls
--- @generic T, U, V, W
--- @param gen fun(...: `W`): fun(state: `T`, control_var: `U`): (...: `V`), T, U
--- @return fun(...: W): fun(): V | nil
function toStatefulGenerator(gen)
  return function(...)
    local stateless_next, state, initial_val = gen(...)
    local control_var = initial_val
    return function()
      local res = {stateless_next(state, control_var)}
      control_var = res[1]
      if control_var == nil then
        return nil
      else
        return table.unpack(res)
      end
    end
  end
end

--- makes a function that returns an iterator instead return a table
--- @generic T, U, V, W, X
--- @param gen fun(...: `V`): fun(state: `T`, control_var: `U`): (`W`, `X`), T, U
--- @return table<W, X>
function iteratorToTable(gen, ...)
  local res = {}
  for k, v in gen do
    res[k] = v
  end
  return res
end

function iteratorToList(gen)
  if gen == nil then
    return {}
  end
  local res = {}
  for v in gen do
    table.insert(res, v)
  end
  return res
end

--- makes a function that returns a stateful iterator instead return a table
--- @generic T, U
--- @param gen fun(...: `T`): fun(): `U` | nil
--- @param ... T
--- @return U[]
function statefulIteratorToTable(gen, ...)
  local res = {}
  for v in gen(...) do
    table.insert(res, v)
  end
  return res
end

--- makes a function that returns a stateful iterator instead return a table
--- @generic T, U
--- @param gen fun(...: `T`): fun(): `U` | nil
--- @param ... T
--- @return U[]
function statefulMultiReturnIteratorToTable(gen, ...)
  local res = {}
  local iter = gen(...)
  while true do
    local val = {iter()}
    if #val == 0 then
      break
    end
    table.insert(res, val)
  end
  return res
end