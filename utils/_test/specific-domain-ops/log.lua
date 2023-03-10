--- @param name string
--- @param msg string
function logFile(name, msg)
  local log_file = env.LOGGER_PATH .. "/hs/" .. name .. ".log"
  writeFile(log_file,  msg .. "\n", "any", true, "a")
end
