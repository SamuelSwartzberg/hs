--- @type ItemSpecifier
Base32ItemSpecifier = {
  type = "base32",
  
  action_table = {
    {
      d = "b32dc",
      i = "🅱️3️⃣2️⃣📖",
      getfn = transf.base32.decoded_string
    }
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateBase32Item = bindArg(NewDynamicContentsComponentInterface, Base32ItemSpecifier)