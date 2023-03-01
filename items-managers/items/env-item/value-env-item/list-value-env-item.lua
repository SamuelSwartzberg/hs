--- @type ItemSpecifier
ListValueEnvItemSpecifier = {
  type = "list-value-env-item",
  properties = {
    getables = {
      ["value-to-env-line-value"] = function(self, pkey_var)
        local values = map(self:get("contents").value, function(v) return pkey_var .. v end)
        return stringx.join(":", values)
      end,
    },
    doThisables = {
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateListValueEnvItem = bindArg(NewDynamicContentsComponentInterface, ListValueEnvItemSpecifier)


