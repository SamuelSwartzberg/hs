--- @type ItemSpecifier
TrueAbsolutePathItemSpecifier = {
  type = "true-absolute-path",
  properties = {
    getables = {
      ["get-tilde-absolute-path"] = function(self) return self:get("contents"):gsub("^" .. env.HOME, "~") end,
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTrueAbsolutePathItem = bindArg(NewDynamicContentsComponentInterface, TrueAbsolutePathItemSpecifier)
