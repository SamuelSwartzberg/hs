--- @param str string
--- @param opts? table
--- @return string
function alert(str, opts)
  opts = copy(opts) or {}
  opts.duration = opts.duration or 10
  return hs.alert.show(str, {textSize = 12, textFont = "Noto Sans Mono", atScreenEdge = 1, radius = 3}, opts.duration)
end