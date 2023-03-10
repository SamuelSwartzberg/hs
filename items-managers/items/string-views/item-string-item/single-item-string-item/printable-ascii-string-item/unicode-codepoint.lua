--- @type ItemSpecifier
UnicodeCodepointItemSpecifier = {
  type = "unicode-codepoint-item",
  properties = {
    getables = {
      ["numeric-equivalent"] = function(self)
        return tonumber(self:get("contents"):sub(3), 16)
      end,
      ["to-number-interface"] = function(self)
        return CreateNumber(self:get("numeric-equivalent"))
      end,
    }
  },
  
  action_table = {}

}

--- @type BoundNewDynamicContentsComponentInterface
CreateUnicodeCodepointItem = bindArg(NewDynamicContentsComponentInterface, UnicodeCodepointItemSpecifier)