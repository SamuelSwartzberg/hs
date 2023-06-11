--- @type ItemSpecifier
YoutubeChannelIdItemSpecifier = {
  type = "youtube-channel-id",
  properties = {
    getables = {
      ["youtube-feed-url"] = function(self)
        return transf.youtube_channel_id.feed_url(self:get("c"))
      end,
      ["youtube-channel-url"] = function(self)
        return transf.youtube_channel_id.channel_url(self:get("c"))
      end,
      ["youtube-channeltitle"] = function(self)
        return transf.youtube_channel_id.channel_title(self:get("c"))
      end,
    },
    doThisables = {
      ["add-to-newsboat-urls"] = function(self, category)
        CreateStringItem(env.NEWSBOAT_URLS):doThis("append-newsboat-url", {
          url = self:get("youtube-feed-url"),
          title = self:get("youtube-title"),
          category = category
        })
      end,
    },
  },
  action_table = concat(getChooseItemTable({
    {
      description = "ytfeedurl",
      emoji_icon = "🟥▶️🔶🔗",
      key = "youtube-feed-url"
    },
    {
      description = "ytchannelurl",
      emoji_icon = "🟥▶️📺🔗",
      key = "youtube-channel-url"
    },
  }),{
    {
      text = "📌🆔⛵️ addidnwsb.",
      key = "do-interactive",
      args = {
        key = "add-to-newsboat-urls",
        thing = "category"
      }
    }
  })
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYoutubeChannelIdItem = bindArg(NewDynamicContentsComponentInterface, YoutubeChannelIdItemSpecifier)
