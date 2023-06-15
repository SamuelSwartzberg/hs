--- @type ItemSpecifier
PassPasswItemSpecifier = {
  type = "pass-passw",
  action_table = {
    {
      d = "passw",
      i = "🔑",
      getfn = transf.pass_name.password
    },{
      i = "🔑📁",
      d = "passwpth",
      key = "pass-passw-path"
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassPasswItem = bindArg(NewDynamicContentsComponentInterface, PassPasswItemSpecifier)
