--- @type ItemSpecifier
PassOtpItemSpecifier = {
  type = "pass-otp",
  properties = {
    getables = {
      ["pass-otp"] = function(self)
        return transf.pass_name.otp(self:get("c"))
      end,
    },
  },
  action_table = {
    {
      d = "otp",
      i = "⌚️🗝",
      getfn = transf.pass_name.otp
    },{
      i = "⌚️🗝📁",
      d = "otppth",
      key = "pass-otp-path"
    },
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassOtpItem = bindArg(NewDynamicContentsComponentInterface, PassOtpItemSpecifier)
