ManagedTimerArraySpecifier = {
  type = "array-with-timer-create-method",
  properties = {
    getables = {
    },
    doThisables = {
      ["space-firings"] = function(self)
        local firings = {}
        for _, item in ipairs(self:get("contents")) do
          local next_firing = item:get("next-firing")
          if not item:get("low-impact") and item:get("is-running") then -- no need to space out low-impact timers
            if not firings[next_firing] then
              firings[next_firing] = item
            else
              while firings[next_firing] do
                next_firing = next_firing + 1
              end
              item:doThis("set-next-firing", next_firing)
              firings[next_firing] = item
            end
          end
        end
      end,
    },
  },
  
  action_table = {}
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateManagedTimerArray = bindArg(NewDynamicContentsComponentInterface, ManagedTimerArraySpecifier)

function CreateManagedTimerArrayDirectly()
  local managed_timer_array = CreateArray({}, "timer")

  managed_timer_array:doThis("create", {
    interval = "*/10 * * * * *",
    low_impact = true,
    fn = function()
      managed_timer_array:doThis("space-firings")
    end
  })
    
  return managed_timer_array
end