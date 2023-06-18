StringItemSpecifier = {
  type = "string",
  properties = {
    getables = {
      ["is-url"] = bc(isUrl),
      ["is-path"] = bc(is.string.looks_like_path),
      ["is-printable-ascii-string-item"] = bc(is.string.printable_ascii),
      ["to-string"] = bc(transf.string.folded),
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
      end
    },
    doThisables = {
      ["tab-fill-with-items"] = function(self, sep)
        self:get("to-string-item-array", sep):doThis("tab-fill-with")
      end
    }
  },
  potential_interfaces = ovtable.init({
    { key = "url", value = CreateURLItem },
    { key = "path", value = CreatePathItem },
    { key = "printable-ascii-string-item", value = CreatePrintableAsciiStringItem },
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
    },
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
    },{
      text = "👉📚 csynav.",
      getfn = transf.word.synonym_string_array,
      filter = ar
    },{
      text = "👉📚 csynth.",
      getfn = transf.word.term_syn_specifier_dict,
      filter = transf.term_syn_specifier_dict.term_syn_specifier_item_dict_item,
      act = "cia"
    },{
      d = "fld",
      i = "🗺",
      getfn = transf.string.folded
    },{
      d = "lnhd",
      i = "⩶👆",
      getfn = get.string.lines_head
    },{
      d = "lntl",
      i = "⩶👇",
      getfn = get.string.lines_tail
    },
    {
      d = "ln",
      i = "⩶",
      getfn = get.string.lines
    },
    {
      text = "🌄📚 crsess.",
      dothis = dothis.url_array.create_as_session_in_msessions,
      filter = transf.string.url_array
    },
  },
  hs.fnutils.imap(
    mt._list.search_engine_names,
    transf.search_engine.action_table_item
  ),
  hs.fnutils.imap(
    transf.dir.descendants_array(env.MQF),
    function(path)
      return {
        dothis = hs.fnutils.partial(
          dothis.plaintext_file.append_line_and_commit,
          path
        ),
        i = "📨",
        d = transf.string.consonants(
          transf.path.filename(path)
        )
      }
    end
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
