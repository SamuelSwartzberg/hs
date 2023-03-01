
ArrayOfPathLeafDatesSpecifier = {
  type = "array-of-path-leafs",
  properties = {
    getables = {
      ["whateverest-path-leaf-date-thing"] = function(self, specifier)
        return reduce(self:get("map", function(path_leaf)
          return path_leaf:get(specifier.whateverest .. "-" .. specifier.thing)
        end))
      end,
      ["whateverest-path-leaf-date"] = function(self, whateverest)
        return self:get("whateverest-path-leaf-date-thing", {whateverest = whateverest, thing = "date"})
      end,
      ["whateverest-path-leaf-date-to-date"] = function(self, whateverest)
        return self:get("whateverest-path-leaf-date-thing", {whateverest = whateverest, thing = "to-date"})
      end,
      ["whateverest-path-leaf-date-to-date-obj"] = function(self, whateverest)
        return self:get("whateverest-path-leaf-date-thing", {whateverest = whateverest, thing = "to-date-obj"})
      end,
      ["largest-and-smallest-thing"] = function(self, thing)
        return {
          self:get("whateverest-path-leaf-date-thing", {whateverest = "largest", thing = thing}),
          self:get("whateverest-path-leaf-date-thing", {whateverest = "smallest", thing = thing})
        }
      end,
      
      
    },
    doThisables = {
    },
  },
  action_table = {},
  
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfPathLeafDates = bindArg(NewDynamicContentsComponentInterface, ArrayOfPathLeafDatesSpecifier)