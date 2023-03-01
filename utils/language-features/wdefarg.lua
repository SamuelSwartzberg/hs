--- @param fn function
--- @param default? any
function wdefarg(fn, default)
  if not default then default = {} end
  if not isListOrEmptyTable(default) or #default <= 1 then
    default = {default}
  end
  return function(...)
    local args = {...}
    if #args == 0 then
      args = default
    end
    return fn(table.unpack(args))
  end
end