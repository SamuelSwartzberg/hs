--- @param path string
--- @return boolean
function isGitRootDir(path)
  local children = getChildren(path, false, true)
  return not not valueFind(children, function (child)
    return stringy.endswith(child, "/.git")
  end)
end