--- @type ItemSpecifier
PathNotInHomeItemSpecifier = {
  type = "path-not-in-home-item",
  properties = {
    getables = {
    },
    doThisables = {
     
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathNotInHomeItem = bindArg(NewDynamicContentsComponentInterface, PathNotInHomeItemSpecifier)