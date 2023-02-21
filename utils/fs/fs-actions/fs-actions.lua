---@diagnostic disable: cast-local-type
--- @param path string
--- @param app? string
--- @return boolean
function openPath(path, app)
  local apparg = app and "-A '" .. app .. "' " or "" 
  local _, status = hs.execute("open " .. apparg .. "'" .. path .. "'")
  return status
end

--- @param path string
function openPathVscode(path)
  if not type(path) == "string" then 
    error("path must be a string")
  end
   runHsTask({
    "open",
    "-a",
     { value = "Visual Studio Code", type = "quoted" },
    { value = path, type = "quoted" }
  })
end

--- @param contents string
function openStringInVscode(contents)
  local tmp_file = createUniqueTempFile(contents)
  openPathVscode(tmp_file)
end

--- @param path string
function processSetupDirectivesInFiles(path)
  for _, child in ipairs(getChildren(path, false,true)) do
    logFile("processSetupDirectivesInFiles", child)
    local basename = getLeafWithoutPath(child)
    local command = changeCasePre(
      table.concat(
        mapValueNewValue(
          stringy.split(basename, "-"),
          function (part)
            return changeCasePre(part, 1, "up")
          end
        ), 
        ""
      ),
      1,
      "down"
    )
    local contents = stringy.strip(envsubstShell(readFile(child)))
    for line in stringx.lines(contents) do
      line = stringy.strip(line)
      if not stringy.startswith(line, "#") then -- allow for simple comments
        print(child)
        local tabbed_line = stringy.split(line, "\t")
        local interval = tabbed_line[1]
        local argstring = tabbed_line[2]
        local args = stringy.split(argstring, " ")
        args = mapValueNewValue(args, function (arg)
          if arg == "true" then
            return true
          elseif arg == "false" then
            return false
          elseif arg == "nil" then
            return nil
          else
            return arg
          end
        end)
        print(
          "Would execute"
          .. " _G[\"" .. command .. "\"]"
          .. "(" .. table.concat(mapValueToStr(args), ", ") .. ")"
        )
        print(
          "with interval " .. interval
        )
        if stringy.startswith(interval, "@") then -- is an event
          if interval == "@startup" then
            _G[command](table.unpack(args))
          else
            -- in the future: add support for other events
          end
        else -- is a timer
          System:get("manager", "timer"):doThis("create", {
            interval = interval,
            fn = function ()
              _G[command](table.unpack(args))
            end
          })
        end
      end
    end
  end
end


function drainAllSubdirsTo(origin, target, validator)
  for _, subdir in getAllInPath(origin, false, true, false) do
    if not validator or validator(subdir) then
      return srctgt("move", subdir, target, "any", true, false, true) and delete(subdir, "dir")
    end
  end
end

--- @param path string
--- @return boolean
function isEmpty(path)
  path = resolveTilde(path)
  if isDir(path) then
    return dirIsEmpty(path)
  else
    return readFile(path) == ""
  end
end

--- @param path string
--- @param thing? "notdir" | "dir" | "any"
--- @param action? "delete" | "empty"
--- @param onlyif? "empty" | "notempty" | "any"
--- @return boolean
function delete(path, thing, action, onlyif)

  -- set defaults

  thing = defaultIfNil(thing, "any")
  action = defaultIfNil(action, "delete")
  onlyif = defaultIfNil(onlyif, "any")

  -- resolve tilde

  path = resolveTilde(path)

  -- set local vars

  local path_is_remote = pathIsRemote(path)
  local is_dir = isDir(path)
  local is_empty = isEmpty(path)

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
    return false
  end    


  -- return early if onlyif is not met

  if onlyif == "empty" and not is_empty then
    return false
  elseif onlyif == "notempty" and is_empty then
    return false
  end

  -- delete

  local res 

  if action ~= "delete" and action ~= "empty" then
    error("action must be 'delete' or 'empty'")
  end

  if is_dir then
    if not path_is_remote then
      if action == "empty" then
        res = not not os.execute("rm -rf '" .. path .. "'/*")
      elseif action == "delete" then
        res = not not os.execute("rm -rf '" .. path .. "'")
      end
    else
      _, res = getOutputArgs(
        "rclone",
        "purge",
        { value = path, type = "quoted"}
      )

      -- purge deletes the directory itself, so we need to recreate it if we want to empty it (there seems to be no rclone empty command, or equivalent)
      if action == "empty" then
        local _, status = getOutputArgs(
          "rclone",
          "mkdir",
          { value = path, type = "quoted"}
        )
        res = res and status
      end
    end
  else
    if action == "empty" then
      res = writeFile(path, "") -- works for remote files too, since writeFile is also implemented for rclone
    elseif action == "delete" then
      if not path_is_remote then
        os.remove(path)
      else
        _, res = getOutputArgs(
          "rclone",
          "deletefile",
          { value = path, type = "quoted"}
        )
      end
    end
  end

  return res
