--- @type ItemSpecifier
CategoryDateDirStructureContainedItemSpecifier = {
  type = "category-date-dir-structure-contained-item",
  properties = {
    getables = {
      ["is-category-date-dir-structure-dir"] = function(self)
        return isDir(self:get("contents"))
      end,
    },
  },
  potential_interfaces = ovtable.init({
    { key = "category-date-dir-structure-dir", value = CreateCategoryDateDirStructureDir },
  })
}


--- @type BoundNewDynamicContentsComponentInterface
CreateCategoryDateDirStructureContainedItem = bindArg(NewDynamicContentsComponentInterface, CategoryDateDirStructureContainedItemSpecifier)