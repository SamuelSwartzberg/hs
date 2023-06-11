--- @type ItemSpecifier
YoutubeVideoIdItemSpecifier = {
  type = "youtube-video-id",
  properties = {
    getables = {
      ["youtube-video-id"] = function(self)
        return transf.youtube_video_id.youtube_video_url(self:get("c"))
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYoutubeVideoIdItem = bindArg(NewDynamicContentsComponentInterface, YoutubeVideoIdItemSpecifier)
