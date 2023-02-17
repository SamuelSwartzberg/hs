
TwoDArrayAsTableSpecifier = {
  type = "table",
  properties = {
    getables = {
      ["row-length"] = function(self) return self:get("first"):get("length") end,
      ["field"] = function(self, coords) return self:get("nth-element", coords.row):get("nth-element", coords.column) end,
      ["column"] = function(self, n) return self:get("map", function(row) return row:get("nth-element", n) end) end,
      ["column-to-new-array"] = function(self, n) return CreateArray(self:get("column", n)) end,
      ["columns"] = function(self) 
        local row_length = self:get("row-length")
        local columns = {}
        for i = 1, row_length do
          table.insert(columns, self:get("column", i))
        end
        return columns
      end,
      ["columns-to-new-array"] = function(self) return CreateArray(self:get("columns")) end,
      ["column-range"] = function(self, specifier) return self:get("columns-to-new-array"):get("range", specifier) end,
      ["column-range-to-new-array"] = function(self, specifier) return CreateArray(self:get("column-range", specifier)) end,
      ["row-for-row-header"] = function (self, header_test) 
        return self:get("find", function(row) 
          return header_test(row:get("first"))
        end)
      end,
      ["column-for-column-header"] = function (self, header_test) 
        return self:get("columns-to-new-array"):get("find", function(column) 
          return header_test(column:get("first"))
        end)
      end,
      ["row-for-row-header-to-new-array"] = function (self, header_test) 
        return CreateArray(self:get("row-for-row-header", header_test))
      end,
      ["column-for-column-header-to-new-array"] = function (self, header_test) 
        return CreateArray(self:get("column-for-column-header", header_test))
      end
      
    },
    doThisables = {
    },
  },
  action_table = {}
  
  }

--- @type BoundNewDynamicContentsComponentInterface
CreateTwoDArrayAsTable = bindArg(NewDynamicContentsComponentInterface, TwoDArrayAsTableSpecifier)