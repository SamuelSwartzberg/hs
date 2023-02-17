

--- @type ItemSpecifier
CsvTableFileItemSpecifier = {
  type = "csv-table-file",
  properties = {
    getables = {
      ["field-separator"] = function()
        return ","
      end,
      ["line-separator"] = function()
        return "\n"
      end,
    },
    doThisables = {
      
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateCsvTableFileItem = bindArg(NewDynamicContentsComponentInterface, CsvTableFileItemSpecifier)