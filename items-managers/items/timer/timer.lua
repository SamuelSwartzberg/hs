--- @type ItemSpecifier
TimerItemSpecifier = {
  type = "timer-item",
  properties = {
    getables = {
      ["timer"] = function(self)
        return self:get("contents").timer
      end,
      ["interval"] = function (self)
        return self:get("contents").interval
      end,
      ["fn"] = function(self)
        return self:get("contents").fn
      end,
      ["is-running"] = function(self)
        return self:get("timer"):running()
      end,
      ["next-trigger"] = function(self)
        return toInt(self:get("timer"):nextTrigger())
      end,
      ["low-impact"] = function(self)
        return self:get("contents").low_impact
      end,

    },
    doThisables = {
      ["start"] = function (self)
        self:get("timer"):start()
      end,
      ["stop"] = function (self)
        self:get("timer"):stop()
      end,
      ["set-next-trigger"] = function (self, seconds)
        self:get("timer"):setNextTrigger(seconds)
      end,
      ["delay-by"] = function (self, seconds)
        self:get("timer"):setNextTrigger(self:get("next-trigger") + seconds)
      end,
      ["fire"] = function (self)
        self:get("timer"):fire()
      end,
      ["set-new-fn"] = function (self, fn)
        self:get("contents").timer = hs.timer.doEvery(self:get("interval"), fn)
      end,
      ["set-new-interval"] = function (self, interval)
        self:get("contents").timer = hs.timer.doEvery(interval, self:get("fn"))
      end,
      
    }
  },
  action_table = {},
  
}

--- @type BoundRootInitializeInterface
function CreateTimerItem(specifier)
  specifier.timer = hs.timer.new(specifier.interval or toSeconds(10, "m"), specifier.fn)
  specifier.timer:start()
  return RootInitializeInterface(TimerItemSpecifier, specifier)
end

