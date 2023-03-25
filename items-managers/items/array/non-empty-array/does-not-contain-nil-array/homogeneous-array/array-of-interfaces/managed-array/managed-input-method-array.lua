ManagedInputMethodArraySpecifier = {
  type = "managed-input-method-array",
  properties = {
    getables = {
      ["next-to-be-activated"] = function(self)
        local current_active_index = self:get('find-index', function(item)
          return item:get("is-active")
        end)
        return self:get("next-wrapping", current_active_index)
      end,
    },
    doThisables = {
      ["create"] = function(self, method_id)
        self:doThis("add-to-end", CreateInputMethodItem(method_id))
      end,
      ["register-all"] = function(self, specifier)
        for index, method_id in iprs(specifier) do
          self:doThis("create", method_id)
        end
      end,
      ["activate-next"] = function(self)
        self:get("next-to-be-activated"):doThis("activate")
      end,
    },
  },
  
  action_table = {}
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateManagedInputMethodArray = bindArg(NewDynamicContentsComponentInterface, ManagedInputMethodArraySpecifier)

function CreateManagedInputMethodArrayDirectly()
  local managed_inputmethod_array = CreateArray({}, "input-method")
  return managed_inputmethod_array
end