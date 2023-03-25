ArrayOfInterfacesSpecifier = {
  type = "array-of-interfaces",
  properties = {
    getables = {
      ["all-queriable-properties"] = function(self) 
        return self:get("first"):get("all-queriable-properties")
      end,
      ["all-queriable-properties-to-string-array"] = function(self)
        return CreateArray(self:get("all-queriable-properties"))
      end,
      ["all-possible-values"] = function(self, key)
        return toSet(self:get("map", function(item) return item:get(key) end))
      end,
      ["all-possible-values-to-string-array"] = function(self, key)
        return CreateArray(self:get("all-possible-values", key))
      end,
      ["item-by-id"] = function (self, id)
        return self:get("find", function(item) return item:get("id") == id end)
      end,
      ["chooser-list-of-all-queriable-properties"] = function(self)
        local chooser_list = {}
        local all_queriable_properties = self:get("all-querable-properties")
        for action, keys in prs(all_queriable_properties) do
          for key, _ in prs(keys) do
            chooser_list[#chooser_list + 1] = {
              text = string.format("%s: %s", action, key),
              ["action"] = action,
              key = key
            }
          end
        end
        return chooser_list
      end,
      ["types-of-homogeneous-array-elements"] = function(self) 
        return self:get("first"):get("types-of-all-valid-interfaces")
      end,
      ["map-elems-to-string"] = function(self)
        return self:get("map", function(item) return item:get("to-string") end)
      end,
      ["sorted-to-string-to-new-array"] = function(self)
        return self:get("sorted-to-new-array", function(elem1, elem2)
          return elem1:get("to-string") < elem2:get("to-string")
        end)
      end,
      ["sorted-to-new-array-default"] = function(self) return self:get("sorted-to-string-to-new-array") end,
      ["is-array-of-arrays"] = bind(isArrayOfInterfacesOfType, { ["2"] = "array" }),
      ["is-array-of-non-array-interfaces"] = function(self)
        return not self:get("is-array-of-arrays")
      end,
      ["is-managed-array"] = function(self) return not not self.properties.doThisables.create end,
      ["chooser-list-of-interfaces"] = function(self)
        return self:get("map", function(item) 
          return item:get("chooser-list-entry") 
        end) 
      end,
      ["chooser-list-of-all"] = function(self) return self:get("chooser-list-of-interfaces") end,
      ["filter-to-array-of-type"] = function(self, type)
        return self:get("filter-to-new-array", function(item)
          return item:get("is-" .. type)
        end)
      end,
      ["min-contents"] = function(self)
        return reduce(self:get("map", function(item) return item:get("contents") end), returnSmaller)
      end,
      ["min-contents-item"] = function(self)
        local target
        for i, item in iprs(self:get("contents")) do
          if not target or item:get("contents") < target:get("contents") then
            target = item
          end
        end
        return target
      end,
      ["max-contents"] = function(self)
        return reduce(self:get("map", function(item) return item:get("contents") end))
      end,
      ["max-contents-item"] = function(self)
        local target
        for i, item in iprs(self:get("contents")) do
          if not target or item:get("contents") > target:get("contents") then
            target = item
          end
        end
        return target
      end,
      ["median-contents"] = function (self)
        return listMedian(self:get("map", function(item) return item:get("contents") end))
      end,
      ["find-contents"] = function(self, contents)
        return self:get("find", function(item)
          return item:get("contents") == contents
        end)
      end,
      ["map-to-table-of-contents"] = function(self)
        return self:get("map", function(item) return item:get("contents") end)
      end,

    },
    doThisables = {
      ["choose-key-and-value"] = function(self, do_after)
        self:get("all-queriable-properties-to-string-array"):doThis("choose-item", function(key)
          self:get("all-possible-values-to-string-array"):doThis("choose-item", function(value)
            do_after(self, key, value)
          end)
        end)
      end,
      ["choose-action-for-all"] = function(self)
        self:get("first"):doThis("choose-action-callback", function(chosen_item)
          self:doThis("for-all", function(item)
            item:doThis("use-action", chosen_item)
          end)
        end)
      end,
      ["set-all"] = function(self, do_specifier)
        for i, item in iprs(self:get("contents")) do
          item:set(item, do_specifier.key, do_specifier.value)
        end
      end,
      ["do-all"] = function(self, do_specifier)
        for i, item in iprs(self:get("contents")) do
          item:doThis(do_specifier.key, do_specifier.args)
        end
      end,
      ["choose-interface-item"] = function(self, callback_after)
        buildChooser(
          self:get("chooser-list-of-interfaces"),
          function(chosen_item)
            local item = self:get("item-by-id", chosen_item.id)
            callback_after(item)
          end,
          nil,
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,
      ["choose-item"] = function(self, callback_after)
        buildChooser(
          self:get("chooser-list-of-all"),
          function(chosen_item)
            local item = self:get("item-by-id", chosen_item.id)
            callback_after(item)
          end,
          nil,
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,
      ["choose-item-and-do"] = function(self, key)
        self:doThis("choose-item", function(item)
          item:doThis(key)
        end)
      end,
      ["choose-item-and-then-action"] = function(self)
        self:doThis("choose-item", function(item) item:doThis("choose-action") end)
      end,
    },
  },
  potential_interfaces = ovtable.init({
    { key = "array-of-arrays", value = CreateArrayOfArrays },
    { key = "array-of-non-array-interfaces", value = CreateArrayOfNonArrayInterfaces },
    { key = "managed-array", value = CreateManagedArray },
  }),
  action_table = {
    {
      text = "👉⏪ cfst",
      key = "choose-action-on-result-of-get",
      args = { key = "first" },
    },
    {
      text = "👉⏩ clst",
      key = "choose-action-on-result-of-get",
      args = { key = "last" },
    }
  
  }
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfInterfaces = bindArg(NewDynamicContentsComponentInterface, ArrayOfInterfacesSpecifier)
