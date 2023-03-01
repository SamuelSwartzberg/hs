--- @type ItemSpecifier
TabbableWindowItemSpecifier = {
  type = "tabbable-window-item",
  properties = {
    getables = {
      ["is-jxa-tabbable-window"] = function(self) 
        return find({
          "Google Chrome",
          "Microsoft Edge",
        }, self:get("application-name"))
      end,
      ["is-state-tabbable-window"] = function(self) 
        return find({
          "Firefox"
        }, self:get("application-name"))
      end,
    },
    doThisables = {
     

    }
  },
  potential_interfaces = ovtable.init({
    { key = "jxa-tabbable-window", value = CreateJxaTabbableWindowItem },
    { key = "state-tabbable-window", value = CreateStateTabbableWindowItem },
  })
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTabbableWindowItem = bindArg(NewDynamicContentsComponentInterface, TabbableWindowItemSpecifier)

