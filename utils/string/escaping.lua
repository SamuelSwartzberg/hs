--- @param str string
--- @param chars_to_escape string[]
--- @param escape_char? string
--- @return string
function escapeCharacters(str, chars_to_escape, escape_char)
  local escape_char = escape_char or "\\"
  local result = str
  for _, char in ipairs(chars_to_escape) do
    result = stringx.replace(result, char, escape_char .. char)
  end
  return result
end

--- @param str string
--- @param char_to_escape string
--- @param escape_char? string
--- @return string
function escapeCharacter(str, char_to_escape, escape_char)
  return escapeCharacters(str, {char_to_escape}, escape_char)
end

local lua_metacharacters = {"%", "^", "$", "(", ")", ".", "[", "]", "*", "+", "-", "?"}

--- @param char string
--- @return string
function escapeLuaMetacharacter(char)
  if valuesContain(lua_metacharacters, char) then
    return "%" .. char
  else
    return char
  end
end

--- @param str string
--- @return string
function escapeAllLuaMetacharacters(str)
  local outstr = str
  for _, char in ipairs(lua_metacharacters) do
    outstr = stringx.replace(outstr, char, "%" .. char)
  end
  return outstr
end

--- @param str string
--- @return string
function escapeGeneralRegex(str) -- not the lua kind, the general kind, where '\' is the escape character and % has no special meaning
  local chars_to_escape = {"\\", "^", "$", ".", "[", "]", "*", "+", "?", "(", ")", "{", "}", "|", "-"}
  local escaped_result = escapeCharacters(str, chars_to_escape, "\\")
  escaped_result = escapeCharacter(escaped_result, "\n", "\\n")
  escaped_result = escapeCharacter(escaped_result, "\t", "\\t")
  escaped_result = escapeCharacter(escaped_result, "\f", "\\f")
  escaped_result = escapeCharacter(escaped_result, "\r", "\\r")
  escaped_result = escapeCharacter(escaped_result, "\0", "\\0")
  return escaped_result
end