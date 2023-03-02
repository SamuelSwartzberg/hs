local printable_ascii_chars = { "!", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "]", "^", "_", "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "{", "|", "}", "~" }

--- @param start string single char
--- @param stop string single char
--- @return string[]
function printableAsciiRange(start, stop)
  local res = {}
  local record = false
  for _, char in ipairs(printable_ascii_chars) do
    if char == start then
      record = true
    end
    if record then
      table.insert(res, char)
    end
    if char == stop then
      break
    end
  end
  return res
end

--- @alias range_specifier string | string[] should be [string, string] but that doesn't work

--- @param parts range_specifier[]
--- @return string[]
function partwiseAsciiRange(parts)
  local res = {}
  for _, part in ipairs(parts) do
    if type(part) == "table" then
      res =  listConcat(res, printableAsciiRange(part[1], part[2]))
    else
      table.insert(res, part)
    end
  end
  table.sort(res) -- useful for comparisons later
  return res
end

local printable_ascii_chars = { "!", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "]", "^", "_", "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "{", "|", "}", "~" }

--- @param chars string[]
--- @return string[]
function printableAsciiComplement(chars) -- assumes that chars is sorted, since that makes the runtime linear rather than quadratic
  local res = {}
  local ascii_index = 1
  for index, char in ipairs(chars) do -- if the current char is in printable_ascii_chars, just advance ascii_index by one, otherwise add chars and increase ascii_index until we find a char that is in printable_ascii_chars
    while printable_ascii_chars[ascii_index] ~= char do
      table.insert(res, printable_ascii_chars[ascii_index])
      ascii_index = ascii_index + 1
    end
    ascii_index = ascii_index + 1
  end
  -- now we've reached the end of chars, so we just need to add the rest of printable_ascii_chars
  while printable_ascii_chars[ascii_index] do
    table.insert(res, printable_ascii_chars[ascii_index])
    ascii_index = ascii_index + 1
  end
  return res
end
