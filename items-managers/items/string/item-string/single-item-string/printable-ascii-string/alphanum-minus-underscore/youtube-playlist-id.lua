--- @type ItemSpecifier
YoutubePlaylistIdItemSpecifier = {
  type = "youtube-playlist-id",
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYoutubePlaylistIdItem = bindArg(NewDynamicContentsComponentInterface, YoutubePlaylistIdItemSpecifier)
