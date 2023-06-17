--- @type ItemSpecifier
LatexProjectDirItemSpecifier = {
  type = "latex-project-dir",
  properties = {
    getables = {
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
      end
    },
  },
  action_table = {
  
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateLatexProjectDirItem = bindArg(NewDynamicContentsComponentInterface, LatexProjectDirItemSpecifier)