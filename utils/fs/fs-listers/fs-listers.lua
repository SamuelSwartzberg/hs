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

--- @class getAllInPathOpts
--- @field path string The path to the directory
--- @field recursion? boolean | integer Whether to recurse into subdirectories, and how much
--- @field include_dirs? boolean Whether to include directories in the returned table
--- @field include_files? boolean Whether to include files in the returned table
--- @field validator? fun(file_name: string): boolean A function that takes a file name and returns true if the file should be included in the returned table
--- @field slice_results? sliceSpec | string A slice spec to slice the results with
--- @field slice_results_opts? table A table of options to pass to pathSlice

--- Returns a table of all things in a directory

--- @param opts getAllInPathOpts
--- @return string[] #A table of all things in the directory
function getAllInPath(opts)
  if not isDir(opts.path) then 
    if opts.include_files then
      return {opts.path}
    else
      return {}
    end
  end
  local files = {}
  opts.path = resolveTilde(opts.path)
  opts.path = ensureAdfix(opts.path, "/", true, false, "suf")
  opts.validator = defaultIfNil(opts.validator, usefulFileValidator)
  opts.recursion = defaultIfNil(opts.recursion, false)
  opts.include_dirs = defaultIfNil(opts.include_dirs, true)
  opts.include_files = defaultIfNil(opts.include_files, true)

  local remote = pathIsRemote(opts.path)

  local lister
  if not remote then
    lister = hs.fs.dir
  else
    lister = function(listerpath)
      local output, status, reason, code = getOutputTask({"rclone", "lsf", {value = listerpath, type = "quoted"}})
      local items
      if status then
        items = splitLines(output)
        items = listFilterEmptyString(items)
        items = mapValueNewValue(
          items,
          function(item)
            item = stringy.strip(item)
            item = ensureAdfix(item, "/", false, false, "pre")
            item = ensureAdfix(item, "/", false, false, "suf")
            return item
          end
        )
      else
        items = {}
      end
      return svalues(items)
    end
  end

  for file_name in lister(opts.path) do
    if file_name ~= "." and file_name ~= ".." and file_name ~= ".DS_Store" and opts.validator(file_name) then
      local file_path = opts.path .. file_name
      if isDir(file_path) then 
        if opts.include_dirs then
          files[#files + 1] = file_path
        end
        local shouldRecurse = opts.recursion
        if type(opts.recursion) == "number" then
          if opts.recursion <= 0 then shouldRecurse = false end
        end
        if shouldRecurse then
          local sub_files = getAllInPath(file_path, crementIfNumber(opts.recursion, "de"), opts.include_dirs, opts.include_files, opts.validator)
          for _, sub_file in ipairs(sub_files) do
            files[#files + 1] = sub_file
          end
        end
      else
        if opts.include_files then
          files[#files + 1] = file_path
        end
      end
    end
  end

  if opts.slice_results then
    files = pathSlice(files, opts.slice_results, opts.slice_results_opts) --[[ @as string[] ]]
  end

  return files
end



--- @param opts getAllInPathOpts
--- 


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
function getAllInPathOwnAndAncestorSiblings(path, include_dirs, include_files)
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
    return pathSlice(path, "-1:-1")[1] == filename
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