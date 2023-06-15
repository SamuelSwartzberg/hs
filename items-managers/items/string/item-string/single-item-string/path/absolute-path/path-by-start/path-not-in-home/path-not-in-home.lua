--- @type ItemSpecifier
PathNotInHomeItemSpecifier = {
  type = "path-not-in-home",
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathNotInHomeItem = bindArg(NewDynamicContentsComponentInterface, PathNotInHomeItemSpecifier)