--- @type ItemSpecifier
URLByPathItemSpecifier = {
  type = "url-by-path",
  properties = {
    getables = {
      ["is-owner-item-url"] = function(self) 
        local url_path_components = self:get("url-path-slice", {":"})
        return #url_path_components >= 2
      end
    }
  },
  potential_interfaces = ovtable.init({
    { key = "owner-item-url", value = CreateOwnerItemUrlItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateURLByPathItem = bindArg(NewDynamicContentsComponentInterface, URLByPathItemSpecifier)