--- @type ItemSpecifier
DependentsEnvItemSpecifier = {
  type = "dependents-env-item",
  properties = {
    getables = {
      ["dependents"] = function(self)
        return self:get("contents").dependents
      end,
      ["dependents-to-env-lines"] = function(self, key)
        return self:get("dependents"):get("env-lines", key)
      end,
    },
    doThisables = {
      
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDependentsEnvItem = bindArg(NewDynamicContentsComponentInterface, DependentsEnvItemSpecifier)


