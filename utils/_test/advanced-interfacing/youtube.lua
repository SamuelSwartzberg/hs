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
  params = { playlistId = "PLIivdWyY5sqJ0oXcnZYqOnuNRxc0cqUzG" },
})

assertMessage(
  playlistItems[1].snippet.title,
  "Andrew Willis, Skatepark Engineer"
)

assertMessage(
  playlistItems[2].position,
  1
)

local createdPlaylistId = createYoutubePlaylist({
  title = "Test Playlist",
  description = "This is a test playlist.",
})

local createdPlaylist = rest({
  api_name = "youtube",
  endpoint = "playlists",
  params = { id = createdPlaylistId },
}).items[1]

assertMessage(
  createdPlaylist,
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
      playlistItems[2].id,
      "V4DDt30Aat4"
    )

    assertMessage(
      playlistItems[3].id,
      "OE63BYWdqC4"
    )

    assertMessage(
      playlistItems[4].id,
      "7nJdEXpvi1g"
    )

    assertMessage(
      playlistItems[5],
      nil
    )

    deleteYoutubePlaylist(createdPlaylistId)

    local playlistItems = rest({
      api_name = "youtube",
      endpoint = "playlistItems",
      params = { playlistId = createdPlaylistId },
    }).items

    assertMessage(
      playlistItems,
      {}
    )

    createYoutubePlaylist({
      title = "Test Playlist",
      description = "This is a test playlist.",
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
        playlistItems[2].id,
        "V4DDt30Aat4"
      )

      assertMessage(
        playlistItems[3].id,
        "OE63BYWdqC4"
      )

      assertMessage(
        playlistItems[4].id,
        "7nJdEXpvi1g"
      )

      assertMessage(
        playlistItems[5],
        nil
    )


    end)




  end

)