StringItemSpecifier = {
  type = "string",
  properties = {
  ({ {
      text = "🌄✂️ crsnp.",
      key = "do-interactive",
      args = {
        thing = {
          func = "promptPathChildren",
          args = env.MSNIPPETS
        },
        key = "write-to-file"
      }
    }{
      text = "👉🍾 cev.",
      getfn = get.khal.search_event_tables
    },{
      d = "1stnum",
      i = "#️⃣",
      key = "extract-utf8-first",
      args = "%d+"
    },{
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