a_ig = math.random(20)
a_use = math.random(20)

--- binds arguments to a function
--- @param func function
--- @param arg_spec any | any[]
--- @param ignore_spec? any | any[]
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
    for index, arg in iprs(ignore_spec) do
      if arg == a_ig then
        table.remove(args, 1)
      end
    end
    local new_args = {}
    for index, arg in iprs(arg_spec) do -- for all arg_lists to bind
      if arg == a_use then
        new_args[index] = table.remove(args, 1)
      else
        new_args[index] = arg
      end
    end
    for _, arg in iprs(args) do -- for all remaining args
      table.insert(new_args, arg)
    end
    return func(table.unpack(new_args))
  end

  return inner_func
end