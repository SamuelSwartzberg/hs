--- @type ItemSpecifier
PathLeafSingleDateSpecifier = {
  type = "path-leaf-single-date",
  properties = {
    getables = {
      ["largest-date"] = function(self)
        return self:get("path-leaf-date")
      end,
      ["smallest-date"] = function(self)
        return self:get("path-leaf-date")
      end,
      ["to-date"] = function(self)
        return st(self:get("path-leaf-date"))
      end,
      ["to-date-obj"] = function(self)
        return date(self:get("path-leaf-date"))
      end,
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathLeafSingleDate = bindArg(NewDynamicContentsComponentInterface, PathLeafSingleDateSpecifier)
