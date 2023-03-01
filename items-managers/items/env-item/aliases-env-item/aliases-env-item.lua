--- @type ItemSpecifier
AliasesEnvItemSpecifier = {
  type = "aliases-env-item",
  properties = {
    getables = {
      ["self-to-env-lines"] = function(self, specifier)
        local val = self:get("value-to-env-line-value", specifier.pkey_var)
        if val ~= nil then 
          local keys = listPrepend(self:get("contents").aliases, specifier.key)
          local lines = map(keys, function(k) return string.format("%s=\"%s\"", k, val) end)
          return lines
        else
          return {}
        end
      end
    },
    doThisables = {
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateAliasesEnvItem = bindArg(NewDynamicContentsComponentInterface, AliasesEnvItemSpecifier)


