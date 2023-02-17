--- @type ItemSpecifier
PathInMspecItemSpecifier = {
  type = "path-in-mspec-item",
  properties = {
    getables = {
      ["is-path-in-mpass"] = function(self)
        return stringy.startswith(self:get("contents"), env.MPASS)
      end
    },
    doThisables = {
     
    }
  },
  potential_interfaces = ovtable.init({
    { key = "path-in-mpass", value = CreatePathInMpassItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathInMspecItem = bindArg(NewDynamicContentsComponentInterface, PathInMspecItemSpecifier)