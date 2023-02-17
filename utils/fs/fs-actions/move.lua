--- @param origin string
--- @param target string
--- @return boolean
function moveWithCreatePath(origin, target)
  createParentPath(target)
  return os.rename(origin, target)
end

--- @param origin string
--- @param target string
--- @return boolean
function moveIfDoesntExist(origin, target)
  if not pathExists(target) then
    return os.rename(origin, target)
  else
    return false
  end
end

--- @param origin string
--- @param target string
--- @return boolean
function moveWithCreatePathIfDoesntExist(origin, target)
  createParentPath(target)
  return moveIfDoesntExist(origin, target)
end

--- @param origin string
--- @param target_dir string
--- @return boolean
function moveInto(origin, target_dir)
  local target = target_dir .. "/" .. getLeafWithoutPath(origin)
  return moveWithCreatePath(origin, target)
end

--- @param origin string
--- @param target string
--- @return boolean
function moveAllInDir(origin, target) -- I'm not sure how fast this is. If it proves to be slow, consider using `mv` instead
  local files = getAllInPath(origin, false, true, true)
  local returned_false = false
  for _, file in ipairs(files) do
    local leaf = getLeafWithoutPath(file)
    local target_file = target .. "/" .. leaf
    local res = moveWithCreatePath(file, target_file)
    if not res then returned_false = true end
  end
  return not returned_false
end


function drainAllSubdirsTo(origin, target, validator)
  for _, subdir in getAllInPath(origin, false, true, false) do
    if not validator or validator(subdir) then
      return moveAllInDir(subdir, target) and deleteDir(subdir)
    end
  end
end