--- @type ItemSpecifier
PackageManagerItemSpecifier = {
  type = "package-manager",
  action_table = {
   {
      text = "📦 lpkg.",
      getfn = get.upkg.package_name_or_package_name_semver_compound_string_array,
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePackageManagerItem = bindArg(NewDynamicContentsComponentInterface, PackageManagerItemSpecifier)
