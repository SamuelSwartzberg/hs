local rrq = bindArg(relative_require, "utils.task")
rrq("args")

--- @param command_parts command_parts
--- @return string, boolean, "exit"|"signal", integer
function getOutputTask(command_parts)
  local bash_args = buildTaskArgs(command_parts)
  local command = string.format(
    "/opt/homebrew/bin/bash %s '%s'",
    bash_args[1],
    bash_args[2]
  )
  return hs.execute(command)
end

--- @param ... command_part
--- @return string, boolean, "exit"|"signal", integer
function getOutputArgs(...)
  return getOutputTask({...})
end

--- @param ... command_part
--- @return string
function getOutputArgsSimple(...)
  local output = getOutputArgs(...)
  return output
end

--- @param command_parts command_parts
--- @return string
function getOutputTaskSimple(command_parts)
  local output = getOutputTask(command_parts)
  return output
end

--- @return { [string]: string }
function getEnvAsTable()
  local env = getOutputTask({"env"})
  local env_table = {}
  for line in stringx.lines(env) do
    local key, value = line:match("^(.-)=(.*)$")
    if key and value then
      env_table[key] = value
    end
  end
  return env_table
end