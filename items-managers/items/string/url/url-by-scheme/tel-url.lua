--- @type ItemSpecifier
TelURLItemSpecifier = {
  type = "tel-url",
  properties = {
    getables = {
      ['phone-number'] = function (self)
        return transf.tel_url.phone_number(self:get("c"))
      end
    }, 
    doThisables = {
      
    }
  },

  action_table =concat(getChooseItemTable({
    {
      i = "📞",
      d = "phone.",
      key = "phone-number"
    },
  }),{})
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTelURLItem = bindArg(NewDynamicContentsComponentInterface, TelURLItemSpecifier)