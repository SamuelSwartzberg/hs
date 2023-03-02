local matchers = {
  lua_metacharacters = {"%", "^", "$", "(", ")", ".", "[", "]", "*", "+", "-", "?"},
  regex_metacharacters =  {"\\", "^", "$", ".", "[", "]", "*", "+", "?", "(", ")", "{", "}", "|", "-"},
  doi_prefix_variants = { "doi:", {r = "(?:https?://)(?:dx.)doi.org/?" } },
}

processors = {
  odd_whitespace = {
    ["\n"] = "\\n",
    ["\t"] = "\\t",
    ["\f"] = "\\f",
    ["\r"] = "\\r",
    ["\0"] = "\\0"
  },
  single_char_readable_equivs = {
    ["\t"] = "tab",
    ["\n"] = "newline",
    [","] = "comma",
    [";"] = "semicolon",
    ["."] = "period",
    [":"] = "colon",
    ["!"] = "exclamation mark",
    ["?"] = "question mark",
    ["("] = "left parenthesis",
    [")"] = "right parenthesis",
    ["["] = "left bracket",
    ["]"] = "right bracket",
    ["{"] = "left brace",
    ["}"] = "right brace",
    ["'"] = "single quote",
    ['"'] = "double quote",
    ["*"] = "asterisk",
    ["-"] = "minus",
    ["_"] = "underscore",
    ["="] = "equals",
    ["+"] = "plus",
    ["<"] = "less than",
    [">"] = "greater than",
    ["/"] = "slash",
    ["\\"] = "backslash",
    ["|"] = "vertical bar",
    ["~"] = "tilde",
    ["`"] = "backtick",
    ["@"] = "at sign",
    ["#"] = "pound sign",
    ["$"] = "dollar sign",
    ["%"] = "percent sign",
    ["^"] = "caret",
    ["&"] = "ampersand",
    [" "] = "space",
  },
  normalizing_modmap = {
    c = "cmd",
    cmd = "cmd",
    ["⌘"] = "cmd",
    a = "alt",
    alt = "alt",
    ["⌥"] = "alt",
    s = "shift",
    shift = "shift",
    ["⇧"] = "shift",
    ct = "ctrl",
    ctrl = "ctrl",
    ["⌃"] = "ctrl",
    f = "fn",
    fn = "fn",
  },
  mod_symbolmap = {
    cmd = "⌘",
    alt = "⌥",
    shift = "⇧",
    ctrl = "⌃",
    fn = "fn",
  },
  normalizing_dt_component_map = {
    S = "second",
    sec = "second",
    second = "second",
    seconds = "second",
    [1] = "second",
    M = "minute",
    min = "minute",
    minute = "minute",
    minutes = "minute",
    [60] = "minute",
    H = "hour",
    hour = "hour",
    hours = "hour",
    [3600] = "hour",
    d = "day",
    day = "day",
    days = "day",
    [86400] = "day",
    w = "week",
    week = "week",
    weeks = "week",
    [604800] = "week",
    m = "month",
    month = "month",
    months = "month",
    [2592000] = "month",
    y = "year",
    year = "year",
    years = "year",
    [31536000] = "year",
  },
  dt_component_seconds_map = {
    second = 1,
    minute = 60,
    hour = 60 * 60,
    day = 60 * 60 * 24,
    week = 60 * 60 * 24 * 7,
    month = 60 * 60 * 24 * 30,
    year = 60 * 60 * 24 * 365,
  },
}


--- @alias matcher string | {r: string} | "processor_table_keys"

--- @class replaceSpec
--- @field matcher? matcher | matcher[] 
--- @field matchall? boolean
--- @field processor? string | table | fun(str: string): string 
--- @field mode? "replace" | "prepend" | "append"
--- @field ignore_case? boolean

--- @param str string | string[]
--- @param specs? replaceSpec | replaceSpec[]
--- @return string
function rawreplace(str, specs)
  if specs == nil then return str end
  if type(specs) ~= "table" then specs = {specs} end
  local res = str
  for _, spec in ipairs(specs) do 
    spec = tablex.deepcopy(spec) or {}
    spec.matcher = spec.matcher or matchers.lua_metacharacters
    spec.processor = spec.processor or "\\"
    spec.mode = spec.mode or "prepend"

    if not isListOrEmptyTable(spec.matcher) then
      spec.matcher = {spec.matcher}
    end

    for i, matcher in ipairs(spec.matcher) do
      local match_func
      if type(matcher) == "string" then
        match_func = function(res)
          return stringx.find(res, matcher)
        end
    end
  end
  return res
