ArrayOfDatesSpecifier = {
  type = "array-of-dates",
  properties = {
    getables = {
      ["max-diff"] = function(self)
        return CreateDate(
          date.diff(
            self:get("max-content"),
            self:get("min-content")
          )
        )
      end,
      ["span"] = function(self, unit)
        return self:get("max-diff"):get("span", unit)
      end,
      ["range"] = function(self, specifier)
        return dateRange(
          self:get("min-content"),
          self:get("max-content"),
          specifier.step,
          specifier.unit
        )
      end,
      ["item-range"] = function(self, specifier)
        return mapValueNewValue(
          self:get("range", specifier),
          function(dt)
            return CreateDate(dt)
          end
        )
      end,
      ["map-to-event-items"] = function(self, specifier)
        specifier = specifier or {}
        specifier.start = self:get("min-content-item"):get("to-precision", "min")
        specifier["end"] = self:get("max-content-item"):get("to-precision", "min")
        return CreateShellCommand("khal"):get("list-events-items", specifier)
      end,

    },
    doThisables = {
      ["create-event-for-range"] = function(self)
        CreateShellCommand("khal"):doThis("add-event-interactive", {
          specifier = {
            start = self:get("min-contents-item"):get("to-precision", "min"),
            ["end"] = self:get("max-contents-item"):get("to-precision", "min"),
          }
        })
      end,
    },
  },
  action_table = {}
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfDates = bindArg(NewDynamicContentsComponentInterface, ArrayOfDatesSpecifier)



