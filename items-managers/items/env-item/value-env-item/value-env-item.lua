--- @type ItemSpecifier
ValueEnvItemSpecifier = {
  type = "value-env-item",
  properties = {
    getables = {
      ["is-list-value-env-item"] = function(self)
        return isListOrEmptyTable(self:get("contents").value)
      end,
      ["is-no-value-env-item"] = function(self)
        return self:get("contents").value == nil
      end,
      ["is-string-value-env-item"] = function(self)
        return type(self:get("contents").value) == "string"
      end
    },
    doThisables = {
    }

  },
  potential_interfaces = ovtable.init({
    { key = "list-value-env-item", value = CreateListValueEnvItem },
    { key = "string-value-env-item", value = CreateStringValueEnvItem },
    { key = "no-value-env-item", value = CreateNoValueEnvItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateValueEnvItem = bindArg(NewDynamicContentsComponentInterface, ValueEnvItemSpecifier)

