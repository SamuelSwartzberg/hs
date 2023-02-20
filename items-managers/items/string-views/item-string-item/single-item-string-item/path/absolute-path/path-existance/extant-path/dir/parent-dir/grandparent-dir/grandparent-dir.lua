--- @type ItemSpecifier
GrandparentDirItemSpecifier = {
  type = "grandparent-dir",
  properties = {

    getables = {
      ["descendant-string-array"] = function(self) return CreateArray(getUserUsefulFilesInPath(self:get("contents"), true, true, true)) end,
      ["raw-descendant-string-array"] = function(self) return CreateArray(getAllInPath(self:get("contents"), true, true, true)) end,
      ["is-git-root-dir"] = function(self) 
        return self:get("raw-child-string-array"):get("some-pass", function(item) return stringy.endswith(item,".git") end)
      end,
      ["grandchildren-string-array"] = function(self)
        return self:get("child-string-array"):get("map-to-new-array", function(item)
          return getUserUsefulFilesInPath(item, false, true, true)
        end):get("flatten")
      end,
      ["all-git-roots"] = function(self)
        return CreateArray(mapValueNewValue(
          getDirsThatAreGitRootsInPath(self:get("contents"), 4),
          function(git_dir)
            return CreateStringItem(git_dir)
          end
        ))
      end,
    },
  
    doThisables = {
      
      ["git-pull-all"] = function (self)
        self:get("all-git-roots"):doThis("do-all", "git-pull")
      end

    }
  },
  potential_interfaces = ovtable.init({
    { key = "git-root-dir", value = CreateGitRootDirItem },
  }),
  action_table = {
    

  }
}


--- @type BoundNewDynamicContentsComponentInterface
CreateGrandparentDirItem = bindArg(NewDynamicContentsComponentInterface, GrandparentDirItemSpecifier)