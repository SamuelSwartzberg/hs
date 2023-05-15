--- @type ItemSpecifier
PotentiallyParseableDateItemSpecifier = {
  type = "potentially-parseable-date",
  properties = {
    getables = {
      ["to-timestamp"] = function(self)
        return parseDate(self:get("contents"))
      end,
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePotentiallyParseableDateItem = bindArg(NewDynamicContentsComponentInterface, PotentiallyParseableDateItemSpecifier)