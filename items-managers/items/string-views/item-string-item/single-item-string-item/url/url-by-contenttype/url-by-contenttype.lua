--- @type ItemSpecifier
URLByContenttypeItemSpecifier = {
  type = "url-by-contenttype-item",
  properties = {
    getables = {
      ["is-image-url"] = function(self)
        return isUsableAsFiletype(self:get("url-path"), "image")
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "image-url", value = CreateImageURLItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateURLByContenttypeItem = bindArg(NewDynamicContentsComponentInterface, URLByContenttypeItemSpecifier)