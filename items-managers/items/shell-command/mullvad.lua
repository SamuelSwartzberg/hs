--- @type ItemSpecifier
MullvadCommandSpecifier = {
  type = "mullvad-command",
  properties = {
    getables = {
      ["relay-list-raw-string"] = function(self)
        return stringy.strip()
      end,
      ["flat-relay-array"] = function(self)
        return CreateArray(memoize(flatten)(self:get("relay-list-raw-table")))
      end,
              
    },
    doThisables = {
      
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateMullvadCommand = bindArg(NewDynamicContentsComponentInterface, MullvadCommandSpecifier)
