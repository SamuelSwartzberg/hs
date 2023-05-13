--- @type ItemSpecifier
NoValueEnvItemSpecifier = {
  type = "no-value-env",
  properties = {
    getables = {
      ["value-to-env-line-value"] = function(self)
        return nil
      end,
    },
    doThisables = {
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNoValueEnvItem = bindArg(NewDynamicContentsComponentInterface, NoValueEnvItemSpecifier)


