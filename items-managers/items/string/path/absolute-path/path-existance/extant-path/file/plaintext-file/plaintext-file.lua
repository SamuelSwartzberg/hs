

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
  action_table = {
    {
      text = "👉✂️🎒⩶ ccutcntln.",
      getfn = dothis.plaintext_file.pop_line,
    },{
      text = "🫳⩶ appdln.",
      dothis = dothis.plaintext_file.append_line,
      args = transf.table.indicated_prompt_table( { line = "string" })
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePlaintextFileItem = bindArg(NewDynamicContentsComponentInterface, PlaintextFileItemSpecifier)