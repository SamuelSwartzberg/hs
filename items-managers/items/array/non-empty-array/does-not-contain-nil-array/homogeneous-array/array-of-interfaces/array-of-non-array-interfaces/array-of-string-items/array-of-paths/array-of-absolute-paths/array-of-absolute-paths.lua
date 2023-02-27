
ArrayOfAbsolutePathsSpecifier = {
  type = "array-of-absolute-paths",
  properties = {
    getables = {
      ["is-array-of-volumes"] = bind(isArrayOfInterfacesOfType, { ["2"] = "volume" }),
      ["is-array-of-extant-paths"] = bind(isArrayOfInterfacesOfType, { ["2"] = "extant-path" }),
      ["common-ancestor"]  = function(self)
        return lolCommonPrefix(mapValueNewValue(self:get("to-string-array"), pathSlice))
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