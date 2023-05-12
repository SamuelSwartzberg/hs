
--- @type ItemSpecifier
DigitStringItemSpecifier = {
  type = "digit-string-item",
  properties = {
    getables = {
      ["is-decimal-digit-string"] = function (self)
        return not eutf8.find(self:get("contents"), "[^%d%.%,%-]")
      end,
      ["is-hexadecimal-digit-string"] = function (self)
        return not eutf8.find(self:get("contents"), "[^%x%.%,%-]")
      end,
      ["is-octal-digit-string"] = function (self)
        return not eutf8.find(self:get("contents"), "[^%o%.%,%-]")
      end,
      ["is-binary-digit-string"] = function (self)
        return not eutf8.find(self:get("contents"), "[^01%.%,%-]")
      end,
      ["get-german-to-canonical"] = function(self)
        local no_seps = eutf8.gsub(self:get("contents"), "%.", "")
        local english_decimal_separator = eutf8.gsub(no_seps, ",", ".")
        return english_decimal_separator
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "decimal-digit-string", value = CreateDecimalDigitStringItem },
    { key = "hexadecimal-digit-string", value = CreateHexadecimalDigitStringItem },
    { key = "octal-digit-string", value = CreateOctalDigitStringItem },
    { key = "binary-digit-string", value = CreateBinaryDigitStringItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDigitStringItem = bindArg(NewDynamicContentsComponentInterface, DigitStringItemSpecifier)
