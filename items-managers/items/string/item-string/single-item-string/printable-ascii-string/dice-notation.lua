--- @type ItemSpecifier
DiceNotationItemSpecifier = {
  type = "dicenotation",
  properties = {
    getables = {
      ["roll-result"] = function(self)
        local res = run({
          "roll",
          {
            value = self:get("c"),
            type = "quoted"
          }
        })
        return res
      end,
    },
  },
  action_table = concat(
    getChooseItemTable({
      i = "🎲",
      d = "rll",
      key = "roll-result"
    }), {}
  ),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDiceNotationItem = bindArg(NewDynamicContentsComponentInterface, DiceNotationItemSpecifier)


