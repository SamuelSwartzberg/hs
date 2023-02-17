
ArrayOfUuidsSpecifier = {
  type = "array-of-uuids",
  properties = {
    getables = {
      ["is-array-of-contacts"] = bindNthArg(isArrayOfInterfacesOfType, 2, "contact-item"),
      
    },
    doThisables = {

    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-contacts", value = CreateArrayOfContacts },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfUuids = bindArg(NewDynamicContentsComponentInterface, ArrayOfUuidsSpecifier)