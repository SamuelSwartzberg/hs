--- @type ItemSpecifier
WindowImplementationItemSpecifier = {
  type = "window-implementation-item",
  properties = {
    getables = {
      ["is-jxa-window"] = function(self) 
        return find({
          "Google Chrome",
          "Microsoft Edge",
          "Firefox",
        }, self:get("application-name"))
      end,
      ["is-state-window"] = function(self) 
        return find({
          "Firefox"
        }, self:get("application-name"))
      end,
    },
    doThisables = {

    }
  },
  potential_interfaces = ovtable.init({
    { key = "jxa-window", value = CreateJxaWindowItem },
    { key = "state-window", value = CreateStateWindowItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateWindowImplementationItem = bindArg(NewDynamicContentsComponentInterface, WindowImplementationItemSpecifier)
