

--- @type ItemSpecifier
TsvTableFileItemSpecifier = {
  type = "tsv-table-file",
  properties = {
    getables = {
      ["field-separator"] = function()
        return "\t"
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
CreateTsvTableFileItem = bindArg(NewDynamicContentsComponentInterface, TsvTableFileItemSpecifier)