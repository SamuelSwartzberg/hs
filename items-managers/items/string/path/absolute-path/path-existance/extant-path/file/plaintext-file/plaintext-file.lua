

--- @type ItemSpecifier
PlaintextFileItemSpecifier = {
  type = "plaintext-file",
  properties = {
    getables = {
      ["is-m3u-file"] = bc(get.path.is_extension, "m3u"),
      ["is-plaintext-table-file"] = bc(get.path.usable_as_filetype, "plaintext-table"),
      ["is-plaintext-dictionary-file"] = bc(get.path.usable_as_filetype, "plaintext-dictionary"),
      ["is-plaintext-tree-file"] = bc(get.path.usable_as_filetype, "plaintext-tree"),
      ["is-executable-code-file"] = transf["nil"]["true"], -- determining whether a file is executable code is difficult, as there are so many programming languages and extensions, so I'm just gonna assert it's true and not implement any polymorphic behavior in executable-code-file
      ["is-gitignore-file"] = bc(get.path.is_filename, ".gitignore"),
      ["is-log-file"] = bc(get.path.is_extension, "log"),
      ["is-newsboat-urls-file"] = bc(get.path.is_leaf, "urls"),
      ["is-md-file"] = bc(get.path.is_standartized_extension, "md")
    },
  },
  potential_interfaces = ovtable.init({
    { key = "m3u-file", value = CreateM3uFileItem },
    { key = "plaintext-table-file", value = CreatePlaintextTableFileItem },
    { key = "plaintext-dictionary-file", value = CreatePlaintextDictionaryFileItem },
    { key = "plaintext-tree-file", value = CreatePlaintextTreeFileItem },
    { key = "executable-code-file", value = CreateExecutableCodeFileItem },
    { key = "gitignore-file", value = CreateGitignoreFileItem },
    { key = "log-file", value = CreateLogFileItem },
    { key = "email-file", value = CreateEmailFileItem },
    { key = "newsboat-urls-file", value = CreateNewsboatUrlsFileItem },
    { key = "md-file", value = CreateMdFileItem },
    
  }),
  action_table = {
    { 
      d = "cnt",
      i = "🎒",
      getfn = transf.plaintext_file.contents
    },{
      d = "cntchrs",
      i = "🎒🀇📏",
      getfn = transf.plaintext_file.len_chars
    },{
      d = "cntln",
      i = "🎒8️⃣📏",
      getfn = transf.plaintext_file.len_lines
    },{
      d = "cnthd",
      i = "🎒👆",
      key = get.plaintext_file.lines_head
    },{
      d = "cnttl",
      i = "🎒👇",
      key = get.plaintext_file.lines_tail
    },
    {
      text = "👉🎒全⩶ ccntlns.",
      getfn = transf.plaintext_file.lines,
      dothis = dothis.any.choose_action
    },
    {
      text = "👉🎒⩶ ccntln.",
      getfn = transf.plaintext_file.lines,
      dothis = dothis.array.choose_item_and_action
    },
    {
      text = "👉✂️🎒⩶ ccutcntln.",
      getfn = dothis.plaintext_file.pop_line,
    },{
      text = "🫳⩶ appdln.",
      dothis = dothis.plaintext_file.append_line,
      args = pt( { line = "string" })
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePlaintextFileItem = bindArg(NewDynamicContentsComponentInterface, PlaintextFileItemSpecifier)