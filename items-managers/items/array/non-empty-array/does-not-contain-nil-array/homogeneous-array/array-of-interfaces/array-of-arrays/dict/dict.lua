
DictSpecifier = {
  type = "dict",
  properties = {
    getables = {
      ["all-keys"] = function(self) return self:get("column", 1) end,
      ["all-keys-to-new-array"] = function(self) return self:get("column-to-new-array", 1) end,
      ["all-values"] = function(self) return self:get("column", 2) end,
      ["all-values-to-new-array"] = function(self) return self:get("column-to-new-array", 2) end,
      ["value-for-string-item-key"] = function(self, key) 
        return self:get(
          "row-for-row-header-to-new-array", 
          function (row_header) 
            return row_header:get("contents") == key:get("contents")
          end
        ):get("pair-value", 2)
      end,
    },
    doThisables = {
      ["choose-item-and-paste-value"] = function(self)
        self:doThis("choose-item", function(line)
          line:doThis("paste-result-of-get", {key = "pair-value"})
        end)
      end,
    },
  },
  action_table = {},
  
}

--- @type BoundNewDynamicContentsComponentInterface
--- @type BoundNewDynamicContentsComponentInterface
CreateDict = bindArg(NewDynamicContentsComponentInterface, DictSpecifier)