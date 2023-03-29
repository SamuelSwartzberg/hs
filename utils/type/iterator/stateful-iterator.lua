--- makes a function that returns a stateful iterator instead return a table
--- @generic T, U
--- @param gen fun(...: `T`): fun(): `U` | nil
--- @param ... T
--- @return U[]
function statefulKeyIteratorToTable(gen, ...)
  local res = {}
  local iter = gen(...)
  while true do
    local val = {iter()}
    if #val == 0 then
      break
    end
    res[val[1]] = val[2]
  end
  return res
end

--- makes a function that returns a stateful iterator instead return a table
--- @generic T, U
--- @param gen fun(...: `T`): fun(): `U` | nil
--- @param ... T
--- @return U[]
function statefulNokeyIteratorToTable(gen, ...)
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

--- stateful generator will create iterators that return values until they are over, at which point they return nil once, and then error on subsequent calls
--- @generic T, U, V, W
--- @param gen fun(...: `W`): fun(state: `T`, control_var: `U`): (...: `V`), T, U
--- @param start_res_at? integer
--- @param end_res_at? integer
--- @return fun(...: W): fun(): V | nil
function toStatefulGenerator(gen, start_res_at, end_res_at)
  start_res_at = start_res_at or 1
  end_res_at = end_res_at or nil
  return function(...)
    local stateless_next, state, initial_val = gen(...)
    local control_var = initial_val
    return function()
      inspPrint(control_var)
      local res = {stateless_next(state, control_var)}
      inspPrint(res)
      control_var = res[1]
      if control_var == nil then
        return nil
      else
        return table.unpack(res, start_res_at, end_res_at)
      end
    end
  end
end


