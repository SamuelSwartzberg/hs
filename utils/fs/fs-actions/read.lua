
--- @param path string
--- @return string | nil
function readFile(path)
  path = resolveTilde(path)
  local file = io.open(path, "r")
  if file ~= nil then
    local contents = file:read("*a")
    io.close(file)
    return contents
  else
    return nil
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