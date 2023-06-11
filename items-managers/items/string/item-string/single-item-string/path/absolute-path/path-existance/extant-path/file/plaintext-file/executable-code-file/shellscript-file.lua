

--- @type ItemSpecifier
ShellscriptFileItemSpecifier = {
  type = "shellscript-file",
}

--- @type BoundNewDynamicContentsComponentInterface
CreateShellscriptFileItem = bindArg(NewDynamicContentsComponentInterface, ShellscriptFileItemSpecifier)