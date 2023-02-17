--- @type ItemSpecifier
YoutubeVideoItemSpecifier = {
  type = "youtube-video",
  properties = {
    getables = {
      ["single-attr"] = function(self, attr)
        return self:get("attr-inner", attr) -- attr-inner gets a single value for a video
      end,
      ["video-id"] = function(self)
        return self:get("url-query"):match("v=([^&]+)")
      end,
    },
  
    doThisables = {
    }
  },
  action_table = {}
}


CreateYoutubeVideoItem = function(super)
  return NewDynamicContentsComponentInterface(YoutubeVideoItemSpecifier, super)
end
