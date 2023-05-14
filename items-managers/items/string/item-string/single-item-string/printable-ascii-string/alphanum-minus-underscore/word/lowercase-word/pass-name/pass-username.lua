--- @type ItemSpecifier
PassUsernameItemSpecifier = {
  type = "pass-username",
  properties = {
    getables = {
      ["pass-username-as-filename"] = function(self)
        return self:get("contents") .. ".txt"
      end,
      ["pass-username-raw"] = function(self)
        return CreateStringItem(env.MPASSUSERNAME .. "/" .. self:get("pass-username-as-filename")):get("file-contents-to-string")
      end,
    }
  },
  action_table = getChooseItemTable({
    {
      description = "usrnm",
      emoji_icon = "👤",
      key = "pass-username"
    },{
      description = "usrnmpth",
      emoji_icon = "👤📁",
      key = "pass-username-path"
    }
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassUsernameItem = bindArg(NewDynamicContentsComponentInterface, PassUsernameItemSpecifier)
