--- @type ItemSpecifier
Base64ItemSpecifier = {
  type = "base64",
  properties = {
    getables = {
      
    }
  },
  
  action_table = concat({}, getChooseItemTable({
    {
      d = "b64dc",
      i = "🅱️6️⃣4️⃣📖",
      key = "decode-base-64"
    }
  }))

}

--- @type BoundNewDynamicContentsComponentInterface
CreateBase64Item = bindArg(NewDynamicContentsComponentInterface, Base64ItemSpecifier)