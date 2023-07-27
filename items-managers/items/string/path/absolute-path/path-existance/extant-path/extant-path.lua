--- @type ItemSpecifier
ExtantPathItemSpecifier = {
  type = "extant-path",
  properties = {
    getables = {
      -- ["is-category-date-dir-structure-contained-item"] = function(self)
      --   return stringy.startswith(self:get("completely-resolved-path"), env.MDIARY) -- currently the only category-date-dir-structure-root is env.MDIARY, and this check is far cheaper then the alternative, so we'll use it for now
      -- end, 
      ["is-dated-extant-path"] = function(self) 
        local path_leaf = transf.path.leaf(self:get("completely-resolved-path")[1])
        return 
          path_leaf:match("^(.-)%-%-") 
          or path_leaf:match("^(%d[^%%]+)") 
      end, 
    },
    doThisables = {
      ["cd-and-run-this-task"] = function(self, task)
        run(self:get("cd-and-this-task", task))
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
      ["copy-safe-and-choose-action"] = function(self, target)
        self:doThis("copy-safe", target)
        st(target):doThis("choose-action")
      end,
      ["copy-force-and-choose-action"] = function(self, target)
        self:doThis("copy-force", target)
        st(target):doThis("choose-action")
      end,
      ["send-in-email-and-choose-action"] = function(self)
        self:doThis("send-in-email", function(target)
          st(target):doThis("choose-action")
        end)
      end,
      ["create-sibling-file-and-choose-action"] = function(self, filename)
        local path = self:get("parent-dir-path") .. "/" .. filename
        dothis.absolute_path.write_file_if_nonextant_path(path, "")
        st(path):doThis("choose-action")
      end,

    }
  },
  ({
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
      getfn = transf.path.m_date
    }, {
      text = "🫳🕚 cadt.",
      getfn = transf.path.a_date
    },{
      text = "👩🏽‍💻🕚 ccdt.",
      getfn = transf.path.c_date
    },{
      text = "🌄🕚 ccrdt.",
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
