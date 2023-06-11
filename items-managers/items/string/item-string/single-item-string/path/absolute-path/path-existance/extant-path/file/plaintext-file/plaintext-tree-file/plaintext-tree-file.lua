

--- @type ItemSpecifier
PlaintextTreeFileItemSpecifier = {
  type = "plaintext-treee-file",
  properties = {
    getables = {
      ["is-xml-file"] = function(self)
        return is.path.usable_as_filetype(self:get("c"), "xml")
      end,
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