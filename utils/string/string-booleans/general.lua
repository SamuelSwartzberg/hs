---@param str string
---@param regex_inner string
---@return boolean
function asciiStringContaisSomeNative(str, regex_inner)
  local regex = ("[%s]"):format(regex_inner)
  return not not string.find(str, regex)
end

---@param str string
---@param list_of_chars string[]
---@return boolean
function asciiStringContainsSome(str, list_of_chars)
  for _, char in ipairs(list_of_chars) do
    if stringy.find(str, char) then return true end
  end
  return false
end

---@param str string
---@param regex_inner string
---@return boolean
function asciiStringContainsNoneNative(str, regex_inner) 
  local regex = ("[%s]"):format(regex_inner)
  return not string.find(str, regex)
end

---significantly faster than using asciiStringContainsNoneNative for smaller amounts of chars (< 20 or so)
---@param str string
---@param list_of_chars string[]
---@return boolean
function asciiStringContainsNone(str, list_of_chars)
  for _, char in ipairs(list_of_chars) do
    if stringy.find(str, char) then return false end
  end
  return true
end
---faster than using asciiStringContainsNone on the complement for any case I benchmarked
---@param str string
---@param regex_inner string
---@return boolean
function asciiStringContainsOnly(str, regex_inner) 
  local regex = ("[^%s]"):format(regex_inner)
  return not string.find(str, regex)
end

---@param str string
---@param regex_inner string
---@return boolean
function utf8StringContainsOnly(str, regex_inner)
  local regex = ("[^%s]"):format(regex_inner)
  return not eutf8.find(str, regex)
end

--- @alias starts_ends_specifier {starts: string, ends: string}

--- @param str string
--- @param specifier starts_ends_specifier
--- @return boolean
function startsEndsWith(str, specifier)
  return stringy.startswith(str, specifier.starts) and stringy.endswith(str, specifier.ends)
end

--- returns true if the string starts with the given substring, or if the string does not contain the given substring at all
--- @param str string 
--- @param first string
--- @return boolean
function isFirstIfAny(str, first)
  if eutf8.find(str, "^" .. first) then
    return true
  else
    return not eutf8.find(str, first)
  end
end

--- returns true if the string ends with the given substring, or if the string does not contain the given substring at all
--- @param str string
--- @param last string
--- @return boolean
function isLastIfAny(str, last)
  if eutf8.find(str, last .. "$") then
    return true
  else
    return not eutf8.find(str, last)
  end
end