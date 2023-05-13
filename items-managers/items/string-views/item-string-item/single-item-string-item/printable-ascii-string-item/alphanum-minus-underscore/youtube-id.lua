--- @type ItemSpecifier
YoutubeIdItemSpecifier = {
  type = "youtube-id",
  properties = {
    getables = {
      ["to-youtube-video"] = function(self)
        return "https://www.youtube.com/watch?v=" .. self:get("value")
      end,
      ["to-youtube-playlist"] = function(self)
        return "https://www.youtube.com/playlist?list=" .. self:get("value")
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYoutubeIdItem = bindArg(NewDynamicContentsComponentInterface, YoutubeIdItemSpecifier)
