--- @type ItemSpecifier
CategoryDateDirStructureDateContainingDirSpecifier = {
  type = "category-date-dir-structure-date-containing-dir",
  properties = {
    getables = {
      ["is-category-date-dir-structure-managed-date-dir"] = function(self)
        return self:get("is-path-leaf-date") and not stringy.endswith(self:get("resolved-path"), "_nm")
      end,
      ["child-smallest-largest-date-array"] = function(self)
        return self:get("child-string-item-array"):get("largest-and-smallest-thing", "to-date")
      end,
      ["contents-to-path-leaf-date-range"] = function(self)
        return self:get("child-smallest-largest-date-array"):get("smallest-largest-date-to-path-leaf-date-range")
      end,
      ["path-with-contents-path-leaf-date-range"] = function(self)
        return self:get("with-path-leaf-part-substituted", {
          key = "date",
          value = self:get("contents-to-path-leaf-date-range")
        })
      end,
    },
    doThisables = {
      ["rename-based-on-contents-path-leaf-date-range"] = function(self)
        self:doThis("move-safe", self:get("path-with-contents-path-leaf-date-range"))
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "category-date-dir-structure-managed-date-dir", value = CreateCategoryDateDirStructureManagedDateDir },
  })
}


--- @type BoundNewDynamicContentsComponentInterface
CreateCategoryDateDirStructureDateContainingDir = bindArg(NewDynamicContentsComponentInterface, CategoryDateDirStructureDateContainingDirSpecifier)