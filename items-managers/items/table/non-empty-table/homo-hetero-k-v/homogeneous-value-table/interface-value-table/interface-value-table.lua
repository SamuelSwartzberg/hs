InterfaceValueTableSpecifier = {
  type = "interface-value-table",
  properties = {
    getables = {
      ["is-single-address-table-value-table"] = function(self)
        return self:get("first-value"):get("is-a", "single-address-table")
      end,
    },
    doThisables = {
      ["choose-item-and-then-action"] = function(self)
        self:doThis("choose-item", function(item)
          item:doThis("choose-action")
        end)
      end,
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateInterfaceValueTable = bindArg(NewDynamicContentsComponentInterface, InterfaceValueTableSpecifier)
