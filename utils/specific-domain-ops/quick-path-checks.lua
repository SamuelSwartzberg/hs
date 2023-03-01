--- @param str string
--- @return boolean
function looksLikePath(str)
  return 
    str:find("/") ~= nil
    and str:find("[\n\t\r\f]") == nil
    and str:find("^%s") == nil
    and str:find("%s$") == nil
end

--- @param path string
--- @return boolean
function pathIsRemote(path)
  return not not path:find("^[^/:]-:") 
end

--- @param path string
--- @return boolean
function isGitRootDir(path)
  return not not valueFind(itemsInPath(path), function (child)
    return stringy.endswith(child, "/.git")
  end)
end