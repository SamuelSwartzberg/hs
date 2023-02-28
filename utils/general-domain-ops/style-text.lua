
--- @class styleTextOpts
--- @field style string
--- @field starts number
--- @field ends number

--- @param str hs.styledtext
--- @param opts styleTextOpts
--- @return hs.styledtext
function styleText(str, opts)
  local style 
  opts.starts = opts.starts or 1
  opts.ends = opts.ends or #str
  if opts.style == "light" then 
    style = { color = { red = 0, green = 0, blue = 0, alpha = 0.3 } }
  end

  return str:setStyle(style, opts.starts, opts.ends)
end