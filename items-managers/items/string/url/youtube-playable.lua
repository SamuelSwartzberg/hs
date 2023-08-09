--- @type ItemSpecifier
YoutubePlayableItemItemSpecifier = {
  type = "youtube-playable",
  properties = {
    
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
            local cleaned = hs.fnutils.imap(tags,transf.string.lower_snake_case_string_by_romanized)
            self:doThis("add-as-m3u", cleaned)
          end
        })
      end,
      ["add-as-m3u"] = function(self, deduced_tags)
        local specifier = {}
        local edited_tags = transf.string_value_dict.string_value_dict_by_prompted_once_from_default(deduced_tags)
        specifier.tag = transf.two_array_or_nils.array(edited_tags, transf.string.prompted_multiple_string_pair_array_for("tag"))
        specifier.path  = promptPipeline({
          {"dir", {prompt_args = {default = env.MAUDIOVISUAL}}},
          {"string", {prompt_args = {message = "Subdirectory name", default = specifier.tag.srs or specifier.tag.tcrea }}},
        })
        specifier.extension = "m3u"
        dothis.absolute_path.write_file(transf.path_leaf_specifier.path(specifier), self:get("c"))
      end,
      ["to-stream"] = function(self, specifier)
        return ar({self.root_super}):doThis("to-stream", specifier)
      end,
    }
  },
}
