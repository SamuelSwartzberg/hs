ArrayOfNoninterfacesSpecifier = {
  type = "array-of-noninterfaces",
  properties = {
    getables = {
      ["chooser-list-of-noninterfaces"] = function(self) 
        return self:get("map", function(item) 
          local formatted_item = self:get("format-noninterface-item-for-chooser", item) or item
          local text = tostring(item)
          if formatted_item and type(formatted_item) == "string" then
            text = formatted_item
          end
          return {
            text = transf.string.with_styled_start_end_markers(text),
            value = item
          }
        end) 
      end,
      ["chooser-list-of-all"] = function(self) return self:get("chooser-list-of-noninterfaces") end,
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
  ({
    { key = "array-of-strings", value = CreateArrayOfStrings },

  }),
  action_table = {}
}


--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfNoninterfaces = bindArg(NewDynamicContentsComponentInterface, ArrayOfNoninterfacesSpecifier)

