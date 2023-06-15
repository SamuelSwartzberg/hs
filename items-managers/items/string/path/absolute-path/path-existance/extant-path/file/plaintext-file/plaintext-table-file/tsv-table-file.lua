

--- @type ItemSpecifier
TsvTableFileItemSpecifier = {
  type = "tsv-table-file",
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTsvTableFileItem = bindArg(NewDynamicContentsComponentInterface, TsvTableFileItemSpecifier)