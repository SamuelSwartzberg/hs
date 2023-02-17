
ArrayOfAlphanumMinusItemsSpecifier = {
  type = "array-of-alphanum-minus-items",
  properties = {
    getables = {
      ["is-array-of-uuids"] = bindNthArg(isArrayOfInterfacesOfType, 2, "uuid-item"),
      
    },
    doThisables = {

    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-uuids", value = CreateArrayOfUuids },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfAlphanumMinusItems = bindArg(NewDynamicContentsComponentInterface, ArrayOfAlphanumMinusItemsSpecifier)