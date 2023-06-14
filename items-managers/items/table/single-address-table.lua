--- @type ItemSpecifier
AddressTableSpecifier = {
  type = "address-table",
  properties = {
    getables = {
      ["name-and-address-string-oneline"] = function(self)
        local address_table = self:get("c")
        return string.format(
          "%s, %s, %s, %s, %s, %s, %s",
          address_table["Formatted name"],
          address_table["Extended"],
          address_table["Street"],
          address_table["Code"],
          address_table["City"],
          address_table["Region"],
          address_table["Country"]
        )
      end,
      ["to-string"] = function(self)
        return self:get("name-and-address-string-oneline")
      end,
      ["name-and-address-string-postal"] = function(self)
        local address_table = self:get("c")
        return 
          address_table["Formatted name"] .. "\n" ..
          address_table["Extended"] .. "\n" ..
          address_table["Street"] .. "\n" ..
          address_table["Code"] .. " " .. address_table["City"] 
      end,
      ["name-and-address-string-form"] = function(self) -- there is of course not one type of form for addresses, this is just the most common I've encountered.
        local address_table = self:get("c")
        return 
          address_table["First name"] .. "\n" ..
          address_table["Last name"] .. "\n" ..
          address_table["Street"] .. "\n" ..
          address_table["Code"] .. "\n" ..
          address_table["City"] .. "\n" ..
          address_table["Country"]
      end,
    }
  },
  
  action_table = {
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
function CreateAddressTable(super)
  return NewDynamicContentsComponentInterface(AddressTableSpecifier, super)
end

