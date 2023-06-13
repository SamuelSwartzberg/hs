--- @type ItemSpecifier
ArrayOfStringsSpecifier = {
  type = "array-of-strings",
  properties = {
    doThisables = {
      ["choose-item-and-then-action"] = function(self)
        self:doThis("choose-item", function(item)
          st(item):doThis("choose-action")
        end)
      end,
    },
  },
  action_table = {
    {
      text = "✍️ fll.",
      dothis = dothis.string_array.fill_with
    },
    {
      text = "👉⏪ cfst.",
      key = "choose-action-on-str-item-result-of-get",
      args = { key = "first" },
    },
    {
      text = "👉⏩ clst.",
      key = "choose-action-on-str-item-result-of-get",
      args = { key = "last" },
    },
    {
      text = "👉➕＿ cmpprfx.",
      key = "choose-action-on-result-of-get",
      args = { key = "map-prepend-all" }
    },
    {
      text = "👉全➕＿ ccmnprfx.",
      key = "choose-action-on-str-item-result-of-get",
      args = { key = "longest-common-prefix" }
    },{
      text = "👉🤝 cjnd.",
      key = "do-interactive",
      args = { thing = "joiner", key = "choose-action-on-str-item-result-of-get", args = { key = "to-joined-string-item"} }
    },{
      text = "👉🤝⩶ cjndln.",
      key = "choose-action-on-result-of-get", 
      args = { key = "to-joined-string-item", args = "\n"}
    },{
      text = "👉🥅🫗 cfltempt.",
      key = "choose-action-on-result-of-get",
      args = { key = "filter-empty-strings-to-new-array"}
    },{
      text = "👉⌨️💎 cstritmarr.",
      key = "choose-action-on-result-of-get",
      args = { key = "to-string-item-array"}
    }
    
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfStrings = bindArg(NewDynamicContentsComponentInterface, ArrayOfStringsSpecifier)