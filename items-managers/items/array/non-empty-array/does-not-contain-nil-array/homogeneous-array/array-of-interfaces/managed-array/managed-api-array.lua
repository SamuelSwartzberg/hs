ManagedApiArraySpecifier = {
  type = "managed-api-array",
  properties = {
    getables = {
      ["creator"] = function(self) return CreateApiItem end,
    },
    doThisables = {
      
    },
  },
  
  action_table = {}
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateManagedApiArray = bindArg(NewDynamicContentsComponentInterface, ManagedApiArraySpecifier)

--- @type BoundRootInitializeInterface
function CreateManagedApiArrayDirectly(managed_timer_array)
  local managed_api_array = CreateArray({}, "api")
  managed_timer_array:doThis("create", {
    interval = "*/30 * * * *",
    fn = function()
      managed_api_array:doThis("for-all-staggered", {
        interval = "*/2 * * * *",
        fn = function(api)
          api:doThis("refresh-tokens")
        end
      })
    end
  })
  return managed_api_array
end