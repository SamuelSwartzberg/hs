
--- @param url string
--- @param spaces_percent? boolean
--- @return string
function urlencode(url, spaces_percent)
  if url == nil then
    return ""
  end
  url = url:gsub("\n", "\r\n")
  url = string.gsub(url, "([^%w _%%%-%.~])", transf.char.percent)
  if spaces_percent then
    url = string.gsub(url, " ", "%%20")
  else
    url = string.gsub(url, " ", "+")
  end
  return url
end
