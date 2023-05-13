--- @param path string
--- @param slice? sliceSpecLike how to slice the path before creating it
function createPath(path, slice)
  path = transf.string.path_resolved(path, true)
  slice = slice or { start = 1, stop = -1 } -- default to entire path
  local resolved_path = pathSlice(path, slice, {rejoin_at_end = true})
  local remote = pathIsRemote(resolved_path)
  if not remote then
    run({"mkdir -p '" .. resolved_path .. "'"})
  else
    run({"rclone", "mkdir", {value = resolved_path, type = "quoted"}})
  end
end

--- @param path? string
--- @param contents? string what to write to the file, if anything
--- @param condition? "exists" | "not-exists" | "any" under what conditions to write the file
--- @param create_path? boolean whether to create the path to the file if it doesn't exist
--- @param mode? "w" | "a" the mode to open the file in (write or append)
--- @param fail? "error" | "nil" what to do if an error occurs
--- @return string | nil 
function writeFile(path, contents, condition, create_path, mode, fail)
  path = path or env.TMPDIR .. "/" .. os.time() .. "-" .. rand({len = 8}) .. ".tmp"
  contents = defaultIfNil(contents, "")
  condition = defaultIfNil(condition, "any")
  create_path = defaultIfNil(create_path, true)
  mode = defaultIfNil(mode, "w")
  path = transf.string.path_resolved(path, true)
  fail = defaultIfNil(fail, "nil")

  local path_is_remote = pathIsRemote(path)

  local parent_path = pathSlice(path, {start = 1, stop = -2}, {rejoin_at_end = true})

  if not testPath(parent_path) then -- if the parent path doesn't exist, we won't be able to write to the file
    if create_path then -- if we're allowed to create the parent path, do so
      createPath(parent_path)
    else -- otherwise, fail by returning nil
      if fail == "error" then
        error(("Failed to write file %s: parent path %s does not exist"):format(path, parent_path))
      else
        return nil
      end
    end
  end

  -- we can now be sure that the parent path exists

  -- check if existance matches condition, and if not fail by returning nil

  local path_exists = testPath(path)
  if path_exists then
    if condition == "not-exists" then
      if fail == "error" then
        error(("Failed to write file %s: file already exists"):format(path))
      else
        return nil
      end
    end
  else
    if condition == "exists" then
      if fail == "error" then
        error(("Failed to write file %s: file does not exist"):format(path))
      else
        return nil
      end
    end
  end
  if not path_is_remote then 
    local file = io.open(path, mode)
    if file ~= nil then
      file:write(contents or "")
      io.close(file)
    else
      if fail == "error" then
        error(("Failed to write file %s: could not open file"):format(path))
      else
        return nil
      end
    end
  else
    local temppath = env.TMPDIR .. "/" .. os.time() .. "-" .. math.random(1000000)
    if mode == "a" then
      run({
        "rclone",
        "cat",
        {value = path, type = "quoted"},
        ">", 
        {value = temppath, type = "quoted"},
      })
    end
    if path_exists then
      delete(path, "any", "delete") -- have to delete the original file, as rclone copyto does not overwrite
      -- not a problem since we're handling appending locally anyway
    end
    writeFile(temppath, contents, "any", false, mode)
    run({
      "rclone",
      "copyto",
      {value = temppath, type = "quoted"},
      {value = path, type = "quoted"},
    })
    delete(temppath)
  end
  return path
end