--- @type ItemSpecifier
HandleItemSpecifier = {
  type = "handle",
  properties = {
    getables = {
      ["raw-handle"] = function(self)
        return transf.handle.raw_handle(self:get("c"))
      end,
      ["youtube-channel-id"] = function(self)
        return transf.handle.youtube_channel_id(self:get("c"))
      end,
      ["youtube-feed-url"] = function(self)
        return transf.handle.feed_url(self:get("c"))
      end,
      ["youtube-channel-title"] = function(self)
        return transf.handle.channel_title(self:get("c"))
      end,
    },
    doThisables = {
      ["add-to-newsboat-urls"] = function(self, category)
        self:get("str-item", "youtube-channel-id"):doThis("add-to-newsboat-urls", category)
      end,
    }
  },
  
  action_table = {
    {
      d = "ytchannelid",
      i = "🟥▶️📺🆔",
      getfn = transf.handle.youtube_channel_id,
    },
    {
      d = "ytfeedurl",
      i = "🟥▶️🔶🔗",
      getfn = transf.handle.feed_url,
    },
    {
      d = "ytchannelurl",
      i = "🟥▶️📺🔗",
      getfn = transf.handle.channel_url,
    },
    {
      text = "📌@⛵️ addhndlnwsb.",
      key = "do-interactive",
      args = {
        key = "add-to-newsboat-urls",
        thing = "category"
      }
    }
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateHandleItem = bindArg(NewDynamicContentsComponentInterface, HandleItemSpecifier)