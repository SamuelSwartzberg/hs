arg_ignore = math.random(20)

--- binds arguments to a function
--- may also bind arguments to arg_ignore, which will cause the function to ignore that argument
--- @param func function
--- @param arg_spec { [string]: any } | any each key is an index representing where to start binding the arguments, each value is a list of arguments to bind to the args starting at that index (or the shorthand of a single argument). There is also a shorthand available, where if arg_spec is not an assoc arr, it will be treated as if it were { ["1"] = arg_spec }.
--- @return function
function bind(func, arg_spec)

  -- handle shorthand
  if type(arg_spec) == "table" and not isListOrEmptyTable(arg_spec) then
    -- no-op
  else 
    arg_spec = { ["1"] = arg_spec }
  end

  -- initialize inner_func to the original function
  local inner_func = func

  for index, arg_list in pairs(arg_spec) do -- for all arg_lists to bind
    local int_index = toNumber(index, "int", "fail")
    if arg_list == arg_ignore then -- ignore this argument
      inner_func = function(...)
        local args = {...}
        local new_args = concat( -- create new list of args without the ignored arg
          slice(args, 1, int_index - 1), -- all args before the index
          slice(args, int_index + 1, #args) -- all args after the index
        )
        return func(table.unpack(new_args)) -- call the original function with the new args
      end
    else -- bind this argument
      if not isListOrEmptyTable(arg_list) then -- handle shorthand
        arg_list = { arg_list }
      end
      inner_func = function(...)
        local args = {...}
        local new_args = splice(args, arg_list, int_index) -- splice the arg_list into the args at the index
        return inner_func(table.unpack(new_args))
      end
    end
  end

  return inner_func
end