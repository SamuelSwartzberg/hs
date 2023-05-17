
ArrayOfExtantPathsSpecifier = {
  type = "array-of-extant-paths",
  properties = {
    getables = {
      ["is-array-of-dirs"] = bind(isArrayOfInterfacesOfType, {a_use, "dir" }),
      ["is-array-of-files"] = bind(isArrayOfInterfacesOfType, {a_use, "file" }),
      ["is-array-of-dated-extant-paths"] = bind(isArrayOfInterfacesOfType, {a_use, "dated-extant-path" }),
      ["is-array-of-in-git-dir-path-items"] = bind(isArrayOfInterfacesOfType, {a_use, "in-git-dir-path" }),
      ["filter-to-array-of-dirs"] = function(self)
        return self:get("filter-to-array-of-type", "dir")
      end,
      ["filter-to-array-of-files"] = function(self)
        return self:get("filter-to-array-of-type", "file")
      end,
      ["filter-to-array-of-non-dotfiles"] = function(self)
        return self:get("filter-to-new-array", function(item)
          return not stringy.startswith(pathSlice(item:get("contents", "-1:-1"))[1], ".")
        end)
      end,
      ["map-to-array-of-files"] = function(self)
        return self:get("map-to-new-array", function(item)
          if item:get("is-dir") then
            return item:get("contents-to-array-of-files")
          else
            return item
          end
        end):get("flatten")
      end,
      ["map-to-array-of-path-contents-items"] = function(self)
        return self:get("map-to-new-array", function(path)
          return path:get("path-content-item")
        end)
      end,
      ["map-to-table-of-path-and-path-content-items"] = function(self)
        local tbl = map(self:get("contents"), function(path_item)
          return path_item:get("contents"), path_item:get("path-content-item")
        end, { "k", "kv" })
        return CreateTable(tbl)
      end,
      ["sorted-path-attr"] = function(self, attr)
        return self:get("sorted", function(a, b)
          return a:get("path-attr", attr) > b:get("path-attr", attr)
        end)
      end,
      ["find-largest-path-attr"] = function(self, attr)
        local sorted_by_attr = self:get("sorted-path-attr", attr)
        return sorted_by_attr[1]
      end,
      ["newest-path"] = function(self)
        return self:get("find-largest-path-attr", "creation")
      end,
    },
    doThisables = {
      ["choose-dir-until-file"] = function(self, callback)
        self:doThis("choose-item", function(item)
          if item:get("is-dir") then
            item:get("child-string-item-array"):doThis("choose-dir-until-file", callback)
          else
            callback(item)
          end
        end)
      end,
      ["choose-dir-until-file-then-choose-action"] = function(self)
        self:doThis("choose-dir-until-file", function(item)
          item:doThis("choose-action")
        end)
      end,
      ["move-all-to"] = function(self, target_dir)
        self:doThis("for-all", function(extant_path)
          createPath(target_dir) -- ensures path exists
          local path_leaf = extant_path:get("path_leaf")
          local target_path = ensureAdfix(target_dir, "/", true, false, "suf") .. path_leaf
          extant_path:doThis("move-safe", target_path)
        end)
      end,
      ["move-from-common-ancestor-to"] = function(self, target)
        local common_ancestor = self:get("common-ancestor")
        self:doThis("for-all", function(extant_path)
          local relpath = extant_path:get("relative-path-from", common_ancestor)
          local target_path = ensureAdfix(target, "/", true, false, "suf") .. relpath
          extant_path:doThis("move-safe", target_path)
        end)
      end,
      ["move-to-new-dir-under-common-ancestor"] = function(self, new_dir_name)
        local common_ancestor = self:get("common-ancestor")
        local new_dir = common_ancestor .. "/" .. new_dir_name
        self:doThis("move-all-to", new_dir)
      end
    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-dirs", value = CreateArrayOfDirs },
    { key = "array-of-files", value = CreateArrayOfFiles },
    { key = "array-of-dated-extant-paths", value = CreateArrayOfDatedExtantPaths },
    { key = "array-of-in-git-dir-path-items", value = CreateArrayOfInGitDirPathItems },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfExtantPaths = bindArg(NewDynamicContentsComponentInterface, ArrayOfExtantPathsSpecifier)