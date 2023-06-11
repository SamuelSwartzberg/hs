--- @type ItemSpecifier
PassPasswItemSpecifier = {
  type = "pass-passw",
  properties = {
    getables = {
      ["pass-passw"] = function(self)
        return self:get("pass-value", "passw")
      end,
    }
  },
  action_table = getChooseItemTable({
    {
      d = "passw",
      i = "🔑",
      key = "pass-passw"
    },{
      i = "🔑📁",
      d = "passwpth",
      key = "pass-passw-path"
    },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassPasswItem = bindArg(NewDynamicContentsComponentInterface, PassPasswItemSpecifier)
