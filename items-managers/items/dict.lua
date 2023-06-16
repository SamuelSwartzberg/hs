

DictSpecifier = {
  type = "dict",
  properties = {
    getables = {
      ["to-string"] = bc(transf.stringable_value_dict.dict_entry_string_summary),
    },
    doThisables = {
      ["choose-item"] = function(self, callback)
        buildChooser(
          transf.stringable_value_dict.chooser_item_list(self:get("c")),
          function(choice)
            callback(choice.v, choice.k)
          end,
          nil,
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,
      ["choose-item-and-then-action"] = function(self)
        self:doThis("choose-item", function(v, k)
          v:doThis("choose-action")
        end)
      end,
      ["choose-key"] = function(self, callback)
        buildChooser(
          transf.stringable_value_dict.key_chooser_item_list(self:get("c")),
          function(choice)
            callback(choice.v, choice.k)
          end,
          nil,
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,
      ["choose-value"] = function (self, callback)
        buildChooser(
          transf.stringable_value_dict.value_chooser_item_list(self:get("c")),
          function(choice)
            callback(choice.v, choice.k)
          end,
          nil,
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,
    },
  },
  action_table = {
    {
      text = "👉 c.",
      key = "choose-item-and-then-action"
    },
    {
      d = "tstr",
      i = "💻🔡",
      key = "to-string",
    },
    {
      d = "tstrml",
      i = "💻🔡📜",
      key = "to-string-multiline",
    },
  }
  
}
--- @type BoundRootInitializeInterface
dc = bindArg(RootInitializeInterface, DictSpecifier)
