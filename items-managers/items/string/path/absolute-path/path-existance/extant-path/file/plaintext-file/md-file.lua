

--- @type ItemSpecifier
MdFileItemSpecifier = {
  type = "md-file",
  properties = {
    getables = {
    },
    doThisables = {
      ["to-pandoc-export-and-then-choose-action"] = function(self, format)
        dothis.pandoc.markdown_to(self:get("resolved-path"), format, nil, function(target)
          st(target):doThis("choose-action")
        end)
      end,

    }
  },
  action_table = {
    {
      text = "👉📑📄🎓 cexltxpdf.",
      key = "to-pandoc-export-and-then-choose-action",
      args = "pdf"
    },
    {
      text = "👉📑💻🟨 cexrvjs.",
      key = "to-pandoc-export-and-then-choose-action",
      args = "revealjs"
    },
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateMdFileItem = bindArg(NewDynamicContentsComponentInterface, MdFileItemSpecifier)