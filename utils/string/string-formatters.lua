
--- @param str hs.styledtext
--- @param starts number
--- @param ends number
--- @return hs.styledtext
function lightText(str, starts, ends)
  return str:setStyle({ color = { red = 0, green = 0, blue = 0, alpha = 0.3 } }, starts, ends)
end

--- @param str string
--- @return hs.styledtext
function surroundByStartEndMarkers(str)
  local res =  hs.styledtext.new("^" .. str .. "$")
  res = lightText(res, 1, 1)
  res = lightText(res, #res, #res)
  return res
end