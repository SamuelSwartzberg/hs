--- @type ItemSpecifier
PassUsernameItemSpecifier = {
  type = "pass-username",
  action_table = {
    {
      d = "usrnm",
      i = "👤",
      getfn = transf.pass_name.username,
    },{
      d = "usrnmpth",
      i = "👤📁",
      key = "pass-username-path"
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassUsernameItem = bindArg(NewDynamicContentsComponentInterface, PassUsernameItemSpecifier)
