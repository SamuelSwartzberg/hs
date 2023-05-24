local google_dev_id = youtube({
  endpoint = "channels",
  target = "id",
  params = { forUsername = "GoogleDevelopers" }
})

assertMessage(
  google_dev_id,
  "UC_x5XG1OV2P6uZZ5FSM9Ttw"
)

local playlistItems = youtube({
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

local createdPlaylist = youtube({
  endpoint = "playlists",
  params = { id = createdPlaylistId },
  target = "title",
})

assertMessage(
  createdPlaylist,
  "Test Playlist"
)

addVidToPlaylist(
  createdPlaylistId,
  "M7FIvfx5J10",
  0
)

local playlistItems = youtube({
  endpoint = "playlistItems",
  params = { playlistId = createdPlaylistId },
})

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

    local playlistItems = youtube({
      endpoint = "playlistItems",
      params = { playlistId = createdPlaylistId },
    })

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

    local playlistItems = youtube({
      endpoint = "playlistItems",
      params = { playlistId = createdPlaylistId },
    })

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
      
      local playlistItems = youtube({
        endpoint = "playlistItems",
        params = { playlistId = id },
      })

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