
ArrayOfInGitDirPathItemsSpecifier = {
  type = "array-of-in-git-dir-paths",
  properties = {
    getables = {
      ["filter-to-uncommitted-git-root-dirs"] = function(self)
        return self:get("filter-to-new-array", function(item)
          return item:get("has-changes")
        end)
      end,
      ["filter-to-unpushed-git-root-dirs"] = function(self)
        return self:get("filter-to-new-array", function(item)
          return item:get("has-unpushed")
        end)
      end,
    },
    doThisables = {
    },
  },
  action_table = {
    {
      text = "🐙⬆️全 gtpshall.",
      key = "do-all",
      args = { key = "git-push"}
    },{
      text = "🐙⬇️全 gtpllall.",
      key = "do-all",
      args = { key = "git-pull"}
    },{
      text = "🐙🔄全 gtftchall.",
      key = "do-all",
      args = { key = "git-fetch"}
    },{
      text = "🐙📝全 gtcmmtall.",
      key = "do-all",
      args = { 
        key = "do-interactive",
        args = {
          key = "git-commit-all"
        }
      }
      
    },
  },
  
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfInGitDirPathItems = bindArg(NewDynamicContentsComponentInterface, ArrayOfInGitDirPathItemsSpecifier)