--- @type ItemSpecifier
OctalDigitStringItemSpecifier = {
  type = "octal-digit-string-item",
  properties = {
    getables = {
      ["octal-numeric-value"] = function(self)
        return tonumber(self:get("contents"), 8)
      end,
      ["octal-to-number-interface"] = function(self)
        return CreateNumber(self:get("octal-numeric-equivalent"))
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateOctalDigitStringItem = bindArg(NewDynamicContentsComponentInterface, OctalDigitStringItemSpecifier)
