

--- @type ItemSpecifier
JsonFileItemSpecifier = {
  type = "json-file",
  properties = {
    getables = {
      ["parse-to-lua-table"] = function(self)
        return json.decode(self:get("file-contents"))
      end,
      ["lua-table-to-string"] = function(_, tbl)
        return json.encode(tbl)
      end,
      ["is-tachiyomi-json-file"] = function(self)
        return self:get("path-leaf-starts-with", "tachiyomi")
      end,
     

    },
    doThisables = {
     
    }
  },
  potential_interfaces = ovtable.init({
    { key = "tachiyomi-json-file", value = CreateTachiyomiJsonFileItem },
  }),
  action_table = concat(getChooseItemTable({
    description = "srvjsonport",
    emoji_icon = "🚚｛：",
    key = "port-of-hosting-json-server",
  }),{})
}

--- @type BoundNewDynamicContentsComponentInterface
CreateJsonFileItem = bindArg(NewDynamicContentsComponentInterface, JsonFileItemSpecifier)