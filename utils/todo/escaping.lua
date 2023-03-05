mt = {
  _contains = {
    lua_metacharacters = {"%", "^", "$", "(", ")", ".", "[", "]", "*", "+", "-", "?"},
    regex_metacharacters =  {"\\", "^", "$", ".", "[", "]", "*", "+", "?", "(", ")", "{", "}", "|", "-"},
    small_words = {
      "a", "an", "and", "as", "at", "but", "by", "en", "for", "if", "in", "of", "on", "or", "the", "to", "v", "v.", "via", "vs", "vs."
    }
  },
  _list = {
    tree_node_keys = {"pos", "children", "parent", "text", "tag", "attrs", "cdata"}
  },
  _r = {
    text_bloat = {
      youtube = {
        video = "[\\-【 \\(]*(?:Official )?(?:Music Video|Video|MV)(?: full)?[\\-】 \\)]*",
        misc = "[\\-【  \\(]*(?:Audio|TVアニメ|Official)[\\-】 \\)]*",
        channel_topic_producer = "[\\-【 \\(]*(?:Official|YouTube|Music|Topic|SMEJ|VEVO|Channel|チャンネル ?){1, 3})[\\-】 \\)]*",
        slash_suffix = " */ *[^/]+$"
      }
    },
    case = {
      snake = "[a-zA-Z0-9_]+",
      upper_snake = "[A-Z0-9_]+",
      lower = "[a-z]+",
      upper = "[A-Z]+",
    },
    syntax = {
      dice = "\\d+d\\d+[/x]\\d+[+-]\\d+"
    },
    date = {
      rfc3339 = "\\d{4}(?:" ..
      "\\-\\d{2}(?:" ..
        "\\-\\d{2}(?:" ..
          "T\\d{2}(?:" ..
            "\\:\\d{2}(?:" ..
              "\\:\\d{2}(?:" ..
                "\\.\\d{1,9}"
              ..")?"
            ..")?"
          ..")?Z?"
        ..")?"
      ..")?"
    ..")?"
    },
    b = {
      b64 = {
        gen = "[A-Za-z0-9+/=]+",
        url = "[A-Za-z0-9_\\-=]+"
      },
      b32 = {
        gen = "[A-Za-z2-7=]+",
        crockford = "[0-9A-HJKMNP-TV-Z=]+"
      }
    },
    id = {
      issn = "[0-9]{4}-?[0-9]{3}[0-9xX]",
      isbn = "(?:[0-9]{9}[0-9xX])|(?:[0-9]{13})",
      uuid = "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}",
      doi = "(?:10\\.\\d{4,9}/[-._;()/:A-Z0-9]+)",
    },
    whitespace = {
      large = "[\t\r\n]"
    }
  }
}

