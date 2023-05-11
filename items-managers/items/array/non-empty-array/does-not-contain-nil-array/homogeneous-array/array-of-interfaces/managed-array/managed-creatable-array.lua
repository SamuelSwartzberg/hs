ManagedCreatableArraySpecifier = {
  type = "managed-creatable-array",
  properties = {
    getables = {
      ["creator"] = function() return CreateCreatableItem end,
      ["find-by-specifier"] = function(self, specifier)
        local specid = json.encode(specifier)
        return self:doThis("find", function(task)
          return task:get("specid") == specid
        end)
      end
    },
    doThisables = {
     
    },
  },
  
  action_table = {}
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateManagedCreatableArray = bindArg(NewDynamicContentsComponentInterface, ManagedCreatableArraySpecifier)

function CreateManagedCreatableArrayDirectly()
  local managed_creatable_array = CreateArray({}, "creatable")
  return managed_creatable_array
end