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


  local is_nokey_endpoint = listContains(mt._list.nokey_endpoints, spec.endpoint)
  local is_extension_endpoint = is_nokey_endpoint -- may make distinction in future

  if is_nokey_endpoint then
    spec.endpoint = "noKey/" .. spec.endpoint
  end

  if is_extension_endpoint then
    spec.host = "yt.lemnoslife.com"
  else
    spec.host = "www.googleapis.com/youtube/v3"
    spec.api_name = "google"
  end


  local getres = function(result)
    local resobj = result.items[1] -- default case
    if -- case where relevant results are in snippet
      (
        spec.endpoint == "channels" or
        spec.endpoint == "playlists"
      )
      and 
      (
        spec.target == "title"
      )
    then
      resobj = resobj.snippet
    elseif -- case where there are more than one item
      (
        spec.endpoint == "playlistItems"
      )
    then
      resobj = result.items
    end

    if spec.target then
      return resobj[spec.target]
    else
      return resobj
    end
  end  

  if do_after then
    rest(spec, function(result)
      do_after(getres(result))
    end)
  else
    local result = rest(spec)
    return getres(result)
  end
end

--- @param id string
--- @param video_id string
--- @param index? number
--- @param do_after? fun(): nil
function addVidToPlaylist(id, video_id, index, do_after)
  youtube({
    endpoint = "playlistItems",
    request_verb = "POST",
    request_table = {
      snippet = {
        playlistId = id,
        position = index,
        resourceId = {
          kind = "youtube#video",
          videoId = video_id
        }
      }
    },
  }, do_after)
end

--- @param id string
--- @param video_ids string[]
--- @param do_after? fun(): nil
function addVidsToPlaylist(id, video_ids, do_after)
  local next_vid = sipairs(video_ids)
  local add_next_vid
  add_next_vid = function ()
    local index, video_id = next_vid()
    if index then
      addVidToPlaylist(id, video_id, index - 1, add_next_vid)
    else
      if do_after then
        do_after()
      end
    end
  end
  add_next_vid()
end

--- @param spec {name?: string, description?: string, privacyStatus?: string, videos?: string[]}
--- @param do_after? fun(result: string): nil
function createYoutubePlaylist(spec, do_after)
  local id = youtube({
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
  }, do_after and function(id)
    if spec.videos then
      addVidsToPlaylist(id, spec.videos, do_after)
    else
      do_after(id)
    end
  end)
  if not do_after then
    if spec.videos then
      addVidsToPlaylist(id, spec.videos)
    end
    return id
  end
end

--- @param id string
--- @param do_after? fun(result: string): nil
function deleteYoutubePlaylist(id, do_after)
  youtube({
    endpoint = "playlists",
    params = { id = id },
    request_verb = "DELETE",
    target = "id",
  }, do_after)
end
