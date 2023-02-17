--- @type ItemSpecifier
WindowCombinationItemSpecifier = {
  type = "window-combination-item",
  properties = {
    getables = {
      ["is-tabbable-browser-window"] = function (self)
        return 
          self:get("is-browser-window") and
          self:get("is-tabbable-window")
      end
    },
    doThisables = {

    }
  },
  potential_interfaces = ovtable.init({
    { key = "tabbable-browser-window", value = CreateTabbableBrowserWindowItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateWindowCombinationItem = bindArg(NewDynamicContentsComponentInterface, WindowCombinationItemSpecifier)
