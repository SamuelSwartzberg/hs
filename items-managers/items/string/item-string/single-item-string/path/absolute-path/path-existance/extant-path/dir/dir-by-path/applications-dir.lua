--- @type ItemSpecifier
ApplicationsDirItemSpecifier = {
  type = "applications-dir",
  properties = {
    getables = {
      ["all-applications"] = function(self)
        return transf.dir_path.children_filenames_array(self:get("contents"))
      end,
    },
  },
  
}


--- @type BoundNewDynamicContentsComponentInterface
CreateApplicationsDirItem = bindArg(NewDynamicContentsComponentInterface, ApplicationsDirItemSpecifier)