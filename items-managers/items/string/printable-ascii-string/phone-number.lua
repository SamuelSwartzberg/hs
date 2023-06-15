--- @type ItemSpecifier
PhoneNumberItemSpecifier = {
  type = "phone-number",
  properties = {
    getables = {
     
    }
  },
  
  action_table =  {}

}

--- @type BoundNewDynamicContentsComponentInterface
CreatePhoneNumberItem = bindArg(NewDynamicContentsComponentInterface, PhoneNumberItemSpecifier)