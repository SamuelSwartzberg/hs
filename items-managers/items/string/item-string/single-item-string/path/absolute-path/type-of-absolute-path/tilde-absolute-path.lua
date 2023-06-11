--- @type ItemSpecifier
TildeAbsolutePathItemSpecifier = {
  type = "tilde-absolute-path",
  properties = {
    getables = {
      ["get-true-absolute-path"] = function(self) return self:get("c"):gsub("^~", env.HOME) end,
      ["completely-resolved-path"] = function(self)
        return transf.string.path_resolved(self:get("c"), true)
      end,
    },
    doThisables = {
    }
  },
  action_table = {},
  

}


--- @type BoundNewDynamicContentsComponentInterface
CreateTildeAbsolutePathItem = bindArg(NewDynamicContentsComponentInterface, TildeAbsolutePathItemSpecifier)
