--- @type ItemSpecifier
CategoryDateDirStructureContainedItemSpecifier = {
  type = "category-date-dir-structure-contained",
  properties = {
    getables = {
      ["is-category-date-dir-structure-dir"] = function(self)
        return testPath(self:get("contents"), "dir")
      end,
    },
  },
  potential_interfaces = ovtable.init({
    { key = "category-date-dir-structure-dir", value = CreateCategoryDateDirStructureDir },
  })
}


--- @type BoundNewDynamicContentsComponentInterface
CreateCategoryDateDirStructureContainedItem = bindArg(NewDynamicContentsComponentInterface, CategoryDateDirStructureContainedItemSpecifier)