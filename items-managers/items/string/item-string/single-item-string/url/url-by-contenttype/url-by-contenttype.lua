--- @type ItemSpecifier
URLByContenttypeItemSpecifier = {
  type = "url-by-contenttype",
  properties = {
    getables = {
      ["is-image-url"] = function(self)
        return is.path.usable_as_filetype(self:get("url-path"), "image")
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "image-url", value = CreateImageURLItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateURLByContenttypeItem = bindArg(NewDynamicContentsComponentInterface, URLByContenttypeItemSpecifier)