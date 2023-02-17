TreeNodeTableSpecifier = {
  type = "tree-node-table",
  properties = {
    getables = {
      ["is-leaf-table"] = function(self)
        return self:get("value", "text") -- nodes which have a text property are leaves
      end,
      ["is-inner-node-table"] = function(self)
        return self:get("value", "children") -- nodes which have a children property are inner nodes
      end,

        
    },
    doThisables = {
     
    },
  },
  potential_interfaces = ovtable.init({
    { key = "leaf-table", value = CreateLeafTable },
    { key = "inner-node-table", value = CreateInnerNodeTable },
  }),
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateTreeNodeTable = bindArg(NewDynamicContentsComponentInterface, TreeNodeTableSpecifier)
