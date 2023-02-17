LeafTableSpecifier = {
  type = "leaf-table",
  properties = {
    getables = {
      ["child-by-tag-name"] = function()
        return nil
      end,
    },
    doThisables = {
     
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateLeafTable = bindArg(NewDynamicContentsComponentInterface, LeafTableSpecifier)
