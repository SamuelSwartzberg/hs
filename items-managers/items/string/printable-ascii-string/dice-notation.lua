--- @type ItemSpecifier
DiceNotationItemSpecifier = {
  type = "dicenotation",
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


