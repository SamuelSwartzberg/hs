--- @type ItemSpecifier
PassSecurityQuestionItemSpecifier = {
  type = "pass-security-question",
  properties = {
    getables = {
      ["pass-security-question"] = function(self)
        return self:get("pass-value", "secq")
      end,
    }
  },
  action_table = getChooseItemTable({
    {
      d = "secq",
      i = "🎭❓",
      key = "pass-passw"
    },{
      d = "secqpth",
      i = "🎭❓📁",
      key = "pass-security-question-path"
    }
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassSecurityQuestionItem = bindArg(NewDynamicContentsComponentInterface, PassSecurityQuestionItemSpecifier)
