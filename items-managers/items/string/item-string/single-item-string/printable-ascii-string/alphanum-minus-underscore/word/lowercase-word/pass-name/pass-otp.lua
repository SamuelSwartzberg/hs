--- @type ItemSpecifier
PassOtpItemSpecifier = {
  type = "pass-otp",
  properties = {
    getables = {
      ["pass-otp"] = function(self)
        return get.pass.otp(self:get("contents"))
      end,
    },
  },
  action_table = concat({getChooseItemTable({
    {
      description = "otp",
      emoji_icon = "⌚️🗝",
      key = "pass-otp"
    },{
      emoji_icon = "⌚️🗝📁",
      description = "otppth",
      key = "pass-otp-path"
    },
  })})
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassOtpItem = bindArg(NewDynamicContentsComponentInterface, PassOtpItemSpecifier)
