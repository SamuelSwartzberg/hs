HomoKHomoVTableSpecifier = {
  type = "homo-k-homo-v-table",
  properties = {
    getables = {
      ["is-str-key-interface-value-table"] = function (self)
        return self:get("is-string-key-table") and self:get("is-interface-value-table")
      end,
      ["is-str-key-noninterface-value-table"] = function (self)
        return self:get("is-string-key-table") and self:get("is-noninterface-value-table")
      end,
    },
    doThisables = {
   
    },
  },
  potential_interfaces = ovtable.init({
    { key = "str-key-interface-value-table", value = CreateStrKeyInterfaceValueTable },
    { key = "str-key-noninterface-value-table", value = CreateStrKeyNoninterfaceValueTable },
    
  }),
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateHomoKHomoVTable = bindArg(NewDynamicContentsComponentInterface, HomoKHomoVTableSpecifier)
