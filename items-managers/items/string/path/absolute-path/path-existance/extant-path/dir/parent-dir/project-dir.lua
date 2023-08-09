--- @type ItemSpecifier
ProjectDirItemSpecifier = {
  type = "project-dir",
  properties = {
    getables = {
      ["is-latex-project-dir"] = function(self)
        return get.dir.find_leaf_of_child("main.tex")
      end,
      ["is-omegat-project-dir"] = function(self)
        return get.dir.find_leaf_of_child("omegat.project")
      end,
      ["is-npm-project-dir"] = function(self)
        return get.dir.find_leaf_of_child("package.json")
      end,
      ["is-cargo-project-dir"] = function(self)
        return get.dir.find_leaf_of_child("Cargo.toml")
      end,
      ["is-sass-project-dir"] = function(self)
        return get.dir.find_extension_of_child("sass")
      end,
      ["project-name"] = function(self)
        return self:get("path-leaf-general-name") or self:get("path-leaf")
      end,
      ["corresponding-application"] = function(self)
        return hs.application.get(self:get("corresponding-application-name"))
      end,
      ["corresponding-application-ensure"] = function(self)
         hs.application.launchOrFocus(self:get("corresponding-application-name"))
         return hs.application.get(self:get("corresponding-application-name"))
      end,
      ["running-application"] = function(self)
        return CreateRunningApplicationItem(self:get("corresponding-application"))
      end,
      
    },
    doThisables = {
      ["initialize"] = function(self)
        self:doThis("table-to-fs", self:get("initial-dir-structure-specifier"))
        self:doThis("specific-initialize")
        self:doThis("initialize-as-git-dir")
        self:doThis("git-commit-all", "initial commit")
      end,
      ["build"] = function (self)
        self:doThis("cd-and-run-this-task", self:get("local-build-task"))
      end,
      ["install"] = function(self)
        self:doThis("cd-and-run-this-task", self:get("local-install-task"))
      end,
      ["do-running-application-ensure"] = function(self, do_after)
        local corresponding_application = self:get("corresponding-application")
        if corresponding_application then 
          local running_application = CreateRunningApplicationItem(corresponding_application)
          do_after(running_application)
        else
          local running_application =  CreateRunningApplicationItem(self:get("corresponding-application-ensure"))
          hs.timer.doAfter(3, function()
            do_after(running_application)
          end) -- wait for app to launch and be ready
        end
      end,
      
    }
  },
  ({
    { key = "latex-project-dir", value = CreateLatexProjectDirItem },
    { key = "omegat-project-dir", value = CreateOmegatProjectDirItem },
    { key = "npm-project-dir", value = CreateNpmProjectDirItem },
    { key = "cargo-project-dir", value = CreateCargoProjectDirItem },
    { key = "sass-project-dir", value = CreateSassProjectDirItem },
  }),
  ({
    {
      text = "🗄🏗️ opproj.",
      key = "open-project"
    },
    {
      text = "👉🏃🏾‍♀️📱 crunapp.",
      key = "choose-action-on-result-of-get",
      args = { key = "running-application"}
    }
  }, getChooseItemTable({}))
}

--- @type BoundNewDynamicContentsComponentInterface
CreateProjectDirItem = bindArg(NewDynamicContentsComponentInterface, ProjectDirItemSpecifier)