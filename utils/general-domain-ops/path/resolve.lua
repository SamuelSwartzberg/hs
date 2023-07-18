--- @class pathSpec 
--- @field path? string
--- @field root? string
--- @field prefix? string will be removed from the beginning of the path if it exists before resolving, and then added back at the very end after resolving
--- @field suffix? string will be removed from the beginning of the path if it exists before resolving, and then added back at the very end after resolving

--- @class resolveOpts
--- @field s pathSpec|string
--- @field t pathSpec|string

--- resolves a path, where some elements are relative to others
--- specifically, we recieve some parts of an s and t path, and we resolve them to a source and target path
--- s.path is necessary, since we need to resolve relative to something
--- we prefer to use as many options of t for target, but will use s to infer the rest
--- prefix and suffix are most useful when paths have some extra info that is not itself a path
---   such as a url or scheme as a prefix
---   or query params or a file extension as a suffix
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

  opts.s = get.table.copy(opts.s) or {}
  opts.s.path = opts.s.path or env.ME -- this is just some reasonable default, may be changed if a more convenient default is needed
  opts.s.root = opts.s.root or env.HOME
  opts.s.prefix = opts.s.prefix or ""
  opts.s.suffix = opts.s.suffix or ""
  opts.t = get.table.copy(opts.t) or {}
  opts.t.prefix = opts.t.prefix or ""
  opts.t.suffix = opts.t.suffix or ""

  -- declare vars

  local source, target

  -- clean paths

  if opts.s.path then
    opts.s.path = get.string.no_prefix_string(opts.s.path, opts.s.prefix)
    opts.s.path = get.string.no_suffix_string(opts.s.path, opts.s.suffix)
  end

  if opts.t.path then
    opts.t.path = get.string.no_prefix_string(opts.t.path, opts.t.prefix)
    opts.t.path = get.string.no_suffix_string(opts.t.path, opts.t.suffix)
  end

  -- clean roots

  if opts.s.root and opts.s.root ~= "" then
    opts.s.root = get.string.with_suffix_string(opts.s.root, "/")
  end

  if opts.t.root and opts.t.root ~= "" then
    opts.t.root = get.string.with_suffix_string(opts.t.root, "/")
  end

  -- init source vars

  local source_relative_path = get.string.no_prefix_string(opts.s.path, opts.s.root)
  source_relative_path = get.string.no_prefix_string(source_relative_path, "/")
  source = opts.s.root .. source_relative_path

  if not opts.t.path then -- use at least relative path from source 
    if not opts.t.root then -- use relative path from source and root from source
      target = source
    else -- use relative path from source and root from target
      target = opts.t.root .. source_relative_path
    end
  else -- use at least relative path from target 
    local target_relative_path = get.string.no_prefix_string(opts.t.path, opts.t.root or "")
    target_relative_path = get.string.no_prefix_string(target_relative_path, "/")
    if opts.t.root then -- use relative path and root from target
      target = opts.t.root .. target_relative_path
    else -- use relative path from target and root from source
      target = opts.s.root .. target_relative_path
    end
  end

  -- readd prefixes and suffixes to results

  source = get.string.with_prefix_string(source, opts.s.prefix)
  source = get.string.with_suffix_string(source, opts.s.suffix)
  target = get.string.with_prefix_string(target, opts.t.prefix)
  target = get.string.with_suffix_string(target, opts.t.suffix)

  return source, target
end