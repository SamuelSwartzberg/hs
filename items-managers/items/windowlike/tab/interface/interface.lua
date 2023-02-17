--- @type ItemSpecifier
TabInterfaceItemSpecifier = {
  type = "tab-interface-item",
  properties = {
    getables = {
      ["is-browser-tab"] = function(self) 
        local app = self:get("application-name")
        return valuesContain({"Google Chrome", "Firefox", "Microsoft Edge"}, app)
      end,
    },
    doThisables = {

    }
  },
  potential_interfaces = ovtable.init({
    { key = "browser-tab", value = CreateBrowserTabItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTabInterfaceItem = bindArg(NewDynamicContentsComponentInterface, TabInterfaceItemSpecifier)
