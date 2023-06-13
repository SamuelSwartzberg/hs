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
  action_table = {
    {
      i = "🎲",
      d = "rll",
      getfn = transf.dice_notation.result,
      filter = nr
    }
  }
  ,
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDiceNotationItem = bindArg(NewDynamicContentsComponentInterface, DiceNotationItemSpecifier)


