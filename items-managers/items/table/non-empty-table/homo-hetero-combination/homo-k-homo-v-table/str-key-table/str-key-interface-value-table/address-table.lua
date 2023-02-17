--- @type ItemSpecifier
AddressTableSpecifier = {
  type = "address-table",
  properties = {
    doThisables = {},
    getables = { }
  },
  
  action_table = { }
}

--- @type BoundNewDynamicContentsComponentInterface
function CreateAddressTable(super)
  return NewDynamicContentsComponentInterface(AddressTableSpecifier, super)
end

