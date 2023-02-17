
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


require("utils.functions")
local rrq = bindArg(relative_require, "utils")


rrq("fs")
rrq("table")
rrq("types")
rrq("string")
rrq("numbers")
rrq("coding")
rrq("applications")
rrq("ui")
rrq("dt")
rrq("comparable")
rrq("email")
rrq("action-table")
rrq("math")
url = rrq("url")
rrq("browser")
rrq("api")
rrq("dom")
rrq("osascript")
rrq("ipc-socket")
rrq("task")
rrq("test")
rrq("sync")
rrq("benchmark")
rrq("external-typings")
rrq("document")
rrq("user-io")
rrq("wrappers")
rrq("build-chooser")
rrq("component-interface")
env = getEnvAsTable()

rrq("_test")
