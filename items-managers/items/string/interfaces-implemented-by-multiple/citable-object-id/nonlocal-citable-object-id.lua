--- @type ItemSpecifier
NonlocalCitableObjectIdItemSpecifier = {
  type = "nonlocal-citable-object-id",
  properties = {
    getables = {
      ["bib-from-internet-as-table"] = function(self) 
        return transf.bib_string.array_of_csl_tables(self:get("bib-from-internet"))
      end,
    },
    doThisables = {
      ["save-as-citation-file"] = function(self)
        local path = promptPathChildren(env.MCITATIONS)
        if path then
          local filename = self:get("to-bib-filename")
          local bib = self:get("bib-from-internet")
          writeFile(path .. "/" .. filename, bib)
        end
      end,
      ["save-as-citation-file-and-write-to-citation-import-file"] = function(self)
        self:doThis("save-as-citation-file")
        self:doThis("write-to-citation-import-file")
      end,
    }
  }
}
--- @type BoundNewDynamicContentsComponentInterface
CreateNonlocalCitableObjectIdItem = bindArg(NewDynamicContentsComponentInterface, NonlocalCitableObjectIdItemSpecifier)