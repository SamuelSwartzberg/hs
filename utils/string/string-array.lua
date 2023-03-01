---dropin replacement for a generic join function, but escapes each field, e.g. for csv
---@param field_sep string
---@param row string[]
---@return string
function joinRow(field_sep, row)
  local res = {}
  for _, field in ipairs(row) do
    table.insert(res, escapeField(field))
  end
  return table.concat(res, field_sep)
end

--- @type fun(row: string[]): string
joinRowComma = bindArg(joinRow, ",")
--- @type fun(row: string[]): string
joinRowTab = bindArg(joinRow, "\t")

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

--- gets the longest common prefix that all strings in a list of strings share
--- @param str_list string[]
--- @return string
function longestCommonPrefix(str_list)
  local prefix = str_list[1]
  for _, str in ipairs(str_list) do
    for i = 1, #prefix do
      if eutf8.sub(str, 1, i) ~= eutf8.sub(prefix, 1, i) then
        prefix = eutf8.sub(prefix, 1, i - 1)
        break
      end
    end
  end
  return prefix
end

--- gets the longest common suffix that all strings in a list of strings share
--- @param str_list string[]
--- @return string
function longestCommonSuffix(str_list)
  local reversed_str_list = map(str_list, function(str) return eutf8.reverse(str) end)
  local reversed_prefix = longestCommonPrefix(reversed_str_list)
  return eutf8.reverse(reversed_prefix)
end

--- @param str string
--- @param separators string[]
--- @return string[]
function splitByMultiple(str, separators)
  local res = {str}
  for _, sep in ipairs(separators) do
    res = map(res, function(str) return stringy.split(str, sep) end)
  end
  res = filterValues(res, function(str) return str ~= "" end)
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