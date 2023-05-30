--- @class openOpts
--- @field path? string
--- @field url? string
--- @field host? string
--- @field endpoint? string
--- @field params? table
--- @field contents? string
--- @field app? string

--- @param opts openOpts | string
--- @param do_after? function
function open(opts, do_after)
  if type(opts) == "string" then 
    opts = { path = opts }
  end
  opts = opts or {}
  local app_args
  if opts.url then 
    if do_after then -- if we're opening an url, typically, we would exit immediately, negating the need for a callback. Therefore, we want to wait. The only easy way to do this is to use a completely different browser. 
      app_args = { "-a", opts.app or "Safari", "-W" }
      -- Annoyingly, due to a 15 (!) year old bug, Firefox will open the url as well, even if we specify a different browser. I've tried various fixes, but for now we'll just have to live with it and click the tab away manually.
    else
      app_args = { "-a", opts.app or "Firefox"}
    end
  elseif opts.app then 
    app_args = { "-a", opts.app}
  else
    app_args = "-t"
  end
  local path
  if opts.url or opts.host then
    if isUrl(opts.url) then 
      path = transf.url_components.url(opts)
    else
      path = "https://www.google.com/search?q=" .. urlencode(opts.url)
    end
  elseif opts.host then 
    path = mustEnd(opts.host, "/")
    if opts.path then 
      path = path .. mustNotStart(opts.path, "/")
    end
    if opts.params then 
      path = path .. "?" .. transf.table.url_params(opts.params)
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

  table.insert(app_args, 1, "open")
  push(app_args, { value = path, type = "quoted" })

  run(app_args, do_after or true)
end
      