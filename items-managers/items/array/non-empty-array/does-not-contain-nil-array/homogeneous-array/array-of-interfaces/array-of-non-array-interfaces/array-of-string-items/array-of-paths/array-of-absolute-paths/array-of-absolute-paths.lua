
ArrayOfAbsolutePathsSpecifier = {
  type = "array-of-absolute-paths",
  properties = {
    getables = {
      ["is-array-of-volumes"] = bindNthArg(isArrayOfInterfacesOfType, 2, "volume"),
      ["is-array-of-extant-paths"] = bindNthArg(isArrayOfInterfacesOfType, 2, "extant-path"),
      ["common-ancestor"]  = function(self)
        return commonAncestorPath(self:get("to-string-array"))
      end,
    },
    doThisables = {
    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-volumes", value = CreateArrayOfVolumes },
    { key = "array-of-extant-paths", value = CreateArrayOfExtantPaths },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfAbsolutePaths = bindArg(NewDynamicContentsComponentInterface, ArrayOfAbsolutePathsSpecifier)