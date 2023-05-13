--- @type ItemSpecifier
FireableItemSpecifier = {
  type = "fireable",
  properties = {
    getables = {
      ["is-watcher"] = function(self)
        return self:get("type") == "watcher"
      end,
      ["is-hotkey"] = function(self)
        return self:get("type") == "hotkey"
      end,
      
    },
    doThisables = {
      ["fire"] = function(self)
        self:get("specifier").fn()
      end,
      ["pause"] = function(self) -- fireable items don't have pause/resume as separate from start/stop, so just stop them
        self:doThis("stop")
      end,
      ["resume"] = function(self)
        self:doThis("start")
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "hotkey", value = CreateHotkeyItem },
    { key = "watcher", value = CreateWatcherItem },
  }),
}

--- @type BoundNewDynamicContentsComponentInterface
CreateFireableItem = bindArg(NewDynamicContentsComponentInterface, FireableItemSpecifier)