--- @param path string
--- @return boolean
function deleteFile(path)
  path = resolveTilde(path)
  return os.remove(path)
end

--- @param path string
--- @return boolean
function deleteDir(path)
  path = resolveTilde(path)
  local res = os.execute("rm -rf '" .. path .. "'")
  return not not res
end

--- @param path string
--- @return boolean
function delete(path)
  if isDir(path) then
    return deleteDir(path)
  else
    return deleteFile(path)
  end
end

--- @param path string
--- @return boolean
function emptyDir(path)
  path = resolveTilde(path)
  local res = os.execute("rm -rf '" .. path .. "'/*")
  return not not res
end