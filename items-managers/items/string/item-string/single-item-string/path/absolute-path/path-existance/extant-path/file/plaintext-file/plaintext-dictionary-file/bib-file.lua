

--- @type ItemSpecifier
BibFileItemSpecifier = {
  type = "bib-file",
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBibFileItem = bindArg(NewDynamicContentsComponentInterface, BibFileItemSpecifier)