
ArrayOfDirsSpecifier = {
  type = "array-of-dirs",
  properties = {
    getables = {
      ["is-array-of-git-root-dirs"] = bindNthArg(isArrayOfInterfacesOfType, 2, "git-root-dir"),
      ["filter-to-array-of-git-root-dirs"] = function(self)
        return self:get("filter-to-array-of-type", "git-root-dir")
      end,
    },
    doThisables = {
    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-git-root-dirs", value = CreateArrayOfGitRootDirs },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfDirs = bindArg(NewDynamicContentsComponentInterface, ArrayOfDirsSpecifier)