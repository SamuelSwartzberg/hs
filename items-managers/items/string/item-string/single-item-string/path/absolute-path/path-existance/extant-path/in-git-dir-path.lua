--- @type ItemSpecifier
InGitDirPathItemSpecifier = {
  type = "in-git-dir-path",
  properties = {
    getables = {
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
      
    },
    doThisables = {
      ["git-add-all"] = function(self)
        self:doThis("cd-and-run-this-task", {
          "git",
          "add",
          "**",
        })
      end,
      ["git-commit-self"] = function(self, message)
        self:doThis("cd-and-run-this-task", {
          "git",
          "commit",
          "-m",
          { value = message or ("changed " .. self:get("relative-path-from", self:get("git-root-dir"))), type = "quoted"},
          { value = self:get("completely-resolved-path"), type = "quoted"}
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
          { value = message or ("Programmatic commit at " .. os.date(tblmap.dt_component.rfc3339["sec"])), type = "quoted" }
        })
      end,
      ["git-commit-all-and-push"] = function(self, message)
        self:doThis("git-add-all")
        hs.timer.doAfter(2, function ()
          self:doThis("git-commit-all", message)
          hs.timer.doAfter(2, function ()
            self:doThis("git-push")
          end)
        end)
      end,
      
    }
  },
  action_table = concat({
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
      i = "🐙❗️",
      d = "gtig",
      key = "gitignore-path"
    },{
      i = "🐙👩🏽‍💻🔗",
      d = "gtremurl",
      key = "git-remote"
    },{
      i = "🐙👩🏽‍💻📄🔗",
      d = "gtremitmurl",
      key = "url-on-master-remote"
    },{
      i = "🐙👩🏽‍💻🍣📄🔗",
      d = "gtremitmrawurl",
      key = "raw-url-on-github-remote"
    },{
      i = "🐙🙋🏽‍♀️💼",
      d = "gtremownitm",
      key = "git-remote-owner-item"
    }
  }))
}

--- @type BoundNewDynamicContentsComponentInterface
CreateInGitDirPathItem = bindArg(NewDynamicContentsComponentInterface, InGitDirPathItemSpecifier)