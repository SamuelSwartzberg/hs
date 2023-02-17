--- @type ItemSpecifier
PassOtpItemSpecifier = {
  type = "pass-otp-item",
  properties = {
    getables = {
      ["pass-otp"] = function(self)
        return stringy.strip(getOutputTask({
          "pass",
          "otp",
          {
            value = "otp/" .. self:get("contents"),
            type = "quoted"
          }
        }))
      end,
    },
  },
  action_table = listConcat(getChooseItemTable({
    {
      description = "otp",
      emoji_icon = "⌚️🗝",
      key = "pass-otp"
    },{
      emoji_icon = "⌚️🗝📁",
      description = "otppth",
      key = "pass-otp-path"
    },
  }))
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassOtpItem = bindArg(NewDynamicContentsComponentInterface, PassOtpItemSpecifier)
