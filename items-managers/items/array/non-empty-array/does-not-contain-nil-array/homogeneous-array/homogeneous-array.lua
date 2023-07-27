HomogeneousArraySpecifier = {
  type = "homogeneous-array",
  properties = {
    getables = {
      ["is-array-of-interfaces"] = bc(is.array.array_of_interfaces),
      ["is-array-of-noninterfaces"] = bc(is.array.not_array_of_interfaces),
      ["to-string"] = bc(transf.array.summary),
    },
  },
  ({
    { key = "array-of-interfaces", value = CreateArrayOfInterfaces },
    { key = "array-of-noninterfaces", value = CreateArrayOfNoninterfaces },
  }),
  action_table = {
    {
      d = "tstr",
      i = "💻🔡",
      key = "to-string",
    },
    {
      d = "tstrml",
      i = "💻🔡📜",
      key = "to-string-multiline",
    },
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateHomogeneousArray = bindArg(NewDynamicContentsComponentInterface, HomogeneousArraySpecifier)



