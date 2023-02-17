--- @type ItemSpecifier
HexadecimalDigitStringItemSpecifier = {
  type = "hexadecimal-digit-string-item",
  properties = {
    getables = {
      ["hexadecimal-numeric-value"] = function(self)
        return tonumber(self:get("contents"), 16)
      end,
      ["hexadecimal-to-number-interface"] = function(self)
        return CreateNumber(self:get("hexadecimal-numeric-equivalent"))
      end,
      ["hexadecimal-to-corresponding-string"] = function(self)
        return basexx.from_hex(self:get("contents"))
      end,
    }
  },
  
  action_table = listConcat({}, getChooseItemTable({
    {
      description = "hexdc",
      emoji_icon = "1️⃣6️⃣📖",
      key = "hexadecimal-to-corresponding-string"
    }
  }))
}

--- @type BoundNewDynamicContentsComponentInterface
CreateHexadecimalDigitStringItem = bindArg(NewDynamicContentsComponentInterface, HexadecimalDigitStringItemSpecifier)
