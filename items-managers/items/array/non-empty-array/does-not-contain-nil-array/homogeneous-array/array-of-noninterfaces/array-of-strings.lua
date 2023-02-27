--- @type ItemSpecifier
ArrayOfStringsSpecifier = {
  type = "array-of-strings",
  properties = {
    getables = {
      ["to-string-item-array"] = function (self)
        return self:get("map-to-new-array", function(item) 
          return CreateStringItem(item) 
        end)
      end,
      ["filter-empty-strings-to-new-array"] = function(self)
        return self:get("filter-to-new-array", function(item) return item ~= "" end)
      end,
      ["joined-string-contents"] = function(self, joiner)
        return table.concat(self:get("contents"), joiner)
      end,
      ["to-joined-string-item"] = function(self, joiner) return CreateStringItem(self:get("joined-string-contents", joiner)) end,
      ["joined-string-contents-with-no-blank-lines"] = function(self)
        return self:get("to-joined-string-item")
                   :get("to-string-array", "\n")
                   :get("filter-to-new-array", function(item) return item ~= "" end)
                   :get("joined-string-contents", "\n")
      end,
      ["to-joined-string-item-with-no-blank-lines"] = function(self)
        return CreateStringItem(self:get("joined-string-contents-with-no-blank-lines"))
      end,
      ["to-resplit-string-array-assume-sep"] = function(self, sep) -- the difference between this and to-resplit-string-array-assume-no-sep is that here we assume that the current array represents a string that was split by sep, and so we only need to split substrings that contain sep, and then flatten, while for to-resplit-string-array-assume-no-sep we assume that the divisions between the strings in the current array are arbitrary, and so we need to join the strings and then split by sep
        return CreateArray(listFlatten(self:get("map", function (str) return stringy.split(str, sep) end)))
      end,
      ["to-resplit-string-array-assume-sep-no-empty-strings"] = function(self, sep)
        return self:get("to-resplit-string-array-assume-sep", sep)
                   :get("filter-empty-strings-to-new-array")
      end,
      ["to-resplit-string-array-assume-no-sep"] = function(self, sep)
        return self:get("to-joined-string-item"):get("to-string-array", sep)
      end,
      ["map-to-matched-substring-array"] = function(self, regex)
        return self:get("map-to-new-array", function(item)
          return eutf8.match(item, regex)
        end)
      end,
      ["longest-common-prefix"] = function(self)
        return longestCommonPrefix(self:get("contents"))
      end,
      ["map-prepend-all"] = function(self, prefix)
        return self:get("map-to-new-array", function(item) return prefix .. item end)
      end,
    
    },
    doThisables = {
      ["choose-item-and-then-action"] = function(self)
        self:doThis("choose-item", function(item)
          CreateStringItem(item):doThis("choose-action")
        end)
      end,
      ["tab-fill-with"] = function(self)
        local str = le(
          stringx.join("\t", self:get("to-string-array"):get("contents"))
        )
        pasteMultilineString(str)
      end,
    },
  },
  action_table = {
    {
      text = "✍️ fll.",
      key = "tab-fill-with",
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