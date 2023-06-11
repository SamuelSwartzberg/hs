--- @type ItemSpecifier
PassOtpItemSpecifier = {
  type = "pass-otp",
  properties = {
    getables = {
      ["pass-otp"] = function(self)
        return get.pass.otp(self:get("c"))
      end,
    },
  },
  action_table = concat({getChooseItemTable({
    {
      d = "otp",
      i = "⌚️🗝",
      key = "pass-otp"
    },{
      i = "⌚️🗝📁",
      d = "otppth",
      key = "pass-otp-path"
    },
  })})
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassOtpItem = bindArg(NewDynamicContentsComponentInterface, PassOtpItemSpecifier)
