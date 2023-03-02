--- @type ItemSpecifier
BinaryDigitStringItemSpecifier = {
  type = "binary-digit-string-item",
  properties = {
    getables = {
      ["binary-numeric-value"] = function(self)
        return tonumber(self:get("contents"), 2)
      end,
      ["binary-to-number-interface"] = function(self)
        return CreateNumber(self:get("binary-numeric-equivalent"))
      end,
      ["binary-to-corresponding-string"] = function(self)
        return basexx.from_bit(self:get("contents"))
      end,

    },
  },
  
  action_table = concat({}, getChooseItemTable({
    {
      description = "bindc",
      emoji_icon = "2️⃣📖",
      key = "binary-to-corresponding-string"
    }
  }))
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBinaryDigitStringItem = bindArg(NewDynamicContentsComponentInterface, BinaryDigitStringItemSpecifier)
