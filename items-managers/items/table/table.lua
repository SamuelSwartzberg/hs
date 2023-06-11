

TableSpecifier = {
  type = "table",
  properties = {
    getables = {
      ["amount-of-elements"] = function(self) return #keys(self:get("c")) end,
      ["is-empty-table"] = function(self) return self:get("amount-of-elements") == 0 end,
      ["is-non-empty-table"] = function(self) return self:get("amount-of-elements") > 0 end,
      ["to-json-string"] = function(self)
        return json.encode(self:get("c"))
      end,
      ["to-yaml-string"] = function(self)
        return json.encode(self:get("c"))
      end,
    },
    doThisables = {
    },
  },
  potential_interfaces = ovtable.init({
    { key = "non-empty-table", value = CreateNonEmptyTable },
    { key = "empty-table", value = CreateEmptyTable },
  }),
  action_table = {}
  
}

--- @type BoundRootInitializeInterface
tb = bindArg(RootInitializeInterface, TableSpecifier)