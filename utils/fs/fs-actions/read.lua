
--- @param path string
--- @return string | nil
function readFile(path)
  path = resolveTilde(path)
  local path_is_remote = pathIsRemote(path)
  if not path_is_remote then 
    local file = io.open(path, "r")
    if file ~= nil then
      local contents = file:read("*a")
      io.close(file)
      return contents
    else
      return nil
    end
  else
    local output, status, reason, code = getOutputTask({"rclone", "cat", {value = path, type = "quoted"}})
    if status then
      return output
    else
      return nil
    end
  end
end

--- @param path string
--- @return string
function readFileOrError(path)
  local contents = readFile(path)
  if contents == nil then
    error("Could not read file: " .. path)
  else
    return contents
  end
end