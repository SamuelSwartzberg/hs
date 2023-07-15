--- @param path? string
--- @param contents? string what to write to the file, if anything. Defaults to an empty string.
--- @param condition? "exists" | "not-exists" | "any" under what conditions to write the file. Defaults to "any"
--- @param create_path? boolean whether to create the path to the file if it doesn't exist. defaults to true
--- @param mode? "w" | "a" the mode to open the file in (write or append). Defaults to "w"
--- @param fail? "error" | "nil" what to do if an error occurs. Defaults to "nil"
--- @return string | nil 
function writeFile(path, contents, condition, create_path, mode, fail)
  contents = get.any.default_if_nil(contents, "")
  condition = get.any.default_if_nil(condition, "any")
  create_path = get.any.default_if_nil(create_path, true)
  mode = get.any.default_if_nil(mode, "w")
  path = transf.string.path_resolved(path, true)
  fail = get.any.default_if_nil(fail, "nil")

  local path_is_remote = is.path.remote_path(path)

  local parent_path = pathSlice(path, {start = 1, stop = -2}, {rejoin_at_end = true})

  if not testPath(parent_path) then -- if the parent path doesn't exist, we won't be able to write to the file
    if create_path then -- if we're allowed to create the parent path, do so
      dothis.absolute_path.create_dir(parent_path)
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
    dothis.absolute_path.delete
  end
  return path
end