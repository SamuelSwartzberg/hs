--- @type ItemSpecifier
Base64ItemSpecifier = {
  type = "base64",
  action_table = {
    {
      d = "b64dc",
      i = "🅱️6️⃣4️⃣📖",
      getfn = transf.base64.decoded_string
    }
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateBase64Item = bindArg(NewDynamicContentsComponentInterface, Base64ItemSpecifier)