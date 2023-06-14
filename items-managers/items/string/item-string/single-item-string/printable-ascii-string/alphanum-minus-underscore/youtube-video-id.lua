--- @type ItemSpecifier
YoutubeVideoIdItemSpecifier = {
  type = "youtube-video-id",
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYoutubeVideoIdItem = bindArg(NewDynamicContentsComponentInterface, YoutubeVideoIdItemSpecifier)
