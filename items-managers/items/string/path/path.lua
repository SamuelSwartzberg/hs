--- @type ItemSpecifier
PathItemSpecifier = {
  type = "path",
  properties = {
    getables = {
      ["is-absolute-path"] = function(self) 
        return stringy.startswith(self:get("c"), "/") or stringy.startswith(self:get("c"), "~")
      end,
      ["is-relative-path"] = function(self) return not self:get("is-absolute-path") end,
      ["is-path-leaf"] = transf["nil"]["true"],
      ["is-in-path"] = function(self, path) return stringy.startswith(self:get("resolved-path"), path) end,
    }
  },
  ({
    { key = "absolute-path", value = CreateAbsolutePathItem },
    { key = "relative-path", value = CreateRelativePathItem },
    { key = "path-leaf", value = CreatePathLeaf },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathItem = bindArg(NewDynamicContentsComponentInterface, PathItemSpecifier)
