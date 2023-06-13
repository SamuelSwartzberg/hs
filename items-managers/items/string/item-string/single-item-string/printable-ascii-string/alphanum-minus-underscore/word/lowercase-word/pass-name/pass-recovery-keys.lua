--- @type ItemSpecifier
PassRecoveryKeysItemSpecifier = {
  type = "pass-recovery-keys",
  action_table = {
    {
      d = "rcvry",
      i = "🔧🔑",
      key = "pass-passw"
    },{
      i = "🔧🔑📁",
      d = "rcvrypth",
      key = "pass-recovery-path"
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassRecoveryKeysItem = bindArg(NewDynamicContentsComponentInterface, PassRecoveryKeysItemSpecifier)
