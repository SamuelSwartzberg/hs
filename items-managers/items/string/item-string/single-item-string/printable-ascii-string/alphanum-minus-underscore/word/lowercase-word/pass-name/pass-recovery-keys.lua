--- @type ItemSpecifier
PassRecoveryKeysItemSpecifier = {
  type = "pass-recovery-keys",
  properties = {
    getables = {
      ["pass-recovery-key"] = function(self)
        return self:get("pass-value", "recovery")
      end,
    }
  },
  action_table = concat({getChooseItemTable({
    {
      description = "rcvry",
      emoji_icon = "🔧🔑",
      key = "pass-passw"
    },{
      emoji_icon = "🔧🔑📁",
      description = "rcvrypth",
      key = "pass-recovery-path"
    }
  })}),
  potential_interfaces = ovtable.init({})
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassRecoveryKeysItem = bindArg(NewDynamicContentsComponentInterface, PassRecoveryKeysItemSpecifier)
