--- @type ItemSpecifier
TabCombinationItemSpecifier = {
  type = "tab-combination-item",
  properties = {
    getables = {
      ["is-jxa-browser-tab"] = function(self) 
        return 
          self:get("is-jxa-tab") and
          self:get("is-browser-tab")
      end,
      ["is-state-browser-tab"] = function(self) 
        return 
          self:get("is-state-tab") and
          self:get("is-browser-tab")
      end,
    },
    doThisables = {

    }
  },
  potential_interfaces = ovtable.init({
    { key = "jxa-browser-tab", value = CreateJxaBrowserTabItem },
    { key = "state-browser-tab", value = CreateStateBrowserTabItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTabCombinationItem = bindArg(NewDynamicContentsComponentInterface, TabCombinationItemSpecifier)
