--- @type ItemSpecifier
EmailAddressItemSpecifier = {
  type = "email-address",
  properties = {
    getables = {
    },
  },
  
  action_table = {
    {
      text = "📧 ma.",
      dothis = dothis.email_address.edit_then_send
    }
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateEmailAddressItem = bindArg(NewDynamicContentsComponentInterface, EmailAddressItemSpecifier)