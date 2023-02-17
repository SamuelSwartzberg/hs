HomogeneousKeyTableSpecifier = {
  type = "homogeneous-key-table",
  properties = {
    getables = {
      ["is-number-key-table"] = function(self)
        return type(self:get("first-key")) == "number"
      end,
      ["is-string-key-table"] = function(self)
        return type(self:get("first-key")) == "string"
      end,
    },
    doThisables = {
   
    },
  },
  potential_interfaces = ovtable.init({
    { key = "number-key-table", value = CreateNumberKeyTable },
    { key = "string-key-table", value = CreateStringKeyTable },
  }),
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateHomogeneousKeyTable = bindArg(NewDynamicContentsComponentInterface, HomogeneousKeyTableSpecifier)
