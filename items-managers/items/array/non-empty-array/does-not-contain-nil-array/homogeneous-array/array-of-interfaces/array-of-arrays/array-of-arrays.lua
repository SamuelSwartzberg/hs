
ArrayOfArraysSpecifier = {
  type = "array-of-arrays",
  properties = {
    getables = {
      ["row-length"] = function(self) 
        return reduce(self:get("map", function(row) return row:get("length") end))
      end,
      ["field"] = function(self, coords) 
        local row =  self:get("nth-element", coords.row)
        if row then
          return row:get("nth-element", coords.column)
        else 
          return nil
        end
      end,
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
      
    },
    doThisables = {
    },
  },
  potential_interfaces = ovtable.init({
    { key = "dict", value = CreateDict },
  }),
  action_table = {}
  
  }

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfArrays = bindArg(NewDynamicContentsComponentInterface, ArrayOfArraysSpecifier)