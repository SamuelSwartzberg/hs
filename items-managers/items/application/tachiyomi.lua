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
            st(env.TMP_TACHIYOMI_JSON):get("to-timestamp-key-history-list")
          )
        end)
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateTachiyomiItem = bindArg(NewDynamicContentsComponentInterface, TachiyomiItemSpecifier)