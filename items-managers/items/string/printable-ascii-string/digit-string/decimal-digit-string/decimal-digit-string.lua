--- @type ItemSpecifier
DecimalDigitStringItemSpecifier = {
  type = "decimal-digit-string",
  properties = {
    getables = {
      ["decimal-numeric-value"] = function(self)
        return get.string_or_number.number(self:get("c"), 10)
      end,
      ["is-decimal-id"] = function(self)
        return not onig.find(self:get("c"), "[^0-9]")
      end,
      ["decimal-to-number-interface"] = function(self)
        return nr(self:get("decimal-numeric-equivalent"))
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "decimal-id", value = CreateDecimalIdItem },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDecimalDigitStringItem = bindArg(NewDynamicContentsComponentInterface, DecimalDigitStringItemSpecifier)