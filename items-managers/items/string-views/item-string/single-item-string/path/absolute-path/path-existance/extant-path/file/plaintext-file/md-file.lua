

--- @type ItemSpecifier
MdFileItemSpecifier = {
  type = "md-file",
  properties = {
    getables = {
    },
    doThisables = {
      ["to-pandoc-export"] = function(self, specifier)
        inspPrint(specifier)
        CreateShellCommand("pandoc"):doThis("md-to-" .. specifier.format , {
          source = self:get("resolved-path"),
          target = specifier.target_path,
          do_after = specifier.do_after
        })
      end,
      ["to-pandoc-export-and-then-choose-action"] = function(self, specifier)
        specifier.do_after = function(target)
          CreateStringItem(target):doThis("choose-action")
        end
        self:doThis("to-pandoc-export", specifier)
      end,

    }
  },
  action_table = {
    {
      text = "👉📑📄🎓 cexltxpdf.",
      key = "to-pandoc-export-and-then-choose-action",
      args = {
        format = "latexlike-pdf"
      }
    },
    {
      text = "👉📑💻🎓 cexltxbmr.",
      key = "to-pandoc-export-and-then-choose-action",
      args = {
        format = "latex-beamer-pdf"
      }
    },
    {
      text = "👉📑💻🟨 cexrvjs.",
      key = "to-pandoc-export-and-then-choose-action",
      args = {
        format = "revealjs"
      }
    },
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateMdFileItem = bindArg(NewDynamicContentsComponentInterface, MdFileItemSpecifier)