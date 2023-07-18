--- @type ItemSpecifier
TrueAbsolutePathItemSpecifier = {
  type = "true-absolute-path",
  properties = {
    getables = {
      ["get-tilde-absolute-path"] = function(self) return self:get("c"):gsub("^" .. env.HOME, "~") end,
      ["completely-resolved-path"] = function(self)
        return hs.fs.pathToAbsolute(self:get("c")) -- no need to resolve tilde
      end,
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTrueAbsolutePathItem = bindArg(NewDynamicContentsComponentInterface, TrueAbsolutePathItemSpecifier)
