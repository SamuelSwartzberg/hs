--- @type ItemSpecifier
WatcherItemSpecifier = {
  type = "watcher",
  properties = {
    getables = {
      ["fn"] = function(self)
        return self:get("specifier").fn
      end,
      ["watchertype"] = function(self)
        return self:get("specifier").watchertype
      end,
      ["running"] = function(self)
        return self:get("hscreatable"):running()
      end,
      ["created"] = function(self)
        return self:get("specifier").type.new(self:get("specifier").fn)
      end,
    },
    doThisables = {
      ["start"] = function (self)
        self:get("hscreatable"):start()
      end,
      ["stop"] = function (self)
        self:get("hscreatable"):stop()
      end,
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateWatcherItem = bindArg(NewDynamicContentsComponentInterface, WatcherItemSpecifier)