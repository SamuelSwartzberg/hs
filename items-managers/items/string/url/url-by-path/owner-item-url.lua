--- a owner-item url is a url whose path starts with /owner/item, such as e.g. used on github

--- @type ItemSpecifier
OwnerItemUrlItemSpecifier = {
  type = "owner-item-url",
  properties = {
    getables = {
      ["owner-item-part"] = function(self)
        return memoize(pathSlice)(self:get("url-path"), "1:2", refstore.params.path_slice.opts.rejoin_at_end)
      end,
    }
  },

}

--- @type BoundNewDynamicContentsComponentInterface
CreateOwnerItemUrlItem = bindArg(NewDynamicContentsComponentInterface, OwnerItemUrlItemSpecifier)