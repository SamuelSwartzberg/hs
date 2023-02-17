HeterogeneousValueTableSpecifier = {
  type = "heterogeneous-value-table",
  properties = {
    getables = {
      ["is-string-and-table-value-table"] = function(self)
        return self:get("all-values-pass", function(value)
          return type(value) == "string" or type(value) == "table"
        end)
      end,
      ["is-string-and-number-value-table"] = function(self)
        return self:get("all-values-pass", function(value)
          return type(value) == "string" or type(value) == "number"
        end)
      end,
      ["is-env-value-table"] = function(self)
        return self:get("all-values-pass", function(value)
          local pass = type(value) == "string" or (type(value) == "table" and value.type == "env-item")
          return pass
        end)
      end,
    },
    doThisables = {
   
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateHeterogeneousValueTable = bindArg(NewDynamicContentsComponentInterface, HeterogeneousValueTableSpecifier)
