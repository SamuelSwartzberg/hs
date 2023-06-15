

TableSpecifier = {
  type = "table",
  properties = {
    getables = {
    },
    doThisables = {
    },
  },

  action_table = {}
  
}

--- @type BoundRootInitializeInterface
dc = bindArg(RootInitializeInterface, TableSpecifier)

NonEmptyTableSpecifier = {
  type = "non-empty-table",
  properties = {
    getables = {
      ["to-string"] = bc(transf.stringable_value_dict.dict_entry_string_summary),
    },
    doThisables = {
      ["choose-item"] = function(self, callback)
        buildChooser(
          transf.stringable_value_dict.chooser_item_list(self:get("c")),
          function(choice)
            callback(choice.v)
          end,
          nil,
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,
      ["choose-key-act-on-value"] = function(self, callback)
        buildChooser(
          transf.stringable_value_dict.chooser_item_list(self:get("c")),
          function(choice)
            callback(self:get("c")[choice.value])
          end,
          nil,
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,
      ["choose-value-act-on-key"] = function (self, callback)
        buildChooser(
          transf.stringable_value_dict.chooser_item_list(self:get("c")),
          function(choice)
            callback(self:get("key", choice.value))
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
--- @type BoundNewDynamicContentsComponentInterface
CreateNonEmptyTable = bindArg(NewDynamicContentsComponentInterface, NonEmptyTableSpecifier)