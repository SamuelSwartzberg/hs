--- replacement for the old timer, using cron specifiers instead

--- @type ItemSpecifier
TimerItemSpecifier = {
  type = "timer",
  properties = {
    getables = {
      ["interval"] = function (self)
        return self:get("c").interval
      end,
      ["fn"] = function(self)
        return self:get("c").fn
      end,
      ["next-firing"] = function(self)
        return self:get("c").next_firing
      end,
      ["timer"] = function (self)
        return self:get("c").timer
      end,
      ["calculate-next-firing"] = function(self)
        return memoize(transf.cronspec_string.next_timestamp_s)(self:get("interval"))
      end,
      ["low-impact"] = function(self)
        return self:get("c").low_impact
      end,
      ["is-primed"] = function(self)
        return self:get("timer") ~= nil
      end,
      ["is-running"] = function(self)
        local timer = self:get("timer")
        return timer ~= nil and timer:isRunning()
      end,

    },
    doThisables = {
      ["prime"] = function(self) -- prime by analogy with explosives: Set the timer for the next exection
        self:get("c").timer = doAtTimestamp(
          self:get("next-firing"), 
          function() 
            self:doThis("fire-and-prime") 
          end
        )
      end,
      ["unprime"] = function (self)
        self:get("c").timer = nil
      end,
      ["calculate-and-prime"] = function(self)
        self:get("c").next_firing = self:get("calculate-next-firing")
        self:doThis("prime")
      end,
      ["fire"] = function (self) -- fire by analogy with explosives: Execute the function and unprime the timer
        self:get("fn")()
        self:get("c").next_firing = nil
        self:get("c").timer = nil
      end,
      ["fire-and-prime"] = function(self) 
        self:get("fn")()
        self:doThis("calculate-and-prime")
      end,
      ["delay-by"] = function(self, seconds)
        self:get("c").next_firing = self:get("next-firing") + seconds
        self:doThis("prime")
      end,
      ["set-next-firing"] = function(self, seconds)
        self:get("c").next_firing = seconds
        self:doThis("prime")
      end,
      ["freeze"] = function(self) -- freezing = stopping a primed timer
        local contents = self:get("c")
        if contents.timer then
          contents.timer:stop()
        end
      end,
      ["unfreeze"] = function(self) -- unfreezing = starting a primed timer
        local contents = self:get("c")
        if contents.timer then
          contents.timer:start()
        end
      end,


      
    }
  },
  action_table = {},
  
}

--- @type BoundRootInitializeInterface
function CreateTimerItem(specifier)
  if type(specifier) == "function" then 
    specifier = {fn = specifier}
  end
  specifier.interval = specifier.interval or "*/10 * * * *"
  local timer_item = RootInitializeInterface(TimerItemSpecifier, specifier)
  timer_item:doThis("calculate-and-prime")
  return timer_item
end

