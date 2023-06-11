

--- @type ItemSpecifier
CsvTableFileItemSpecifier = {
  type = "csv-table-file",
}

--- @type BoundNewDynamicContentsComponentInterface
CreateCsvTableFileItem = bindArg(NewDynamicContentsComponentInterface, CsvTableFileItemSpecifier)