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
        st(env.NEWSBOAT_URLS):doThis("append-newsboat-url", {
          url = self:get("youtube-feed-url"),
          title = self:get("youtube-title"),
          category = category
        })
      end,
    },
  },
  action_table = concat(getChooseItemTable({
    {
      d = "ytfeedurl",
      i = "🟥▶️🔶🔗",
      key = "youtube-feed-url"
    },
    {
      d = "ytchannelurl",
      i = "🟥▶️📺🔗",
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
