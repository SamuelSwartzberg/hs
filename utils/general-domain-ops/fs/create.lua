--- @param path string
--- @param slice? sliceSpecLike how to slice the path before creating it
function createPath(path, slice)
  path = transf.string.tilde_resolved(path)
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
--- @return string | nil 
function writeFile(path, contents, condition, create_path, mode)
  path = path or env.TMPDIR .. "/" .. os.time() .. "-" .. rand({len = 8}) .. ".tmp"
  contents = defaultIfNil(contents, "")
  condition = defaultIfNil(condition, "any")
  create_path = defaultIfNil(create_path, true)
  mode = defaultIfNil(mode, "w")
  path = transf.string.tilde_resolved(path)

  local path_is_remote = pathIsRemote(path)

  if create_path then
    createPath(path, "1:-2")
  end

  -- check if existance matches condition, and if not fail by returning nil

  if testPath(path) then
    if condition == "not-exists" then
      return nil
    end
  else
    if condition == "exists" then
      return nil
    end
  end
  if not path_is_remote then 
    local file = io.open(path, mode)
    if file ~= nil then
      file:write(contents or "")
      io.close(file)
    else
      error(("Failed to open file %s with mode %s"):format(path, mode))
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
    delete(path, "any", "delete") -- have to delete the original file, as rclone copyto does not overwrite
    -- not a problem since we're handling appending locally anyway
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