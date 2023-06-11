ArrayOfShrinkSpecifierTablesSpecifier = {
  type = "array-of-shrink-specifier-tables",
  properties = {
    getables = {
      ["best-version"] = function(self)
        return reduce(self:get("map", function(shrink_specifier_table)
          return shrink_specifier_table:get("score")
        end), returnSmaller)
      end,
    },
    doThisables = {
      ["create-shrunken-versions"] = function(self, path)
        self:doThis("do-all", {key = "shrink", args = path})
      end,
      ["delete-non-best-versions"] = function(self, path)
        local bestver = self:get("best-version")
        self:get("filter-to-new-array", function(shrink_specifier_table)
          return shrink_specifier_table ~= bestver
        end):get("map-to-new-array", function(shrink_specifier_table)
          return st(shrink_specifier_table:get("value", "result"))
        end):doThis("do-all", {key = "rm-file"})
      end,
    },
  },
  action_table = {}
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfShrinkSpecifierTables = bindArg(NewDynamicContentsComponentInterface, ArrayOfShrinkSpecifierTablesSpecifier)



