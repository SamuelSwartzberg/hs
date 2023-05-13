--- @type ItemSpecifier
TrueAbsolutePathItemSpecifier = {
  type = "true-absolute-path",
  properties = {
    getables = {
      ["get-tilde-absolute-path"] = function(self) return self:get("contents"):gsub("^" .. env.HOME, "~") end,
      ["completely-resolved-path"] = function(self)
        return transf.string.path_resolved(self:get("contents")) -- no need to resolve tilde
      end,
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTrueAbsolutePathItem = bindArg(NewDynamicContentsComponentInterface, TrueAbsolutePathItemSpecifier)
