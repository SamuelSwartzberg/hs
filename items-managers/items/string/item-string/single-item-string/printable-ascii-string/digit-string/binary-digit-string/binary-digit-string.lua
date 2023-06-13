--- @type ItemSpecifier
BinaryDigitStringItemSpecifier = {
  type = "binary-digit-string",
  properties = {
    getables = {
      ["binary-numeric-value"] = function(self)
        return tonumber(self:get("c"), 2)
      end,
      ["binary-to-number-interface"] = function(self)
        return nr(self:get("binary-numeric-equivalent"))
      end,
      ["binary-to-corresponding-string"] = function(self)
        return basexx.from_bit(self:get("c"))
      end,

    },
  },
  
  action_table = concat({}, getChooseItemTable({
    {
      d = "bindc",
      i = "2️⃣📖",
      key = "binary-to-corresponding-string"
    }
  }))
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBinaryDigitStringItem = bindArg(NewDynamicContentsComponentInterface, BinaryDigitStringItemSpecifier)
