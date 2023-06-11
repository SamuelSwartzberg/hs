NonHomogeneousArraySpecifier = {
  type = "non-homogeneous-array",
  properties = {
    getables = {
      ["to-map-of-homogeneous-arrays"] = function(self)
        local homogeneous_array_map = {}
        for _, item in ipairs(self:get("c")) do
          for _, type in ipairs(allTypesOfPrimitiveOrInterface(item)) do
            if homogeneous_array_map[type] == nil then homogeneous_array_map[type] = {} end
            homogeneous_array_map[type][#homogeneous_array_map[type]+1] = item
          end
        end
        return homogeneous_array_map
      end,
      ["to-list-of-homogeneous-arrays"] = function(self)
        return values(self:get("to-map-of-homogeneous-arrays"))
      end,
      ["to-homogeneous-array-of-type"] = function(self, type)
        return self:get("to-map-of-homogeneous-arrays")[type]
      end,
      ["chooser-list-of-all"] = function(self) 
        return self:get("map", function(item) 
          if item.get and item:get("type") then
            return item:get("chooser-list-entry") 
          else
            return {text = tostring(item), value = item}
          end
        end) 
      end,
    },
    doThisables = {
      ["continue-with-chosen-homogeneous-array"] = function(self, callback)
        CreateArray(keys(self:get("to-map-of-homogeneous-arrays"))):doThis("choose-item", function(chosen_item)
          local homogeneous_array = CreateArray(self:get("to-homogeneous-array-of-type", chosen_item.text))
          callback(homogeneous_array)
        end)
      end,
      ["choose-item"] = function(self, callback_after)
        buildChooser(
          self:get("chooser-list-of-all"),
          function(chosen_item)
            local item
            if (chosen_item.id) then
              item = self:get("item-by-id", chosen_item.id)
            else 
              item = chosen_item.value
            end
            callback_after(item)
          end,
          nil,
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,

    },
  },
  
  action_table = {}

}

--- @type BoundNewDynamicContentsComponentInterface
CreateNonHomogeneousArray = bindArg(NewDynamicContentsComponentInterface, NonHomogeneousArraySpecifier)
