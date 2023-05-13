--- @type ItemSpecifier
--- @type ItemSpecifier
InGitDirPathItemSpecifier = {
  type = "in-git-dir-path-item",
  properties = {
    getables = {
      ["git-root-dir"] = function(self)
        if self:get("is-git-root-dir") then return self:get("completely-resolved-path") end
        local dotgit = memoize(getItemsForAllLevelsInSlice)(self:get("contents"), "1:-2", {
          include_files = false,
          validator_result = bind(stringy.endswith, {a_use, "/.git"})
        })[1]
        print(dotgit)
        if not dotgit then
          return nil
        end
        return pathSlice(dotgit, ":-2", {rejoin_at_end = true})
      end,
      ["git-root-dir-relative-path"] = function(self)
        return self:get("relative-path-from", self:get("git-root-dir"))
      end,
      ["git-remote"] = function(self)
        local remote = self:get("cd-and-output-this-task", {
          "git",
          "config",
          "--get",
          "remote.origin.url",
        })
        remote = ensureAdfix(remote, ".git", false, false, "suf")
        remote = ensureAdfix(remote, "/", false, false, "suf")
        return remote
      end,
      ["git-remote-owner-item"] = function(self)
        return self:get("git-remote"):find("/([^/]+[^/]+)$")
      end,
      ["url-on-master-remote"] = function(self)
        return self:get("git-remote") .. "/blob/master" .. self:get("git-root-dir-relative-path")
      end,
      ["raw-url-on-github-remote"] = function(self)
        return "https://raw.githubusercontent.com/" .. self:get("git-remote-owner-item") .. "/master" .. self:get("git-root-dir-relative-path")
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
          { value = self:get("completely-resolved-path"), type = "quoted"}
        })
      end,
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
      emoji_icon = "🐙❗️",
      description = "gtig",
      key = "gitignore-path"
    },{
      emoji_icon = "🐙👩🏽‍💻🔗",
      description = "gtremurl",
      key = "git-remote"
    },{
      emoji_icon = "🐙👩🏽‍💻📄🔗",
      description = "gtremitmurl",
      key = "url-on-master-remote"
    },{
      emoji_icon = "🐙👩🏽‍💻🍣📄🔗",
      description = "gtremitmrawurl",
      key = "raw-url-on-github-remote"
    },{
      emoji_icon = "🐙🙋🏽‍♀️💼",
      description = "gtremownitm",
      key = "git-remote-owner-item"
    }
  }))
}

--- @type BoundNewDynamicContentsComponentInterface
CreateInGitDirPathItem = bindArg(NewDynamicContentsComponentInterface, InGitDirPathItemSpecifier)