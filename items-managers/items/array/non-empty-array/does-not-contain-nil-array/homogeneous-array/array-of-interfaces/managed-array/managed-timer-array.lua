ManagedTimerArraySpecifier = {
  type = "array-with-timer-create-method",
  properties = {
    getables = {
    },
    doThisables = {
      ["space-triggers"] = function(self)
        local triggers = {}
        for _, item in ipairs(self:get("contents")) do
          local next_trigger = item:get("next-trigger")
          if not item:get("low-impact") and item:get("is-running") then -- no need to space out low-impact timers
            if not triggers[next_trigger] then
              triggers[next_trigger] = item
            else
              print("Spacing")
              while triggers[next_trigger] do
                next_trigger = next_trigger + 1
              end
              item:doThis("set-next-trigger", next_trigger)
              triggers[next_trigger] = item
            end
          end
        end
      end,

      ["create"] = function(self, specifier)
        local timer
        if type(specifier) == "function" then 
          timer = CreateTimerItem({fn = specifier})
        else
          timer = CreateTimerItem(specifier)
        end
        self:doThis("add-to-end", timer)
      end,
      ["register-all"] = function(self, specifiers)
        for _, specifier in ipairs(specifiers) do
          self:doThis("create", specifier)
        end
      end
    },
  },
  
  action_table = {}
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateManagedTimerArray = bindArg(NewDynamicContentsComponentInterface, ManagedTimerArraySpecifier)

function CreateManagedTimerArrayDirectly()
  local managed_timer_array = CreateArray({}, "timer")

  managed_timer_array:doThis("create", {
    interval = 10,
    low_impact = true,
    fn = function()
      managed_timer_array:doThis("space-triggers")
    end
  })
    
  return managed_timer_array
end