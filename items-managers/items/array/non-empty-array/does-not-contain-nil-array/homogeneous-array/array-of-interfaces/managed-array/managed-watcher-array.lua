ManagedWatcherArraySpecifier = {
  type = "managed-watcher-array",
  properties = {
    getables = {
    },
    doThisables = {
      ["create"] = function(self, specifier)
        self:doThis("add-to-end", CreateWatcherItem(specifier))
      end,
      ["register-all"] = function(self, specifiers)
        print("registering")
        for _, specifier in ipairs(specifiers) do
          self:doThis("create", specifier)
        end
      end
    },
  },
  
  action_table = {}
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateManagedWatcherArray = bindArg(NewDynamicContentsComponentInterface, ManagedWatcherArraySpecifier)

function CreateManagedWatcherArrayDirectly()
  local managed_watcher_array = CreateArray({}, "watcher")
  return managed_watcher_array
end