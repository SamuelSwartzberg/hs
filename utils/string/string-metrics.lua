--- @param str string
--- @return integer
function cleanedLength(str)
  local cleaned = eutf8.gsub(str, "%s+", " ")
  return eutf8.len(cleaned)
end