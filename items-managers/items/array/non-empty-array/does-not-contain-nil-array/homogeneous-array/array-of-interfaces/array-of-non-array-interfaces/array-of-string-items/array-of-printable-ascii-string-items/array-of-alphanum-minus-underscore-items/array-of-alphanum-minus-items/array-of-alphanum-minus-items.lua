
ArrayOfAlphanumMinusItemsSpecifier = {
  type = "array-of-alphanum-minus-items",
  properties = {
    getables = {
      ["is-array-of-uuids"] = bind(isArrayOfInterfacesOfType, {a_use, "uuid-item" }),
      
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