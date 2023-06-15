--- @type ItemSpecifier
AddressTableSpecifier = {
  type = "address-table",
  
  action_table = {
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
function CreateAddressTable(super)
  return NewDynamicContentsComponentInterface(AddressTableSpecifier, super)
end

