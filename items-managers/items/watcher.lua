--- @type ItemSpecifier
WatcherItemSpecifier = {
  type = "watcher-item",
  properties = {
    getables = {
    },
    doThisables = {
    }
  }
}

--- @type BoundRootInitializeInterface
function CreateWatcherItem(specifier)
  local watcher = specifier.type.new(specifier.fn)
  watcher:start()
  return RootInitializeInterface(WatcherItemSpecifier, watcher)
end

