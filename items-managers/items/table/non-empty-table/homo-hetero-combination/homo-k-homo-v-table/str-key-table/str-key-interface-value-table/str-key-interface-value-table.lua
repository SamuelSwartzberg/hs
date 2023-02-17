StrKeyInterfaceValueTableSpecifier = {
  type = "str-key-interface-value-table",
  properties = {
    getables = {
      ["is-address-table"] = function (self)
        return self:get("is-address-value-table")
      end,
    },
    doThisables = {
   
    },
  },
  potential_interfaces = ovtable.init({
    { key = "address-table", value = CreateAddressTable },
    
  }),
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateStrKeyInterfaceValueTable = bindArg(NewDynamicContentsComponentInterface, StrKeyInterfaceValueTableSpecifier)
