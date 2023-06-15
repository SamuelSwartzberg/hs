--- @type ItemSpecifier
CitableObjectIdItemSpecifier = {
  type = "citable-object-id",
  properties = {
    getables = {
      ["to-bib-filename"] = function(self)
        return self:get("c") .. ".bib"
      end,
      ["to-pdf-filename"] = function(self)
        return self:get("c") .. ".pdf"
      end,
      ["to-epub-filename"] = function(self)
        return self:get("c") .. ".epub"
      end,
      ["local-citation-file-if-any"] = function(self)
        return st(env.MCITATIONS):get("descendant-ending-with",self:get("to-bib-filename"))
      end,
      ["local-corresponding-paper-if-any"] = function(self)
        return 
          st(env.MPAPERS):get("descendant-ending-with",self:get("to-pdf-filename"))
          or st(env.MPAPERS):get("descendant-ending-with",self:get("to-epub-filename"))
      end,
      ["is-local-citable-object-id"] = function(self)
        return not not self:get("local-citation-file-if-any")
      end,
      ["is-nonlocal-citable-object-id"] = function(self)
        return not self:get("local-citation-file-if-any")
      end,
      
    },
    doThisables = {
      ["import-citation"] = function(self, project_path)
        local project_item = st(project_path)
        project_item:get("str-item", "latex-importfile"):doThis("append-file-contents", self:get("c") .. "\n")
        project_item:get("str-item", "latex-imported-papers"):doThis("copy-into", self:get("local-corresponding-paper-if-any"))
        project_item:get("str-item", "latex-paper-notes"):doThis("create-empty-file-in-dir", self:get("c") .. "_notes.md")
        project_item:get("str-item", "latex-bibfile"):doThis("append-file-contents", self:get("bibtex-from-citation-file"))
      end,

    }
  },
  potential_interfaces = ovtable.init({
    { key = "local-citable-object-id", value = CreateLocalCitableObjectIdItem },
    { key = "nonlocal-citable-object-id", value = CreateNonlocalCitableObjectIdItem },
  }),
}
--- @type BoundNewDynamicContentsComponentInterface
CreateCitableObjectIdItem = bindArg(NewDynamicContentsComponentInterface, CitableObjectIdItemSpecifier)