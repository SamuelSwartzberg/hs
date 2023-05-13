--- @type ItemSpecifier
StateBrowserTabItemSpecifier = {
  type = "state-browser-tab",
  properties = {
    getables = {
      ["url"] = function (self)
        return self:get("current-hist-attrs").url
      end,
    },
    doThisables = {
      
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateStateBrowserTabItem = bindArg(NewDynamicContentsComponentInterface, StateBrowserTabItemSpecifier)

