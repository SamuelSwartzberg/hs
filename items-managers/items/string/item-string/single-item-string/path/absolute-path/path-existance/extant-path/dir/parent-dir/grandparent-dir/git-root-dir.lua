--- @type ItemSpecifier
GitRootDirItemSpecifier = {
  type = "git-root-dir",
  properties = {
    getables = {
    },
    doThisables = {
      ["copy-as-hook"] = function(self, hook_path)
        local newpath = self:get("hooks-dir") .. pathSlice(hook_path, "-1:-1")[1]
        dir.copyfile(hook_path, newpath)
        local newpath_permissions = hs.fs.attributes(hook_path, "permissions")
        if stringx.at(newpath_permissions, 3) ~= "x" then
          self:doThis("cd-and-run-this-task", {
            "chmod",
            "+x",
            newpath,
          })
        end
      end,
      ["sync-hook"] = function(self, hook_name)
        self:doThis("copy-as-hook", env.GITCONFIGHOOKS  .. "/"  .. hook_name)
      end,
      ["sync-hooks"] = function(self)
        for _, hook_path in fastpairs(itemsInPath({path = env.GITCONFIGHOOKS, include_dirs = false})) do
          self:doThis("copy-as-hook", hook_path)
        end
      end,

    }
  },
  action_table = {
  
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateGitRootDirItem = bindArg(NewDynamicContentsComponentInterface, GitRootDirItemSpecifier)