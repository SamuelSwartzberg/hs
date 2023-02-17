
ArrayOfPathLeafsSpecifier = {
  type = "array-of-path-leafs",
  properties = {
    getables = {
      ["is-array-of-path-leaf-dates"] = bindNthArg(isArrayOfInterfacesOfType, 2, "path-leaf-date"),
    
    },
    doThisables = {
    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-path-leaf-dates", value = CreateArrayOfPathLeafDates },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfPathLeafs = bindArg(NewDynamicContentsComponentInterface, ArrayOfPathLeafsSpecifier)