map = {
  whitespace = {
    escaped = {
      ["\n"] = "\\n",
      ["\t"] = "\\t",
      ["\f"] = "\\f",
      ["\r"] = "\\r",
      ["\0"] = "\\0"
    },
  },
  char = {
    name = {
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
    }
  },
  mod = {
    symbol = {
      cmd = "⌘",
      alt = "⌥",
      shift = "⇧",
      ctrl = "⌃",
      fn = "fn",
    }
  },
  normalize = {
    extension = {
      jpeg = "jpg",
      jpg = "jpg",
      htm = "html",
      html = "html",
      yml = "yaml",
      yaml = "yaml",
      markdown = "md",
      md = "md",
    },
    mod = {
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
    dt_component = {
      S = "second",
      sec = "second",
      secs = "second",
      second = "second",
      seconds = "second",
      [1] = "second", -- 1 second
      ["6."] = "second", -- sixth component of a rf3339 date
      ["%S"] = "second",
      M = "minute",
      min = "minute",
      mins = "minute",
      minute = "minute",
      minutes = "minute",
      [60] = "minute",
      ["5."] = "minute", 
      ["%M"] = "minute",
      H = "hour",
      hour = "hour",
      hours = "hour",
      [3600] = "hour",
      ["4."] = "hour",
      ["%H"] = "hour",
      d = "day",
      day = "day",
      days = "day",
      [86400] = "day",
      ["3."] = "day",
      ["%d"] = "day",
      w = "week",
      week = "week",
      weeks = "week",
      [604800] = "week",
      ["%w"] = "week",
      m = "month",
      month = "month",
      months = "month",
      [2592000] = "month",
      ["2."] = "month",
      ["%m"] = "month",
      y = "year",
      year = "year",
      years = "year",
      [31536000] = "year",
      ["1."] = "year",
      ["%y"] = "year",
    },
  },
  dt_component = {
    seconds = {
      second = 1,
      minute = 60,
      hour = 60 * 60,
      day = 60 * 60 * 24,
      week = 60 * 60 * 24 * 7,
      month = 60 * 60 * 24 * 30,
      year = 60 * 60 * 24 * 365,
    },
    format_part = {
      second = "%S",
      minute = "%M",
      hour = "%H",
      day = "%d",
      week = "%W",
      month = "%m",
      year = "%Y",
    },
    RFC3339_separator = {
      year = "-",
      month = "-",
      day = "T",
      hour = ":",
      minute = ":",
      second = "Z",
    },
    rfc3339 = {
      year = "%Y",
      month = "%Y-%m",
      day = "%Y-%m-%d",
      hour = "%Y-%m-%dT%H",
      minute = "%Y-%m-%dT%H:%M",
      second = "%Y-%m-%dT%H:%M:%SZ",
    },
  },
  date_format_name = {
    date_format = {
      ["rfc3339-date"] = "%Y-%m-%d",
      ["rfc3339-time"] = "%H:%M:%S",
      ["rfc3339-datetime"] = "%Y-%m-%dT%H:%M:%SZ",
      ["american-date"] = "%m/%d/%Y",
      ["american-time"] = "%I:%M:%S %p",
      ["american-datetime"] = "%m/%d/%Y %I:%M:%S %p",
      ["german-date"] = "%d.%m.%Y",
      ["german-time"] = "%H:%M:%S",
      ["german-datetime"] = "%d.%m.%Y %H:%M:%S",
      ["email"] = "%a, %d %b %Y %H:%M:%S %z"
    },
  },
  mon1_int = {
    weekday_en = {
      [1] = "Monday",
      [2] = "Tuesday",
      [3] = "Wednesday",
      [4] = "Thursday",
      [5] = "Friday",
      [6] = "Saturday",
      [7] = "Sunday"
    }
  } 
}

transf = {
  hex = {
    char = function(hex)
      return string.char(tonumber(hex, 16))
    end,
  },
  char = {
    hex = function(char)
      return string.format("%%%02X", string.byte(char))
    end,
  },
  path = {
    attachment = function(path)
      local mimetype = mimetypes.guess(path) or "text/plain"
      return "#" .. mimetype .. " " .. path
    end,
  },
  string = {
    escaped_csv_field = function(field)
      return '"' .. rawreplace(field, {{'"', "\n"}, {'""', '\\n'}})  .. '"'
    end
  }
}


function resolveTilde(path)
  return path:gsub("^~", env.HOME)
end

to = {
  case = {
    snake = {
      cond = {
        _r = "[^%w%d]",
        _regex_engine = "eutf8",
        _ignore_case = true,
      },
      mode = "replace",
      proc = "_"
    },
    kebap = {
      cond = {
        _r = "[^%w%d]",
        _regex_engine = "eutf8",
        _ignore_case = true,
      },
      mode = "replace",
      proc = "-"
    }
  }
}

map.weekday_en.mon1_int = map(map.mon1_int.weekday_en, returnAny, {"kv", "vk"})


-- TODO replace custom matcher implementation here with `find`

--- @alias procSpec string | any[] | mapProcessor

--- @class replaceOpts : splitOpts
--- @field mode? "before" | "after" | "replace" | "remove"
--- @field args kvmult
--- @field cond? conditionSpec
--- @field proc? procSpec

--- @alias replaceSpec replaceOpts | (conditionSpec | procSpec)[]

--- @generic T : indexable
--- @param thing T
--- @param opts? replaceOpts | replaceOpts[] | (conditionSpec[] | procSpec[])[]
--- @param globalopts? replaceOpts
--- @return T
function rawreplace(thing, opts, globalopts)
  if opts == nil then return thing end
  opts = tablex.deepcopy(opts) or {}
  if not isListOrEmptyTable(opts) then opts = {opts} end

  --- allow for tr-like operation with two lists
  if #opts == 2 and isListOrEmptyTable(opts[1]) and isListOrEmptyTable(opts[2]) then
    local resolvedopts = {}
    for i = 1, #opts[1] do
      push(resolvedopts, {cond = opts[1][i], proc = opts[2][i]})
    end
  end

  -- opts get set with the following precedence:
  -- 1. opts on the current opt element
  -- 2. opts on the globalopts
  -- 3. opts of the previous opt element
  -- 4. default opts
  -- however, if the current opt has a proc of type table, then the cond will be overwritten unless it is explicitly set

  globalopts = globalopts or {}
  local mode, args, cond, proc, findopts = globalopts.mode, globalopts.args, globalopts.cond, globalopts.proc, globalopts.findopts
  mode = defaultIfNil(mode, "before")
  cond = defaultIfNil(cond, "\"")
  proc = defaultIfNil(proc, "\\")

  local res = thing
  for _, opt in ipairs(opts) do
    if isListOrEmptyTable(opt) and #opt == 2 then
      opt = {cond = opt[1], proc = opt[2]}
    end
    matchall = defaultIfNil(opt.matchall, matchall)
    mode = defaultIfNil(opt.mode, mode)
    args = defaultIfNil(opt.args, args)
    cond = defaultIfNil(opt.cond, cond)
    proc = defaultIfNil(opt.proc, proc)

  
    if not opt.cond and type(proc) == "table" then
      cond = {_list = keys(proc)} -- if no condition is specified, use the keys of the processor table as the condition
    end
  
    local splitopts = {
      mode = mode,
      findopts = findopts
    }
    if splitopts.mode == "replace" then
      splitopts.mode = "remove"
    end
    local parts, removed = split(res, cond, opts)
    removed = map(removed, returnUnpack, {"v", "kv"})
  
    local sep
    if mode == "replace" and not (type(proc) == "string" or isListOrEmptyTable(proc)) then -- we actually have to process the removed items to get the new items
      sep = map(
        removed,
        proc,
        {opts.args or "v", "v"}
      )    
    elseif mode == "remove" then
      -- no-op
    else
      sep = opts.processor
    end
    res = concat({
      isopts = "isopts",
      sep = sep,
    }, parts)
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
      {cond = mt._contains.lua_metacharacters, processor = "%", mode = "prepend"}
    )
  elseif type == "regex" then
    res = rawreplace(
      res, 
      {
        {cond = mt._contains.regex_metacharacters, processor = "\\", mode = "prepend"},
        {processor = mt.whitespace.escaped, mode = "replace" }
      }
    )
  elseif type == "modsymbols" then 
    res = rawreplace(
      res, 
      {
        { processor = map.normalize.mod, mode = "replace" },
        { processor = map.mod_symbolmap, mode = "replace" }
      }
    )
  elseif type == "doi" then 
    doi_prefix_variants = { "doi:", {_r = "(?:https?://)(?:dx.)doi.org/?" } },
    res = rawreplace(
      res, 
      {cond = mt.doi_prefix_variants, processor = "https://doi.org/", mode = "replace" }
    )
  elseif type == "urlencode" then
    res = rawreplace(
      res, 
      {cond = "[^\\w _%\\-\\.~]", processor = char_to_hex, mode = "replace" }
    )
  end
  return res
