--- @type ItemSpecifier
TabbableBrowserWindowItemSpecifier = {
  type = "tabbable-browser-window",
  properties = {
    getables = {
      ["url"] = function (self)
        return self:get("active-tab"):get("url")
      end,
    },
    doThisables = {
     

    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTabbableBrowserWindowItem = bindArg(NewDynamicContentsComponentInterface, TabbableBrowserWindowItemSpecifier)