--- @param line string
--- @return boolean
function isShebangLine(line)
  return not not (stringy.startswith(line, "#!"))
end

--- @param line string
--- @return boolean
function isShellShebangLine(line)
  return not not (isShebangLine(line) and (
    stringy.find(line, "bash") or
    stringy.find(line, "sh") or
    stringy.find(line, "zsh") or
    stringy.find(line, "fish") or 
    stringy.find(line, "dash") or
    stringy.find(line, "ksh") or
    stringy.find(line, "csh") or
    stringy.find(line, "tcsh") 
  ))
end

--- @param path string
--- @return boolean
function dirIsEmpty(path)
  path = resolveTilde(path)
  for file_name in hs.fs.dir(path) do
    if file_name ~= "." and file_name ~= ".." and file_name ~= ".DS_Store" then
      return false
    end
  end
  return true
end

--- @param path string
--- @return boolean
function isDirAndEmpty(path)
  return isDir(path) and dirIsEmpty(path)
end