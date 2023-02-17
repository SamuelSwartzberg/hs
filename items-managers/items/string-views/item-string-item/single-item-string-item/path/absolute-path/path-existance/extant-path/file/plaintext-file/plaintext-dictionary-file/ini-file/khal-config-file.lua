

--- @type ItemSpecifier
KhalConfigFileItemSpecifier = {
  type = "khal-config-file",
  properties = {
    getables = {
     

    },
    doThisables = {
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateKhalConfigFileItem = bindArg(NewDynamicContentsComponentInterface, KhalConfigFileItemSpecifier)