--- @class querySelectorOpts
--- @field url string
--- @field selector string
--- @field only_text? boolean

--- @param opts querySelectorOpts
--- @return string
function queryPage(opts)
  opts = copy(opts) or {}
  opts.url = opts.url or "https://example.com"
  local _, webpage = memoize(hs.http.get, {mode = "fs", invalidation_mode = "invalidate", interval = tblmap.dt_component.seconds.day}, "hs.http.get")(opts.url)

  if not webpage then
    error("Could not fetch webpage at: " .. url)
  end
  local res
  if opts.selector then
    res = memoize(run)({
      "echo",
      { value = webpage, type = "quoted"},
      "|",
      "htmlq",
      opts.only_text and "--text" or nil,
      { value = opts.selector, type = "quoted" }
    })
  else
    res = webpage
  end

  return res
    
end
 