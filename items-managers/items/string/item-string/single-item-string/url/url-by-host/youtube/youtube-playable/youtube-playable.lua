--- @type ItemSpecifier
YoutubePlayableItemItemSpecifier = {
  type = "youtube-playable",
  properties = {
    getables = {
      ["is-youtube-playlist"] = function(self)
        return stringy.endswith(self:get("url-path"), "playlist")
      end,
      ["is-youtube-video"] = function(self)
        return stringy.endswith(self:get("url-path"), "watch")
      end,
      ["youtube-playable-item-title-cleaned"] = function(self)
        return transf.youtube_video_title.cleaned(self:get("youtube-playable-item-title"))
      end,
      ["youtube-playable-item-channel-cleaned"] = function(self)
        return transf.youtube_video_channel.cleaned(self:get("youtube-playable-item-channel"))
      end,
        
    },
  
    doThisables = {
      ["add-as-m3u-ai"] = function(self)
        self:doThis("extract-attrs-from-title-channel-via-ai", {
          in_fields = { "title", "uploader" },
          out_fields = {
            {
              alias = "tcrea",
              value = "Artist"
            },
            {
              alias = "title",
              value = "Title"
            },
            {
              alias = "srs",
              value = "Series"
            },
            {
              alias = "srsrel",
              value = "Relation to series",
              explanation = "op, ed, ost, insert song, etc."
            }
          },
          do_after = function(tags)
            local cleaned = map(tags, function(v)
              return transf.string.romanized_snake(v)
            end)
            self:doThis("add-as-m3u", cleaned)
          end
        })
      end,
      ["add-as-m3u"] = function(self, deduced_tags)
        --- @type path_leaf_parts
        local specifier = {}
        local edited_tags = map(deduced_tags, {_p = "string"})
        specifier.tag = glue(edited_tags, promptUserToAddNKeyValuePairs("tag"))
        specifier.path  = promptPipeline({
          {"dir", {prompt_args = {default = env.MAUDIOVISUAL}}},
          {"string-path", {prompt_args = {message = "Subdirectory name", default = specifier.tag.srs or specifier.tag.tcrea }}},
        })
        specifier.extension = "m3u"
        local path_string = CreatePathLeafParts(specifier):get("str-item", "path-leaf-parts-as-string")
        path_string:doThis("create-file", self:get("contents"))
      end,
      ["to-stream"] = function(self, specifier)
        return CreateArray({self.root_super}):doThis("to-stream", specifier)
      end,
    }
  },
  action_table = concat(
    getChooseItemTable({
      {
        description = "ttl",
        emoji_icon = "🏧",
        key = "youtube-playable-item-title-cleaned"
      },
      {
        description = "crea",
        emoji_icon = "👩‍🎤",
        key = "youtube-playable-item-channel-cleaned"
      }
    }),
    {
      {
        text = "📌🎸🔨 addm3udet.",
        key = "add-as-m3u-deterministic",
      },
      {
        text = "📌🎸🧠 addm3uai.",
        key = "add-as-m3u-ai",
      }
    },
    createAllCreationEntryCombinations()
  ),
  potential_interfaces = ovtable.init({
    { key = "youtube-playlist", value = CreateYoutubePlaylistItem },
    { key = "youtube-video", value = CreateYoutubeVideoItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYoutubePlayableItem = function(super)
  return NewDynamicContentsComponentInterface(YoutubePlayableItemItemSpecifier, super)
end
