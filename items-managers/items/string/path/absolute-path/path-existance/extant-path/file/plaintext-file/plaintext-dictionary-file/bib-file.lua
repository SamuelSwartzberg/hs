

--- @type ItemSpecifier
BibFileItemSpecifier = {
  type = "bib-file",
  properties = {
    getables = {
      ["parse-to-lua-table"] = bc(transf.bib_file.array_of_csl_tables)
      
    },
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBibFileItem = bindArg(NewDynamicContentsComponentInterface, BibFileItemSpecifier)