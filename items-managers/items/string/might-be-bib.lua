--- @type ItemSpecifier
MightBeBibItemSpecifier = {
  type = "might-be-bib",
  properties = {
    getables = {
      ["bib-url"] = function(self)
        return slice(self:get("c"), "url = \\{", "\\}")
      end,
      ["to-citable-object-id"] = function(self)
        return st(transf.string.base64_url(self:get("bib-url")))
      end,
    },
    doThisables = {
      ["save-as-citation-file"] = function(self)
        local path = promptPathChildren(env.MCITATIONS)
        if path then
          local filename = self:get("to-citable-object-id"):get("to-bib-filename")
          local bib = self:get("c")
          writeFile(path .. "/" .. filename, bib)
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