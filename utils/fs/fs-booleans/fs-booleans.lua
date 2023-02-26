--- @param path string
--- @return boolean
function isGitRootDir(path)
  local children = getAllInPath(path, false, true)
  return not not valueFind(children, function (child)
    return stringy.endswith(child, "/.git")
  end)
end

--- @param path string
--- @return boolean
function pathIsRemote(path)
  return not not path:find("^[^/:]-:") 
end
