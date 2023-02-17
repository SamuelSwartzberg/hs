--- @type ItemSpecifier
NoninterfaceValueTableInterfaceSpecifier = {
  type = "noninterface-value-table",
  properties = {
    getables = {
      ["is-string-value-table"] = function(self)
        return type(self:get("first-value")) == "string"
      end,
      ["is-plain-table-value-table"] = function(self)
        return type(self:get("first-value")) == "table"
      end,
    },
    doThisables = {
   
    },
  },

  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "string-value-table", value = CreateStringValueTable },
  })
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateNoninterfaceValueTable = bindArg(NewDynamicContentsComponentInterface, NoninterfaceValueTableInterfaceSpecifier)
