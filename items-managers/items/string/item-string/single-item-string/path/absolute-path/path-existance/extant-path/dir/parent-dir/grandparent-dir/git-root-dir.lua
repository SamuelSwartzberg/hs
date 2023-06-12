--- @type ItemSpecifier
GitRootDirItemSpecifier = {
  type = "git-root-dir",
  action_table = {
  
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateGitRootDirItem = bindArg(NewDynamicContentsComponentInterface, GitRootDirItemSpecifier)