
ArrayOfDirsSpecifier = {
  type = "array-of-dirs",
  properties = {
    getables = {
      ["is-array-of-git-root-dirs"] = bind(isArrayOfInterfacesOfType, {a_use, "git-root-dir" }),
    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-git-root-dirs", value = CreateArrayOfGitRootDirs },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfDirs = bindArg(NewDynamicContentsComponentInterface, ArrayOfDirsSpecifier)