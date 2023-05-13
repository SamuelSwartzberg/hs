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
      description = "secq",
      emoji_icon = "🎭❓",
      key = "pass-passw"
    },{
      description = "secqpth",
      emoji_icon = "🎭❓📁",
      key = "pass-security-question-path"
    }
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassSecurityQuestionItem = bindArg(NewDynamicContentsComponentInterface, PassSecurityQuestionItemSpecifier)
