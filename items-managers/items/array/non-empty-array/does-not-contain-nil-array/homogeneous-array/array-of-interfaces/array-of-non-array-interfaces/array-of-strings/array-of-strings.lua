
ArrayOfStringItemsSpecifier = {
  type = "array-of-strings-item",
  properties = {
    getables = {
      ["is-array-of-urls"] = bind(isArrayOfInterfacesOfType, {a_use, "url" }),
      ["is-array-of-paths"] = bind(isArrayOfInterfacesOfType, {a_use, "path" }),
      ["is-array-of-printable-ascii-string-items"] = bind(isArrayOfInterfacesOfType, {a_use, "printable-ascii-string" }),
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