--- @type ItemSpecifier
TachiyomiItemSpecifier = {
  type = "tachiyomi",
  properties = {
    getables = {
     
    },
    doThisables = {
      ["backup-application"] = function(self)
        run({ "jsonify-tachiyomi-backup" }, function()
          st(env.MMANGA_LOGS):doThis(
            "log-timestamp-table",
            transf.tachiyomi_json_table.timestamp_key_array_value_dict(transf.json_file.not_userdata_or_function(env.TMP_TACHIYOMI_JSON))
          )
        end)
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateTachiyomiItem = bindArg(NewDynamicContentsComponentInterface, TachiyomiItemSpecifier)