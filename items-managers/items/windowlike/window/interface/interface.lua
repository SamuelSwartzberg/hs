--- @type ItemSpecifier
WindowInterfaceItemSpecifier = {
  type = "window-interface-item",
  properties = {
    getables = {
      ["is-browser-window"] = function(self) 
        local app = self:get("application-name")
        return valuesContain({"Google Chrome", "Firefox", "Microsoft Edge"}, app)
      end,
      ["is-tabbable-window"] = function (self)
        local app = self:get("application-name")
        return valuesContain({"Google Chrome", "Firefox", "Microsoft Edge"}, app)
      end,
      ["is-window-combination"] = returnTrue
    },
    doThisables = {

    }
  },
  potential_interfaces = ovtable.init({
    { key = "browser-window", value = CreateBrowserWindowItem },
    { key = "tabbable-window", value = CreateTabbableWindowItem },
    { key = "window-combination", value = CreateWindowCombinationItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateWindowInterfaceItem = bindArg(NewDynamicContentsComponentInterface, WindowInterfaceItemSpecifier)
