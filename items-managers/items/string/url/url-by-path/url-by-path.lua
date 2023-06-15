--- @type ItemSpecifier
URLByPathItemSpecifier = {
  type = "url-by-path",
  properties = {
    getables = {
      ["is-owner-item-url"] = function(self) 
        return #memoize(pathSlice)(self:get("url-path"), ":") >= 2
      end
    }
  },
  potential_interfaces = ovtable.init({
    { key = "owner-item-url", value = CreateOwnerItemUrlItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateURLByPathItem = bindArg(NewDynamicContentsComponentInterface, URLByPathItemSpecifier)