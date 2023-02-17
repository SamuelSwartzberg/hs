--- @type ItemSpecifier
BrowserWindowItemSpecifier = {
  type = "browser-window-item",
  properties = {
    getables = {
      
    },
    doThisables = {
     

    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBrowserWindowItem = bindArg(NewDynamicContentsComponentInterface, BrowserWindowItemSpecifier)