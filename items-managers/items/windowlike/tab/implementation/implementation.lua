--- @type ItemSpecifier
TabImplementationItemSpecifier = {
  type = "tab-implementation",
  properties = {
    getables = {
      ["is-jxa-tab"] = function(self) 
        return self:get("contents").type == "jxa"
      end,
      ["is-state-tab"] = function(self) 
        return self:get("contents").type == "state"
      end,
    },
    doThisables = {

    }
  },
  potential_interfaces = ovtable.init({
    { key = "jxa-tab", value = CreateJxaTabItem },
    { key = "state-tab", value = CreateStateTabItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTabImplementationItem = bindArg(NewDynamicContentsComponentInterface, TabImplementationItemSpecifier)
