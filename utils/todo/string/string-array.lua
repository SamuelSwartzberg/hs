--- @param params table<string, string>
--- @param initial_mode? "append" | "initial"
--- @return string
function toUrlParams(params, initial_mode)
  local res = {}
  if not params or type(params) ~= "table" then
    return ""
  end
  for key, value in pairs(params) do
    table.insert(res, key .. "=" .. value)
  end
  table.sort(res)
  local outstr = table.concat(res, "&")
  if initial_mode == "append" then
    return "&" .. outstr
  elseif initial_mode == "initial" then
    return "?" .. outstr
  else
    return outstr
  end
end

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

--- @param str string
--- @param pattern string
--- @param utf8? boolean
--- @return string[]
function extractAllMatches(str, pattern, utf8)
  local lib = utf8 and eutf8 or onig
  local res = {}
  for match in lib.gmatch(str, pattern) do
    table.insert(res, match)
  end
  return res
end

--- @param str string
--- @return string[]
function splitBytes(str)
  local t = {}
  for i = 1, #str do
    t[i] = str:sub(i, i)
  end
  return t
end


--- @param str string
--- @return string[]
function splitChars(str)
  local t = {}
  for i = 1, eutf8.len(str) do
    t[i] = eutf8.sub(str, i, i)
  end
  return t
end

--- @param str string
--- @return string[]
function splitLines(str)
  return stringy.split(
    stringy.strip(str),
    "\n"
  )
end