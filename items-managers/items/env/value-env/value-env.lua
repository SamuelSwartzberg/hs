--- @type ItemSpecifier
ValueEnvItemSpecifier = {
  type = "value-env",
  properties = {
    getables = {
      ["is-list-value-env-item"] = function(self)
        return isListOrEmptyTable(self:get("c").value)
      end,
      ["is-string-value-env-item"] = function(self)
        return type(self:get("c").value) == "string"
      end
    },
    doThisables = {
    }

  },
  potential_interfaces = ovtable.init({
    { key = "list-value-env-item", value = CreateListValueEnvItem },
    { key = "string-value-env-item", value = CreateStringValueEnvItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateValueEnvItem = bindArg(NewDynamicContentsComponentInterface, ValueEnvItemSpecifier)

