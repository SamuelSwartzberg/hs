--- @type ItemSpecifier
PathNotInHomeItemSpecifier = {
  type = "path-not-in-home",
  properties = {
    getables = {
    },
    doThisables = {
     
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathNotInHomeItem = bindArg(NewDynamicContentsComponentInterface, PathNotInHomeItemSpecifier)