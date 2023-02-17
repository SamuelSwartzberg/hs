--- @type ItemSpecifier
--- @type ItemSpecifier
InGitDirPathItemSpecifier = {
  type = "in-git-dir-path-item",
  properties = {
    getables = {
      ["git-root-dir"] = function(self)
        if self:get("is-git-root-dir") then return self:get("contents") end
        local dotgit = findInSiblingsOrAncestorSiblings(self:get("contents"), ".git", true, false)
        print(dotgit)
        if not dotgit then
          return nil
        end
        return getParentPath(dotgit) or nil
      end,
      ["gitignore-path"] = function(self)
        return self:get("git-root-dir") .. "/.gitignore"
      end,
      ["has-changes"] = function(self)
        local git_status = self:get("cd-and-output-this-task", {
          "git",
          "status",
          "--porcelain",
        })
        return git_status ~= ""
      end,
      ["unpushed-commits"] = function(self)
        return self:get("cd-and-output-this-task", {
          "git",
          "log",
          "--branches",
          "--not",
          "--remotes",
          "--pretty=format:%h",
        })
      end,
      ["has-unpushed"] = function(self)
        return self:get("unpushed-commits") ~= ""
      end,
      ["autocommit-and-push-task"] = function(self, interval)
        return {
          interval = interval,
          fn = function()
            self:doThis("git-commit-all")
            self:doThis("git-push")
          end
        }
      end,
      
    },
    doThisables = {
      ["git-push"] = function(self)
        self:doThis("cd-and-run-this-task", {
          "git",
          "push",
        })
      end,
      ["git-pull"] = function(self)
        self:doThis("cd-and-run-this-task", {
          "git",
          "pull",
        })
      end,
      ["git-fetch"] = function(self)
        self:doThis("cd-and-run-this-task", {
          "git",
          "fetch",
        })
      end,
      ["git-add-self"] = function(self)
        self:doThis("cd-and-run-this-task", {
          "git",
          "add",
          { value = self:get("contents"), type = "quoted"}
        })
      end,
      ["git-commit-self"] = function(self, message)
        self:doThis("cd-and-run-this-task", {
          "git",
          "commit",
          "-m",
          { value = message or ("changed " .. self:get("relative-path-from", self:get("git-root-dir"))), type = "quoted"},
          { value = self:get("contents"), type = "quoted"}
        })
      end,
      ["git-commit-staged"] = function(self, message)
        self:doThis("cd-and-run-this-task", {
          "git",
          "commit",
          "-m",
          { value = message, type = "quoted"}
        })
      end,
      ["git-commit-all"] = function(self, message)
        self:doThis("cd-and-run-this-task", {
          "git",
          "commit",
          "-a",
          "-m",
          { value = message or ("Programmatic commit at " .. os.date(getRFC3339FormatStringForPrecision("sec"))), type = "quoted" }
        })
      end,
      ["git-commit-all-and-push"] = function(self, message)
        self:doThis("git-commit-all", message)
        self:doThis("git-push")
      end,
      ["git-add-all"] = function(self)
        self:doThis("cd-and-run-this-task", {
          "git",
          "add",
          "-A",
        })
      end,
      
    }
  },
  action_table = listConcat({
    {
      text = "🐙⬆️ gtpsh.",
      key = "git-push"
    },{
      text = "🐙⬇️ gtpll.",
      key = "git-pull"
    },{
      text = "🐙🔄 gtftch.",
      key = "git-fetch"
    },{
      text = "🐙📝 gtcmmt.",
      key = "do-interactive",
      args = {
        key = "git-commit-all"
      }
    },
  }, getChooseItemTable({
    {
      emoji_icon = "🐙❗️",
      description = "gtig",
      key = "open-gitignore"
    }
  }))
}

--- @type BoundNewDynamicContentsComponentInterface
CreateInGitDirPathItem = bindArg(NewDynamicContentsComponentInterface, InGitDirPathItemSpecifier)