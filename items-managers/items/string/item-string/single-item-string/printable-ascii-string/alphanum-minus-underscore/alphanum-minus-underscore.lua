--- @type ItemSpecifier
AlphanumMinusUnderscoreItemSpecifier = {
  type = "alphanum-minus-underscore",
  properties = {
    getables = {
      ["is-word"] = function(self) 
        return is.alphanum_minus_underscore.word(self:get("contents"))
      end,
      ["is-alphanum-minus"] = function(self)
        return is.alphanum_minus_underscore.alphanum_minus(self:get("contents"))
      end,
      ["is-youtube-id"] = function(self)
        return is.alphanum_minus_underscore.youtube_id(self:get("contents"))
      end,
      ["is-youtube-channel-id"] = function(self)
        return is.alphanum_minus_underscore.youtube_channel_id(self:get("contents"))
      end,
      ["is-package-manager"] = function(self)
        return is.alphanum_minus_underscore.package_manager(self:get("contents"))
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "word", value = CreateWordItem },
    { key = "alphanum-minus", value = CreateAlphanumMinusItem },
    { key = "youtube-id", value = CreateYoutubeIdItem },
    { key = "youtube-channel-id", value = CreateYoutubeChannelIdItem },
    { key = "package-manager", value = CreatePackageManagerItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateAlphanumMinusUnderscoreItem = bindArg(NewDynamicContentsComponentInterface, AlphanumMinusUnderscoreItemSpecifier)