end

--- @param str string
--- @param type? "luaregex" | "regex" | "modsymbols" | "doi"
--- @param ... any
--- @return string
function replace(str, type, ...)
  local res = str
  type = type or "luaregex"
  if type == "luaregex" then
    res = rawreplace(
      res, 
      {matcher = matchers.lua_metacharacters, processor = "%", mode = "prepend"}
    )
  elseif type == "regex" then
    res = rawreplace(
      res, 
      {
        {matcher = matchers.regex_metacharacters, processor = "\\", mode = "prepend"},
        {matcher = "processor_table_keys", processor = matchers.odd_whitespace, mode = "replace" }
      }
    )
  elseif type == "modsymbols" then 
    res = rawreplace(
      res, 
      {
        {matcher = "processor_table_keys", processor = processors.normalizing_modmap, mode = "replace" },
        {matcher = "processor_table_keys", processor = processors.mod_symbolmap, mode = "replace" }
      }
    )
  elseif type == "doi" then 
    res = rawreplace(
      res, 
      {matcher = matchers.doi_prefix_variants, processor = "https://doi.org/", mode = "replace" }
    )
  elseif type == "urlencode" then
    res = rawreplace(
      res, 
      {matcher = "[^\\w _%\\-\\.~]", processor = char_to_hex, mode = "replace" }
    )
  end
  return res
end


---tr all chars in from to chars in to (1:1), similar to the cli tool `tr`
---@param s string
---@param from string
---@param to string
---@return string
function stringTr(s, from, to)
  for i = 1, #from do
    s = eutf8.gsub(s, eutf8.sub(from, i, i), eutf8.sub(to, i, i))
  end
  return s
end

---tr all chars in from to the same char(s) in to (n:1)
---@param s string
---@param from string
---@param to string
---@return string
function stringTrAllToSame(s, from, to)
  for i = 1, #from do
    s = eutf8.gsub(s, eutf8.sub(from, i, i), to)
  end
  return s
end

local small_words = {
  "a", "an", "and", "as", "at", "but", "by", "en", "for", "if", "in", "of", "on", "or", "the", "to", "v", "v.", "via", "vs", "vs."
}

local word_separators = {
  " ", ":", "–", "—", "-", "\t", "\n"
}

---@param word string
---@return string
function firstCharToUpper(word)
  local index_of_first_letter = eutf8.find(word, "%a")
  if index_of_first_letter then
    local first_letter = eutf8.sub(word, index_of_first_letter, index_of_first_letter)
    local rest_of_word = eutf8.sub(word, index_of_first_letter + 1)
    return eutf8.upper(first_letter) .. rest_of_word
  else
    return word
  end
end

---@param word string
---@return string
function titleCaseWordNoContext(word)
  if find(small_words, word) then
    return word
  elseif eutf8.find(word, "%u") then -- words with uppercase letters are presumed to already be correctly title cased (acronyms, brands, the like)
    return word
  else
    return firstCharToUpper(word)
  end
end

---@param str string
---@return string
function toTitleCase(str)
  local words = splitByMultiple(str, word_separators)
  local title_cased_words = map(words, titleCaseWordNoContext)
  title_cased_words[1] = firstCharToUpper(title_cased_words[1])
  title_cased_words[#title_cased_words] = firstCharToUpper(title_cased_words[#title_cased_words])
  -- it would be tempting to think that we could just join the words with a space, but that would normalize all word separators to spaces, which is not what we want, so we have to search for the correct occurrence of the non-capitalized word and replace it with the capitalized version
  local current_position_in_str = 1
  local original_str_lower = eutf8.lower(str)
  for index, word in ipairs(words) do
    local word_lower = eutf8.lower(word)
    local word_position_in_str = eutf8.find(original_str_lower, word_lower, current_position_in_str, true)
    if word_position_in_str then
      str = eutf8.sub(str, 1, word_position_in_str - 1) .. title_cased_words[index] .. eutf8.sub(str, word_position_in_str + #word_lower)
      current_position_in_str = word_position_in_str + #title_cased_words[index]
    else 
      error("Capitalized word is somehow not in the original string")
    end
    
  end
  return str
end

---@param str string
---@param base string
---@return string
function fromBaseEncoding(str, base)
  return basexx["from_" .. base](str)
end

---@param str string
---@param base string
---@return string
function toBaseEncoding(str, base)
  return basexx["to_" .. base](str)
end

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