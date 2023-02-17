--- @param origin string
--- @param target string
--- @return boolean
function copyFilelike(origin, target)
  if isDir(origin) then
    return dir.clonetree(origin, target)
  else
    return file.copy(origin, target)
  end
end

--- @param origin string
--- @param target string
--- @return boolean
function copyWithCreatePath(origin, target)
  createParentPath(target)
  return copyFilelike(origin, target)
end

--- @param origin string
--- @param target_dir string
--- @return boolean
function copyInto(origin, target_dir)
  local target = target_dir .. "/" .. getLeafWithoutPath(origin)
  return copyWithCreatePath(origin, target)
end

--- @param origin string
--- @param target string
--- @return boolean
function copyIfDoesntExist(origin, target)
  if not pathExists(target) then
    return copyFilelike(origin, target)
  else
    return false
  end
end

--- @param origin string
--- @param target string
--- @return boolean
function copyWithCreatePathIfDoesntExist(origin, target)
  createParentPath(target)
  return copyIfDoesntExist(origin, target)
end

function copyAllInDir(origin, target)
  local files = getAllInPath(origin, false, true, true)
  for _, file in ipairs(files) do
    local leaf = getLeafWithoutPath(file)
    local target_file = target .. "/" .. leaf
    local res = copyWithCreatePath(file, target_file)
    if not res then returned_false = true end
  end
  return not returned_false
end
