if mode == "full-test" then -- testing costs api requests and therefore money!

-- Test 1: Basic functionality
local test1Opts = {
  in_fields = {
    channel_name = "XxAimerLoverxX",
    video_title = "XxAimerLoverxX - Aimer - Last Stardust",
  },
  out_fields = {
    {value = "artist"},
    {value = "song_title"},
  },
}

fillTemplateGPT(test1Opts, function(result)
  assertMessage(result.artist, "Aimer")
  assertMessage(result.song_title, "Last Stardust")
end)

-- Test 2: Alias and explanation
local test2Opts = {
  in_fields = {
    channel_name = "PianoMaster",
    video_title = "PianoMaster - Beethoven - Moonlight Sonata (1st Movement)",
  },
  out_fields = {
    {value = "composer", alias = "artist", explanation = "The composer of the piece"},
    {value = "piece", alias = "song_title", explanation = "The title of the piece"},
    {value = "movement", explanation = "The movement of the piece"},
  },
}

fillTemplateGPT(test2Opts, function(result)
  assertMessage(result.composer, "Beethoven")
  assertMessage(result.piece, "Moonlight Sonata")
  assertMessage(result.movement, "1st Movement")
end)
else
  print("skipping...")
end