
ArrayOfPrintableAsciiStringItemsSpecifier = {
  type = "array-of-printable-ascii-string-items",
  properties = {
    getables = {
      ["is-array-of-pass-name-items"] = bind(isArrayOfInterfacesOfType, {a_use, "pass-name" }),
      ["is-array-of-date-related-items"] = bind(isArrayOfInterfacesOfType, {a_use, "date-related-item" }),
    },
    doThisables = {
    
    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-pass-name-items", value = CreateArrayOfPassNameItems },
    { key = "array-of-date-related-items", value = CreateArrayOfDateRelatedItems },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfPrintableAsciiStringItems = bindArg(NewDynamicContentsComponentInterface, ArrayOfPrintableAsciiStringItemsSpecifier)