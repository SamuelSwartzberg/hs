--- @type ItemSpecifier
Base32ItemSpecifier = {
  type = "base32-item",
  properties = {
    getables = {
      
    }
  },
  
  action_table = listConcat({}, getChooseItemTable({
    {
      description = "b32dc",
      emoji_icon = "🅱️3️⃣2️⃣📖",
      key = "decode-base-32"
    }
  }))

}

--- @type BoundNewDynamicContentsComponentInterface
CreateBase32Item = bindArg(NewDynamicContentsComponentInterface, Base32ItemSpecifier)