--- @class itemsInPathOpts
--- @field path string The path to the directory
--- @field recursion? boolean | integer Whether to recurse into subdirectories, and how much. Default false (no recursion)
--- @field include_dirs? boolean Whether to include directories in the returned table. Default true
--- @field include_files? boolean Whether to include files in the returned table. Default true
--- @field validator? fun(file_name: string): boolean A function that takes a file name and returns true if the file should be included in the returned table. Default is a simple validator that excludes some files that are rarely useful (e.g. .git, node_modules, etc.)
--- @field slice_results? sliceSpecLike A slice spec to slice each result with, e.g. "-1:-1" to get the file name. Default is no slicing
--- @field slice_results_opts? table A table of options to pass to pathSlice
--- @field validator_result? fun(path: string): boolean An additional validation function that runs as an additional filter on each result. default is no additional validation

--- Returns a table of all things in a directory

--- @param opts itemsInPathOpts | string
--- @return string[] #A table of all things in the directory
function itemsInPath(opts)
  if type (opts) == "string" then
    opts = {path = opts}
  elseif type (opts) == "table" then
    opts = copy(opts)
  elseif opts == nil then
    opts = {}
  else
    error("itemsInPath: opts must be a string or a table")
  end
  
  if not testPath(opts.path, "dir") then 
    if opts.include_files then
      return {opts.path}
    else
      return {}
    end
  end
  local files = {}
  opts.path = transf.string.path_resolved(opts.path, true)
  opts.path = ensureAdfix(opts.path, "/", true, false, "suf")
  if opts.path == "" then opts.path = "/" end
  opts.validator = opts.validator or function(file_name)
    return not findsingle(file_name,{".git", "node_modules", ".vscode"})
  end
  opts.recursion = defaultIfNil(opts.recursion, false)
  opts.include_dirs = defaultIfNil(opts.include_dirs, true)
  opts.include_files = defaultIfNil(opts.include_files, true)

  local remote = pathIsRemote(opts.path)

  local lister
  if not remote then
    lister = hs.fs.dir
  else
    lister = function(listerpath)
      local output = run({
        args = {"rclone", "lsf", {value = listerpath, type = "quoted"}},
        catch = function() return nil end,
      }) 
      if output then
        items = lines(output)
        items = filter(items, false)
        inspPrint(items)
        items = map(
          items,
          function(item)
            item = stringy.strip(item)
            item = ensureAdfix(item, "/", false, false, "pre")
            item = ensureAdfix(item, "/", false, false, "suf")
            print(item)
            return item
          end
        )
      else
        items = {}
      end
      inspPrint(items)
      return svalues(items)
    end
  end

  for file_name in lister(opts.path) do
    if file_name ~= "." and file_name ~= ".." and file_name ~= ".DS_Store" and opts.validator(file_name) then
      local file_path = opts.path .. file_name
      if testPath(file_path, "dir") then 
        if opts.include_dirs then
          files[#files + 1] = file_path
        end
        local shouldRecurse = opts.recursion
        if type(opts.recursion) == "number" then
          if opts.recursion <= 0 then shouldRecurse = false end
        end
        if shouldRecurse then
          local sub_opts = copy(opts)
          sub_opts.path = file_path
          sub_opts.recursion = crementIfNumber(opts.recursion, "de")
          local sub_files = itemsInPath(sub_opts)
          for _, sub_file in iprs(sub_files) do
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

  if opts.validator_result then
    files = filter(files, opts.validator_result, {tolist=true})
  end

  inspPrint(files)
  if opts.slice_results then
    files = map(files, function(path)
      opts.slice_results_opts = opts.slice_results_opts or {}
      opts.slice_results_opts.rejoin_at_end = defaultIfNil(opts.slice_results_opts.rejoin_at_end, true) -- default to rejoining the path, since more often than not we don't want to get a table of tables when listing paths
      return pathSlice(path, opts.slice_results, opts.slice_results_opts)
    end)
  end

  return files
end

--- @class getItemsForAllLevelsInSliceOpts : itemsInPathOpts

--- Gets all dirs and files in all levels of a path selected by a slice spec
--- @param path string
--- @param slice_spec? sliceSpecLike
--- @param opts? getItemsForAllLevelsInSliceOpts
function getItemsForAllLevelsInSlice(path, slice_spec, opts)
  slice_spec = slice_spec or { start = 1, stop = -1 }
  opts = opts or {}
  opts.recursion = false
  local path = transf.string.path_resolved(path, true)
  local levels = pathSlice(path, slice_spec, { entire_path_for_each = true })
  local res = {}
  for _, level in iprs(levels) do
    opts.path = level -- this modifies the opts table, but that's fine, since it gets copied in itemsInPath
    local items = itemsInPath(opts)
    res = concat(res, items)
  end
  return res
end