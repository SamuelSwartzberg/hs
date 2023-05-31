a_use = math.random(999999999)

--- binds arguments to a function
--- @param func function
--- @param arg_spec any | any[] List of arguments to bind. Use a_use to consume an argument passed at runtime.
--- @param ignore_spec? integer | integer[] List of arguments to ignore (by index).
--- @return function
function bind(func, arg_spec, ignore_spec)

  -- handle shorthand
  if not isListOrEmptyTable(arg_spec) then
    arg_spec = { arg_spec }
  end
  if not isListOrEmptyTable(ignore_spec) then
    ignore_spec = { ignore_spec }
  end
  
  -- initialize inner_func to the original function
  local inner_func = function(...)
    local args = {...}
    table.sort(ignore_spec, function(a, b) return a > b end)
    for _, index in ipairs(ignore_spec) do
      table.remove(args, index)
    end
    local new_args = {}
    for index, arg in ipairs(arg_spec) do -- for all arg_lists to bind
      if arg == a_use then
        new_args[index] = table.remove(args, 1)
      else
        new_args[index] = arg
      end
    end
    for _, arg in ipairs(args) do -- for all remaining args
      table.insert(new_args, arg)
    end
    return func(table.unpack(new_args))
  end

  return inner_func
end