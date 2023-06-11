

--- @type ItemSpecifier
BibFileItemSpecifier = {
  type = "bib-file",
  properties = {
    getables = {
      ["to-csl-table"] = function(self)
        local raw_table = self:get("parse-to-lua-table")
        return ar(map(raw_table, tb))
      end,
      
        
    },
    doThisables = {
      
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBibFileItem = bindArg(NewDynamicContentsComponentInterface, BibFileItemSpecifier)