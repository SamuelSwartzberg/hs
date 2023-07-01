--- @type ItemSpecifier
ExtantPathItemSpecifier = {
  type = "extant-path",
  properties = {
    getables = {
      -- ["is-category-date-dir-structure-contained-item"] = function(self)
      --   return stringy.startswith(self:get("completely-resolved-path"), env.MDIARY) -- currently the only category-date-dir-structure-root is env.MDIARY, and this check is far cheaper then the alternative, so we'll use it for now
      -- end, 
      ["is-dir"] = function(self) return testPath(self:get("c"), "dir") end,
      ["is-file"] = function(self) return not self:get("is-dir") end, 
      ["is-dated-extant-path"] = function(self) 
        local path_leaf = pathSlice(self:get("completely-resolved-path", "-1:-1"))[1]
        return 
          path_leaf:match("^(.-)%-%-") 
          or path_leaf:match("^(%d[^%%]+)") 
      end, 
      ["is-in-git-dir-path"] = function(self) 
        return find(
          getItemsForAllLevelsInSlice(self:get("c"), "1:-1", { include_files = false }),
          function(item)
            return stringy.endswith(item, ".git")
          end
        )
      end,
    },
    doThisables = {
      ["cd-and-run-this-task"] = function(self, task)
        run(self:get("cd-and-this-task", task))
      end,
      ["open-path"] = function (self, app)
        open({path = self:get("completely-resolved-path"), app = app})
      end,
      ["open-parent"] = function (self, app)
        open({path = self:get("parent-dir-path"), app = app})
      end,
      ["open-path-in-finder"] = function(self)
        hs.execute("open -R '" .. self:get("completely-resolved-path") .. "'")
      end,
      ["open-with-application"] = function(self, application)
        run({
          "open",
          "-a",
          application,
          { value = self:get("completely-resolved-path"), type = "quoted" }
        }, true)
      end,
      ["open-contents-in-new-vscode-window"] = function(self)
        -- this should ideally use the `code` command, but it is currently broken
        open(self:get("completely-resolved-path"))
      end,
      ["open-contents-in-current-vscode-window"] = function(self)
        -- this should ideally use the `code` command, but it is currently broken
        open(self:get("completely-resolved-path"))
      end,
      ["move-safe"] = function(self, target)
        srctgt("move", self:get("c"), target, "not-exists")
      end,
      ["move-force"] = function(self, target)
        srctgt("move", self:get("c"), target)
      end,
      ["move-replace-self"] = function(self, origin)
        srctgt("move", origin, self:get("c"))
      end,
      ["move-into-dir"] = function (self, target)
        srctgt("move", self:get("c"), target, nil, true, true)
      end,
      ["move-safe-and-choose-action"] = function(self, target)
        self:doThis("move-safe", target)
        st(target):doThis("choose-action")
      end,
      ["move-force-and-choose-action"] = function(self, target)
        self:doThis("move-force", target)
        st(target):doThis("choose-action")
      end,
      ["move-up-and-choose-action"] = function(self)
        self:doThis("move-safe-and-choose-action", self:get("parent-dir-path"))
      end,
      ["copy-safe"] = function(self, target)
        srctgt("copy", self:get("c"), target, "not-exists")
      end,
      ["copy-force"] = function(self, target)
        srctgt("copy", self:get("c"), target)
      end,
      ["copy-safe-and-choose-action"] = function(self, target)
        self:doThis("copy-safe", target)
        st(target):doThis("choose-action")
      end,
      ["copy-force-and-choose-action"] = function(self, target)
        self:doThis("copy-force", target)
        st(target):doThis("choose-action")
      end,
      ["rename"] = function(self, new_name)
        local new_path = self:get("parent-dir-path") .. "/" .. new_name
        self:get("move-safe", new_path)
      end,
      ["zip"] = function(self, target_path)
        srctgt("zip", self:get("c"), target_path)
      end,
      ["zip-and-choose-action"] = function(self, target_path)
        srctgt("zip", self:get("c"), target_path, function(target)
          st(target):doThis("choose-action")
        end)
      end,
      ["send-in-email-and-choose-action"] = function(self)
        self:doThis("send-in-email", function(target)
          st(target):doThis("choose-action")
        end)
      end,
      ["create-sibling-file-and-choose-action"] = function(self, filename)
        local path = self:get("parent-dir-path") .. "/" .. filename
        writeFile(path, "", "not-exists")
        st(path):doThis("choose-action")
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
  action_table = {
    {
      text = "🗄 op.",
      key = "open-path"
    },
    {
      text = "🗄👩‍👧 oppnt.",
      key = "open-parent"
    },
    {
      text = "🗄👤 opfd.",
      key = "open-path-in-finder"
    },
    {
      text = "🎒🔷🈁 cntvscur.",
      key = "open-contents-in-current-vscode-window"
    },
    {
      text = "🎒🔷✳️ cntvscnew.",
      key = "open-contents-in-new-vscode-window"
    },{
      text = "👉📁 cmv.",
      key = "do-interactive",
      args = {thing = "target path", key = "move-safe-and-choose-action"}
    },{
      text = "👉📁❗️ cmvfrc.",
      key = "do-interactive",
      args = {thing = "target path", key = "move-force-and-choose-action"}
    },{
      text = "👉📋 ccpy.",
      key = "do-interactive",
      args = {thing = "target path", key = "copy-safe-and-choose-action"}
    },{
      text = "👉📋❗️ ccpyfrc.",
      key = "do-interactive",
      args = {thing = "target path", key = "copy-force-and-choose-action"}
    },
    {
      text = "📁📥 mvdl.",
      key = "move-safe",
      args = env.DOWNLOADS
    },{
      text = "👉📁🔼 cmvup.",
      key = "move-up-and-choose-action",
    },
    {
      text = "👉🤐 czip.",
      key = "zip-and-choose-action",
    },{
      text = "👉📧 cem.",
      key = "send-in-email-and-choose-action"
    },
    {
      text = "👉🌄▶️ ccrsbl.",
      key = "do-interactive",
      args = {thing = "file name", key = "create-sibling-file-and-choose-action"}
    }, {
      text = "👉✏️🕚 cmdt.",
      filter = dat,
      getfn = transf.path.m_date
    }, {
      text = "🫳🕚 cadt.",
      filter = dat,
      getfn = transf.path.a_date
    },{
      text = "👩🏽‍💻🕚 ccdt.",
      filter = dat,
      getfn = transf.path.c_date
    },{
      text = "🌄🕚 ccrdt.",
      filter = dat,
      getfn = transf.path.cr_date
    },
    {
      d = "📏 pthsz.",
      getfn = transf.path.size
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateExtantPathItem = bindArg(NewDynamicContentsComponentInterface, ExtantPathItemSpecifier)