--- @type ItemSpecifier
UnicodeCodepointItemSpecifier = {
  type = "unicode-codepoint",
  properties = {
    getables = {
      ["numeric-equivalent"] = function(self)
        return get.string_or_number.number_or_nil(self:get("c"):sub(3), 16)
      end,
      ["to-number-interface"] = function(self)
        return nr(self:get("numeric-equivalent"))
      end,
    }
  },
  
  action_table = {}

}

--- @type BoundNewDynamicContentsComponentInterface
CreateUnicodeCodepointItem = bindArg(NewDynamicContentsComponentInterface, UnicodeCodepointItemSpecifier)