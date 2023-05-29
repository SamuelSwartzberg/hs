--- @type ItemSpecifier
YoutubeChannelIdItemSpecifier = {
  type = "youtube-channel-id",
  properties = {
    getables = {
      ["youtube-feed-url"] = function(self)
        return "https://www.youtube.com/feeds/videos.xml?channel_id=" .. self:get("contents")
      end,
      ["youtube-channel-url"] = function(self)
        return "https://www.youtube.com/channel/" .. self:get("contents")
      end,
      ["youtube-pretty-name"] = function(self)
        return memoize(rest, refstore.params.memoize.opts.invalidate_1_month_fs)({
          api_name = "youtube",
          endpoint = "channels",
          params = { id = self:get("contents")}
        }).items[1].snippet.title
      end,
    },
    doThisables = {
      ["add-to-newsboat-urls"] = function(self, category)
        CreateStringItem(env.NEWSBOAT_URLS):doThis("append-newsboat-url", {
          url = self:get("youtube-feed-url"),
          title = self:get("youtube-pretty-name"),
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
