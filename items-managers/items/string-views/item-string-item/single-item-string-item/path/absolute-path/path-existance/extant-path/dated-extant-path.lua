--- @type ItemSpecifier
DatedExtantPathItemSpecifier = {
  type = "dated-extant-path",
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