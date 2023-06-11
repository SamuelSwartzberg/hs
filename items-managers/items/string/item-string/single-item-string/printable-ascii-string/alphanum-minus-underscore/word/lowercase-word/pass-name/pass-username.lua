--- @type ItemSpecifier
PassUsernameItemSpecifier = {
  type = "pass-username",
  action_table = {
    {
      description = "usrnm",
      emoji_icon = "👤",
      getfn = transf.pass_name.username,
    },{
      description = "usrnmpth",
      emoji_icon = "👤📁",
      key = "pass-username-path"
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassUsernameItem = bindArg(NewDynamicContentsComponentInterface, PassUsernameItemSpecifier)
