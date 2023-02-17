--- @type ItemSpecifier
Base64ItemSpecifier = {
  type = "base64-item",
  properties = {
    getables = {
      
    }
  },
  
  action_table = listConcat({}, getChooseItemTable({
    {
      description = "b64dc",
      emoji_icon = "🅱️6️⃣4️⃣📖",
      key = "decode-base-64"
    }
  }))

}

--- @type BoundNewDynamicContentsComponentInterface
CreateBase64Item = bindArg(NewDynamicContentsComponentInterface, Base64ItemSpecifier)