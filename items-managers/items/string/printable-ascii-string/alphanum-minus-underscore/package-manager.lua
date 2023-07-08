--- @type ItemSpecifier
PackageManagerItemSpecifier = {
  type = "package-manager",
  action_table = {
   {
      text = "📦 lpkg.",
      getfn = get.upkg.list,
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePackageManagerItem = bindArg(NewDynamicContentsComponentInterface, PackageManagerItemSpecifier)
