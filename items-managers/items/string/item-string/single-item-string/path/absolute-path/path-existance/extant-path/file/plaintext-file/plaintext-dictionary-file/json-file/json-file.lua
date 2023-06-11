

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

  action_table = concat(getChooseItemTable({
    description = "srvjsonport",
    emoji_icon = "🚚｛：",
    key = "port-of-hosting-json-server",
  }),{})
}

--- @type BoundNewDynamicContentsComponentInterface
CreateJsonFileItem = bindArg(NewDynamicContentsComponentInterface, JsonFileItemSpecifier)