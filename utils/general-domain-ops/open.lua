--- @class openOpts
--- @field path? string
--- @field url? string
--- @field contents? string
--- @field app? string

--- @param opts openOpts | string
function open(opts)
  if type(opts) == "string" then 
    opts = { path = opts }
  end
  opts = opts or {}
  if opts.url then 
    opts.app = opts.app or "Firefox"
  else
    opts.app = opts.app or "Visual Studio Code"
  end
  local path
  if opts.url then 
    path = opts.url
  elseif opts.contents then 
    if opts.path then
      path = writeFile(opts.path, opts.contents)
    else 
      path = writeFile(nil, opts.contents)
    end
  elseif opts.path then
    path = opts.path
  else
    path = writeFile(nil, "")
  end

  if not path then 
    error("Something went wrong when determining the path to open. Opts that caused this:\n\n" .. json.encode(opts))
  end

  run({
    "open",
    "-a",
     { value = opts.app, type = "quoted" },
    { value = path, type = "quoted" }
  }, true)
end
      