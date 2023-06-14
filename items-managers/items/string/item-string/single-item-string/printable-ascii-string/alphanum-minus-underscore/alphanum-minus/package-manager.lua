-- packagemanager means \w+

--- @type ItemSpecifier
PackageManagerItemSpecifier = {
  type = "package-manager",
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreatePackageManagerItem = bindArg(NewDynamicContentsComponentInterface, PackageManagerItemSpecifier)