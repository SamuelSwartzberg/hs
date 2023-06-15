

--- @type ItemSpecifier
IniFileItemSpecifier = {
  type = "ini-file",
  properties = {
    getables = {
      ["parse-to-lua-table"] = bc(transf.ini_file.table),
    },

  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateIniFileItem = bindArg(NewDynamicContentsComponentInterface, IniFileItemSpecifier)