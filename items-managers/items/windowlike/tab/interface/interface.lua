--- @type ItemSpecifier
TabInterfaceItemSpecifier = {
  type = "tab-interface",
  properties = {
    getables = {
      ["is-browser-tab"] = function(self) 
        local app = self:get("application-name")
        return find({"Google Chrome", "Firefox", "Microsoft Edge"}, app)
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