end

--- @param action "copy" | "move" | "link" what to do with the source
--- @param source string the source file or directory
--- @param target string  the target file or directory
--- @param condition? "exists" | "not-exists" | "any" when, related to the existence of the target, to action the source
--- @param create_path? boolean whether to create the path of the target if it doesn't exist
--- @param into? boolean whether to action the source into the target directory, rather than action the source to the target
--- @param all_in? boolean whether to action all the files in the source directory, rather than the source directory itself
--- @param relative_to? string allow specifying
--- @return boolean
function srctgt(action, source, target, condition, create_path, into, all_in, relative_to)

  -- set defaults

  condition = defaultIfNil(condition, "any")
  create_path = defaultIfNil(create_path, true)
  into = defaultIfNil(into, false)
  all_in = defaultIfNil(all_in, false)

  -- resolve tilde

  source = resolveTilde(source)
  target = resolveTilde(target)

  -- check if path is remote, customize things accordingly

  local source_is_remote = pathIsRemote(source)
  local target_is_remote = pathIsRemote(target)
  local has_remote_path = source_is_remote or target_is_remote

  -- resolve relative_to

  if relative_to then
    source = resolveRelativePath(source, relative_to)
    target = resolveRelativePath(target, relative_to)
  end

  -- create (parent) path if necessary

  if create_path then
    if isDir(target) then
      createPath(target)
    else
      createParentPath(target)
    end
  end

  -- check if target exists, and if return early if it does not match the condition

  if pathExists(target) then
    if condition == "not-exists" then
      return false
    end
  else
    if condition == "exists" then
      return false
    end
  end

  -- if into, then change target to be the target directory + the leaf of the source

  if into then
    if not isDir(target) then
      return false
    end
    target = target .. "/" .. getLeafWithoutPath(source)
    createParentPath(target)
  end

  -- prepare a list of sources to action, or a 'list' of one if not all_in

  local sources
  if all_in then
    sources = getAllInPath(source, false, true, true)
  else
    sources = {source}
  end

  local returned_false = false
  local final_target = target
  for _, final_source in ipairs(sources) do
    local res
    
    -- if all_in, then change target to be the target directory + the leaf of the source
    -- this does mean that this doesn't play nice with the `into` option, but I don't think that's a problem
    if all_in then
      final_target = target .. "/" .. getLeafWithoutPath(final_source)
      createParentPath(final_target)
    end
    print(final_source .. " -> " .. final_target)

    if not has_remote_path then 
      if action == "copy" then
        if isDir(final_source) then
          res =  dir.clonetree(final_source, final_target)
        else
          res =  file.copy(final_source, final_target)
        end
      elseif action == "move" then
        res =  os.rename(final_source, final_target)
      elseif action == "link" then
        res =  hs.fs.link(final_source, final_target, true)
      end
    else
      local final_
      if action == "copy" then
        _, res = getOutputArgs(
          "rclone",
          "copyto",
          { value = final_source, type = "quoted"},
          { value = final_target, type = "quoted"}
        )
      elseif action == "move" then
        _, res = getOutputArgs(
          "rclone",
          "moveto",
          { value = final_source, type = "quoted"},
          { value = final_target, type = "quoted"}
        )
      elseif action == "link" then
        error("linking remote files is not supported (not supported by rclone and also not really sensible)")
      end
    end

    if not res then returned_false = true end
  end
  return not returned_false
end





