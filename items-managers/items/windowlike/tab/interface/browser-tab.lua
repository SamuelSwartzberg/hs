--- @type ItemSpecifier
BrowserTabItemSpecifier = {
  type = "browser-tab",
  properties = {
    getables = {
      ["extra-tab-info"] = function(self)
        return self:get("url")
      end,
    },
    doThisables = {
     

    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBrowserTabItem = bindArg(NewDynamicContentsComponentInterface, BrowserTabItemSpecifier)

