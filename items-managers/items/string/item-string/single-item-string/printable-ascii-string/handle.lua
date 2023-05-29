--- @type ItemSpecifier
HandleItemSpecifier = {
  type = "handle",
  properties = {
    getables = {
      ["raw-handle"] = function(self)
        return self:get("contents"):sub(2) -- remove the leading @
      end,
      ["youtube-channel-id"] = function(self)
        return memoize(rest, refstore.params.memoize.opts.invalidate_1_month_fs)({
          api_name = "youtube",
          endpoint = "channels",
          params = { handle = self:get("contents")}
        }).items[1].id
      end,
      ["youtube-feed-url"] = function(self)
        return self:get("str-item", "youtube-channel-id"):get("youtube-feed-url")
      end,
      ["youtube-pretty-name"] = function(self)
        return self:get("str-item", "youtube-channel-id"):get("youtube-pretty-name")
      end,
    },
    doThisables = {
      ["add-to-newsboat-urls"] = function(self, category)
        self:get("str-item", "youtube-channel-id"):doThis("add-to-newsboat-urls", category)
      end,
    }
  },
  
  action_table = concat(getChooseItemTable({
    {
      description = "ytchannelid",
      emoji_icon = "🟥▶️📺🆔",
      key = "youtube-channel-id"
    },
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
      text = "📌@⛵️ addhndlnwsb.",
      key = "do-interactive",
      args = {
        key = "add-to-newsboat-urls",
        thing = "category"
      }
    }
  })

}

--- @type BoundNewDynamicContentsComponentInterface
CreateHandleItem = bindArg(NewDynamicContentsComponentInterface, HandleItemSpecifier)