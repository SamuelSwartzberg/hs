--- @type ItemSpecifier
NewpipeSqliteFileItemSpecifier = {
  type = "newpipe-sqlite-file",
  properties = {

  }
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNewpipeSqliteFileItem = bindArg(NewDynamicContentsComponentInterface, NewpipeSqliteFileItemSpecifier)