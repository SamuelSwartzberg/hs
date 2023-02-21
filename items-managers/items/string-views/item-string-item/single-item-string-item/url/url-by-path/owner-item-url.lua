--- a owner-item url is a url whose path starts with /owner/item, such as e.g. used on github

--- @type ItemSpecifier
OwnerItemUrlItemSpecifier = {
  type = "owner-item-url-item",
  properties = {
    getables = {
      ["owner-item-part"] = function(self)
        local url_path_components = self:get("url-path-components")
        return url_path_components[1] .. "/" .. url_path_components[2]
      end,
    }
  },

}

--- @type BoundNewDynamicContentsComponentInterface
CreateOwnerItemUrlItem = bindArg(NewDynamicContentsComponentInterface, OwnerItemUrlItemSpecifier)