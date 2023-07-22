--- @type ItemSpecifier
OtpauthURLItemSpecifier = {
  type = "otpauth-url",
  properties = {
    getables = {
     

    }, 
    doThisables = {
      ["add-as-otp"] = function (self, name)
        dothis.otp_url.add_otp_pass_item(self:get("c"), name)
      end
    }
  },

  action_table = {
    {
      text = "📌⌚️🗝 addotp.",
      key = "do-interactive",
      args = { key = "add-as-otp", thing = "name" }
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateOtpauthURLItem = bindArg(NewDynamicContentsComponentInterface, OtpauthURLItemSpecifier)