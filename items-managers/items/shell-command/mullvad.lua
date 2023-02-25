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
        run({
          "mullvad",
          "connect",
        }, true)
      end,
      ["disconnect"] = function()
        run({
          "mullvad",
          "disconnect",
        }, true)
      end,
      ["toggle"] = function(self)
        if self:get("is-connected") then
          self:doThis("disconnect")
        else
          self:doThis("connect")
        end
      end,
      ["relay-set"] = function(self, relay)
        run({
          "mullvad",
          "relay",
          "set",
          "hostname",
          relay,
        }, true)
      end,
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateMullvadCommand = bindArg(NewDynamicContentsComponentInterface, MullvadCommandSpecifier)
