--- @type ItemSpecifier
NodependentsEnvItemSpecifier = {
  type = "nodependents-env-item",
  properties = {
    getables = {
      ["dependents-to-env-lines"] = function()
        return {}
      end,
    },
    doThisables = {
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNodependentsEnvItem = bindArg(NewDynamicContentsComponentInterface, NodependentsEnvItemSpecifier)

