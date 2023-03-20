arg_ignore = math.random(20)

--- @param func function
--- @param arg_spec { [string]: any } | any each key is an index representing where to start binding the arguments, each value is a list of arguments to bind to the args starting at that index
--- @return function
function bind(func, arg_spec)
  if type(arg_spec) == "table" and not isListOrEmptyTable(arg_spec) then
    -- no-op
  else 
    arg_spec = { ["1"] = arg_spec }
  end

  local inner_func = func

  for index, arg_list in pairs(arg_spec) do
    local int_index = toNumber(index, "int", "fail")
    if arg_list == arg_ignore then
      inner_func = function(...)
        local args = {...}
        local new_args = concat(
          slice(args, 1, int_index - 1),
          slice(args, int_index + 1, #args)
        )
        return func(table.unpack(new_args))
      end
    else
      if not isListOrEmptyTable(arg_list) then
        arg_list = { arg_list }
      end
      inner_func = function(...)
        local args = {...}
        local new_args = splice(args, arg_list, int_index)
        return inner_func(table.unpack(new_args))
      end
    end
  end

  return inner_func
end