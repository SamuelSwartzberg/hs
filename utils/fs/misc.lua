



--- @param name string
--- @param msg string
function logFile(name, msg)
  local log_file = env.LOGGER_PATH .. "/hs/" .. name .. ".log"
  writeFile(log_file,  msg .. "\n", "exists", true, "a")
end

function resolveTilde(path)
  return path:gsub("^~", env.HOME)
end




--- @param path string
--- @return string
function asAttach(path)
  local mimetype = mimetypes.guess(path) or "text/plain"
  return "#" .. mimetype .. " " .. path
end
