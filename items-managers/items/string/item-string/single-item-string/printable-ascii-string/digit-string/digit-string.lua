
--- @type ItemSpecifier
DigitStringItemSpecifier = {
  type = "digit-string",
  properties = {
    getables = {
      ["is-decimal-digit-string"] = 
      ["is-hexadecimal-digit-string"] = 
      ["is-octal-digit-string"] = 
      ["is-binary-digit-string"] = 
      ["get-german-to-canonical"] = function(self)
        local no_seps = eutf8.gsub(self:get("c"), "%.", "")
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
