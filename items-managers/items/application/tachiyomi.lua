--- @type ItemSpecifier
TachiyomiItemSpecifier = {
  type = "tachiyomi",
  properties = {
    getables = {
     
    },
    doThisables = {
      ["backup-application"] = function(self)
        run({ "jsonify-tachiyomi-backup" }, function()
          CreateStringItem(env.MMANGA_LOGS):doThis(
            "log-timestamp-table",
            CreateStringItem(env.TMP_TACHIYOMI_JSON):get("to-timestamp-key-history-list")
          )
        end)
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateTachiyomiItem = bindArg(NewDynamicContentsComponentInterface, TachiyomiItemSpecifier)