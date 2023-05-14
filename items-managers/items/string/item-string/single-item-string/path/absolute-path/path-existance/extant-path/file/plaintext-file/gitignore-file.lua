

--- @type ItemSpecifier
GitignoreFileItemSpecifier = {
  type = "gitignore-file",
  properties = {
    getables = {
      
    },
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateGitignoreFileItem = bindArg(NewDynamicContentsComponentInterface, GitignoreFileItemSpecifier)