
ArrayOfYoutubeVideosSpecifier = {
  type = "array-of-youtube-videos",
  properties = {
    getables = {

    },
    doThisables = {
      ["create-youtube-playlist-with-videos"] = function(self, name)
        createYoutubePlaylist({videos = self:get("c"), name = name})
      end,
          
    },
  },
  action_table = {}
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfYoutubeVideos = bindArg(NewDynamicContentsComponentInterface, ArrayOfYoutubeVideosSpecifier)
