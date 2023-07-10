--- @type ItemSpecifier
CreatableItemSpecifier = {
  type = "creatable",
  properties = {
    getables = {
      ["specid"] = function(self)
        local spec = self:get("specifier")
        local filteredSpec = {}
        for k,v in transf.native_table.key_value_stateless_iter(spec) do
          if type(v) ~= "userdata" and type(v) ~= "function" then
            filteredSpec[k] = v
          end
        end
        return json.encode(filteredSpec)
      end,
      ["is-fireable"] = function(self)
        return self:get("specifier").fn ~= nil
      end,
      
    },
    doThisables = {
    }
  },
  potential_interfaces = ovtable.init({
    {"task", CreateTaskItem },
    {"fireable", CreateFireableItem },
  }),
}

--- @type BoundRootInitializeInterface
function CreateCreatableItem(specifier)
  specifier.type = specifier.type or "hotkey"
  local creatable = RootInitializeInterface(CreatableItemSpecifier, {
    specifier = specifier
  })
  creatable:doThis("add-defaults-to-specifier")
  creatable:doThis("create-and-start")
  return creatable
end

