--- @type ItemSpecifier
HexadecimalDigitStringItemSpecifier = {
  type = "hexadecimal-digit-string",
  properties = {
    getables = {
      ["hexadecimal-numeric-value"] = function(self)
        return get.string_or_number.number(self:get("c"), 16)
      end,
      ["hexadecimal-to-number-interface"] = function(self)
        return nr(self:get("hexadecimal-numeric-equivalent"))
      end,
      ["hexadecimal-to-corresponding-string"] = function(self)
        return basexx.from_hex(self:get("c"))
      end,
    }
  },
  
  action_table = {
    {
      d = "hexdc",
      i = "1️⃣6️⃣📖",
      key = "hexadecimal-to-corresponding-string"
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateHexadecimalDigitStringItem = bindArg(NewDynamicContentsComponentInterface, HexadecimalDigitStringItemSpecifier)
