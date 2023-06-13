
ArrayOfFilesSpecifier = {
  type = "array-of-files",
  properties = {
    getables = {
      ["is-array-of-plaintext-files"] = bind(isArrayOfInterfacesOfType, {a_use, "plaintext-file" }),
    },
    doThisables = {
    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-plaintext-files", value = CreateArrayOfPlaintextFiles },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfFiles = bindArg(NewDynamicContentsComponentInterface, ArrayOfFilesSpecifier)