--- @type ItemSpecifier
AddressTableSpecifier = {
  type = "address-table",
  
  action_table = {
    
  }

}

--- @type BoundRootInitializeInterface
function CreateAddressTable(contents)
  return RootInitializeInterface(AddressTableSpecifier, contents)
end

