--- @type ItemSpecifier
PathLeafExtensionSpecifier = {
  type = "path-leaf-extension",
  properties = {
    getables = {
      ["path-leaf-extension"] = function(self)
        return getStandartizedExtension(self:get("path-leaf"))
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathLeafExtension = bindArg(NewDynamicContentsComponentInterface, PathLeafExtensionSpecifier)