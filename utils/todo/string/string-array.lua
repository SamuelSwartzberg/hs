--- @param str string
--- @param separators string[]
--- @return string[]
function splitByMultiple(str, separators)
  local res = {str}
  for _, sep in ipairs(separators) do
    res = map(res, function(str) return stringy.split(str, sep) end)
  end
  res = filter(res, true)
  return res
end