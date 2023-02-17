TimestampKeyTableSpecifier = {
  type = "timestamp-key-table",
  properties = {
    getables = {
      ["to-ymd-array-table"] = function(self)
        return CreateTable(timestampKeyTableToYMDTable(self:get("contents")))
      end,
    },
    doThisables = {
   
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateTimestampKeyTable = bindArg(NewDynamicContentsComponentInterface, TimestampKeyTableSpecifier)
