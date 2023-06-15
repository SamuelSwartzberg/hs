StringItemSpecifier = {
  type = "string",
  properties = {
    getables = {
      ["stripped-contents"] = function(self)
        return stringy.strip(self:get("c"))
      end,
      ["is-single-item-string-item"] = function(self) 
        return (not (#self:get("c") < 2000)) or (not onig.find(self:get("c"), mt._r.whitespace.large)) 
      end,
      ["is-multiline-string-item"] = function(self) return stringy.find(self:get("c"), "\n") end,
      ["is-might-be-json-item"] = function(self)
        return  startsEndsWithFast(self:get("c"), "{", "}") or startsEndsWithFast(self:get("c"), "[", "]")
      end,
      ["is-might-be-xml-item"] = function(self) return startsEndsWithFast(self:get("c"), "<", ">") end,
      ["is-might-be-bib-item"] =function(self) return startsEndsWithFast(self:get("c"), "@", "}") end,
      ["to-string-array"] = function(self, sep) 
        return ar(stringy.split(self:get("c"), sep)) 
      end,
      ["to-string-item-array"] = function(self, sep) return self:get("to-string-array", sep):get("to-string-item-array") end,
      ["to-array-of-string-arrays"] = function(self, seps)
        return self:get("to-string-array", seps.upper):get("map-to-new-array", 
        function(line) 
          return ar(stringy.split(line, seps.lower))
        end)
      end,
      ["to-string"] = function(self)
        return eutf8.gsub(self:get("c"), "\n", " ")
      end,
      ["new-string-item-from-contents"] = function(self)
        return self:doThis("str-item", {key = "c"})
      end,
      ["starts-with"] = function(self, str)
        return stringy.startswith(self:get("c"), str)
      end,
      ["ends-with"] = function(self, str)
        return stringy.endswith(self:get("c"), str)
      end,
      ["difference-from-prefix-or-self"] = function(self, prefix) 
        return mustNotStart(self:get("c"), prefix)
      end,
      ["difference-from-prefix-or-nil"] = function(self, prefix)
        if not stringy.startswith(self:get("c"), prefix) then return nil end
        return eutf8.sub(self:get("c"), eutf8.len(prefix) + 1)
      end,
      ["difference-from-suffix-or-self"] = function(self, suffix) 
        return mustNotEnd(self:get("c"), suffix)
      end,
      ["difference-from-suffix-or-nil"] = function(self, suffix)
        if not self:get("ends-with", suffix) then return nil end
        return eutf8.sub(self:get("c"), 1, eutf8.len(self:get("c")) - eutf8.len(suffix))
      end,
      ["contained-unicode-prop-tables"] = function(self)
        return transf.table_array.item_array_of_item_tables(
          transf.string.unicode_prop_table_array(self:get("c"))
        )
      end,
      ["encoded-as"] = function(self, enc)
        return transf.string[enc](self:get("c"))
      end,
      ["escaped-general-regex"] = function(self)
        return replace(self:get("c"), to.regex.general_escaped)
      end,
      ["escape-lua-regex"] = function(self)
        return replace(self:get("c"), to.regex.lua_escaped)
      end,
      ["window-with-contents-as-title"] = function(self)
        local res = hs.window.find(self:get("c"))
        if type(res) == "table" then return res 
        else return {res} end
      end,
      ["window-item-contents-as-title"] = function(self)
        return map(self:get("windows-with-contents-as-title"), function(window)
          return CreateWindowlikeItem(window)
        end)
      end,
      ["evaluated-as-lua"] = function(self)
        return singleLe(self:get("c"))
      end,
      ["evaluated-as-bash"] = function(self)
        local parts = stringy.split(self:get("c"), " ")
        return run(parts)
      end,
      ["fold"] = function(self)
        return transf.string.folded(self:get("c"))
      end,
      ["template-evaluated-contents"] = function (self)
        return le(self:get("c"))
      end,
      ["contents-romanized"] = function (self) return transf.string.romanized(self:get("c")) end,
      ["contents-as-romanized-snake-case-string"] = function(self)
        return transf.string.romanized_snake(self:get("c"))
      end,
      ["is-html-entity-encoded-string-item"] = function(self) 
        return allOfFast(self:get("c"), mt._list.html_entity_indicator.encoded)
      end,
      ["is-html-entity-decoded-string-item"] = function(self)
         return anyOfFast(self:get("c"), mt._list.html_entity_indicator.decoded)
      end, -- 'decoded' = to be encoded
      ["extract-utf8"] = function(self, pattern)
        return iterToTbl({tolist=true, ret="v"},eutf8.gmatch(self:get("c"), pattern))
      end,
      ["extract-utf8-array"] = function(self, pattern)
        return ar(self:get("extract-utf8", pattern))
      end,
      ["extract-onig"] = function(self, pattern)
        return iterToTbl({tolist=true, ret="v"},onig.gmatch(self:get("c"), pattern))
      end,
      ["extract-onig-array"] = function(self, pattern)
        return ar(self:get("extract-onig", pattern))
      end,
      ["extract-utf8-first"] = function(self, pattern)
        local res = eutf8.match(self:get("c"), pattern)
        return res
      end,
      ["extract-onig-first"] = function(self, pattern)
        local res = onig.match(self:get("c"), pattern)
        return res
      end,
      ["to-title-case"] = function(self)
        return transf.string.title_case(self:get("c"))
      end,
      ["events-matching-search"] = function(self)
        return get.khal.search_event_tables(self:get("fold"))
      end,
      ["envsubst"] = function(self)
        return transf.string.envsubsted(self:get("c"))
      end,
      ["qr-utf8-image-bow"] = function(self)
        return transf.string.qr_utf8_image_bow(self:get("c"))
      end,
      ["qr-utf8-image-wob"] = function(self)
        return transf.string.qr_utf8_image_wob(self:get("c"))
      end,
      ["qr-png-path"] = function(self)
        return transf.string.qr_png_in_cache(self:get("c"))
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
      ["say"] = function(self, lang)
        dothis.string.say(self:get("c"), lang)
      end,
      ["add-to-log"] = function(self, path)
        st(path):doThis("log-now", self:get("c"))
      end,
      ["write-to-file"] = function(self, path)
        writeFile(path, self:get("c"))
      end,
      ["search-with"] = function(self, search_engine)
        open(
          string.format(
            tblmap.search_engine.url[search_engine],
            transf.string.urlencoded(self:get("fold"), tblmap.search_engine.spaces_percent[search_engine])
          )
        )
      end,
      ["open-in-vscode"] = function(self)
        open({contents = self:get("c")})
      end,
      ["open-contents-in-browser"] = function(self)
        open({url = self:get("fold")})
      end,
      ["append-to-qf-file"] = function(self)
        st(env.MQF):get("descendant-file-only-string-item-array"):doThis("choose-item", function(path)
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
  action_table = concat({
    {
      text = "📋 cp.",
      dothis = dothis.string.copy
    },{
      text = "📎 pst.",
      dothis = dothis.string.paste
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
          func = "promptPathChildren",
          args = env.MSNIPPETS
        },
        key = "write-to-file"
      }
    }, {
      text = "🔍 ql.",
      dothis = alert
    },{
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
      d = "binec",
      i = "🅱️2️⃣📦",
      key = "encoded-as",
      args = "bits"
    }, {
      d = "hexec",
      i = "🅱️1️⃣6️⃣📦",
      key = "encoded-as",
      args = "hex"
    }, {
      d = "urlb64ec",
      i = "🔗🅱️6️⃣4️⃣📦",
      key = "encoded-as",
      args = "base64_url"
    }, {
      d = "genb64ec",
      i = "🤝🅱️6️⃣4️⃣📦",
      key = "encoded-as",
      args = "base64_gen"
    }, {
      d = "crc32ec",
      i = "👴🏻🅱️3️⃣2️⃣📦",
      key = "encoded-as",
      args = "base32_crock"
    }, {
      d = "gen32ec",
      i = "🤝🅱️3️⃣2️⃣📦",
      key = "encoded-as",
      args = "base32_gen"
    }, {
      d = "escrgx",
      i = "🏃🏾‍♀️🧩",
      key = "escaped-general-regex"
    }, {
      d = "escluargx",
      i = "🏃🏾‍♀️🔵🧩",
      key = "escape-lua-regex"
    }, {
      d = "eval",
      i = "🧬",
      key = "evaluated-as-lua"
    },
    {
      d = "tmpeval",
      i = "🕳🧬",
      key = "template-evaluated-contents"
    }, {
      d = "basheval",
      i = "🐚🧬",
      key = "evaluated-as-bash"
    }, {
      d = "envsubst",
      i = "🌥🧬",
      key = "envsubst"
    }, {
      d = "rsnu",
      i = "🅰🐍🧗‍♀️",
      key = "contents-as-romanized-snake-case-string"
    },
    {
      d = "r",
      i = "🅰",
      key = "contents-romanized"
    },{
      d = "1stnum",
      i = "#️⃣",
      key = "extract-utf8-first",
      args = "%d+"
    },{
      i = "📰",
      d = "ttlcs",
      key = "to-title-case"
    },{
      i = "🔳🏞🛣",
      d = "qrimgpth",
      key = "qr-image-path"
    },{
      i = "🔳🔡⬜️",
      d = "qrstrbow",
      key = "qr-utf8-image-bow"
    },{
      i = "🔳🔡⬛️", 
      d = "qrstrwob",
      key = "qr-utf8-image-wob"
    },{
      d = "al",
      i = "🪂",
      getfn = transf.string.lowercase
    },
    {
      d = "snl",
      i = "🐍🪂",
      getfn = transf.string.lower_snake_case
    },
    {
      d = "kbl",
      i = "🍢🪂",
      getfn = transf.string.lower_kebap_case
    },
    {
      d = "au",
      i = "🧗‍♀️",
      getfn = transf.string.uppercase
    },
    {
      d = "snu",
      i = "🐍🧗‍♀️",
      getfn = transf.string.upper_snake_case
    },
    {
      d = "kbu",
      i = "🍢🧗‍♀️",
      getfn = transf.string.upper_kebap_case
    },{
      d = "hendc",
      i = "🔶📖",
      getfn = transf.string.html_entitiy_decoded
    },{
      d = "henec",
      i = "🔶📦",
      getfn = transf.string.html_entitiy_encoded
    }
  }),
  hs.fnutils.imap(
    mt._list.search_engine_names,
    transf.search_engine.action_table_item
  ))
}

--- @type BoundRootInitializeInterface
function st(contents)
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
