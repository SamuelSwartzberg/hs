StringValueTableSpecifier = {
  type = "string-value-table",
  properties = {
    getables = {
      
    },
    doThisables = {
      ["choose-item-and-then-action"] = function(self)
        self:doThis("choose-item", function(item)
          CreateStringItem(item):doThis("choose-action")
        end)
      end
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateStringValueTable = bindArg(NewDynamicContentsComponentInterface, StringValueTableSpecifier)
