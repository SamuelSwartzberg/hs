--- @type ItemSpecifier
BrowserWindowItemSpecifier = {
  type = "browser-window",
  properties = {
    getables = {
      
    },
    doThisables = {
     

    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBrowserWindowItem = bindArg(NewDynamicContentsComponentInterface, BrowserWindowItemSpecifier)