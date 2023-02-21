-- packagemanager means \w+

--- @type ItemSpecifier
PackageManagerItemSpecifier = {
  type = "package-manager-item",
  properties = {
    getables = {
      
    }
  },
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreatePackageManagerItem = bindArg(NewDynamicContentsComponentInterface, PackageManagerItemSpecifier)