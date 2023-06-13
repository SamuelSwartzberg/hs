--- @type ItemSpecifier
OctalDigitStringItemSpecifier = {
  type = "octal-digit-string",
  properties = {
    getables = {
      ["octal-numeric-value"] = function(self)
        return tonumber(self:get("c"), 8)
      end,
      ["octal-to-number-interface"] = function(self)
        return nr(self:get("octal-numeric-equivalent"))
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateOctalDigitStringItem = bindArg(NewDynamicContentsComponentInterface, OctalDigitStringItemSpecifier)
