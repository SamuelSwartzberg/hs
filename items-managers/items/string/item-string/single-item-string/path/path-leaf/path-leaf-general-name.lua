--- @type ItemSpecifier
PathLeafDateSpecifier = {
  type = "path-leaf-general-name",
  properties = {
    getables = {
      ["path-leaf-general-name"] = function(self) 
        local path_leaf =  self:get("path-leaf")
        return path_leaf:match("^.---([^%%]+)$") or path_leaf:match("^(%D[^%%]*)$") 
      end,
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathLeafGeneralName = bindArg(NewDynamicContentsComponentInterface, PathLeafDateSpecifier)
