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
  local app_args
  if opts.url then 
    app_args = { "-a", opts.app or "Firefox"}
  elseif opts.app then 
    app_args = { "-a", opts.app}
  else
    app_args = "-t"
  end
  local path
  if opts.url then 
    if isUrl(opts.url) then 
      path = opts.url
    else
      path = "https://www.google.com/search?q=" .. urlencode(opts.url)
    end
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

  local args = concat(
    "open",
    app_args,
    { value = path, type = "quoted" }
  )

  run(args, true)
end
      