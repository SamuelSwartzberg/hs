StrKeyNoninterfacevalueTableSpecifier = {
  type = "str-key-noninterface-value-table",
  properties = {
    getables = {
      ["is-str-key-plain-table-value-table"] = function(self)
        return self:get("is-plain-table-value-table")
      end,
      ["is-str-key-str-value-table"] = function(self)
        return self:get("is-string-value-table")
      end,
    },
    doThisables = {
   
    },
  },
  potential_interfaces = ovtable.init({
   { key = "str-key-plain-table-value-table", value = CreateStrKeyPlainTableValueTable },
   { key = "str-key-str-value-table", value = CreateStrKeyStrValueTable },
  }),
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateStrKeyNoninterfaceValueTable = bindArg(NewDynamicContentsComponentInterface, StrKeyNoninterfacevalueTableSpecifier)
