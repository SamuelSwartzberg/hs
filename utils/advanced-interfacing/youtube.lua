--- @class youtubeRestSpec : RESTApiSpecifier
--- @field target? string 

--- @param spec? youtubeRestSpec
--- @param do_after? fun(result: string): nil
function youtube(spec, do_after)

  spec = spec or {}
  
  if type(spec) == "string" then
    spec = {
      target = spec
    }
  elseif isList(spec) then
    spec = {
      endpoint = spec[1],
      target = spec[2],
      params = spec[3]
    }
  elseif type(spec) == "table" then
    spec = copy(spec)
  end

  spec.params = spec.params or {}
  spec.params.part = spec.params.part or "snippet"
  spec.endpoint = spec.endpoint or "channels"
  spec.target = spec.target or "id"


  local is_nokey_endpoint = listContains(mt._list.nokey_endpoints, spec.endpoint)
  local is_extension_endpoint = is_nokey_endpoint -- may make distinction in future

  if is_nokey_endpoint then
    spec.endpoint = "noKey/" .. spec.endpoint
  end

  if is_extension_endpoint then
    spec.host = "https://yt.lemnoslife.com/"
  else
    spec.host = "https://www.googleapis.com/youtube/v3/"
    spec.api_name = "google"
    spec.oauth2_subname = "google_youtube_scope"  
    spec.oauth2_url = "https://accounts.google.com/o/oauth2/token"
  end


  local getresobj = function(result)
    local resobj = result.items[1] -- default case
    if spec.endpoint == "channels" and spec.target == "title" then
      resobj = resobj.snippet
    end
    return resobj
  end

  if do_after then
    rest(spec, function(result)
      do_after(getresobj(result)[spec.target])
    end)
  else
    local result = rest(spec)
    return getresobj(result)[spec.target]
  end
end

--- @param spec {name?: string, description?: string, privacyStatus?: string, videos?: string[]}
--- @param do_after? fun(result: string): nil
function createYoutubePlaylist(spec, do_after)
  youtube({
    endpoint = "playlists",
    params = { part = "snippet,status" },
    request_verb = "POST",
    request_table = {
      snippet = {
        title = spec.name or string.format("Playlist from %s", os.date("%Y-%m-%dT%H:%M:%S%Z")),
        description = spec.description or string.format("Created at %s", os.date("%Y-%m-%dT%H:%M:%S%Z")),
      }
    },
    target = "id",
  }, function(id)
    if spec.videos then
      for index, video_id in ipairs(spec.videos) do
        youtube({
          endpoint = "playlistItems",
          request_verb = "POST",
          request_table = {
            snippet = {
              playlistId = id,
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
    else
      if do_after then
        do_after(id)
      end
    end
  end)
end