--- @type ItemSpecifier
NpmProjectDirItemSpecifier = {
  type = "npm-project-dir",
  properties = {
    doThisables = {
      ["bump-version"] = function(self, type)
        dothis.string.env_bash_eval_async("npm version " .. type .. "-m Bump version to %s")
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