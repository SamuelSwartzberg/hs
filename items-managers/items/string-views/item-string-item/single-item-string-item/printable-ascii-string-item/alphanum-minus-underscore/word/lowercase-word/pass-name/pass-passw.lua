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
      description = "passw",
      emoji_icon = "🔑",
      key = "pass-passw"
    },{
      emoji_icon = "🔑📁",
      description = "passwpth",
      key = "pass-passw-path"
    },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassPasswItem = bindArg(NewDynamicContentsComponentInterface, PassPasswItemSpecifier)