end



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
  local words = split(str, {_r = "[ :\\–\\—\\-\\t\\n]"})
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


--- @param url string
--- @param spaces_percent? boolean
--- @return string
function urlencode(url, spaces_percent)
  if url == nil then
    return ""
  end
  url = url:gsub("\n", "\r\n")
  url = string.gsub(url, "([^%w _%%%-%.~])", transf.char.hex)
  if spaces_percent then
    url = string.gsub(url, " ", "%%20")
  else
    url = string.gsub(url, " ", "+")
  end
  return url
end



--- @param url string
--- @return string
urldecode = function(url)
  if url == nil then
    return ""
  end
  url = url:gsub("+", " ")
  url = url:gsub("%%(%x%x)", transf.hex.char)
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

--- @param str string
--- @return string
function romanize(str)
  local raw_romanized = run(
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
  str = eutf8.lower(rawreplace(str, to.case.snake))
  return str
end

---Ensure things related to adfixes
---@param in_str string the string to check and potentially modify
---@param in_adfix string the adfix to check for and potentially add
---@param presence? boolean whether the adfix should be present or not
---@param case_insensitive? boolean whether to ignore case when checking for the adfix
---@param adfix_type? "pre"|"suf"|"in"|nil where the adfix should be
---@param strip_after? boolean whether to strip whitespace before returning
---@param regex? boolean whether the adfix is a regex
---@return string
function ensureAdfix(in_str, in_adfix, presence, case_insensitive, adfix_type, strip_after, regex)
  if case_insensitive == nil then case_insensitive = false end
  if presence == nil then presence = true end
  if adfix_type == nil then adfix_type = "pre" end
  if strip_after == nil then strip_after = false end
  if regex == nil then regex = false end
  local str, adfix
  if case_insensitive then
    str = in_str:lower()
    adfix = in_adfix:lower()
  else
    str = in_str
    adfix = in_adfix
  end
  local flag = ternary(case_insensitive, "i", "")
  local check_ad = ternary(regex, in_adfix, replace(in_adfix, "regex")) -- which adfix to check for in regex
  local position_check_func
  if adfix_type == "pre" then
    if regex then 
      position_check_func = function(s, ad) 
        return onig.find(s, "^" .. check_ad, nil, flag) ~= nil
      end
    else
      position_check_func = stringy.startswith
    end
    append_func = function(s, ad) return ad .. s end
    if regex then 
      remove_func = function(s, ad) 
        return onig.gsub(s, "^" .. check_ad, "", nil, flag)
      end
    else
      remove_func = function(s, ad) return eutf8.sub(s, eutf8.len(ad) + 1) end
    end
  elseif adfix_type == "suf" then
    if regex then 
      position_check_func = function(s, ad) 
        return onig.find(s, check_ad .. "$", nil, flag) ~= nil
      end
    else
      position_check_func = stringy.endswith
    end
    append_func = function(s, ad) return s .. ad end
    if regex then 
      remove_func = function(s, ad) 
        return onig.gsub(s, check_ad .. "$", "", nil, flag)
      end
    else
      remove_func = function(s, ad) return eutf8.sub(s, 1, eutf8.len(s) - eutf8.len(ad)) end
    end
  elseif adfix_type == "in" then
    position_check_func = function(s, ad) 
      return onig.find(s, check_ad, nil, flag) ~= nil
    end
    append_func = function(s, ad)
      local pos = math.random(1, eutf8.len(s)) -- no way to know where exactly to insert, so just insert at a random position
      return eutf8.sub(s, 1, pos) .. ad .. eutf8.sub(s, pos + 1)
    end
    remove_func = function(s, ad)
      return onig.gsub(s, check_ad, "", nil, flag)
    end
  else
    error("Invalid adfix type: " .. tostring(adfix_type))
  end
  local res
  if position_check_func(str, adfix) then
    if presence then
      res =  in_str
    else
      res = remove_func(in_str, in_adfix)
    end
  else
    if presence then
      res = append_func(in_str, in_adfix)
    else
      res = str
    end
  end
  if strip_after then
    res = stringy.strip(res)
  end
  return res
end

---@param str string
---@param n? integer
---@param dir? "up"| "down"
---@return string
function changeCasePre(str, n, dir)
  n = n or 1
  dir = dir or "up"
  local casefunc
  if dir == "up" then
    casefunc = eutf8.upper
  elseif dir == "down" then
    casefunc = eutf8.lower
  else
    error("Invalid direction: " .. tostring(dir))
  end
  local res = casefunc(eutf8.sub(str, 1, n)) .. eutf8.sub(str, n + 1)
  return res
end

--- try rewriting the above using rawreplace
function changeCasePre(str, n, dir)
  return rawreplace(str, {
    mode = "replace",
    cond = {_r = "^.{0," .. n .. "}"},
    proc = dir == "up" and eutf8.upper or eutf8.lower
  })
end