--- @param path string
--- @return boolean
function createDir(path)
  path = resolveTilde(path)
  return hs.fs.mkdir(path)
end

--- @param path string
--- @return boolean
function createPath(path)
  path = resolveTilde(path)
  local _, res = hs.execute("mkdir -p '" .. path .. "'")
  return res
end

--- @param path string
--- @return boolean
function createParentPath(path)
  path = resolveTilde(path)
  local parent_path = getParentPath(path)
  return createPath(parent_path)
end

--- @param path string
--- @param contents string
--- @return boolean
function writePathAndFile(path, contents)
  path = resolveTilde(path)
  createParentPath( path)
  return writeFile(path, contents)
end

--- @param path string
--- @param contents string
--- @return boolean
function createPathAndFile(path, contents)
  path = resolveTilde(path)
  createParentPath( path)
  return createFile(path, contents)
end


--- @param path string
--- @param contents string
--- @return boolean
function writeFile(path, contents)
  path = resolveTilde(path)
  local file = io.open(path, "w")
  if file ~= nil then
    file:write(contents or "")
    io.close(file)
    return true
  else
    return false
  end
end

--- @param path string
--- @param contents string
--- @return boolean
function writeExistingFile(path, contents)
  if pathExists(path) then
    return writeFile(path, contents)
  else
    return false
  end
end

--- @param path string
--- @param contents string
--- @return boolean
function createFile(path, contents) -- create = write if not exists
  if not pathExists(path) then
    return writeFile(path, contents)
  else
    return false
  end
end

--- @param path string
--- @param contents string
--- @return boolean
function appendFile(path, contents)
  path = resolveTilde(path)
  local file = io.open(path, "a")
  if file ~= nil then
    file:write(contents)
    io.close(file)
    return true
  else
    return false
  end
end

--- @param contents? string
--- @param filename? string
--- @param extension? string
--- @return string
function createUniqueTempFile(contents, filename, extension)
  extension = extension or "tmp"
  local unique_filename = os.time() .. "-" .. (filename or math.random(1000000))
  local path = ensureAdfix(env.TMPDIR, "/", true, false, "suf") .. unique_filename .. "." .. extension
  createFile(path, contents or "")
  return path
end

--- @param contents string
--- @param do_this fun(tmp_file: string): nil
--- @param filename? string
--- @param extension? string
function doWithTempFile(contents, do_this, filename, extension)
  local tmp_file = createUniqueTempFile(contents, filename, extension)
  do_this(tmp_file)
  deleteFile(tmp_file)
end

--- @param contents string
--- @param do_this fun(tmp_file: string): nil
--- @param filename? string
--- @param extension? string
function doWithTempFileEditedInEditor(contents, do_this, filename, extension)
  local tmp_file = createUniqueTempFile(contents, filename, extension)
  runHsTask({
    "code",
    "--wait",
    "--disable-extensions",
    {value = tmp_file, type = "quoted"},
  }, function(exit_code)
    if exit_code == 0 then 
      do_this(tmp_file)
    end
    deleteFile(tmp_file)
  end)
end

--- @param source string
--- @param target? string
--- @param do_after? fun(target: string): nil
function zipFile(source, target, do_after)
  local source, target = getSourceAndTarget({
    source = source,
    target = target,
    target_ext = "zip"
  })
  runHsTask({
    "zip",
    "-r",
    {value = target, type = "quoted"},
    {value = source, type = "quoted"},
  }, function() if do_after then do_after(target) end end)
end

--- @param source string
--- @param target string
--- @param hard_link? boolean
function link(source, target, hard_link)
  source = resolveTilde(source)
  target = resolveTilde(target)
  hs.fs.link(source, target, not hard_link)
end

--- @param source string
--- @param target string
--- @param hard_link? boolean
function linkAllInDir(source, target, hard_link)
  source = resolveTilde(source)
  target = resolveTilde(target)
  for _, file in ipairs(getChildren(source)) do
    print("linking " .. file .. " to " .. target .. "/" .. getLeafWithoutPath(file))
    link(file, target .. "/" .. getLeafWithoutPath(file), hard_link)
  end
end

--- @param name string
--- @param msg string
function logFile(name, msg)
  local log_file = env.LOGGER_PATH .. "/hs/" .. name .. ".log"
  if not pathExists(log_file) then
    createPathAndFile(log_file, "")
  end
  appendFile(log_file, msg .. "\n")
end