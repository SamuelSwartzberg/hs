StringItemSpecifier = {
  type = "string",
  properties = {
    getables = {
      ["to-string"] = bc(transf.string.folded),
    },
  },
  potential_interfaces = ovtable.init({
    { key = "url", value = CreateURLItem },
    { key = "path", value = CreatePathItem },
    { key = "printable-ascii-string-item", value = CreatePrintableAsciiStringItem },
  }),
  action_table = concat({
    {
      text = "📋 cp.",
      dothis = dothis.string.add_to_clipboard
    },{
      text = "📎 pst.",
      dothis = dothis.string.paste
    },{
      text = "👄🇺🇸 sayen.",
      dothis = get.fn.arbitrary_args_bound_or_ignored_fn(dothis.string.say, {a_use, "en"})
    },{
      text = "👄🇯🇵 sayja.",
      dothis = get.fn.arbitrary_args_bound_or_ignored_fn(dothis.string.say, {a_use, "ja"})
    }, {
      text = "📓🦄 logdia.",
      dothis = dothis.entry_logging_dir.log_string,
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
      dothis = dothis.string.alert
    },{
      text = "🔷🈁 vscur.",
      dothis = dothis.url_or_local_path.open_temp_file
    },{
      text = "🦊🌐 ffbr.",
      dothis = dothis.url_or_local_path.open_ff
    },{
      text = "🧭🌐 sfbr.",
      dothis = dothis.url_or_local_path.open_safari,
    },{
      text = "🌈🌐 gcbr.",
      dothis = dothis.url_or_local_path.open_chrome,
    }, {
      text = "👉🍾 cev.",
      getfn = get.khal.search_event_tables
    },
    {
      d = "binec",
      i = "🅱️2️⃣📦",
      getfn = transf.string.binary_string
    }, {
      d = "hexec",
      i = "🅱️1️⃣6️⃣📦",
      getfn = transf.string.hex_string
    }, {
      d = "urlb64ec",
      i = "🔗🅱️6️⃣4️⃣📦",
      getfn = transf.string.base64_url_string
    }, {
      d = "genb64ec",
      i = "🤝🅱️6️⃣4️⃣📦",
      getfn = transf.string.base64_gen_string
    }, {
      d = "crc32ec",
      i = "👴🏻🅱️3️⃣2️⃣📦",
      getfn = transf.string.base32_crock_string
    }, {
      d = "gen32ec",
      i = "🤝🅱️3️⃣2️⃣📦",
      getfn = transf.string.base32_gen_string
    }, {
      d = "escrgx",
      i = "🏃🏾‍♀️🧩",
      getfn = transf.string.escaped_general_regex
    }, {
      d = "escluargx",
      i = "🏃🏾‍♀️🔵🧩",
      getfn = transf.string.escaped_lua_regex
    }, {
      d = "eval",
      i = "🧬",
      getfn = get.string.evaled_as_lua
    }, 
    {
      d = "tmpeval",
      i = "🕳🧬",
      getfn = get.string.evaled_as_template
    }, {
      d = "basheval",
      i = "🐚🧬",
      getfn = transf.string.evaled_bash
    }, {
      d = "envsubst",
      i = "🌥🧬",
      getfn = transf.string.envsubsted
    }, {
      d = "rsnu",
      i = "🅰🐍🧗‍♀️",
      getnf = transf.string.romanized_snake
    },
    {
      d = "rdet",
      i = "🅰",
      getfn = transf.string.romanized_deterministic
    },{
      d = "rgpt",
      i = "🅰",
      getfn = transf.string.romanized_gpt
    },{
      d = "1stnum",
      i = "#️⃣",
      key = "extract-utf8-first",
      args = "%d+"
    },{
      i = "📰",
      d = "ttlcs",
      getfn = transf.string.title_case
    },{
      i = "🔳🏞🛣",
      d = "qrimgpth",
      getfn = transf.string.qr_png_in_cache
    },{
      i = "🔳🔡⬜️",
      d = "qrstrbow",
      getfn = transf.string.qr_utf8_image_bow
    },{
      i = "🔳🔡⬛️", 
      d = "qrstrwob",
      getfn = transf.string.qr_utf8_image_wob
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
      getfn = transf.string.html_entitiy_decoded_string
    },{
      d = "henec",
      i = "🔶📦",
      getfn = transf.string.html_entitiy_encoded_string
    },{
      text = "👉📚 csynav.",
      getfn = transf.word.synonym_string_array,
      dothis = dothis.array.choose_item_and_action
    },{
      text = "👉📚 csynth.",
      getfn = transf.word.term_syn_specifier_dict,
      dothis = dothis.array.choose_item_and_action
    },{
      d = "fld",
      i = "🗺",
      getfn = transf.string.folded
    },{
      d = "lnhd",
      i = "⩶👆",
      getfn = get.string.lines_head,

    },{
      d = "lntl",
      i = "⩶👇",
      getfn = get.string.lines_tail,
    },
    {
      d = "ln",
      i = "⩶",
      getfn = get.string.lines,
    }, {
      d = "spltarr",
      i = "⽄,",
      getfn = get.fn.arbitrary_args_bound_or_ignored_fn(get.string.string_array_split_single_char_stripped, {a_use, ","}),
    },
    {
      text = "🌄📚 crsess.",
      dothis = dothis.string.create_as_session_in_msessions,
    },
  },
  hs.fnutils.imap(
    mt._list.search_engine_names,
    transf.search_engine.action_table_item
  ),
  hs.fnutils.imap(
    transf.extant_path.descendants_absolute_path_array(env.MQF),
    function(path)
      return {
        dothis = get.fn.first_n_args_bound_fn(
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
