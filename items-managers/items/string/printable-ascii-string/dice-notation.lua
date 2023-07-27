--- @type ItemSpecifier
DiceNotationItemSpecifier = {
  type = "dicenotation",
  action_table = {
    {
      i = "🎲",
      d = "rll",
      getfn = transf.dice_notation.nonindicated_decimal_number_string_result,
    }
  }
  ,
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDiceNotationItem = bindArg(NewDynamicContentsComponentInterface, DiceNotationItemSpecifier)


