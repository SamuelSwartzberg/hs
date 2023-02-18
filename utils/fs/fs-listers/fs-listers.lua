--- @param path string
--- @return string[]
function getAncestors(path)
  local parents = {}
  local path_components = stringy.split(path, "/")
  while true do
    local _ = listPop(path_components)
    if #path_components == 0 then
      break
    end
    parents[#parents + 1] = "/" .. table.concat(path_components, "/")
  end
  return parents
end


--- Returns a table of all things in a directory
--- @param path string The path to the directory
--- @param recursion? boolean | integer Whether to recurse into subdirectories, and how much
--- @param include_dirs? boolean Whether to include directories in the returned table
--- @param include_files? boolean Whether to include files in the returned table
--- @param validator? fun(file_name: string): boolean A function that takes a file name and returns true if the file should be included in the returned table
--- @return string[] #A table of all things in the directory
function getAllInPath(path, recursion, include_dirs, include_files, validator)
  if not isDir(path) then 
    if include_files then
      return {path}
    else
      return {}
    end
  end
  local files = {}
  path = resolveTilde(path)
  path = ensureAdfix(path, "/", true, false, "suf")
  if not validator then 
    validator = function() return true end
  end
  if recursion == nil then recursion = false end
  if include_dirs == nil then include_dirs = true end
  if include_files ==nil then include_files = true end

  local remote = pathIsRemote(path)

  local lister
  if not remote then
    lister = hs.fs.dir
  else
    lister = function(listerpath)
      local output, status, reason, code = getOutputTask({"rclone", "lsf", {value = listerpath, type = "quoted"}})
      local items
      if status then
        items = mapValueNewValue(
          stringy.split(stringy.strip(output), "\n"),
          function(item)
            item = stringy.strip(item)
            item = ensureAdfix(item, "/", false, false, "pre")
          end
        )
      else
        items = {}
      end
      return svalues(items)
    end
  end

  for file_name in lister(path) do
    if file_name ~= "." and file_name ~= ".." and file_name ~= ".DS_Store" and validator(file_name) then
      local file_path = path .. file_name
      if isDir(file_path) then 
        if include_dirs then
          files[#files + 1] = file_path
        end
        local shouldRecurse = recursion
        if type(recursion) == "number" then
          if recursion <= 0 then shouldRecurse = false end
        end
        if shouldRecurse then
          local sub_files = getAllInPath(file_path, decrementIfNumber(recursion), include_dirs, include_files, validator)
          for _, sub_file in ipairs(sub_files) do
            files[#files + 1] = sub_file
          end
        end
      else
        if include_files then
          files[#files + 1] = file_path
        end
      end
    end
  end
  return files
end


--- @type fun(path: string, recursive?: boolean, include_dirs?: boolean, include_files?: boolean): string[]
getUserUsefulFilesInPath = bindNthArg(getAllInPath, 5, usefulFileValidator)

--- Imitates `ls`/`tree -i`, i.e. returns a list of all leaves in a directory (or subdirectories), without their paths
--- @param path string The path to the directory
--- @param recursive? boolean Whether to recurse into subdirectories
--- @param include_dirs? boolean Whether to include directories in the returned table
--- @param include_files? boolean Whether to include files in the returned table
--- @return string[] #A table of all things in the directory
function getLeavesInPath(path, recursive, include_dirs, include_files)
  local paths = getAllInPath(path, recursive, include_dirs, include_files)
  return mapValueNewValue(paths, function(path)
    return getLeafWithoutPath(path)
  end)
end

--- returns a list of all leaves in a directory (or subdirectories), without their paths or extensions
--- @param path string The path to the directory
--- @param recursive? boolean Whether to recurse into subdirectories
--- @param include_dirs? boolean Whether to include directories in the returned table
--- @param include_files? boolean Whether to include files in the returned table
--- @return string[] #A table of all things in the directory
function getLeavesWithoutExtensionInPath(path, recursive, include_dirs, include_files)
  local paths = getAllInPath(path, recursive, include_dirs, include_files)
  return mapValueNewValue(paths, function(path)
    return getLeafWithoutPathOrExtension(path)
  end)
end

--- @param path string
--- @param depth? integer
--- @return string[]
function getDirsThatAreGitRootsInPath(path, depth)
  local dirs = getAllInPath(path, depth or true, true, false)
  return listFilter(dirs, function(dir)
    return isGitRootDir(dir)
  end)
end



--- @param path string
--- @param include_dirs? boolean
--- @param include_files? boolean
--- @return string[]
function getSiblings(path, include_dirs, include_files)
  return getAllInPath(getParentPath(path), false, include_dirs, include_files)
end

--- @param path string
--- @param include_dirs? boolean
--- @param include_files? boolean
--- @return string[]
function getChildren(path, include_dirs, include_files)
  return getAllInPath(path, false, include_dirs, include_files)
end

--- @param path string
--- @param include_dirs? boolean
--- @param include_files? boolean
--- @return string[]
function getOwnAndAncestorSiblings(path, include_dirs, include_files)
  local siblings = getSiblings(path, include_dirs, include_files)
  if path ~= "/" then
    local ancestor_siblings = getOwnAndAncestorSiblings(getParentPath(path), include_dirs, include_files)
    return listConcat(siblings, ancestor_siblings)
  else
    return siblings
  end
end

--- @param path string
--- @param include_dirs boolean
--- @param include_files boolean
--- @return string[]
function getChildrenOwnAndAncestorSiblings(path, include_dirs, include_files)
  local children = getAllInPath(path, false, include_dirs, include_files)
  local siblings_and_ancestor_siblings = getOwnAndAncestorSiblings(path, include_dirs, include_files)
  return listConcat(children, siblings_and_ancestor_siblings)
end

--- @param path string
--- @param filename string
--- @param include_dirs boolean
--- @param include_files boolean
--- @return string | nil
function findInSiblingsOrAncestorSiblings(path, filename,  include_dirs, include_files)
  local siblings = getSiblings(path, include_dirs, include_files)
  local target_element = valueFind(siblings, function(path)
    return getLeafWithoutPath(path) == filename
  end)
  if target_element then
    return target_element
  else
    if path ~= "/" then
      return findInSiblingsOrAncestorSiblings(getParentPath(path), filename, include_dirs, include_files)
    else
      return nil
    end
  end
end

--- @param path string
--- @param ends string
--- @param include_dirs? boolean
--- @param include_files? boolean
--- @return string | nil
function findChildThatEndsWith(path, ends, include_dirs, include_files)
  local children = getAllInPath(path, false, include_dirs, include_files)
  return valueFindStringEndsWith(children, ends)
end


function getSortedDirArr(path)
  local temp_dir_array = {}
  for file_name in hs.fs.dir(path) do
    temp_dir_array[#temp_dir_array + 1] = file_name
  end
  table.sort(temp_dir_array)
  return temp_dir_array
end