--- @type ItemSpecifier
PathLeafExtensionSpecifier = {
  type = "path-leaf-extension",
  properties = {
    getables = {
      ["path-leaf-extension"] = function(self)
        return pathSlice(self:get("path-leaf"), "-1:-1", { ext_sep = true, standartize_ext = true })[1]
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathLeafExtension = bindArg(NewDynamicContentsComponentInterface, PathLeafExtensionSpecifier)