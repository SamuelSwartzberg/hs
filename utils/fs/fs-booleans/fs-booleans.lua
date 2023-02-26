--- @param path string
--- @return boolean
function isGitRootDir(path)
  local children = itemsInPath(path)
  return not not valueFind(children, function (child)
    return stringy.endswith(child, "/.git")
  end)
end

--- @param path string
--- @return boolean
function pathIsRemote(path)
  return not not path:find("^[^/:]-:") 
end

--- @param path string
--- @return boolean
function isEmpty(path)
  path = resolveTilde(path)
  if isDir(path) then
    return dirIsEmpty(path)
  else
    return readFile(path) == ""
  end
end
