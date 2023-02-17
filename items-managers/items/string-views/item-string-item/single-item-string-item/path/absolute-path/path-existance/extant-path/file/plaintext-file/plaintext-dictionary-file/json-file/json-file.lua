

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
      ["port-of-hosting-json-server"] = function(self)
        local port = getOutputArgsSimple("freeport")
        self:doThis("host-on-json-server", port)
        return port
      end,

    },
    doThisables = {
      ["host-on-json-server"] = function(self, port)
        runHsTask({
          "mockrs",
          "serve",
          "--port=" .. port,
        })
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "tachiyomi-json-file", value = CreateTachiyomiJsonFileItem },
  }),
  action_table = listConcat(getChooseItemTable({
    description = "srvjsonport",
    emoji_icon = "🚚｛：",
    key = "port-of-hosting-json-server",
  }),{})
}

--- @type BoundNewDynamicContentsComponentInterface
CreateJsonFileItem = bindArg(NewDynamicContentsComponentInterface, JsonFileItemSpecifier)