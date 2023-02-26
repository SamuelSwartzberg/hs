

--- @alias pathSpec { path?: string, root?: string, prefix?: string, suffix?: string }

--- @alias resolveOpts { s: pathSpec | string, t: pathSpec | string }

--- @param opts resolveOpts
--- @return string, string
function resolve(opts)

  -- normalize string args to pathSpec

  if type(opts.s) == "string" then
    opts.s = { path = opts.s --[[ @as string ]] } 
  end
  if type(opts.t) == "string" then
    opts.t = { path = opts.t --[[ @as string ]] }
  end

  -- set defaults

  opts.s = opts.s or {}
  opts.s.path = opts.s.path or env.ME -- this is just some reasonable default, may be changed if a more convenient default is needed
  opts.s.root = opts.s.root or env.HOME
  opts.s.prefix = opts.s.prefix or ""
  opts.s.suffx = opts.s.suffix or ""
  opts.t = opts.t or {}
  opts.t.prefix = opts.t.prefix or ""
  opts.t.suffix = opts.t.suffix or ""

  -- declare vars

  local source, target

  -- clean paths

  if opts.s.path then
    ensureAdfix(opts.s.path, opts.s.prefix, true, false, "pre")
    ensureAdfix(opts.s.path, opts.s.suffix, true, false, "suf")
  end

  if opts.t.path then
    ensureAdfix(opts.t.path, opts.t.prefix, true, false, "pre")
    ensureAdfix(opts.t.path, opts.t.suffix, true, false, "suf")
  end

  -- clean roots

  if opts.s.root and opts.s.root ~= "" then
    opts.s.root = ensureAdfix(opts.s.root, "/", true, false, "suf")
  end

  if opts.t.root and opts.t.root ~= "" then
    opts.t.root = ensureAdfix(opts.t.root, "/", true, false, "suf")
  end

  -- init source vars

  local source_relative_path = ensureAdfix(opts.s.path, opts.s.root, false, false, "pre")
  source_relative_path = ensureAdfix(source_relative_path, "/", false, false, "pre")
  source = opts.s.root .. source_relative_path

  if not opts.t.path then -- use at least relative path from source 
    if not opts.t.root then -- use relative path from source and root from source
      target = source_relative_path
    else -- use relative path from source and root from target
      target = opts.t.root .. source_relative_path
    end
  else -- use at least relative path from target 
    local target_relative_path = ensureAdfix(opts.t.path, opts.t.root, false, false, "pre")
    target_relative_path = ensureAdfix(target_relative_path, "/", false, false, "pre")
    if opts.t.root then -- use relative path and root from target
      target = opts.t.root .. target_relative_path
    else -- use relative path from target and root from source
      target = opts.s.root .. target_relative_path
    end
  end

  -- readd prefixes and suffixes to results

  source = ensureAdfix(source, opts.s.prefix, true, false, "pre")
  source = ensureAdfix(source, opts.s.suffix, true, false, "suf")
  target = ensureAdfix(target, opts.t.prefix, true, false, "pre")
  target = ensureAdfix(target, opts.t.suffix, true, false, "suf")

  return source, target
end

--- @param name string
--- @param msg string
function logFile(name, msg)
  local log_file = env.LOGGER_PATH .. "/hs/" .. name .. ".log"
  writeFile(log_file,  msg .. "\n", "exists", true, "a")
end

function resolveTilde(path)
  return path:gsub("^~", env.HOME)
end

--- @alias NodeSpecifier { [string]: NodeSpecifier | string }

--- @param path string
--- @return NodeSpecifier
function fsTreeToContentsTable(path)
  local res = {}
  path = ensureAdfix(path, "/", true, false, "suf")
  for file in hs.fs.dir(path) do
    if file ~= "." and file ~= ".." and file ~= ".DS_Store" and usefulFileValidator(path)  then
      local full_path = path .. file
      if isDir(full_path) then 
        res[file] = fsTreeToContentsTable(full_path)
      else
        res[file] = readFile(full_path)
      end
    end
  end
  return res
end

--- @param path string
--- @return NodeSpecifier
function fsTreeToPathTable(path)
  local res = {}
  path = ensureAdfix(path, "/", true, false, "suf")
  for file in hs.fs.dir(path) do
    if file ~= "." and file ~= ".." and file ~= ".DS_Store" and usefulFileValidator(path)  then
      local full_path = path .. file
      if isDir(full_path) then 
        res[file] = fsTreeToPathTable(full_path)
      else
        listPush(res, full_path)
      end
    end
  end
  return res
end

--- @param path string
--- @param also_include_json? boolean
--- @return NodeSpecifier
function hybridFsDictFileTreeToTable(path, also_include_json)
  local res = {}
  path = ensureAdfix(path, "/", true, false, "suf")
  for file in hs.fs.dir(path) do
    if file ~= "." and file ~= ".." and file ~= ".DS_Store" and usefulFileValidator(path) then
      local full_path = path .. file
      local nodename = getFilenameWithoutExtension(file)
      if isDir(full_path) then 
        res[nodename] = hybridFsDictFileTreeToTable(full_path, also_include_json)
      elseif stringy.endswith(file, ".yaml") then
        res[nodename] = yamlLoad(readFile(full_path, "error"))
      elseif also_include_json and stringy.endswith(file, ".json") then
        res[nodename] = json.decode(readFile(full_path, "error"))
      else
        res[nodename] = readFile(full_path, "error")
      end
    end
  end
  return res
end

--- @param path string
--- @return string
function asAttach(path)
  local mimetype = mimetypes.guess(path) or "text/plain"
  return "#" .. mimetype .. " " .. path
end

--- @param path string
--- @param other_root string must provide its own trailing slash if needed, to allow for relative hosts disallowing a trailing slash
--- @return string, string
function getHomeOtherRootPathPair(path, other_root)
  return resolve({ s = path, t = { root = other_root }})
end

---@param path string
---@param other_root string
---@return string
function getPathRelativeToOtherRoot(path, other_root)
  local _, relative_path = resolve({ s = path, t = { root = other_root }})
  return relative_path
end