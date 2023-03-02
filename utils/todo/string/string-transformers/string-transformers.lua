--- @param doi string
--- @return string
function toResolvedDoi(doi)
  doi = ensureAdfix(doi, "doi:", false)
  doi = ensureAdfix(doi, "https://dx.doi.org/", false)
  doi = ensureAdfix(doi, "http://dx.doi.org/", false)
  doi = ensureAdfix(doi, "http://doi.org/", false)
  doi = ensureAdfix(doi, "doi.org/", false)
  doi = ensureAdfix(doi, "dx.doi.org/", false)
  return ensureAdfix(doi, "https://doi.org/", false)
end

--- @param str string
--- @return string
function extractDoi(str)
  local str_lower = eutf8.lower(str)
  local doi = eutf8.match(str_lower, "10%d%d%d%d%d?%d?%d?%d?%d?/[-._;()/:A-Z0-9]+")
  return doi
end

--- @param str string
--- @return string
function foldStr(str)
  local res = eutf8.gsub(str, "\n", " ")
  return res
end

---@param str string
---@param to_remove string
---@return string
function removeCaseInsensitive(str, to_remove)
  local lower_str = str:lower()
  local lower_to_remove = to_remove:lower()
  local start, stop = eutf8.find(lower_str, lower_to_remove, 1, true)
  if start then
    return eutf8.sub(str, 1, start - 1) .. eutf8.sub(str, stop + 1)
  else
    return str
  end
end

--- replace all chars not in pattern with sep, and remove consecutive, leading, trailing sep. Useful for converting strings to snake_case, kebab-case, etc.
--- @param str string
--- @param pattern string
--- @param sep string
--- @param mode "lower"|"upper"
function toPatternSeparator(str, pattern, sep, mode)
  local escaped_sep = escapeLuaMetacharacters(sep)
  if mode == "lower" then
    str = str:lower()
  elseif mode == "upper" then
    str = str:upper()
  end
  str = eutf8.gsub(str, "[^" .. pattern .. escaped_sep ..  "]", sep)
  str = eutf8.gsub(str, escaped_sep .. "+", sep)
  str = eutf8.gsub(str, "^" .. escaped_sep, "")
  str = eutf8.gsub(str, escaped_sep .. "$", "")
  return str
end

--- @type fun(str: string): string
toLowerAlphanumUnderscore = bind(toPatternSeparator, {["2"] = {"%w%d", "_", "lower"}})
--- @type fun(str: string): string
toLowerAlphanumMinus = bind(toPatternSeparator, {["2"] = {"%w%d", "-", "lower"}})
--- @type fun(str: string): string
toUpperAlphanumUnderscore = bind(toPatternSeparator, {["2"] = {"%w%d", "_", "upper"}})
--- @type fun(str: string): string
toUpperAlphanumMinus = bind(toPatternSeparator, {["2"] = {"%w%d", "-", "upper"}})

--- @param str string
--- @return string
function romanize(str)
  local raw_romanized = getOutputTask(
    { "echo", "-n",  {value = str, type = "quoted"}, "|", "kakasi", "-iutf8", "-outf8", "-ka", "-Ea", "-Ka", "-Ha", "-Ja", "-s", "-ga" }
  )
  local is_ok, romanized = pcall(eutf8.gsub, raw_romanized, "(%w)%^", "%1%1")
  if not is_ok then
    return str -- if there's an error, just return the original string
  end
  romanized = eutf8.gsub(romanized, "(kigou)", "")
  romanized = eutf8.gsub(romanized, "'", "")
  return romanized
end

--- @param str string
--- @return string
function romanizeToLowerAlphanumUnderscore(str)
  str = eutf8.gsub(str, "[%^']", "")
  str = romanize(str)
  str = toLowerAlphanumUnderscore(str)
  return str
end

--- @param field string
--- @return string
function escapeField(field)
  local escaped_quotes = eutf8.gsub(field, '"', '""')
  local escaped_newlines = eutf8.gsub(escaped_quotes, '\n', '\\n') -- not technically necessary for CSV, but so many implementations don't handle newlines properly that it's worth it
  return '"' .. escaped_newlines  .. '"'
end

--- @param str string
--- @return string | nil
function extractFirstThingInParentheses(str)
  local first_parentheses = onig.match(str, "\\(([^)]+)\\)")
  if first_parentheses then
    return first_parentheses
  else
    return nil
  end
end

--- @param mods string[]
--- @param key string
--- @return string | nil
function shortcutToString(mods, key)
  local modifier_str = stringx.join("", modsToSymbols(mods))
  if key ~= "" then
    if modifier_str ~= "" then
      return modifier_str .. " " .. key
    else
      return key
    end
  else
    return nil
  end
end

--- @param str string
--- @param splitter string
--- @param prefix string
--- @return string
function prependAllWith(str, splitter, prefix)
  local parts 
  if #splitter == 1 then
    parts = stringy.split(str, splitter)
  else
    parts = stringx.split(str, splitter)
  end
  local prefixed_parts = map(
    parts,
    function (value)
      return prefix .. value
    end
  )
  return stringx.join(splitter, prefixed_parts)
end

--- @param str string
--- @param prefix
function quoteLines(str, prefix)
  local body = stringy.strip(str)
  local lines = stringx.splitlines(body)
  local newlines = {}
  for i, line in ipairs(lines) do
    if stringy.startswith(line, prefix) then
      table.insert(newlines, prefix .. line)
    else
      table.insert(newlines, prefix .. " " .. line)
    end
  end
  return stringx.join("\n", newlines)
end

 