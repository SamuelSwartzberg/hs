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
  }
}


--- @alias matcher string | {r: string} | "matcher_table_keys"

--- @class replaceSpec
--- @field matcher? matcher | matcher[] 
--- @field must_match_entire_string? boolean
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
--- @param type? "luaregex" | "regex" | "modsymbols"
--- @return string
function replace(str, type)
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
        {matcher = "matcher_table_keys", processor = matchers.odd_whitespace, mode = "replace" }
      }
    )
  elseif type == "modsymbols" then 
    res = rawreplace(
      res, 
      {
        {matcher = "matcher_table_keys", processor = processors.normalizing_modmap, mode = "replace" },
        {matcher = "matcher_table_keys", processor = processors.mod_symbolmap, mode = "replace" }
      }
    )
  elseif type == "doi" then 
    res = rawreplace(
      res, 
      {matcher = matchers.doi_prefix_variants, processor = "https://doi.org/", mode = "replace" }
    )
  end
  return res
end