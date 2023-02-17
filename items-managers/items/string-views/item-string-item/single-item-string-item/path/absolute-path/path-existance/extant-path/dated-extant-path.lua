--- @type ItemSpecifier
DatedExtantPathItemSpecifier = {
  type = "dated-extant-path-item",
  properties = {
    getables = {
      
    },
    doThisables = {
    }
  },
  action_table = {
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDatedExtantPathItem = bindArg(NewDynamicContentsComponentInterface, DatedExtantPathItemSpecifier)