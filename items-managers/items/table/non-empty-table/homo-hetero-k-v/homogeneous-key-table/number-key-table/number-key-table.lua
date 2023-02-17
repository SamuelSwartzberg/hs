NumberKeyTableSpecifier = {
  type = "number-key-table",
  properties = {
    getables = {
      ["is-timestamp-key-table"] = function(self)
        return self:get("first-key") < (10 ^ 10) and self:get("last-key") < (10 ^ 10) -- cheap spot check rather than checking all keys, which is not worth it
      end,
    },
    doThisables = {
   
    },
  },
  potential_interfaces = ovtable.init({
    { key = "timestamp-key-table", value = CreateTimestampKeyTable },
  }),
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateNumberKeyTable = bindArg(NewDynamicContentsComponentInterface, NumberKeyTableSpecifier)
