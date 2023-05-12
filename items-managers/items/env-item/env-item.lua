--- @type ItemSpecifier
EnvItemSpecifier = {
  type = "env-item",
  properties = {
    getables = {
      ["is-value-env-item"] = function(self)
        return self:get("contents").value
      end,
      ["is-no-value-env-item"] = function(self)
        return self:get("contents").value == nil
      end,
      ["is-dependents-env-item"] = function(self)
        return self:get("contents").dependents
      end,
      ["is-nodependents-env-item"] = function(self)
        return not self:get("contents").dependents
      end,
      ["is-aliases-env-item"] = function(self)
        return self:get("contents").aliases
      end,
      ["is-noaliases-env-item"] = function(self)
        return not self:get("contents").aliases
      end,
      ["env-lines"] = function(self, specifier)
        local my_lines = self:get("self-to-env-lines", specifier)
        local dependent_lines = self:get("dependents-to-env-lines", specifier.key) or {}
        return concat(my_lines, dependent_lines)
      end,
    },
    doThisables = {
    }
  },
  potential_interfaces = ovtable.init({
    { key = "value-env-item", value = CreateValueEnvItem },
    { key = "no-value-env-item", value = CreateNoValueEnvItem },
    { key = "dependents-env-item", value = CreateDependentsEnvItem },
    { key = "nodependents-env-item", value = CreateNodependentsEnvItem },
    { key = "aliases-env-item", value = CreateAliasesEnvItem },
    { key = "noaliases-env-item", value = CreateNoaliasesEnvItem },
  })
}

--- @type BoundRootInitializeInterface
function CreateEnvItem(contents)
  if contents.dependents then 
    contents.dependents = CreateTable(contents.dependents):get("parse-to-env-map")
  end
  local interface = RootInitializeInterface(EnvItemSpecifier, contents)
  return interface
end

