--- @return { [string]: string }
function getEnvAsTable()
  local env = run({"env"})
  local env_table = {}
  for line in stringx.transf.string.lines(env) do
    local key, value = line:match("^(.-)=(.*)$")
    if key and value then
      env_table[key] = value
    end
  end
  return env_table
end
