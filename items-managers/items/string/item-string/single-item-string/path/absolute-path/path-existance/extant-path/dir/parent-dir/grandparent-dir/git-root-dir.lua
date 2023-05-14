--- @type ItemSpecifier
GitRootDirItemSpecifier = {
  type = "git-root-dir",
  properties = {
    getables = {
      ["dotgit-dir"] = function(self)
        return self:get("path-ensure-final-slash") .. ".git/"
      end,
      ["hooks-dir"] = function(self)
        return self:get("path-ensure-final-slash") .. ".git/hooks/"
      end,
      ["run-hook-and-get-output"] = function(self)
        return self:get("cd-and-output-this-task", {
          self:get("hooks-dir") .. "run-hook-and-get-output",
        })
      end,
      ["all-hooks"] = function(self)
        return itemsInPath({path = self:get("hooks-dir"), include_dirs = false})
      end,
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
        for _, hook_path in prs(itemsInPath({path = env.GITCONFIGHOOKS, include_dirs = false})) do
          self:doThis("copy-as-hook", hook_path)
        end
      end,
      ["run-hook"] = function(self, hook_name)
        self:doThis("cd-and-run-this-task", {
          self:get("hooks-dir") .. hook_name,
        })
      end,

    }
  },
  action_table = {
  
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateGitRootDirItem = bindArg(NewDynamicContentsComponentInterface, GitRootDirItemSpecifier)