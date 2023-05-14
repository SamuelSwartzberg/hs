--- @type ItemSpecifier
ApplicationsDirItemSpecifier = {
  type = "applications-dir",
  properties = {
    getables = {
      ["all-applications"] = function(self)
        return self:get("child-filename-only-array")
      end,
    },
  },
  
}


--- @type BoundNewDynamicContentsComponentInterface
CreateApplicationsDirItem = bindArg(NewDynamicContentsComponentInterface, ApplicationsDirItemSpecifier)