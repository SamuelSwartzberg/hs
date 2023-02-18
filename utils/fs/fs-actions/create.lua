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

-- todo: remote?

--- @param path string
--- @param contents string
--- @param condition? "exists" | "not-exists" | "any"
--- @param create_path? boolean
--- @param mode? "w" | "a"
--- @return boolean
function writeFile(path, contents, condition, create_path, mode)
  condition = defaultIfNil(condition, "any")
  create_path = defaultIfNil(create_path, true)
  mode = defaultIfNil(mode, "w")
  path = resolveTilde(path)
  if create_path then
    createParentPath(path)
  end
  if pathExists(path) then
    if condition == "not-exists" then
      return false
    end
  else
    if condition == "exists" then
      return false
    end
  end
  local file = io.open(path, mode)
  if file ~= nil then
    file:write(contents or "")
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
  writeFile(path, contents or "", "not-exists")
  return path
end

--- @param contents string
--- @param do_this fun(tmp_file: string): nil
--- @param filename? string
--- @param extension? string
function doWithTempFile(contents, do_this, filename, extension)
  local tmp_file = createUniqueTempFile(contents, filename, extension)
  do_this(tmp_file)
  delete(tmp_file)
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
    delete(tmp_file)
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

--- @param name string
--- @param msg string
function logFile(name, msg)
  local log_file = env.LOGGER_PATH .. "/hs/" .. name .. ".log"
  writeFile(log_file,  msg .. "\n", "exists", true, "a")
end