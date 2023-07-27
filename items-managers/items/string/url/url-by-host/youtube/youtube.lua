--- @type ItemSpecifier
YoutubeItemSpecifier = {
  type = "youtube",
  properties = {
    getables = {
      ["is-youtube-playable-item"] = function(self)
        return stringx.endswith(self:get("url-path"), {"watch", "playlist"})
      end,
    }
  },
  ({
    { key = "youtube-playable-item", value = CreateYoutubePlayableItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYoutubeItem = bindArg(NewDynamicContentsComponentInterface, YoutubeItemSpecifier)