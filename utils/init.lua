
--- require a module in the current module's directory relatively to the current module's path
--- @param currmod string current module 'path'
--- @param modname string module name
--- @return unknown, unknown
function relative_require(currmod, modname) -- relative require
  return require(currmod .. "." .. modname)
end

--- @generic T
--- @generic U
--- @generic V
--- @param func fun(arg: `T`, ...: `U`): `V`
--- @param arg T
--- @return fun(...: U): V
function bindArg(func, arg)
  return function(...)
    return func(arg, ...)
  end
end

local rrq = bindArg(relative_require, "utils")


rrq("language-features")
rrq("externals")
rrq("type")
rrq("basic-interfacing")
rrq("advanced-interfacing")
rrq("general-domain-ops")
rrq("specific-domain-ops")
rrq("test")

env = getEnvAsTable()

if mode ~= "prod" then 
  rrq("_test")
end
