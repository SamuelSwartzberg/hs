
--- @param path string
--- @param thing? "notdir" | "dir" | "any" what kind of thing the path must point to in order to be deleted
--- @param action? "delete" | "empty" what to do with the path
--- @param onlyif? "empty" | "notempty" | "any" only delete if the path is empty or not empty
--- @param fail? "error" | "nil" what to do in various failure cases. Default "nil"
--- @return nil
function delete(path, thing, action, onlyif, fail)

  -- set defaults

  thing = defaultIfNil(thing, "any")
  action = defaultIfNil(action, "delete")
  onlyif = defaultIfNil(onlyif, "any")
  fail = defaultIfNil(fail, "nil")

  -- resolve path

  path = transf.string.path_resolved(path, true)

  -- set local vars

  local path_is_remote = pathIsRemote(path)
  local exists = testPath(path)

  -- return early if path doesn't exist

  if not exists then
    if fail == "error" then
      error("path does not exist: " .. path)
    else
      return nil
    end
  end

  local is_dir = testPath(path, "dir")
  local is_empty = testPath(path, { contents = false})
  print(is_empty)

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
    if fail == "error" then
      error("path is not a directory, but should be, or vice versa: " .. path)
    else
      return nil
    end
  end    


  -- return early if onlyif is not met

  if onlyif == "empty" and not is_empty then
    if fail == "error" then
      error("path is not empty, but should be: " .. path)
    else
      return nil
    end
  elseif onlyif == "notempty" and is_empty then
    if fail == "error" then
      error("path is empty, but should not be: " .. path)
    else
      return nil
    end
  end

  -- check actions

  if action ~= "delete" and action ~= "empty" then
    error("action must be 'delete' or 'empty'")
  end

  -- potential todo: How to handle failures of run()? Currently, they are not handled at all, and will just cause an error. Maybe we should handle them, and return nil if fail == "nil"? OTOH, some failues of run() may be unexpected, and we shouldn't hide them. Distinguishing between those from the outside is not easy, though.

  if is_dir then
    if not path_is_remote then
      if action == "empty" then
        print("emptying")
        path = ensureAdfix(path, "/", true, false, "suf")
        run("rm -rf \"" .. replace(path, {{"\"", "\\\""}}) .. "\"*") -- need to make sure that the glob is not quoted
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