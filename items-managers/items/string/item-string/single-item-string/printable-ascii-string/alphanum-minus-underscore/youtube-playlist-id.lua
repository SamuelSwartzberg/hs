--- @type ItemSpecifier
YoutubePlaylistIdItemSpecifier = {
  type = "youtube-playlist-id",
  properties = {
    getables = {
      ["youtube-playlist-id"] = function(self)
        return transf.youtube_playlist_id.youtube_playlist_url(self:get("c"))
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYoutubePlaylistIdItem = bindArg(NewDynamicContentsComponentInterface, YoutubePlaylistIdItemSpecifier)
