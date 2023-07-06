

DictSpecifier = {
  type = "dict",
  properties = {
    getables = {
      ["to-string"] = bc(transf.dict.summary),
    },
    doThisables = {
      ["choose-item"] = function(self, callback)
        buildChooser(
          transf.dict.chooser_item_list(self:get("c")),
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
          transf.dict.key_chooser_item_list(self:get("c")),
          function(choice)
            callback(choice.v, choice.k)
          end,
          nil,
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,
      ["choose-value"] = function (self, callback)
        buildChooser(
          transf.dict.value_chooser_item_list(self:get("c")),
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
      d = "smm",
      i = emj.summary,
      getfn = transf.dict.summary
    },
    {
      d = "mlstr",
      i = emj.multiline_string,
      getfn = transf.dict.dict_entry_multiline_string
    },
  }
  
}
--- @type BoundRootInitializeInterface
dc = bindArg(RootInitializeInterface, DictSpecifier)
