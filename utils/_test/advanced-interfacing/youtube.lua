-- access and refresh tokens should already exist here, since we ran the oauth2 flow in the previous test, and don't want to test it here

assert(
  readFile(env.MAPI .. "/google/access_token") ~= ""
)

assert(
  readFile(env.MAPI .. "/google/refresh_token") ~= ""
)

local playlistItems = rest({
  api_name = "youtube",
  endpoint = "playlistItems",
  params = { playlistId = "PLBCF2DAC6FFB574DE" },
}).items

assertMessage(
  playlistItems[1].snippet.title,
  "Andrew Willis, Skatepark Engineer"
)

assertMessage(
  playlistItems[2].snippet.position,
  1
)

createYoutubePlaylist({
  title = "Test Playlist",
  description = "This is a test playlist created at " .. os.date("%Y-%m-%dT%H:%M:%S%Z"),
}, function (createdPlaylistId)
    
  local createdPlaylist = rest({
    api_name = "youtube",
    endpoint = "playlists",
    params = { id = createdPlaylistId },
  }).items[1]

  assertMessage(
    createdPlaylist.id,
    createdPlaylistId
  )

  assertMessage(
    createdPlaylist.snippet.title,
    "Test Playlist"
  )

  addVidToPlaylist(
    createdPlaylistId,
    "M7FIvfx5J10",
    0
  )

  local playlistItems = rest({
    api_name = "youtube",
    endpoint = "playlistItems",
    params = { playlistId = createdPlaylistId },
  }).items

  assertMessage(
    playlistItems[1].snippet.title,
    "Volvo Trucks - The Epic Split feat. Van Damme (Live Test)"
  )

  assertMessage(
    playlistItems[2],
    nil
  )

  addVidsToPlaylist(
    createdPlaylistId,
    {
      "V4DDt30Aat4",
      "OE63BYWdqC4",
      "7nJdEXpvi1g"
    },
    function()

      local playlistItems = rest({
        api_name = "youtube",
        endpoint = "playlistItems",
        params = { playlistId = createdPlaylistId },
      }).items

      assertMessage(
        playlistItems[1].snippet.title,
        "Volvo Trucks - The Epic Split feat. Van Damme (Live Test)"
      )

      assertMessage(
        playlistItems[2].snippet.title,
        "Mark Lesek: A New/Old Prosthetic"
      )

      assertMessage(
        playlistItems[3].snippet.title,
        "Zack Matere: Growing Knowledge"
      )

      assertMessage(
        playlistItems[4].snippet.title,
        "The Tofino Riders: A 1,000 Year-Old-Wave"
      )

      assertMessage(
        playlistItems[5],
        nil
      )

      deleteYoutubePlaylist(createdPlaylistId)

      local succ, res = pcall(rest,{
        api_name = "youtube",
        endpoint = "playlistItems",
        params = { playlistId = createdPlaylistId },
      })

      assert(not succ)

      createYoutubePlaylist({
        videos = {
          "M7FIvfx5J10",
          "V4DDt30Aat4",
          "OE63BYWdqC4",
          "7nJdEXpvi1g"
        }
      }, function (id)
        
        local playlistItems = rest({
          api_name = "youtube",
          endpoint = "playlistItems",
          params = { playlistId = id },
        }).items

        assertMessage(
          playlistItems[1].snippet.title,
          "Volvo Trucks - The Epic Split feat. Van Damme (Live Test)"
        )
  
        assertMessage(
          playlistItems[2].snippet.title,
          "Mark Lesek: A New/Old Prosthetic"
        )
  
        assertMessage(
          playlistItems[3].snippet.title,
          "Zack Matere: Growing Knowledge"
        )
  
        assertMessage(
          playlistItems[4].snippet.title,
          "The Tofino Riders: A 1,000 Year-Old-Wave"
        )
  
        assertMessage(
          playlistItems[5],
          nil
        )

        deleteYoutubePlaylist(id)


      end)




    end

  )
end)
