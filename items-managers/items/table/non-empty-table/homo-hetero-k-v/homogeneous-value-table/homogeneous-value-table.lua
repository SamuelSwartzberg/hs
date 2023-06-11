HomogeneousValueTableSpecifier = {
  type = "homogeneous-value-table",
  properties = {
    getables = {
      ["is-interface-value-table"] = function (self)
        return is.any.component_interface(self:get("first-value"))
      end,
      ["is-noninterface-value-table"] = function (self)
        return not is.any.component_interface(self:get("first-value"))
      end,
    },
    doThisables = {
   
    },
  },
  potential_interfaces = ovtable.init({
    { key = "interface-value-table", value = CreateInterfaceValueTable },
    { key = "noninterface-value-table", value = CreateNoninterfaceValueTable },
    
  }),
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateHomogeneousValueTable = bindArg(NewDynamicContentsComponentInterface, HomogeneousValueTableSpecifier)
