--- @type ItemSpecifier
MullvadRelayIdentifierItemSpecifier = {
  type = "mullvad-relay-identifier",
  properties = {
    getables = {

    },
    doThisables = {
      ["relay-set"] = function(self)
        CreateShellCommand("mullvad"):doThis("relay-set", self:get("contents"))
      end,
    }
  },
  
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateMullvadRelayIdentifierItem = bindArg(NewDynamicContentsComponentInterface, MullvadRelayIdentifierItemSpecifier)