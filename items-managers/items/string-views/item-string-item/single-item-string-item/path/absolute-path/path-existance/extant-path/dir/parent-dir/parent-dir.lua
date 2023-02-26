--- @type ItemSpecifier
ParentDirItemSpecifier = {
  type = "parent-dir",
  properties = {

    getables = {
      ["child-string-array"] = function(self) 
        return CreateArray(getAllInPath(self:get("contents"), false, true, true)) 
      end,
      ["find-child"] = function(self, func)
        return self:get("child-string-array"):get("find", func)
      end,
      ["child-string-item-array"] = function(self) return self:get("child-string-array"):get("to-string-item-array") end,
      ["child-file-only-string-item-array"] = function(self)
        return self:get("child-string-item-array"):get("filter-to-array-of-files")
      end,
      ["child-dir-only-string-item-array"] = function(self)
        return self:get("child-string-item-array"):get("filter-to-array-of-dirs")
      end,
      ["raw-child-string-array"] = function(self)
        return CreateArray(getAllInPath(self:get("contents"), false, true, true))
      end,
      ["children-any-pass"] = function(self, query) return self:get("child-string-item-array"):get("some-pass", query) end,
      ["is-grandparent-dir"] = function(self)
        return self:get("child-string-array"):get("some-pass", function(item)
          return isDir(item)
        end)
      end,
      ["is-parent-but-not-grandparent-dir"] = function(self)
        return not self:get("is-grandparent-dir")
      end,
      ["is-project-dir"] = function(self)
        return true -- no way to check generally, so this always returns true, and we'll check for specific project dirs in the project dir subclass
      end,
--[[       ["is-managed-date-project-dir"] = function(self)
        return self:get("child-string-item-array"):get("is-path-leaf-date-array")
      end, ]] -- currently disabled as converting to a string-item-array in an is-function of a string-item, which gets called during initialization, obviously will cause an infinite loop
      ["child-filename-only-array"] = function(self)
        return self:get("child-string-array"):get("map-to-new-array", function(item)
          return getLeafWithoutPathOrExtension(item)
        end)
      end,
      ["child-leaf-only-array"] = function(self)
        return self:get("child-string-array"):get("map-to-new-array", function(item)
          return getLeafWithoutPath(item)
        end)
      end,
      ["child-ending-with"] = function(self, ending)
        return self:get("child-string-array"):get("find", function(item)
          return stringy.endswith(item, ending)
        end)
      end,
      ["newest-child-string-item"] = function(self)
        return self:get("child-string-item-array"):get("newest-path")
      end,
    },
  
    doThisables = {
      ["choose-child"] = function(self)
        self:get("child-string-array"):doThis("choose-item-and-then-action")
      end,
      ["choose-child-file"]  = function(self)
        self:get("child-file-only-string-item-array"):doThis("choose-item-and-then-action")
      end,
      ["choose-child-dir"]  = function(self)
        self:get("child-dir-only-string-item-array"):doThis("choose-item-and-then-action")
      end,
      ["choose-child-string-item-dir"]  = function(self)
        self:get("child-dir-only-string-item-array"):doThis("choose-item-and-then-action")
      end,
      ["move-contents"] = function(self, target)
        srctgt("move", self:get("contents"), target, "any", false, false, true)
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "grandparent-dir", value = CreateGrandparentDirItem },
    { key = "parent-but-not-grandparent-dir", value = CreateParentButNotGrandparentDirItem },
    { key = "project-dir", value = CreateProjectDirItem },
--[[     { key = "managed-date-project-dir", value = CreateManagedDateProjectDirItem },
 ]]  }),
  action_table = {
    {
      text = "👉🔽 cchld.",
      key = "choose-child"
    },{
      text = "👉🕚🌄🚀🔽 cnwstchld.",
      key = "choose-action-on-result-of-get",
      args = "newest-child-string-item"
    }
  }
}


--- @type BoundNewDynamicContentsComponentInterface
CreateParentDirItem = bindArg(NewDynamicContentsComponentInterface, ParentDirItemSpecifier)