--- @type ItemSpecifier
PhoneNumberItemSpecifier = {
  type = "phone-number-item",
  properties = {
    getables = {
     
    }
  },
  
  action_table =  {}

}

--- @type BoundNewDynamicContentsComponentInterface
CreatePhoneNumberItem = bindArg(NewDynamicContentsComponentInterface, PhoneNumberItemSpecifier)