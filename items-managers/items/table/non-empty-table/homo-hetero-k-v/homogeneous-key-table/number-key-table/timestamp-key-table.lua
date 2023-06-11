TimestampKeyTableSpecifier = {
  type = "timestamp-key-table",
  properties = {
    getables = {
      ["to-ymd-array-table"] = function(self)
        return tb(transf.timestamp_table.ymd_table(self:get("c")))
      end,
    },
    doThisables = {
   
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateTimestampKeyTable = bindArg(NewDynamicContentsComponentInterface, TimestampKeyTableSpecifier)
