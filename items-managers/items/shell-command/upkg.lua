--- @type ItemSpecifier
UpkgCommandSpecifier = {
  type = "upkg-command",
  properties = {
    getables = {
      ["package-managers"] = function(self)
        return lines(run({"list-package-managers"}))
      end,
      ["list"] = function(self, mgr) return lines(run({mgr, "list"})) end,
      ["list-version"] = function(self, mgr) return lines(run({mgr, "list-version"})) end,
      ["with-version"] = function(self, specifier) return lines(run({specifier.mgr, "with-version", specifier.arg})) end,
      ["version"] = function(self, specifier) return lines(run({specifier.mgr, "version", specifier.arg})) end,
      ["count"] = function(self, mgr) return lines(run({mgr, "count"})) end,
      ["which"] = function(self, specifier) return lines(run({specifier.mgr, "which", specifier.arg}))
      end,
      ["is-installed"] = function(self, specifier)
        return find(
          lines(run({
            specifier.mgr, 
            "list"
          })), specifier.arg
        )
      end,
      ["package-managers-installed"] = function(self, specifier)
        return lines(run({
          specifier.mgr, 
          "is-installed-package-manager",
          specifier.arg
        }))
      end,
      ["backed-up-packages"] = function(self, mgr)
        return lines(run({
          mgr, 
          "read-backup"
        }))
      end,
      ["missing-packages"] = function(self, mgr)
        return lines(run({
          mgr, 
          "missing"
        }))
      end,
      ["added-packages"] = function(self, mgr)
        return lines(run({
          mgr, 
          "added"
        }))
      end,
      ["difference-packages"] = function(self, mgr)
        return lines(run({
          mgr, 
          "difference"
        }))
      end,
      ["package-manager-version"] = function(self, mgr)
        return lines(run({
          mgr, 
          "package-manager-version"
        }))
      end,
      ["which-package-manager"] = function(self, mgr)
        return lines(run({
          mgr, 
          "which-package-manager"
        }))
      end,
      ["package-managers-with-missing-packages"] = function(self, mgr)
        return lines(run({
          mgr, 
          "missing-package-managers"
        }))
      end,
      ["package-manager-res-map"] = function(self, specifier) -- upkg theoretically already has the ability to iterate over all package managers, but it's easier for us to do the iterating, knowing which mgr we used, here, rather than parsing out the mgr from the upkg result
        local res = {}
        for _, mgr in self:get("package-managers") do
          res[mgr] = self:get(specifier.action, specifier.args)
        end
        return res
      end

    },
    doThisables = {
      ["do-and-commit"]  = function(self, specifier)
        run({
          "upkg",
          specifier.mgr,
          specifier.action,
        }, function()
          local message = specifier.msg or specifier.action
          
          if specifier.mgr then
            message = message .. " for " .. specifier.mgr
            local mgr_backup = CreateStringItem(env.MDEPENDENCIES .. "/" .. specifier.mgr)
            mgr_backup:doThis("git-commit-self", message)
            mgr_backup:doThis("git-push")
          else 
            local mdependencies = CreateStringItem(env.MDEPENDENCIES)
            mdependencies:doThis("git-commit-all", message)
            mdependencies:doThis("git-push")
          end
        end)
      end,
      ["backup"] = function(self, mgr)
        self:doThis("do-and-commit", {
          mgr = mgr,
          action = "backup",
          msg = "backup packages"
        })
      end,
      ["delete-backup"] = function(self, mgr)
        self:doThis("do-and-commit", {
          mgr = mgr,
          action = "delete-backup",
          msg = "delete backup of packages"
        })
      end,
      ["replace-backup"] = function(self,mgr)
        self:doThis("do-and-commit", {
          mgr = mgr,
          action = "replace-backup",
          msg = "replace backup of packages"
        })
      end,
      ["do-single-arg"] = function(self,specifier)
        run({
          "upkg",
          specifier.mgr,
          specifier.action,
          specifier.arg,
        }, true)
      end,
      ["install"] = function(self,specifier)
        specifier.action = "install"
        self:doThis("do-single-arg",specifier)
      end,
      ["install-self"] = function(self,specifier)
        specifier.action = "install-self"
        self:doThis("do-single-arg",specifier)
      end,
      ["install-missing"] = function(self, specifier)
        specifier.action = "install-missing"
        self:doThis("do-single-arg",specifier)
      end,
      ["remove"] = function(self,specifier)
        specifier.action = "remove"
        self:doThis("do-single-arg",specifier)
      end,
      ["upgrade"] = function(self,specifier)
        specifier.action = "upgrade"
        self:doThis("do-single-arg",specifier)
      end,
      ["link"] = function(self,specifier)
        specifier.action = "link"
        self:doThis("do-single-arg",specifier)
      end,
      ["upgrade-all"] = function(self,specifier)
        specifier.action = "upgrade-all"
        self:doThis("do-single-arg",specifier)
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateUpkgCommand = bindArg(NewDynamicContentsComponentInterface, UpkgCommandSpecifier)
