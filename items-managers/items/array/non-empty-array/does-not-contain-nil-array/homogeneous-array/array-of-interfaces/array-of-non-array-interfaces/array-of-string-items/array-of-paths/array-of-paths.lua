
ArrayOfPathsSpecifier = {
  type = "array-of-paths",
  properties = {
    getables = {
      ["is-array-of-absolute-paths"] = bindNthArg(isArrayOfInterfacesOfType, 2, "absolute-path"),
      ["is-array-of-path-leafs"] = bindNthArg(isArrayOfInterfacesOfType, 2, "path-leaf"),
      ["filter-to-array-of-path-leafs-with-tag-name"] = function(self, name)
        return self:get("filter-to-new-array", function(path)
          return path:get("has-tag-name", name)
        end)
      end,
      ["filter-to-array-of-path-leafs-with-tag-nv"] = function(self, nv)
        return self:get("filter-to-new-array", function(path)
          return valuesContain(path:get("tag-value", nv.name), nv.value)
        end)
      end,
      ["array-of-tag-names"] = function(self)
        return self:get("filter-nil-map-to-new-array", function(path)
          return path:get("tag-name-list")
        end):get("flatten-to-new-array"):get("filter-to-unique-array")
      end,
      ["array-of-tag-values-for-name"] = function(self, name)
        return self:get("filter-nil-map-to-new-array", function(path)
          return path:get("tag-value", name)
        end)
          :get("flatten-to-new-array")
          :get("filter-to-unique-array")
      end,

    
    },
    doThisables = {
      ["choose-tag-name-value"] = function(self, callback)
        self:get("array-of-tag-names"):doThis("choose-item", function(name)
          self:get("array-of-tag-values-for-name", name):doThis("choose-item", function(value)
            local matches_array = self:get("filter-to-array-of-path-leafs-with-tag-nv", {name = name, value = value})
            callback(matches_array, name, value)
          end)
        end)
      end,
      ["choose-tag-name-value-and-then-action"] = function(self)
        self:doThis("choose-tag-name-value", function(matches_array)
          matches_array:doThis("choose-action")
        end)
      end,
    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-absolute-paths", value = CreateArrayOfAbsolutePaths },
    { key = "array-of-path-leafs", value = CreateArrayOfPathLeafs },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfPaths = bindArg(NewDynamicContentsComponentInterface, ArrayOfPathsSpecifier)