--- @type ItemSpecifier
DecimalDigitStringItemSpecifier = {
  type = "decimal-digit-string",
  properties = {
    getables = {
      ["decimal-numeric-value"] = function(self)
        return tonumber(self:get("contents"), 10)
      end,
      ["is-decimal-id"] = function(self)
        return not onig.find(self:get("contents"), "[^0-9]")
      end,
      ["decimal-to-number-interface"] = function(self)
        return CreateNumber(self:get("decimal-numeric-equivalent"))
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "decimal-id", value = CreateDecimalIdItem },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDecimalDigitStringItem = bindArg(NewDynamicContentsComponentInterface, DecimalDigitStringItemSpecifier)
