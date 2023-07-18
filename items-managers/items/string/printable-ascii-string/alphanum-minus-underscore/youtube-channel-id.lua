--- @type ItemSpecifier
YoutubeChannelIdItemSpecifier = {
  type = "youtube-channel-id",
  action_table = {
    {
      d = "ytfeedurl",
      i = "🟥▶️🔶🔗",
      getfn = transf.youtube_channel_id.feed_url
    },
    {
      d = "ytchannelurl",
      i = "🟥▶️📺🔗",
      getfn = transf.youtube_channel_id.channel_url
    },
    {
      text = "📌🆔⛵️ addidnwsb.",
      dothis = dothis.youtube_channel_id.add_to_newsboat_urls_file,
      args = transf.table.indicated_prompt_table({ category = "string"})
    }
  }
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYoutubeChannelIdItem = bindArg(NewDynamicContentsComponentInterface, YoutubeChannelIdItemSpecifier)
