--- @alias pathSpec { path?: string, root?: string, prefix?: string, suffix?: string }

--- @alias resolveOpts { s: pathSpec | string, t: pathSpec | string }

--- @param opts resolveOpts | string
--- @return string, string
function resolve(opts)

  -- normalize opts

  if type(opts) == "string" then
    opts = { s = { path = opts --[[ @as string ]] } }
  end

  -- normalize string args to pathSpec

  if type(opts.s) == "string" then
    opts.s = { path = opts.s --[[ @as string ]] } 
  end
  if type(opts.t) == "string" then
    opts.t = { path = opts.t --[[ @as string ]] }
  end

  -- set defaults

  opts.s = tablex.deepcopy(opts.s) or {}
  opts.s.path = opts.s.path or env.ME -- this is just some reasonable default, may be changed if a more convenient default is needed
  opts.s.root = opts.s.root or env.HOME
  opts.s.prefix = opts.s.prefix or ""
  opts.s.suffx = opts.s.suffix or ""
  opts.t = tablex.deepcopy(opts.t) or {}
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

remote = function(path)
  return select(2, resolve({s=path, t = {prefix = "hsftp:", root = ""}}))
end
fshttp = function(path)
  return select(2, resolve({s=path, t = {prefix = env.FS_HTTP_SERVER, root = ""}}))
end