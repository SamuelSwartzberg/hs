

--- @type ItemSpecifier
JsonFileItemSpecifier = {
  type = "json-file",
  properties = {
    getables = {
      ["parse-to-lua-table"] = bc(transf.json_file.table),
    },
    doThisables = {
     
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateJsonFileItem = bindArg(NewDynamicContentsComponentInterface, JsonFileItemSpecifier)