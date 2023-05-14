--- @type ItemSpecifier
NonlocalCitableObjectIdItemSpecifier = {
  type = "nonlocal-citable-object-id",
  properties = {
    getables = {
      ["bibtex-from-internet-as-table"] = function(self) 
        return runJSON({
          "echo",
          "-n",
          {
            value = self:get("bibtex-from-internet"),
            type = "quoted"
          },
          "|",
          "pandoc",
          "-f",
          "bibtex",
          "-t",
          "csljson"
        })
      end,
    },
    doThisables = {
      ["save-as-citation-file"] = function(self)
        local path = promptPathChildren(env.MCITATIONS)
        if path then
          local filename = self:get("to-bib-filename")
          local bibtex = self:get("bibtex-from-internet")
          writeFile(path .. "/" .. filename, bibtex)
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