--- @type ItemSpecifier
PassSecurityQuestionItemSpecifier = {
  type = "pass-security-question",
  action_table = {
    {
      d = "secq",
      i = "🎭❓",
      getfn = transf.pass_name.security_question
    },{
      d = "secqpth",
      i = "🎭❓📁",
      key = "pass-security-question-path"
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassSecurityQuestionItem = bindArg(NewDynamicContentsComponentInterface, PassSecurityQuestionItemSpecifier)
