--- @type ItemSpecifier
NpmProjectDirItemSpecifier = {
  type = "npm-project-dir-item",
  properties = {
    getables = {
      ["local-build-task"] = function()
        return {
          "npm",
          "run",
          "build",
        }
      end,
      ["local-install-task"] = function()
        return {
          "npm",
          "run",
          "install",
        }
      end,
      ["is-actually-project-dir"] = returnTrue
    },
    doThisables = {
      ["bump-version"] = function(self, type)
        run({
          "npm",
          "version",
          type,
          "-m",
          "Bump version to %s"
        }, true)
      end,
      ["open-project"] = function(self)
        self:doThis("open-in-new-vscode-window")
      end,
    }
  },
  action_table = {
  
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNpmProjectDirItem = bindArg(NewDynamicContentsComponentInterface, NpmProjectDirItemSpecifier)