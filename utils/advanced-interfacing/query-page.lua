local rrq = bindArg(relative_require, "utils.dom")

--- @class querySelectorOpts
--- @field url string
--- @field selector string
--- @field only_text boolean

--- @param opts querySelectorOpts
--- @return string
function queryPage(opts)
  opts = tablex.deepcopy(opts) or {}
  opts.url = opts.url or "https://example.com"
  local webpage = memoized(run, {mode = "fs", invalidation_mode = "invalidate", interval = processors.dt_component_seconds_map.day})({
    "curl",
    "-Ls",
    { value = url, type = "quoted"}
  })

  if not webpage then
    error("Could not fetch webpage at: " .. url)
  end
  local res
  if opts.selector then
    res = memoized(run)({"|",
      "htmlq",
      opts.only_text and "--text" or nil,
      { value = opts.selector, type = "quoted" }
    })
  else
    res = webpage
  end

  return res
    
end
 