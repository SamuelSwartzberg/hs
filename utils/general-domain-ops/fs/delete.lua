
--- @param path string
--- @param thing? "notdir" | "dir" | "any" what kind of thing the path must point to in order to be deleted
--- @param action? "delete" | "empty" what to do with the path
--- @param onlyif? "empty" | "notempty" | "any" only delete if the path is empty or not empty
--- @return nil
function delete(path, thing, action, onlyif)

  -- set defaults

  thing = defaultIfNil(thing, "any")
  action = defaultIfNil(action, "delete")
  onlyif = defaultIfNil(onlyif, "any")

  -- resolve tilde

  path = transf.string.tilde_resolved(path)

  -- set local vars

  local path_is_remote = pathIsRemote(path)
  local is_dir = testPath(path, "dir")
  local is_empty = testPath(path, { contents = false})

  -- return early if dirness of path doesn't match thing

  if 
    (
      is_dir and
      thing == "notdir"
    ) or
    (
      not is_dir and
      thing == "dir"
    )
  then
    return nil
  end    


  -- return early if onlyif is not met

  if onlyif == "empty" and not is_empty then
    return nil
  elseif onlyif == "notempty" and is_empty then
    return nil
  end

  -- delete

  if action ~= "delete" and action ~= "empty" then
    error("action must be 'delete' or 'empty'")
  end

  if is_dir then
    if not path_is_remote then
      if action == "empty" then
        run({
          "rm",
          "-rf",
          { value = path .. "/*", type = "quoted"}
        })
      elseif action == "delete" then
        run({
          "rm",
          "-rf",
          { value = path, type = "quoted"}
        })
      end
    else
      run({
        "rclone",
        "purge",
        { value = path, type = "quoted"}
      })

      -- purge deletes the directory itself, so we need to recreate it if we want to empty it (there seems to be no rclone empty command, or equivalent)
      if action == "empty" then
        run({
          "rclone",
          "mkdir",
          { value = path, type = "quoted"}
        })
      end
    end
  else
    if action == "empty" then
      writeFile(path, "") -- works for remote files too, since writeFile is also implemented for rclone
    elseif action == "delete" then
      if not path_is_remote then
        local _, err_msg = os.remove(path)
        if err_msg then
          error(err_msg)
        end
      else
        inspPrint({ "rclone",
        "deletefile",
        { value = path, type = "quoted"}})
        run({
          "rclone",
          "deletefile",
          { value = path, type = "quoted"}
        })
      end
    end
  end

end