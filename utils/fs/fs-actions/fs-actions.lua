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
      local args = stringy.split(line, " ")
      print(
        "Would execute"
        .. " _G[\"" .. command .. "\"]"
        .. "(" .. table.concat(args, ", ") .. ")"
      )
      _G[command](table.unpack(args))
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
--- @param thing? "notdir" | "dir" | "any"
--- @param action? "delete" | "empty"
--- @return boolean
function delete(path, thing, action)
  thing = defaultIfNil(thing, "any")
  action = defaultIfNil(action, "delete")
  path = resolveTilde(path)
  if 
    (
      isDir(path) and
      thing == "notdir"
    ) or
    (
      not isDir(path) and
      thing == "dir"
    )
  then
    return false
  end    
  if isDir(path) then
    if action == "empty" then
      local res = os.execute("rm -rf '" .. path .. "'/*")
      return not not res
    else
      local res os.execute("rm -rf '" .. path .. "'")
      return not not res
    end
  else
    if action == "empty" then
      return writeFile(path, "")
    else
      return os.remove(path)
    end
  end
end

--- @param action "copy" | "move" | "link" what to do with the source
--- @param source string the source file or directory
--- @param target string  the target file or directory
--- @param condition? "exists" | "not-exists" | "any" when, related to the existence of the target, to action the source
--- @param create_path? boolean whether to create the path of the target if it doesn't exist
--- @param into? boolean whether to action the source into the target directory, rather than action the source to the target
--- @param all_in? boolean whether to action all the files in the source directory, rather than the source directory itself
--- @return boolean
function srctgt(action, source, target, condition, create_path, into, all_in)

  -- set defaults

  condition = defaultIfNil(condition, "any")
  create_path = defaultIfNil(create_path, true)
  into = defaultIfNil(into, false)
  all_in = defaultIfNil(all_in, false)

  -- resolve tilde

  source = resolveTilde(source)
  target = resolveTilde(target)

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
  for _, source in ipairs(sources) do
    local res

    -- if all_in, then change target to be the target directory + the leaf of the source
    -- this does mean that this doesn't play nice with the `into` option, but I don't think that's a problem
    if all_in then
      target = target .. "/" .. getLeafWithoutPath(source)
    end

    if action == "copy" then
      if isDir(source) then
        res =  dir.clonetree(source, target)
      else
        res =  file.copy(source, target)
      end
    elseif action == "move" then
      res =  os.rename(source, target)
    elseif action == "link" then
      res =  hs.fs.link(source, target, true)
    end

    if not res then returned_false = true end
  end
  return not returned_false
end





