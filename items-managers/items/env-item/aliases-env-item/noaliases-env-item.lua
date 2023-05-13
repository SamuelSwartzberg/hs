--- @type ItemSpecifier
NoaliasesEnvItemSpecifier = {
  type = "noaliases-env",
  properties = {
    getables = {
      ["self-to-env-lines"] = function(self, specifier)
        local val = self:get("value-to-env-line-value", specifier.pkey_var)
        if val ~= nil then
          return {
            string.format(
              "%s=\"%s\"", 
              specifier.key, 
              val
            )
          }
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
CreateNoaliasesEnvItem = bindArg(NewDynamicContentsComponentInterface, NoaliasesEnvItemSpecifier)


