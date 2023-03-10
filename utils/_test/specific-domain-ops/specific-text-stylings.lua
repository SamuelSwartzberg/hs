

--- @param str string
--- @return hs.styledtext
function surroundByStartEndMarkers(str)
  local res =  hs.styledtext.new("^" .. str .. "$")
  res = styleText(res, { style = "light", starts = 1, ends = 1 })
  res = styleText(res, { style = "light", starts = #res, ends = #res})
  return res
end