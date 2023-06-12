--- @type ItemSpecifier
URLByContenttypeItemSpecifier = {
  type = "url-by-contenttype",
  properties = {
    getables = {
      ["is-image-url"] = function(self)
        return get.path.usable_as_filetype(self:get("url-path"), "image")
      end,
      ["is-playable-url"] = function(self)
        return get.path.usable_as_filetype(self:get("url-path"), "playable")
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "image-url", value = CreateImageURLItem },
    { key = "playable-url", value = CreatePlayableURLItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateURLByContenttypeItem = bindArg(NewDynamicContentsComponentInterface, URLByContenttypeItemSpecifier)