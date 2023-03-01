
ArrayOfStringItemsSpecifier = {
  type = "array-of-string-items",
  properties = {
    getables = {
      ["to-string-array"] = function(self) return self:get("map-to-new-array", function(item) return item:get("contents") end) end,
      ["filter-empty-strings-to-new-array"] = function(self)
        return self:get("filter-to-new-array", function(item) return item:get("contents") ~= "" end)
      end,
      ["joined-string-contents"] = function(self, joiner) return self:get("to-string-array"):get("joined-string-contents", joiner) end,
      ["to-joined-string-item"] = function(self, joiner) return CreateStringItem(self:get("to-string-array"):get("joined-string-contents", joiner)) end,
      ["joined-string-contents-with-no-blank-lines"] = function(self) return self:get("to-string-array"):get("joined-string-contents-with-no-blank-lines") end,
      ["to-joined-string-item-with-no-blank-lines"] = function(self) return CreateStringItem(self:get("to-string-array"):get("joined-string-contents-with-no-blank-lines")) end,
      ["to-resplit-string-item-array-assume-sep"] = function(self, sep)
        return CreateArray(
          map(
            self:get("contents"),
            function (strItem) 
              return strItem:get("to-string-item-array", sep) 
            end,
            { flatten = true }
          )
        )
      end,
      ["to-resplit-string-item-array-assume-no-sep"] = function(self, sep)
        return self:get("to-joined-string-item"):get("to-string-item-array", sep)
      end,
      ["longest-common-prefix"] = function(self)
        return self:get("to-string-array"):get("longest-common-prefix")
      end,
      ["map-prepend-all"] = function(self, prefix)
        return self:get("to-string-array"):get("map-to-new-array", function(item) return prefix .. item end)
      end,
      ["is-array-of-urls"] = bind(isArrayOfInterfacesOfType, { ["2"] = "url" }),
      ["is-array-of-paths"] = bind(isArrayOfInterfacesOfType, { ["2"] = "path" }),
      ["is-array-of-printable-ascii-string-items"] = bind(isArrayOfInterfacesOfType, { ["2"] = "printable-ascii-string-item" }),
    },
    doThisables = {
      ["tab-fill-with"] = function(self)
        self:get("to-string-array"):doThis("tab-fill-with")
      end,
    },
  },
  action_table = {
    {
      text = "✍️ fll.",
      key = "tab-fill-with",
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
      text = "👉⌨️ cstrarr.",
      key = "choose-action-on-result-of-get",
      args = { key = "to-string-array"}
    }
  },
  potential_interfaces = ovtable.init({
    { key = "array-of-urls", value = CreateArrayOfUrls },
    { key = "array-of-paths", value = CreateArrayOfPaths },
    { key = "array-of-printable-ascii-string-items", value = CreateArrayOfPrintableAsciiStringItems },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfStringItems = bindArg(NewDynamicContentsComponentInterface, ArrayOfStringItemsSpecifier)