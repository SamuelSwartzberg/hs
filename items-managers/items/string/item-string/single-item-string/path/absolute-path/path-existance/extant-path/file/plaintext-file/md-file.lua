

--- @type ItemSpecifier
MdFileItemSpecifier = {
  type = "md-file",
  properties = {
    getables = {
    },
    doThisables = {
      ["to-pandoc-export"] = function(self, specifier)
        dothis.pandoc.markdown_to(self:get("resolved-path"), specifier.format, nil, specifier.do_after)
      end,
      ["to-pandoc-export-and-then-choose-action"] = function(self, format)
        dothis.pandoc.markdown_to(self:get("resolved-path"), format, nil, function(target)
          CreateStringItem(target):doThis("choose-action")
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
      text = "👉📑💻🎓 cexltxbmr.",
      key = "to-pandoc-export-and-then-choose-action",
      args = "beamer"
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