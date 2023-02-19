--- replacement for the old timer, using cron specifiers instead

--- @type ItemSpecifier
TimerItemSpecifier = {
  type = "timer-item",
  properties = {
    getables = {
      ["interval"] = function (self)
        return self:get("contents").interval
      end,
      ["fn"] = function(self)
        return self:get("contents").fn
      end,
      ["next-firing"] = function(self)
        return self:get("contents").next_firing
      end,
      ["timer"] = function (self)
        return self:get("contents").timer
      end,
      ["calculate-next-firing"] = function(self)
        return tonumber(stringy.strip(getOutputArgsSimple(
          "ncron",
          { value = self:get("interval"), type = "quoted"}
        )), 10)
      end,
      ["low-impact"] = function(self)
        return self:get("contents").low_impact
      end,
      ["is-primed"] = function(self)
        return self:get("timer") ~= nil
      end,
      ["is-running"] = function(self)
        return self:get("timer"):running()
      end,

    },
    doThisables = {
      ["prime"] = function(self) -- prime by analogy with explosives: Set the timer for the next exection
        self:get("contents").timer = doAtTimestamp(
          self:get("next-firing"), 
          function() 
            self:doThis("fire-and-prime") 
          end
        )
      end,
      ["unprime"] = function (self)
        self:get("contents").timer = nil
      end,
      ["calculate-and-prime"] = function(self)
        self:get("contents").next_firing = self:get("calculate-next-firing")
        self:doThis("prime")
      end,
      ["fire"] = function (self) -- fire by analogy with explosives: Execute the function and unprime the timer
        self:get("fn")()
        self:get("contents").next_firing = nil
        self:get("contents").timer = nil
      end,
      ["fire-and-prime"] = function(self) 
        self:get("fn")()
        self:doThis("calculate-and-prime")
      end,
      ["delay-by"] = function(self, seconds)
        self:get("contents").next_firing = self:get("next-firing") + seconds
        self:doThis("prime")
      end,
      ["set-next-firing"] = function(self, seconds)
        self:get("contents").next_firing = seconds
        self:doThis("prime")
      end,
      ["freeze"] = function(self) -- freezing = stopping a primed timer
        local contents = self:get("contents")
        if contents.timer then
          contents.timer:stop()
        end
      end,
      ["unfreeze"] = function(self) -- unfreezing = starting a primed timer
        local contents = self:get("contents")
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
  specifier.interval = specifier.interval or "*/10 * * * *"
  local timer_item = RootInitializeInterface(TimerItemSpecifier, specifier)
  timer_item:doThis("calculate-and-prime")
  return timer_item
end

