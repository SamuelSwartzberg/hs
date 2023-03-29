

transf = {
  hex = {
    char = function(hex)
      return string.char(tonumber(hex, 16))
    end,
  },
  percent = {
    char = function(percent)
      local num = percent:sub(2, 3)
      return string.char(tonumber(num, 16))
    end,
  },
  not_nil = {
    string = function(arg)
      if arg == nil then
        return nil
      else
        return tostring(arg)
      end
    end,
  },
  char = {
    hex = function(char)
      return string.format("%02X", string.byte(char))
    end,
    percent = function(char)
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
      return '"' .. replace(field, {{'"', "\n"}, {'""', '\\n'}})  .. '"'
    end,
    bits = basexx.to_bit,
    hex = basexx.to_hex,
    base64_gen = basexx.to_base64,
    base64_url = basexx.to_url64,
    base32_gen = basexx.to_base32,
    base32_crock = basexx.to_crockford,
    title_case = function(str)
      local words, removed = split(str, {_r = "[ :–\\—\\-\\t\\n]", _regex_engine = "onig"})
      print("titlecase")
      local title_cased_words = map(words, transf.word.title_case_policy)
      title_cased_words[1] = replace(title_cased_words[1], to.case.capitalized)
      title_cased_words[#title_cased_words] = replace(title_cased_words[#title_cased_words], to.case.capitalized)
      inspPrint(removed)
      inspPrint(title_cased_words)
      return concat({
        isopts = "isopts",
        sep = removed,
      }, title_cased_words)
    end,
    romanized = function(str)
      local raw_romanized = run(
        { "echo", "-n",  {value = str, type = "quoted"}, "|", "kakasi", "-iutf8", "-outf8", "-ka", "-Ea", "-Ka", "-Ha", "-Ja", "-s", "-ga" }
      )
      local is_ok, romanized = pcall(eutf8.gsub, raw_romanized, "(%w)%^", "%1%1")
      if not is_ok then
        return str -- if there's an error, just return the original string
      end
      replace(romanized, {{"(kigou)", "'"}, {}}, {
        mode = "remove",
      })
      return romanized
    end,
    romanized_snake = function(str)
      str = eutf8.gsub(str, "[%^']", "")
      str = transf.string.romanized(str)
      str = eutf8.lower(replace(str, to.case.snake))
      return str
    end,
    tilde_resolved = function(path)
      return path:gsub("^~", env.HOME)
    end

  },
  multiline_string = {
    trimmed_lines = function(str)
      local lines = split(str, "\n")
      local trimmed_lines = map(lines, stringy.strip)
      return concat(trimmed_lines, "\n")
    end,
  },
  word = {
    title_case_policy = function(word)
      if find(mt._contains.small_words, word) then
        return word
      elseif eutf8.find(word, "%u") then -- words with uppercase letters are presumed to already be correctly title cased (acronyms, brands, the like)
        return word
      else
        return replace(word, to.case.capitalized)
      end
    end
  }
}
