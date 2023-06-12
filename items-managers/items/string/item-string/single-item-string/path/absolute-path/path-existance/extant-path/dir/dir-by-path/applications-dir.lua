--- @type ItemSpecifier
ApplicationsDirItemSpecifier = {
  type = "applications-dir",
  properties = {
    getables = {
      ["all-applications"] = function(self)
        return transf.dir.children_filenames_array(self:get("c"))
      end,
    },
  },
  
}


--- @type BoundNewDynamicContentsComponentInterface
CreateApplicationsDirItem = bindArg(NewDynamicContentsComponentInterface, ApplicationsDirItemSpecifier)