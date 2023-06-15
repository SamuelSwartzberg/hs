

--- @type ItemSpecifier
LogFileItemSpecifier = {
  type = "log-file",
}

--- @type BoundNewDynamicContentsComponentInterface
CreateLogFileItem = bindArg(NewDynamicContentsComponentInterface, LogFileItemSpecifier)