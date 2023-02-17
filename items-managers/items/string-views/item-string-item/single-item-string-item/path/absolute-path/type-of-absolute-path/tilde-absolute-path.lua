--- @type ItemSpecifier
TildeAbsolutePathItemSpecifier = {
  type = "tilde-absolute-path",
  properties = {
    getables = {
      ["get-true-absolute-path"] = function(self) return self:get("contents"):gsub("^~", env.HOME) end,
    },
    doThisables = {
    }
  },
  action_table = {},
  

}


--- @type BoundNewDynamicContentsComponentInterface
CreateTildeAbsolutePathItem = bindArg(NewDynamicContentsComponentInterface, TildeAbsolutePathItemSpecifier)
