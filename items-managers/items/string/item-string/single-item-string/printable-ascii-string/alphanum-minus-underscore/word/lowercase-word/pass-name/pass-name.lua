--- @type ItemSpecifier
PassNameItemSpecifier = {
  type = "pass-name",
  properties = {
    getables = {
      ["is-pass-otp"] = bc(is.pass_name.otp),
      ["is-pass-passw"] = bc(is.pass_name.password),
      ["is-pass-recovery-keys"] = bc(is.pass_name.recovery),
      ["is-pass-security-question"] = bc(is.pass_name.security_question),
      ["is-pass-username"] = bc(is.pass_name.username),
    },
  },
  action_table = {
    {
      text = "✍️🔑 fllpss",
      dothis = dothis.pass_name.fill
    },{
      text = "📋🔑 cpypss",
      key = "copy-pass"
    },
  },
  potential_interfaces = ovtable.init({
    { key = "pass-passw", value = CreatePassPasswItem },
    { key = "pass-otp", value = CreatePassOtpItem },
    { key = "pass-recovery-keys", value = CreatePassRecoveryKeysItem },
    { key = "pass-security-question", value = CreatePassSecurityQuestionItem },
    { key = "pass-username", value = CreatePassUsernameItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassNameItem = bindArg(NewDynamicContentsComponentInterface, PassNameItemSpecifier)
