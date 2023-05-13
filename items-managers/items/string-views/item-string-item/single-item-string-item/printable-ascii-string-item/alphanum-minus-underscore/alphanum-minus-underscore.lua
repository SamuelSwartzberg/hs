--- @type ItemSpecifier
AlphanumMinusUnderscoreItemSpecifier = {
  type = "alphanum-minus-underscore",
  properties = {
    getables = {
      ["is-word"] = function(self) 
        return not string.find(self:get("contents"), "-")
      end,
      ["is-alphanum-minus"] = function(self)
        return not string.find(self:get("contents"), "_")
      end,
      ["is-youtube-id"] = function(self)
        return #self:get("contents") == 11 -- not officially specified, but b/c 64^11 > 2^64 > 64^10 and 64 chars in base64, allowing for billions of ids per living person, unlikely to change
      end,
      ["is-youtube-channel-id"] = function(self)
        return #self:get("contents") == 24 -- standartized length
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "word", value = CreateWordItem },
    { key = "alphanum-minus", value = CreateAlphanumMinusItem },
    { key = "youtube-id", value = CreateYoutubeIdItem },
    { key = "youtube-channel-id", value = CreateYoutubeChannelIdItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateAlphanumMinusUnderscoreItem = bindArg(NewDynamicContentsComponentInterface, AlphanumMinusUnderscoreItemSpecifier)
