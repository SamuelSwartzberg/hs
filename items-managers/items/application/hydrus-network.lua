--- @type ItemSpecifier
HydrusNetworkItemSpecifier = {
  type = "hydrus-network",
  properties = {
    getables = {
      ["to-hs-application"] = function(self)
        return hs.application.get("client") -- for some reason, this is the name of the application. While one would think there might be other applications with the same name, I have not found any.
      end,
      ["to-running-application"] = function(self)
        return CreateRunningApplicationItem(self:get("to-hs-application"))
      end,
    },
    doThisables = {
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateHydrusNetworkItem = bindArg(NewDynamicContentsComponentInterface, HydrusNetworkItemSpecifier)