--- @type ItemSpecifier
AlphanumMinusUnderscoreItemSpecifier = {
  type = "alphanum-minus-underscore",
  properties = {
    getables = {
      ["is-word"] = function(self) 
        return is.alphanum_minus_underscore.word(self:get("c"))
      end,
      ["is-alphanum-minus"] = function(self)
        return is.alphanum_minus_underscore.alphanum_minus(self:get("c"))
      end,
      ["is-youtube-video-id"] = function(self)
        return is.alphanum_minus_underscore.youtube_video_id(self:get("c"))
      end,
      ["is-youtube-channel-id"] = function(self)
        return is.alphanum_minus_underscore.youtube_channel_id(self:get("c"))
      end,
      ["is-package-manager"] = function(self)
        return is.alphanum_minus_underscore.package_manager(self:get("c"))
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "word", value = CreateWordItem },
    { key = "alphanum-minus", value = CreateAlphanumMinusItem },
    { key = "youtube-id", value = CreateYoutubeVideoIdItem },
    { key = "youtube-playlist-id", value = CreateYoutubePlaylistIdItem},
    { key = "youtube-channel-id", value = CreateYoutubeChannelIdItem },
    { key = "package-manager", value = CreatePackageManagerItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateAlphanumMinusUnderscoreItem = bindArg(NewDynamicContentsComponentInterface, AlphanumMinusUnderscoreItemSpecifier)
