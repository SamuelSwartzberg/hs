
ArrayOfYoutubeVideosSpecifier = {
  type = "array-of-youtube-videos",
  properties = {
    getables = {

    },
    doThisables = {
      ["create-youtube-playlist-with-videos"] = function(self, name)
        curl.easy({
          url = "https://www.googleapis.com/youtube/v3/playlists?part=snippet&key=" .. env.GOOGLE_API_KEY,
          httpheader = {
            "Content-Type: application/json",
            "Accept: application/json",
            "Authorization: Bearer " .. env.YOUTUBE_SCOPE_ACCESS_TOKEN,
          },
        }):setopt_postfields(json.encode({
          snippet = {
            title = name,
            description = string.format("Created at %s", os.date("%Y-%m-%dT%H:%M:%S%Z")),
          }
        })
        ):setopt_headerfunction(function(headers)
          -- print(hs.inspect(headers))
        end)
        :setopt_writefunction(function(data)
          local parsed_data = json.decode(data)
          local playlistid = parsed_data.id
          
          -- print(hs.inspect(json.decode(data)))
          return true
        end):perform():close()
      end,
          
    },
  },
  action_table = {}
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfYoutubeVideos = bindArg(NewDynamicContentsComponentInterface, ArrayOfYoutubeVideosSpecifier)
