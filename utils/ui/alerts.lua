--- @param str string
--- @param duration? any
--- @return string
function alertCode(str, duration)
  return hs.alert.show(str, {textSize = 12, textFont = "Noto Sans Mono", atScreenEdge = 1, radius = 3}, duration or 10)
end