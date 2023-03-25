ManagedApiArraySpecifier = {
  type = "managed-api-array",
  properties = {
    getables = {
    },
    doThisables = {
      ["create"] = function(self, api_url)
        self:doThis("add-to-end", CreateApiItem(api_url))
      end,
      ["register-all"] = function(self, api_urls)
        for _, api_url in iprs(api_urls) do
          self:doThis("create", api_url)
        end
      end
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