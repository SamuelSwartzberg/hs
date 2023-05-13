--- @type ItemSpecifier
EmailAddressItemSpecifier = {
  type = "email-address",
  properties = {
    getables = {
    },
    doThisables = {
      ["send-email"] = function(self, specifier)
        specifier = specifier or {}
        sendEmailInteractive({
          from = env.MAIN_EMAIL,
          to = self:get("contents"),
          subject = specifier.subject,
        }, specifier.body, specifier.edit_func or editorEditFunc)
      end
    }
  },
  
  action_table = {
    {
      text = "📧 ma.",
      key = "send-email"
    }
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateEmailAddressItem = bindArg(NewDynamicContentsComponentInterface, EmailAddressItemSpecifier)