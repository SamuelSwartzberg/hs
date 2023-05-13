--- @type ItemSpecifier
SassProjectDirItemSpecifier = {
  type = "sass-project-dir",
  properties = {
    getables = {
      ["local-build-task"] = function()
        return {
          "sass",
          "**.scss",
          "./dist/main.css"
        }
      end,
      ["is-actually-project-dir"] = returnTrue
    },
    doThisables = {
      ["open-project"] = function(self)
        self:doThis("open-in-new-vscode-window")
      end,
    }
  },
  action_table = {
  
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateSassProjectDirItem = bindArg(NewDynamicContentsComponentInterface, SassProjectDirItemSpecifier)