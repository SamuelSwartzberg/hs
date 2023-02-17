ArrayOfNoninterfacesSpecifier = {
  type = "array-of-noninterfaces",
  properties = {
    getables = {
      ["is-array-of-strings"] = function (self)
        return self:get("all-pass", function(item) return type(item) == "string" end)
      end,
      ["map-elems-to-string"] = function(self)
        return self:get("map", function(item) return tostring(item) end)
      end,
      ["chooser-list-of-noninterfaces"] = function(self) 
        return self:get("map", function(item) 
          local formatted_item = self:get("format-noninterface-item-for-chooser", item) or item
          local text = tostring(item)
          if formatted_item and type(formatted_item) == "string" then
            text = formatted_item
          end
          return {
            text = surroundByStartEndMarkers(text),
            value = item
          }
        end) 
      end,
      ["sorted-to-new-array-default"] = function(self) return self:get("sorted-to-new-array") end,
      ["chooser-list-of-all"] = function(self) return self:get("chooser-list-of-noninterfaces") end,
      ["min"] = function(self)
        return listMin(self:get("contents"))
      end,
      ["max"] = function(self)
        return listMax(self:get("contents"))
      end,
    },
    doThisables = {
      ["choose-noninterface-item"] = function(self, callback_after)
        buildChooser(
          self:get("chooser-list-of-noninterfaces"),
          function(chosen_item)
            local item = chosen_item.value
            callback_after(item)
          end,
          nil,
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,
      ["choose-item"] = function(self, callback_after)
        self:doThis("choose-noninterface-item", callback_after)
      end,
    },
  },
  potential_interfaces = ovtable.init({
    { key = "array-of-strings", value = CreateArrayOfStrings },

  }),
  action_table = {}
}


--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfNoninterfaces = bindArg(NewDynamicContentsComponentInterface, ArrayOfNoninterfacesSpecifier)

