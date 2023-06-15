

--- @type ItemSpecifier
TomlFileItemSpecifier = {
  type = "toml-file",
  properties = {
    getables = {
      ["parse-to-lua-table"] = bc(transf.toml_file.table)
    },
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTomlFileItem = bindArg(NewDynamicContentsComponentInterface, TomlFileItemSpecifier)