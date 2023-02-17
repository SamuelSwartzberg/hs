--- @param c string character to encode
--- @return string
char_to_hex = function(c)
  return string.format("%%%02X", string.byte(c))
end

--- @param url string
--- @param spaces_percent? boolean
--- @return string
function urlencode(url, spaces_percent)
  if url == nil then
    return ""
  end
  url = url:gsub("\n", "\r\n")
  url = string.gsub(url, "([^%w _%%%-%.~])", char_to_hex)
  if spaces_percent then
    url = string.gsub(url, " ", "%%20")
  else
    url = string.gsub(url, " ", "+")
  end
  return url
end

--- @param x string
--- @return string
hex_to_char = function(x)
  return string.char(tonumber(x, 16))
end

--- @param url string
--- @return string
urldecode = function(url)
  if url == nil then
    return ""
  end
  url = url:gsub("+", " ")
  url = url:gsub("%%(%x%x)", hex_to_char)
  return url
end
