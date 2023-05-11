--- @type ItemSpecifier
CreatableItemSpecifier = {
  type = "creatable-item",
  properties = {
    getables = {
      ["specifier"] = function(self)
        return self:get("contents").specifier
      end,
      ["hscreatable"] = function (self)
        return self:get("contents").hscreatable
      end,
      ["specid"] = function(self)
        return json.encode(self:get("specifier"))
      end,
      ["type"] = function(self)
        return self:get("specifier").type
      end,
      ["is-hotkey"] = function(self)
        return self:get("type") == "hotkey"
      end,
      ["is-task"] = function(self)
        return self:get("type") == "task"
      end,
      ["is-watcher"] = function(self)
        return self:get("type") == "watcher"
      end,
    },
    doThisables = {
      ["recreate"] = function (self)
        self:doThis("stop")
        self:doThis("create-and-run")
      end,
      ["create-and-start"] = function(self)
        self:doThis("create")
        self:doThis("start")
      end,
      ["create"] = function(self)
        self:get("contents").hscreatable = self:get("created")
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "hotkey", value = CreateHotkeyItem },
    { key = "task", value = CreateTaskItem },
    { key = "watcher", value = CreateWatcherItem },
  }),
}

--- @type BoundRootInitializeInterface
function CreateCreatableItem(specifier)
  specifier.type = specifier.type or "hotkey"
  local creatable = RootInitializeInterface(CreatableItemSpecifier, {
    specifier = specifier
  })
  creatable:doThis("add-defaults-to-specifier")
  creatable:doThis("create-and-start")
  return creatable
end

