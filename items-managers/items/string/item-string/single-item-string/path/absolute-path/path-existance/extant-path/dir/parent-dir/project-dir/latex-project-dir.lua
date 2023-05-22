--- @type ItemSpecifier
LatexProjectDirItemSpecifier = {
  type = "latex-project-dir",
  properties = {
    getables = {
      
      ["latex-importfile"] = function(self)
        return self:get("path-ensure-final-slash") .. "importfile"
      end,
      ["latex-main-tex-file"] = function(self)
        return self:get("path-ensure-final-slash") .. "main.tex"
      end,
      ["latex-main-pdf"] = function(self)
        return self:get("path-ensure-final-slash") .. "main.pdf"
      end,
      ["latex-bibfile"] = function(self)
        return self:get("path-ensure-final-slash") .. "main.bib"
      end,
      ["latex-imported-papers"] = function(self)
        return self:get("path-ensure-final-slash") .. "imported_papers"
      end,
      ["latex-paper-notes"] = function(self)
        return self:get("path-ensure-final-slash") .. "paper_notes"
      end,
      ["latex-imports-as-string-item-array"] = function(self)
        return self:get("str-item", { key = "latex-importfile-to-string-item" }):get("to-line-array"):get("map-to-new-array", function(line)
          return CreateStringItem(line)
        end)
      end,
      ["local-build-task"] = function() -- minimal implementation, may be expanded later
        return {
          "pdflatex",
          "main.tex"
        }
      end,
      ["initial-dir-structure-specifier"] = function(self)
        return {
          mode = "write",
          overwrite = false,
          payload = {
            importfile = "",
            ["main.tex"] = readFile(le(comp.templates.latex_main)),
            imported_papers = false -- false means 'only create dir'
          }
        }
      end,
      ["imported-bib-items"] = function(self)
        return self:get("latex-imports-as-string-item-array"):get("map", function(citable_object_id)
          return citable_object_id:get("bibtex-from-citation-file")
        end)
      end,
      ["is-actually-project-dir"] = returnTrue
    },
    doThisables = {
      ["specific-initialize"] = function(self)
        
      end,
      ["build-and-open-pdf"] = function(self)
        run(self:get("build-task")) -- outputTask since it is blocking, and we want to open the pdf after it is done
        self:doThis("open-result-of-get", {
          key = "latex-main-pdf"
        })
      end,
      -- things like opening of various files, e.g. bibfile can be achieved by doing self:doThis("open-result-of-get", {action = "get", key = <whatever-key>, e.g. "latex-biblfile"}), so there's no need to implement them here
      ["open-project"] = function(self)
        self:doThis("open-in-new-vscode-window")
      end,
      ["build-bibfile"] = function(self)
        for _, bib_item in ipairs(self:get("imported-bib-items")) do
          writeFile(self:get("latex-bibfile"), bib_item, "any", true, "a")
        end
      end,
    }
  },
  action_table = {
  
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateLatexProjectDirItem = bindArg(NewDynamicContentsComponentInterface, LatexProjectDirItemSpecifier)