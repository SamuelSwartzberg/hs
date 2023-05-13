--- @type ItemSpecifier
StringValueEnvItemSpecifier = {
  type = "string-value-env",
  properties = {
    getables = {
      ["value-to-env-line-value"] = function(self, pkey_var)
        return pkey_var .. self:get("contents").value
      end,
    },
    doThisables = {
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateStringValueEnvItem = bindArg(NewDynamicContentsComponentInterface, StringValueEnvItemSpecifier)


