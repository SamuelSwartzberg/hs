
ArrayOfArraysSpecifier = {
  type = "array-of-arrays",
  properties = {
    getables = {
      ["is-dict"] = function(self) self:get("all-pass", function(item) return item:get("is-pair") end) end,
      ["is-two-d-array-as-table"] = function(self) 
        local length = self:get("first"):get("length")
        return self:get("all-pass", function(item) return item:get("length") == length end)
      end,
    },
    doThisables = {
    },
  },
  potential_interfaces = ovtable.init({
    { key = "dict", value = CreateDict },
    { key = "two-d-array-as-table", value = CreateTwoDArrayAsTable },
  }),
  action_table = {}
  
  }

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfArrays = bindArg(NewDynamicContentsComponentInterface, ArrayOfArraysSpecifier)