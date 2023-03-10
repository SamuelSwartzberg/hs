--- @type ItemSpecifier
URLByHostItemSpecifier = {
  type = "url-by-host-item",
  properties = {
    getables = {
      ["is-youtube"] = function(self) return stringy.find(self:get("url-host"), "youtube") end, 
      ["is-booru-url"] = function(self) return stringy.find(self:get("url-host"), "gelbooru") or stringy.find(self:get("url-host"), "danbooru") end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "youtube", value = CreateYoutubeItem },
    { key = "booru-url", value = CreateBooruURLItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateURLByHostItem = bindArg(NewDynamicContentsComponentInterface, URLByHostItemSpecifier)