--- @type ItemSpecifier
UpkgCommandSpecifier = {
  type = "upkg-command",
  properties = {
    getables = {
      
    },
    doThisables = {
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateUpkgCommand = bindArg(NewDynamicContentsComponentInterface, UpkgCommandSpecifier)
