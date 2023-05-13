--- @type ItemSpecifier
CargoProjectDirItemSpecifier = {
  type = "cargo-project-dir",
  properties = {
    getables = {
      ["local-build-task"] = function()
        return {
          "cargo",
          "build",
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
CreateCargoProjectDirItem = bindArg(NewDynamicContentsComponentInterface, CargoProjectDirItemSpecifier)