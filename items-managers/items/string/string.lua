StringItemSpecifier = {
  type = "string",
  properties = {
  ({{
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
      text = "👉🍾 cev.",
      getfn = get.khal.search_event_tables
    }, {
      d = "basheval",
      i = "🐚🧬",
      getfn = transf.string.string_by_evaled_bash
    }, {
      d = "envsubst",
      i = "🌥🧬",
      getfn = transf.string.string_by_envsubsted
    }, {
      d = "rsnu",
      i = "🅰🐍🧗‍♀️",
      getnf = transf.string.lower_snake_case_string_by_romanized
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
      getfn = transf.string.string_by_all_eutf8_upper
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
      getfn = transf.string.string_by_all_eutf8_lower
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
      getfn = transf.string.singleline_string_by_folded
    }
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