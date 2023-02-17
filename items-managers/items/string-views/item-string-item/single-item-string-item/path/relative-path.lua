--- @type ItemSpecifier
RelativePathItemSpecifier = {
  type = "relative-path",
  properties = {},
  action_table = {},
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateRelativePathItem = bindArg(NewDynamicContentsComponentInterface, RelativePathItemSpecifier)
