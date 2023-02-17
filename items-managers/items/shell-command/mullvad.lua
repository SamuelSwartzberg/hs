--- @type ItemSpecifier
MullvadCommandSpecifier = {
  type = "mullvad-command",
  properties = {
    getables = {
      ["status"] = function()
        return stringy.strip(getOutputArgs(
          "mullvad",
          "status"
        ))
      end,
      ["is-connected"] = function (self)
        return stringy.startswith(self:get("status"),"Connected")
      end,
      ["relay-list-raw-string"] = function(self)
        return stringy.strip(memoized.getOutputArgs(
          "mullvad",
          "relay",
          "list"
        ))
      end,
      ["relay-list-raw-table"] = function(self)
        return memoized.parseRelayTable(self:get("relay-list-raw-string"))
      end,
      ["flat-relay-array"] = function(self)
        return CreateArray(memoized.collectLeaves(self:get("relay-list-raw-table")))
      end,
              
    },
    doThisables = {
      ["connect"] = function()
        runHsTask({
          "mullvad",
          "connect",
        })
      end,
      ["disconnect"] = function()
        runHsTask({
          "mullvad",
          "disconnect",
        })
      end,
      ["toggle"] = function(self)
        if self:get("is-connected") then
          self:doThis("disconnect")
        else
          self:doThis("connect")
        end
      end,
      ["relay-set"] = function(self, relay)
        runHsTask({
          "mullvad",
          "relay",
          "set",
          "hostname",
          relay,
        })
      end,
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateMullvadCommand = bindArg(NewDynamicContentsComponentInterface, MullvadCommandSpecifier)
