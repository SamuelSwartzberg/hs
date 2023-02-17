--- @type ItemSpecifier
DiceNotationItemSpecifier = {
  type = "dicenotation-item",
  properties = {
    getables = {
      ["roll-result"] = function(self)
        local res = getOutputTask({
          "roll",
          {
            value = self:get("contents"),
            type = "quoted"
          }
        })
        return res
      end,
    },
  },
  action_table = listConcat(
    getChooseItemTable({
      emoji_icon = "🎲",
      description = "rll",
      key = "roll-result"
    }), {}
  ),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDiceNotationItem = bindArg(NewDynamicContentsComponentInterface, DiceNotationItemSpecifier)


