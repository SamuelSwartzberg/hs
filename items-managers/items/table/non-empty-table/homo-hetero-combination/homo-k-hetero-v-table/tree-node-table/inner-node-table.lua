InnerNodeTableSpecifier = {
  type = "inner-node-table",
  properties = {
    getables = {
      ["child-by-tag-name"] = function(self, tag_name)
        local children = self:get("value", "children")
        valueFind(children, function(child)
          return child.tag == tag_name
        end)
      end,
    },
    doThisables = {
     
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateInnerNodeTable = bindArg(NewDynamicContentsComponentInterface, InnerNodeTableSpecifier)
