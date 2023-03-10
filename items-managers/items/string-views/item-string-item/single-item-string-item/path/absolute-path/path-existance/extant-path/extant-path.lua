--- @type ItemSpecifier
ExtantPathItemSpecifier = {
  type = "extant-path",
  properties = {
    getables = {
    --[[   ["is-category-date-dir-structure-contained-item"] = function(self)
        return stringy.startswith(self:get("contents"), env.MDIARY) -- currently the only category-date-dir-structure-root is env.MDIARY, and this check is far cheaper then the alternative, so we'll use it for now
      end, ]]
      ["is-dir"] = function(self) return testPath(self:get("contents"), "dir") end,
      ["is-file"] = function(self) return not self:get("is-dir") end, 
      ["is-dated-extant-path"] = function(self) 
        local path_leaf = pathSlice(self:get("contents", "-1:-1")[1])
        return 
          path_leaf:match("^(.-)%-%-") 
          or path_leaf:match("^(%d[^%%]+)") 
      end, 
      ["get-ancestor-string-array"] = function(self)
        return CreateArray(pathSlice(self:get("contents"), "1:-2", { entire_path_for_each = true }))
      end,
      ["is-in-git-dir-path"] = function(self) 
        return find(
          getItemsForAllLevelsInSlice(self:get("contents"), "1:-1", { include_files = false }),
          function(item)
            return stringy.endswith(item, ".git")
          end
        )
      end,
      ["cd-to-parent-dir-and-task"] = function(self)
        return {
          "cd",
          { value = self:get("parent-dir-path"), type = "quoted" },
          "&&",
        }
      end,
      ["cd-and-this-task"] = function(self, task)
        return concat(
          self:get("cd-and-task"),
          task
        )
      end,
      ["cd-and-output-this-task"] = function(self, task)
        return run(self:get("cd-and-this-task", task))
      end,
      ["sibling-string-array"] = function(self)
        return CreateArray(getItemsForAllLevelsInSlice(self:get("contents"), "-2:-2"))
      end,
      ["sibling-file-only-string-array"] = function(self)
        return CreateArray(getItemsForAllLevelsInSlice(self:get("contents"), "-2:-2", { include_dirs = false }))
      end,
      ["sibling-dir-only-string-array"] = function(self)
        return CreateArray(getItemsForAllLevelsInSlice(self:get("contents"), "-2:-2", { include_files = false }))
      end,
      ["find-sibling"] = function(self, func)
        return self:get("sibling-string-array"):get("find", function(sibling)
          if sibling == self:get("contents") then return false end -- don't return self
          return func(sibling)
        end)
      end,
      ["find-sibling-with-same-filename"] = function(self)
        return self:get("find-sibling", function(sibling)
          return pathSlice(sibling, "-2:-2", { ext_sep = true })[1] == pathSlice(self:get("contents", "-2:-2", { ext_sep = true })[1])
        end)
      end,
      ["find-sibling-with-different-extension"] = function(self, ext)
        return self:get("find-sibling", function(sibling)
          return pathSlice(sibling, "-1:-1")[1] == pathSlice(self:get("contents", "-2:-2", { ext_sep = true })[1]) .. "." .. ext
        end)
      end,
      ["find-sibling-dir-with-same-filename"] = function(self)
        return self:get("find-sibling", function(sibling)
          return pathSlice(sibling, "-1:-1")[1] == pathSlice(self:get("contents", "-2:-2", { ext_sep = true })[1])
        end)
      end,
      ["path-attr"] = function(self, attr)
        return hs.fs.attributes(self:get("contents"), attr)
      end,
      ["path-size"] = function(self)
        return self:get("path-attr", "size")
      end,
      ["path-date"] = function(self, attr) -- attr must be one of "access", "modification", "change", "creation"
        return date(self:get("path-attr", attr))
      end,
      ["path-date-item"] = function (self, attr)
        return CreateDate(self:get("path-date", attr))
      end,
    },
    doThisables = {
      ["cd-and-run-this-task"] = function(self, task)
        run(self:get("cd-and-this-task", task))
      end,
      ["open-path"] = function (self, app)
        open({path = self:get("contents"), app = app})
      end,
      ["open-parent"] = function (self, app)
        open({path = self:get("parent-dir-path"), app = app})
      end,
      ["open-path-in-finder"] = function(self)
        hs.execute("open -R '" .. self:get("contents") .. "'")
      end,
      ["open-with-application"] = function(self, application)
        run({
          "open",
          "-a",
          application,
          { value = self:get("contents"), type = "quoted" }
        }, true)
      end,
      ["open-contents-in-new-vscode-window"] = function(self)
        -- this should ideally use the `code` command, but it is currently broken
        open(self:get("contents"))
      end,
      ["open-contents-in-current-vscode-window"] = function(self)
        -- this should ideally use the `code` command, but it is currently broken
        open(self:get("contents"))
      end,
      ["move-safe"] = function(self, target)
        srctgt("move", self:get("contents"), target, "not-exists")
      end,
      ["move-force"] = function(self, target)
        srctgt("move", self:get("contents"), target)
      end,
      ["move-replace-self"] = function(self, origin)
        srctgt("move", origin, self:get("contents"))
      end,
      ["move-into-dir"] = function (self, target)
        srctgt("move", self:get("contents"), target, nil, true, true)
      end,
      ["move-safe-and-choose-action"] = function(self, target)
        self:doThis("move-safe", target)
        CreateStringItem(target):doThis("choose-action")
      end,
      ["move-force-and-choose-action"] = function(self, target)
        self:doThis("move-force", target)
        CreateStringItem(target):doThis("choose-action")
      end,
      ["move-up-and-choose-action"] = function(self)
        self:doThis("move-safe-and-choose-action", self:get("parent-dir-path"))
      end,
      ["copy-safe"] = function(self, target)
        srctgt("copy", self:get("contents"), target, "not-exists")
      end,
      ["copy-force"] = function(self, target)
        srctgt("copy", self:get("contents"), target)
      end,
      ["copy-safe-and-choose-action"] = function(self, target)
        self:doThis("copy-safe", target)
        CreateStringItem(target):doThis("choose-action")
      end,
      ["copy-force-and-choose-action"] = function(self, target)
        self:doThis("copy-force", target)
        CreateStringItem(target):doThis("choose-action")
      end,
      ["rename"] = function(self, new_name)
        local new_path = self:get("parent-dir-path") .. "/" .. new_name
        self:get("move-safe", new_path)
      end,
      ["zip"] = function(self, target_path)
        srctgt("zip", self:get("contents"), target_path)
      end,
      ["zip-and-choose-action"] = function(self, target_path)
        srctgt("zip", self:get("contents"), target_path, function(target)
          CreateStringItem(target):doThis("choose-action")
        end)
      end,
      ["send-in-email-and-choose-action"] = function(self)
        self:doThis("send-in-email", function(target)
          CreateStringItem(target):doThis("choose-action")
        end)
      end,
      ["create-sibling-file-and-choose-action"] = function(self, filename)
        local path = self:get("parent-dir-path") .. "/" .. filename
        writeFile(path, "", "not-exists")
        CreateStringItem(path):doThis("choose-action")
      end,

    }
  },
  potential_interfaces = ovtable.init({
    { key = "dir", value = createPathItem },
    { key = "file", value = CreateFileItem },
    { key = "in-git-dir-path", value = CreateInGitDirPathItem },
    { key = "dated-extant-path", value = CreateDatedExtantPathItem },
  --[[   { key = "category-date-dir-structure-contained-item", value = CreateCategoryDateDirStructureContainedItem },
 ]]
  }),
  action_table = concat({
    {
      text = "???? op.",
      key = "open-path"
    },
    {
      text = "??????????????? oppnt.",
      key = "open-parent"
    },
    {
      text = "???????? opfd.",
      key = "open-path-in-finder"
    },
    {
      text = "???????????? cntvscur.",
      key = "open-contents-in-current-vscode-window"
    },
    {
      text = "?????????????? cntvscnew.",
      key = "open-contents-in-new-vscode-window"
    },{
      text = "???????? cmv.",
      key = "do-interactive",
      args = {thing = "target path", key = "move-safe-and-choose-action"}
    },{
      text = "?????????????? cmvfrc.",
      key = "do-interactive",
      args = {thing = "target path", key = "move-force-and-choose-action"}
    },{
      text = "???????? ccpy.",
      key = "do-interactive",
      args = {thing = "target path", key = "copy-safe-and-choose-action"}
    },{
      text = "?????????????? ccpyfrc.",
      key = "do-interactive",
      args = {thing = "target path", key = "copy-force-and-choose-action"}
    },
    {
      text = "???????? mvdl.",
      key = "move-safe",
      args = env.DOWNLOADS
    },{
      text = "???????????? cmvup.",
      key = "move-up-and-choose-action",
    },
    {
      text = "???????? czip.",
      key = "zip-and-choose-action",
    },{
      text = "???????? cem.",
      key = "send-in-email-and-choose-action"
    },
    {
      text = "?????????????? ccrsbl.",
      key = "do-interactive",
      args = {thing = "file name", key = "create-sibling-file-and-choose-action"}
    }, {
      text = "?????????????? cmtime.",
      key = "choose-action-on-result-of-get",
      args = {
        key = "path-date-item",
        args = "modification"
      }
    }, {
      text = "???????????? catime.",
      key = "choose-action-on-result-of-get",
      args = {
        key = "path-date-item",
        args = "access"
      }
    },{
      text = "??????????????????????? cctime.",
      key = "choose-action-on-result-of-get",
      args = {
        key = "path-date-item",
        args = "change"
      }
    },{
      text = "???????????? ccrtime.",
      key = "choose-action-on-result-of-get",
      args = {
        key = "path-date-item",
        args = "creation"
      }
    }
  }, getChooseItemTable({
    {
      description = "pthsz",
      key = "path-size",
      emoji_icon = "????",
    }
  }))
}

--- @type BoundNewDynamicContentsComponentInterface
CreateExtantPathItem = bindArg(NewDynamicContentsComponentInterface, ExtantPathItemSpecifier)
