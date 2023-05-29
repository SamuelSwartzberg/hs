--- @param id string
--- @param video_id string
--- @param index? number
--- @param do_after? fun(): nil
function addVidToPlaylist(id, video_id, index, do_after)
  rest({
    api_name = "youtube",
    endpoint = "playlistItems",
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
  local id = rest({
    api_name = "youtube",
    endpoint = "playlists",
    params = { part = "snippet,status" },
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
  rest({
    api_name = "youtube",
    endpoint = "playlists",
    params = { id = id },
    request_verb = "DELETE",
    target = "id",
  }, do_after)
end
