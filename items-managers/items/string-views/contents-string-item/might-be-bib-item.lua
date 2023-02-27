--- @type ItemSpecifier
MightBeBibItemSpecifier = {
  type = "might-be-bib-item",
  properties = {
    getables = {
      ["bib-url"] = function(self)
        return extractBetween(self:get("contents"), "url = \\{", "\\}")
      end,
      ["to-citable-object-id"] = function(self)
        return CreateStringItem(toBaseEncoding(self:get("bib-url"), "url_64"))
      end,
    },
    doThisables = {
      ["save-as-citation-file"] = function(self)
        local path = promptPathChildren(env.MCITATIONS)
        if path then
          local filename = self:get("to-citable-object-id"):get("to-bib-filename")
          local bibtex = self:get("contents")
          writeFile(path .. "/" .. filename, bibtex)
        end
      end,
    }
  },
  
  action_table = {
    {
      text = "💾🖋 svcit.",
      key = "save-as-citation-file"
    }
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateMightBeBibItem = bindArg(NewDynamicContentsComponentInterface, MightBeBibItemSpecifier)