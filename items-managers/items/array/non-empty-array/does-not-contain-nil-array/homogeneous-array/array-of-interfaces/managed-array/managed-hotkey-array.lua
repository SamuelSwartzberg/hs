ManagedHotkeyArraySpecifier = {
  type = "managed-hotkey-array",
  properties = {
    getables = {
    },
    doThisables = {
      ["create"] = function(self, specifier)
        self:doThis("add-to-end", CreateHotkeyItem(specifier))
      end,
      --- @param specifier { [string]: key_inner_specifier}
      ["register-all"] = function(self, specifier)
        for key, inner_specifier in pairs(specifier) do
          self:doThis("create", {key = key, fn = inner_specifier.fn, explanation = inner_specifier.explanation, mnemonic = inner_specifier.mnemonic})
        end
      end
    },
  },
  
  action_table = {}
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateManagedHotkeyArray = bindArg(NewDynamicContentsComponentInterface, ManagedHotkeyArraySpecifier)

function CreateManagedHotkeyArrayDirectly()
  local managed_hotkey_array = CreateArray({}, "hotkey")
  return managed_hotkey_array
end