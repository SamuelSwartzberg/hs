

--- @type ItemSpecifier
LogFileItemSpecifier = {
  type = "log-file",
  properties = {
    getables = {
      
    },
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateLogFileItem = bindArg(NewDynamicContentsComponentInterface, LogFileItemSpecifier)