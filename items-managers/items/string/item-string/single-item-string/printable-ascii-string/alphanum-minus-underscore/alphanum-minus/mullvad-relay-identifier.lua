--- @type ItemSpecifier
MullvadRelayIdentifierItemSpecifier = {
  type = "mullvad-relay-identifier",
  properties = {
    getables = {

    },
    doThisables = {
      ["relay-set"] = function(self)
        dothis.mullvad.relay_set(self:get("c"))
      end,
    }
  },
  
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateMullvadRelayIdentifierItem = bindArg(NewDynamicContentsComponentInterface, MullvadRelayIdentifierItemSpecifier)