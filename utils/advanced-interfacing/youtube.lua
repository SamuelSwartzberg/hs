--- @param spec {title?: string, description?: string, privacyStatus?: string, videos?: string[]}
--- @param do_after? fun(id: string): nil
function createYoutubePlaylist(spec, do_after)
  local result = rest({
    api_name = "youtube",
    endpoint = "playlists",
    params = { part = "snippet,status" },
    request_table = {
      snippet = {
        title = spec.title or string.format("Playlist from %s", os.date("%Y-%m-%dT%H:%M:%S%Z")),
        description = spec.description or string.format("Created at %s", os.date("%Y-%m-%dT%H:%M:%S%Z")),
      }
    },
  }, do_after and function(result)
    local id = result.id
    hs.timer.doAfter(3, function () -- wait for playlist to be created, seems to not happen instantly
      if spec.videos then
        dothis.youtube_playlist_id.add_youtube_video_id_array(id, spec.videos, do_after)
      else
        do_after(id)
      end
    end)
  end)
  local id = result.id
  if not do_after then
    if spec.videos then
      dothis.youtube_playlist_id.add_youtube_video_id_array(id, spec.videos)
    end
    return id
  end
end
