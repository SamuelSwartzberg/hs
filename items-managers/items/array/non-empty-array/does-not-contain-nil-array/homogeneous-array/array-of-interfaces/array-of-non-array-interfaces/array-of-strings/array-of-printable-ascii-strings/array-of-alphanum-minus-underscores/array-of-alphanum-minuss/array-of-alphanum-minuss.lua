
ArrayOfAlphanumMinusItemsSpecifier = {
  type = "array-of-alphanum-minuss",
  properties = {
    getables = {
      ["is-array-of-uuids"] = bind(isArrayOfInterfacesOfType, {a_use, "uuid" }),
      
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