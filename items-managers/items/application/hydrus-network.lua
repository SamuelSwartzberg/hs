--- @type ItemSpecifier
HydrusNetworkItemSpecifier = {
  type = "hydrus-network-item",
  properties = {
    getables = {
      ["to-hs-application"] = function(self)
        return hs.application.get("client") -- for some reason, this is the name of the application. While one would think there might be other applications with the same name, I have not found any.
      end,
      ["to-running-application"] = function(self)
        return CreateRunningApplicationItem(self:get("to-hs-application"))
      end,
      ["api-host"] = function(self)
        return "http://127.0.0.1:45869/"
      end,
      ["access-key"] = function()
        return env.HYDRUS_ACCESS_KEY
      end,
      ["api-url"] = function(self, endpoint)
        return self:get("api-host") .. endpoint
      end,
    },
    doThisables = {
      ["do-api-request"] = function(self, specifier)
        local local_specifier = {
          host = self:get("api-host"),
          endpoint = specifier.endpoint,
          params = specifier.params,
          api_key = self:get("access-key"),
          api_key_header = "Hydrus-Client-API-Access-Key:"
        }
        specifier = concat(local_specifier, specifier)
---@diagnostic disable-next-line: undefined-field
        makeSimpleRESTApiRequest(specifier, specifier.do_after)
      end,
      ["add-url-to-hydrus"] = function(self, url)
        self:doThis("do-api-request", {
          endpoint = "add_urls/add_url",
          request_table = { url = url }
        })
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateHydrusNetworkItem = bindArg(NewDynamicContentsComponentInterface, HydrusNetworkItemSpecifier)