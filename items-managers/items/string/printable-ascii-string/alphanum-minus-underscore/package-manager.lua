--- @type ItemSpecifier
PackageManagerItemSpecifier = {
  type = "package-manager",
  action_table = {
   {
      text = "📦 lpkg.",
      getfn = get.upkg.list,
      filter = ar
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePackageManagerItem = bindArg(NewDynamicContentsComponentInterface, PackageManagerItemSpecifier)
