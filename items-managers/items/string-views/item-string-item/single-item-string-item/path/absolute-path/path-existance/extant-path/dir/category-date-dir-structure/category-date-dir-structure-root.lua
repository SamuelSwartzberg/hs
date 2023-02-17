--- @type ItemSpecifier
CategoryDateDirStructureRootItemSpecifier = {
  type = "category-date-dir-structure-root",
  properties = {
    getables = {
      ["category-string-array"] = function(self)
        return self:get("child-string-array")
      end,
    },
    doThisables = {
      ["add-to-structure"] = function(self, specifier)
        local subcategory_path = self:get("contents") .. specifier.category .. "/" .. specifier.subcategory
        CreateTable(specifier.table):doThis("write-to-fs", subcategory_path)
      end,
    }
  },
}


--- @type BoundNewDynamicContentsComponentInterface
CreateCategoryDateDirStructureRootItem = bindArg(NewDynamicContentsComponentInterface, CategoryDateDirStructureRootItemSpecifier)