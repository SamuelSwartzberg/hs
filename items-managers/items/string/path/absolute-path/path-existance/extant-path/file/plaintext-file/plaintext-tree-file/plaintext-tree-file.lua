

--- @type ItemSpecifier
PlaintextTreeFileItemSpecifier = {
  type = "plaintext-treee-file",
  properties = {
    getables = {
      ["is-xml-file"] = bc(get.path.usable_as_filetype, "xml")
    },
    doThisables = {
      
    }
  },
  ({
    { key = "xml-file", value = CreateXmlFileItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePlaintextTreeFileItem = bindArg(NewDynamicContentsComponentInterface, PlaintextTreeFileItemSpecifier)