--- @type ItemSpecifier
CategoryDateDirStructureDirSpecifier = {
  type = "category-date-dir-structure-dir",
  properties = {
    getables = {
      ["is-category-date-dir-structure-date-containing-dir"] = function(self)
        self:get("child-string-array"):get("all-pass", function(self)
          return st(self):get("is-path-leaf-date")
        end)
      end,
    },
  },
  potential_interfaces = ovtable.init({
    { key = "category-date-dir-structure-date-containing-dir", value = CreateCategoryDateDirStructureDateContainingDir },
  })
}


--- @type BoundNewDynamicContentsComponentInterface
CreateCategoryDateDirStructureDir = bindArg(NewDynamicContentsComponentInterface, CategoryDateDirStructureDirSpecifier)