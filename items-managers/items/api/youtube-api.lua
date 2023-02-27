local youtube_auth_params_env_var_map = {
  client_id = "GOOGLE_OAUTH_CLIENT_ID",
  client_secret = "GOOGLE_OAUTH_CLIENT_SECRET",
  refresh_token = "YOUTUBE_SCOPE_REFRESH_TOKEN",
  access_token = "YOUTUBE_SCOPE_ACCESS_TOKEN",
}

--- @type ItemSpecifier
YoutubeApiItemSpecifier = {
  type = "youtube-api-item",
  properties = {
    getables = {
      ["access-token"] = function() return nil end, -- todo
      ["refreshed-tokens"] = function(self)
        local json_output = runJSON({
          "curl",
          "--request", "POST",
          "--data", { 
            value = "client_id=$GOOGLE_OAUTH_CLIENT_ID"
            .. "&client_secret=$GOOGLE_OAUTH_CLIENT_SECRET"
            .. "&refresh_token=$YOUTUBE_SCOPE_REFRESH_TOKEN"
            .. "&grant_type=refresh_token",
            type = "quoted"
          },
          {value = "https://accounts.google.com/o/oauth2/token", type = "quoted"},
        })
        return {
          access_token = json_output.access_token,
          refresh_token = json_output.refresh_token,
        }
      end,
      ["auth-params-env-var-map"] = function()
        return youtube_auth_params_env_var_map
      end,
    },
    doThisables = {
      ["refresh-tokens"] = function(self)
        specifier = {
          host = "https://accounts.google.com",
          endpoint = "o/oauth2/token",
          request_table = {
            client_id = env.GOOGLE_OAUTH_CLIENT_ID,
            client_secret = env.GOOGLE_OAUTH_CLIENT_SECRET,
            refresh_token = env.YOUTUBE_SCOPE_REFRESH_TOKEN,
            grant_type = "refresh_token",
          },
          request_verb = "POST",
        }
        makeSimpleRESTApiRequest(specifier, function(data)
          env.YOUTUBE_SCOPE_ACCESS_TOKEN = data.access_token
          env.YOUTUBE_SCOPE_REFRESH_TOKEN = data.refresh_token
        end)
      end,
      ["api-message"] = function(self, specifier)
        local local_specifier = {
          host = "https://www.googleapis.com",
          endpoint = "youtube/v3/" .. specifier.endpoint,
          params = mergeAssocArrRecursive({
            part = "snippet",
            key = env.GOOGLE_API_KEY,
          }, specifier.params or {}),
          api_key = env.YOUTUBE_SCOPE_ACCESS_TOKEN
        }
        specifier = mergeAssocArrRecursive(local_specifier, specifier)
        makeSimpleRESTApiRequest(specifier, specifier.do_after)
      end,
      ["create-youtube-playlist"] = function(self, specifier)
        self:doThis("api-message", {
          endpoint = "playlists",
          params = { part = "snippet,status" },
          request_verb = "POST",
          request_table = {
            snippet = {
              title = specifier.name,
              description = string.format("Created at %s", os.date("%Y-%m-%dT%H:%M:%S%Z")),
            }
          },
          do_after = specifier.do_after
        })
      end,
      ["create-youtube-playlist-with-videos"] = function(self, specifier)
        self:doThis("create-youtube-playlist", {
          name = specifier.name,
          do_after = function(response)
            local playlist_id = response.id

            for index, video_id in ipairs(specifier.videos) do
              self:doThis("async-post", {
                endpoint = "playlistItems",
                request_verb = "POST",
                request_table = {
                  snippet = {
                    playlistId = playlist_id,
                    position = index - 1,
                    resourceId = {
                      kind = "youtube#video",
                      videoId = video_id,
                    }
                  }
                },
                do_after = function(response)
                  inspPrint(response)
                  -- todo: return url or something
                end
              })
            end            
          end,
        })
      end,
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYoutubeApiItem = bindArg(NewDynamicContentsComponentInterface, YoutubeApiItemSpecifier)

