--- @type ItemSpecifier
LatexProjectDirItemSpecifier = {
  type = "latex-project-dir",
  action_table = {
  
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateLatexProjectDirItem = bindArg(NewDynamicContentsComponentInterface, LatexProjectDirItemSpecifier)