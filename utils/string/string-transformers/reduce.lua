--- @param str string
---@param limit integer
---@param suffix string?
---@return string
function stringTruncate(str, limit, suffix)
  if str:len() > limit then
    return eutf8.sub(str, 1, limit) .. (suffix or "")
  else
    return str
  end
end

--- @param str string
--- @return string
function withoutVowels(str)
  local res = eutf8.gsub(str, "[aeiou]", "")
  return res
end

--- @param str string
--- @return string
function shortWithoutVowelString(str)
  return stringTruncate(withoutVowels(str), 2)
end


--- @param str string
--- @return string
function getSubstringAtStartOfFirstDigit(str)
  local i = 1
  while i <= #str do
      if eutf8.match(eutf8.sub(str, i, i), "%d") then
          return eutf8.sub(str, i)
      end
      i = i + 1
  end
  return str
end
