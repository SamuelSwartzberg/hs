

--- @type ItemSpecifier
PlaintextTreeFileItemSpecifier = {
  type = "plaintext-treee-file",
  properties = {
    getables = {
      ["is-xml-file"] = bc(is.path.usable_as_filetype, "xml")
    },
    doThisables = {
      
    }
  },
  potential_interfaces = ovtable.init({
    { key = "xml-file", value = CreateXmlFileItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePlaintextTreeFileItem = bindArg(NewDynamicContentsComponentInterface, PlaintextTreeFileItemSpecifier)