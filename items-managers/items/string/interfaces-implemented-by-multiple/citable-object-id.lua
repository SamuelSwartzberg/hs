--- @type ItemSpecifier
CitableObjectIdItemSpecifier = {
  type = "citable-object-id",
  properties = {
    doThisables = {
      ["import-citation"] = function(self, project_path)
        local project_item = st(project_path)
        project_item:get("str-item", "latex-importfile"):doThis("append-file-contents", self:get("c") .. "\n")
        project_item:get("str-item", "latex-imported-papers"):doThis("copy-into", self:get("local-corresponding-paper-if-any"))
        project_item:get("str-item", "latex-paper-notes"):doThis("create-empty-file-in-dir", self:get("c") .. "_notes.md")
        project_item:get("str-item", "latex-bibfile"):doThis("append-file-contents", self:get("bib-from-citation-file"))
      end,

    }
  },
}
--- @type BoundNewDynamicContentsComponentInterface
CreateCitableObjectIdItem = bindArg(NewDynamicContentsComponentInterface, CitableObjectIdItemSpecifier)