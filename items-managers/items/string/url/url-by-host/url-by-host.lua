--- @type ItemSpecifier
URLByHostItemSpecifier = {
  type = "url-by-host",
  properties = {
    getables = {
      ["is-youtube"] = function(self) return stringy.find(self:get("url-host"), "youtube") end, 
      ["is-booru-url"] = function(self) return stringy.find(self:get("url-host"), "gelbooru") or stringy.find(self:get("url-host"), "danbooru") or stringy.find(self:get("url-host"), "yande.re") end,
    }
  },
  ({
    { key = "youtube", value = CreateYoutubeItem },
    { key = "booru-url", value = CreateBooruURLItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateURLByHostItem = bindArg(NewDynamicContentsComponentInterface, URLByHostItemSpecifier)