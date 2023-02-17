StringItemSpecifier = {
  type = "string-item",
  properties = {
    getables = {
      ["stripped-contents"] = function(self)
        return stringy.strip(self:get("contents"))
      end,
      ["is-single-item-string-item"] = function(self) 
        return (not containsLargeWhitespace(self:get("contents"))) or (not (#self:get("contents") < 2000))
      end,
      ["is-multiline-string-item"] = function(self) return stringy.find(self:get("contents"), "\n") end,
      ["is-has-lowercase-string-item"] = function(self)
        return containsLowercase(self:get("contents"))
      end,
      ["is-has-uppercase-string-item"] = function(self)
        return containsUppercase(self:get("contents"))
      end,
      ["is-might-be-json-item"] = function(self)
        local stripped_contents = self:get("stripped-contents")
        return 
          startsEndsWith(stripped_contents,{starts = "{", ends = "}"}) or
          startsEndsWith(stripped_contents,{starts = "[", ends = "]"})
      end,
      ["starts-ends-with"] = function(self, specifier)
        return startsEndsWith(stringy.strip(self:get("contents")), specifier)
      end,
      ["is-might-be-xml-item"] = function(self) return self:get("starts-ends-with", {starts = "<", ends = ">"}) end,
      ["is-might-be-bib-item"] = function(self) return self:get("starts-ends-with", {starts = "@", ends = "}"}) end,
      ["to-string-array"] = function(self, sep) 
        return CreateArray(stringy.split(self:get("contents"), sep)) 
      end,
      ["to-string-item-array"] = function(self, sep) return self:get("to-string-array", sep):get("to-string-item-array") end,
      ["to-array-of-string-arrays"] = function(self, seps)
        return self:get("to-string-array", seps.upper):get("map-to-new-array", 
        function(line) 
          return CreateArray(stringy.split(line, seps.lower))
        end)
      end,
      ["to-string"] = function(self)
        return foldStr(self:get("contents"))
      end,
      ["new-string-item-from-contents"] = function(self)
        return self:doThis("str-item", {key = "contents"})
      end,
     
      ["starts-with"] = function(self, str)
        return stringy.startswith(self:get("contents"), str)
      end,
      ["ends-with"] = function(self, str)
        return stringy.endswith(self:get("contents"), str)
      end,
      ["difference-from-prefix-or-self"] = function(self, prefix) return 
        ensureAdfix(self:get("contents"), prefix, false)
      end,
      ["difference-from-prefix-or-nil"] = function(self, prefix)
        if not self:get("starts-with", prefix) then return nil end
        return eutf8.sub(self:get("contents"), eutf8.len(prefix) + 1)
      end,
      ["difference-from-suffix-or-self"] = function(self, suffix) return 
          ensureAdfix(self:get("contents"), suffix, false, "suf")
      end,
      ["difference-from-suffix-or-nil"] = function(self, suffix)
        if not self:get("ends-with", suffix) then return nil end
        return eutf8.sub(self:get("contents"), 1, eutf8.len(self:get("contents")) - eutf8.len(suffix))
      end,
      ["contained-unicode-prop-tables"] = function(self)
        return CreateShellCommand("uni"):get("identify", self:get("contents"))
      end,
      ["encoded-as"] = function(self, enc)
        return toBaseEncoding(self:get("contents"), enc)
      end,
      ["escaped-general-regex"] = function(self)
        return escapeGeneralRegex(self:get("contents"))
      end,
      ["escape-lua-regex"] = function(self)
        return escapeAllLuaMetacharacters(self:get("contents"))
      end,
      ["window-with-contents-as-title"] = function(self)
        local res = hs.window.find(self:get("contents"))
        if type(res) == "table" then return res 
        else return {res} end
      end,
      ["window-item-contents-as-title"] = function(self)
        return mapValueNewValue(self:get("windows-with-contents-as-title"), function(window)
          return CreateWindowlikeItem(window)
        end)
      end,
      ["evaluated-as-lua"] = function(self)
        return evaluateStringToValue(self:get("contents"))
      end,
      ["evaluated-as-bash"] = function(self)
        local parts = stringy.split(self:get("contents"), " ")
        return getOutputArgsSimple(table.unpack(parts))
      end,
      ["fold"] = function(self)
        return foldStr(self:get("contents"))
      end,
      ["template-evaluated-contents"] = function (self)
        return luaTemplateEval(self:get("contents"))
      end,
      ["contents-romanized"] = function (self) return romanize(self:get("contents")) end,
      ["contents-as-romanized-snake-case-string"] = function(self)
        return romanizeToLowerAlphanumUnderscore(self:get("contents"))
      end,
      ["is-html-entity-encoded-string-item"] = function(self) 
        return stringy.find(self:get("contents"), "&") and stringy.find(self:get("contents"), ";")
      end,
      ["is-html-entity-decoded-string-item"] = function(self)
         return 
          stringy.find(self:get("contents"), "\"")
          or stringy.find(self:get("contents"), "'")
          or stringy.find(self:get("contents"), "<")
          or stringy.find(self:get("contents"), ">")
          or stringy.find(self:get("contents"), "&")
      end, -- 'decoded' = to be encoded
      ["extract-utf8"] = function(self, pattern)
        return extractAllMatches(self:get("contents"), pattern, true)
      end,
      ["extract-utf8-array"] = function(self, pattern)
        return CreateArray(self:get("extract-utf8", pattern))
      end,
      ["extract-onig"] = function(self, pattern)
        return extractAllMatches(self:get("contents"), pattern, false)
      end,
      ["extract-onig-array"] = function(self, pattern)
        return CreateArray(self:get("extract-onig", pattern))
      end,
      ["extract-utf8-first"] = function(self, pattern)
        local res = eutf8.match(self:get("contents"), pattern)
        return res
      end,
      ["extract-onig-first"] = function(self, pattern)
        local res = onig.match(self:get("contents"), pattern)
        return res
      end,
      ["to-title-case"] = function(self)
        return toTitleCase(self:get("contents"))
      end,
      ["events-matching-search"] = function(self)
        return CreateShellCommand("khal"):get("search-events-items", {searchstr = self:get("fold")})
      end,
      ["envsubst"] = function(self)
        return envsubstShell(self:get("contents"))
      end,
    },
    doThisables = {
      ["tab-fill-with-items"] = function(self, sep)
        self:get("to-string-item-array", sep):doThis("tab-fill-with")
      end,
      ["split-and-choose-action"] = function (self, sep)
        self:get("to-string-item-array", sep)
          :doThis("choose-action")
      end,
      ["copy-contents"] = function(self)
        self:doThis("copy-result-of-get", {key = "contents"})
      end,
      ["paste-contents"] = function(self)
        self:doThis("paste-result-of-get", {key = "contents"})
      end,
      ["say"] = function(self, lang)
        say(self:get("fold"), lang)
      end,
      ["add-to-log"] = function(self, path)
        CreateStringItem(path):doThis("log-now", self:get("contents"))
      end,
      ["write-to-file"] = function(self, path)
        writePathAndFile(path, self:get("contents"))
      end,
      ["quick-look-bash-eval"] = function(self)
        local parts = stringy.split(self:get("contents"), " ")
        runHsTaskQuickLookResult(parts)
      end,
      ["search-with"] = function(self, search_engine)
        searchWith(self:get("fold"), search_engine)
      end,
      ["open-in-vscode"] = function(self)
        openStringInVscode(self:get("contents"))
      end,
      ["open-contents-in-browser"] = function(self)
        self:doThis("open-result-of-get-in-browser", { key = "fold"})
      end,
      ["append-as-line-to-file"] = function(self, path)
        CreateStringItem(path):doThis("append-line-and-commit", self:get("fold"))
      end,
      ["append-to-qf-file"] = function(self)
        CreateStringItem(env.MQF):get("descendant-file-only-string-item-array"):doThis("choose-item", function(path)
          path:doThis("append-line-and-commit", self:get("fold"))
        end)
      end,
      
    }
  },
  potential_interfaces = ovtable.init({
    { key = "single-item-string-item", value = CreateSingleItemStringItem },
    { key = "multiline-string-item", value = CreateMultilineStringItem },
    { key = "html-entity-encoded-string-item", value = CreateHTMLEntityEncodedStringItem },
    { key = "html-entity-decoded-string-item", value = CreateHTMLEntityDecodedStringItem },
    { key = "has-lowercase-string-item", value = CreateHasLowercaseStringItem },
    { key = "has-uppercase-string-item", value = CreateHasUppercaseStringItem },
    { key = "might-be-json-item", value = CreateMightBeJsonItem },
    { key = "might-be-xml-item", value = CreateMightBeXmlItem },
    { key = "might-be-bib-item", value = CreateMightBeBibItem },
  }),
  action_table = listConcat({
    {
      text = "📋 cp.",
      key = "copy-contents"
    },{
      text = "📎 pst.",
      key = "paste-contents"
    },{
      text = "👄🇺🇸 sayen.",
      key = "say",
      args = "en"
    },{
      text = "👄🇯🇵 sayja.",
      key = "say",
      args = "ja"
    }, {
      text = "👉⽄👊 cspltact.",
      key = "do-interactive",
      args = {
        key = "split-and-choose-action",
        thing = "separator"
      }
    }, {
      text = "📓🦄 logdia.",
      key = "add-to-log",
      args = env.MENTRY_LOGS
    }, {
      text = "🌄✂️ crsnp.",
      key = "do-interactive",
      args = {
        thing = {
          func = "chooseDirAndCreateSubdirsAndFiles",
          args = env.MSNIPPETS
        },
        key = "write-to-file"
      }
    }, {
      text = "🔍 ql.",
      key = "code-quick-look-result-of-get",
      args = {key = "contents"}
    }, {
      text = "🔍🐚🧬 qlbasheval.",
      key = "quick-look-bash-eval"
    }, {
      text = "🧬 eval.",
      key = "get-as-do",
      args = "evaluated-as-lua"
    }, {
      text = "🔷🈁 vscur.",
      key = "open-in-vscode"
    },{
      text = "🌐 br.",
      key = "open-contents-in-browser"
    },{
      text = "📨 qf.",
      key = "append-to-qf-file"
    }, {
      text = "👉🍾 cev.",
      key = "choose-item-on-result-of-get",
      args = {
        key = "array",
        args = "events-matching-search"
      }
    }
  }, getChooseItemTable({
    {
      description = "binec",
      emoji_icon = "🅱️2️⃣📦",
      key = "encoded-as",
      args = "bit"
    }, {
      description = "hexec",
      emoji_icon = "🅱️1️⃣6️⃣📦",
      key = "encoded-as",
      args = "hex"
    }, {
      description = "urlb64ec",
      emoji_icon = "🔗🅱️6️⃣4️⃣📦",
      key = "encoded-as",
      args = "url_64"
    }, {
      description = "genb64ec",
      emoji_icon = "🤝🅱️6️⃣4️⃣📦",
      key = "encoded-as",
      args = "base_64"
    }, {
      description = "crc32ec",
      emoji_icon = "👴🏻🅱️3️⃣2️⃣📦",
      key = "encoded-as",
      args = "crockford"
    }, {
      description = "gen32ec",
      emoji_icon = "🤝🅱️3️⃣2️⃣📦",
      key = "encoded-as",
      args = "base_32"
    }, {
      description = "escrgx",
      emoji_icon = "🏃🏾‍♀️🧩",
      key = "escaped-general-regex"
    }, {
      description = "escluargx",
      emoji_icon = "🏃🏾‍♀️🔵🧩",
      key = "escape-lua-regex"
    }, {
      description = "eval",
      emoji_icon = "🧬",
      key = "evaluated-as-lua"
    },
    {
      description = "tmpeval",
      emoji_icon = "🕳🧬",
      key = "template-evaluated-contents"
    }, {
      description = "basheval",
      emoji_icon = "🐚🧬",
      key = "evaluated-as-bash"
    }, {
      description = "envsubst",
      emoji_icon = "🌥🧬",
      key = "envsubst"
    }, {
      description = "rsnu",
      emoji_icon = "🅰🐍🧗‍♀️",
      key = "contents-as-romanized-snake-case-string"
    },
    {
      description = "r",
      emoji_icon = "🅰",
      key = "contents-romanized"
    },{
      description = "1stnum",
      emoji_icon = "#️⃣",
      key = "extract-utf8-first",
      args = "%d+"
    },{
      emoji_icon = "📰",
      description = "ttlcs",
      key = "to-title-case"
    }
  }),
  getSearchEngineActionTable({
    {
      name = "jisho",
      emoji_icon = "🟩", -- the color of jisho's logo/favicon
    },
    {
      name = "wiktionary",
      emoji_icon = "⬜️"
    },
    {
      name = "wikipedia",
      emoji_icon = "🏐" -- trying to imitate the wikipedia logo
    },
    {
      name = "youtube",
      emoji_icon = "🟥▶️" -- trying to imitate the youtube logo
    },
    {
      name = "glottopedia",
      emoji_icon = "🟧" -- the color of the glottopedia logo
    },
    {
      name = "ruby-apidoc",
      emoji_icon = "🔴"
    },
    {
      name = "python-docs",
      emoji_icon = "🐍"
    },
    {
      name = "merriam-webster",
      emoji_icon = "🆎" -- kinda might look like the merriam-webster logo if you squint hard enough
    },
    {
      name = "dict-cc",
      emoji_icon = "📙"
    },
    {
      name = "deepl-en-ja",
      emoji_icon = "🟦🇺🇸🇯🇵"
    },
    {
      name = "deepl-de-en",
      emoji_icon = "🟦🇩🇪🇺🇸"
    },
    {
      name = "mdn",
      emoji_icon = "🦊"
    },
    {
      name = "libgen",
      emoji_icon = "⛴"
    },
    {
      name = "danbooru",
      emoji_icon = "🟫"
    },
    {
      name = "google-scholar",
      emoji_icon = "🏳️‍🌈🎓"
    },
    {
      name = "semantic-scholar",
      emoji_icon = "👩‍🔧🎓"
    },
    {
      name = "google-images",
      emoji_icon = "🏳️‍🌈🖼"
    },
    {
      name = "google-maps",
      emoji_icon = "🏳️‍🌈🗺"
    }
  }))
}

--- @type BoundRootInitializeInterface
function CreateStringItem(contents)
  if type(contents) ~= "string" then
    if type(contents) == "number" then 
      contents = tostring(contents)
    elseif type(contents) == "boolean" then
      contents = tostring(contents)
    else
      print("Error: contents must be a string. Got:")
      inspPrint(contents)
      error("Cannot proceed.")
    end
  end
  return RootInitializeInterface(StringItemSpecifier, contents)
end
