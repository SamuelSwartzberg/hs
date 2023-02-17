--- @type ItemSpecifier
PathLeafDateRangeSpecifier = {
  type = "path-leaf-date-range",
  properties = {
    getables = {
      ["start-and-end-of-date-range"] = function(self)
        return stringy.split(self:get("path-leaf-date"), "_to_")
      end,
      ["start-of-date-range"] = function(self)
        return self:get("start-and-end-of-date-range")[1]
      end,
      ["end-of-date-range"] = function(self)
        return self:get("start-and-end-of-date-range")[2]
      end,
      ["largest-date"] = function(self)
        return self:get("end-of-date-range")
      end,
      ["smallest-date"] = function(self)
        return self:get("start-of-date-range")
      end,
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathLeafDateRange = bindArg(NewDynamicContentsComponentInterface, PathLeafDateRangeSpecifier)
