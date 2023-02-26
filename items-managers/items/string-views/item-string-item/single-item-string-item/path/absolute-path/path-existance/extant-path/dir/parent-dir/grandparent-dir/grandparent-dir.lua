--- @type ItemSpecifier
GrandparentDirItemSpecifier = {
  type = "grandparent-dir",
  properties = {

    getables = {
      ["descendant-string-array"] = function(self) return CreateArray(itemsInPath({
        path = self:get("contents"),
        recursion = true
      })) end,
      ["raw-descendant-string-array"] = function(self) return CreateArray(itemsInPath({
        path = self:get("contents"),
        recursion = true,
      })) end,
      ["is-git-root-dir"] = function(self) 
        return self:get("raw-child-string-array"):get("some-pass", function(item) return stringy.endswith(item,".git") end)
      end,
      ["grandchildren-string-array"] = function(self)
        return self:get("child-string-array"):get("map-to-new-array", function(item)
          return itemsInPath(item)
        end):get("flatten")
      end,
      ["all-git-roots"] = function(self)
        return CreateArray(mapValueNewValue(
          itemsInPath({path = self:get("contents"), recursion = 4, include_files = false, validator_result = isGitRootDir}),
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