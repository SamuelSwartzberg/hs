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
      ["attrs-inner-task-args"] = function(self, attrs)
        local attrs_mapped = map(attrs, function(attr)
          return "%(" .. attr ..")s"
        end)
        local attrs_joined = table.concat(attrs_mapped, env.UNLIKELY_SEPARATOR)
        return {
          "youtube-dl", 
          "--get-filename",
          "-o",
          {value =  attrs_joined, type = "quoted"},
          {value = self:get("contents"), type = "quoted"}
        }
      end,
      ["process-raw-attrs"] = function(self, specifier)
        local fields = stringx.split(specifier.raw_attr_string, env.UNLIKELY_SEPARATOR)
        local res = {}
        for i, field in iprs(fields) do
          res[specifier.attrs[i]] = stringy.strip(field)
        end
        return res
      end,
      ["attrs-sync-inner"] = function (self, attrs)
        local rawres = memoize(run)(
          self:get("attrs-inner-task-args", attrs)
        )
        return self:get("process-raw-attrs", {
          raw_attr_string = rawres,
          attrs = attrs
        })
      end,
      ["attr-inner"] = function (self, attr)
        return self:get("attrs-sync-inner", {attr})[attr]
      end,
      ["youtube-playable-item-unavailable"] = function(self)
        local output, status = run({"youtube-dl", "--get-title", self:get("contents")})
        if status ~= 0 then
          local lines = stringy.split(output, "\n")
          return find(lines, function(line)
            return stringy.startswith(line, "ERROR: Private video")
          end)
        else
          return false
        end
      end,
      ["youtube-playable-item-title"] = function(self)
        return self:get("single-attr", "title")
      end,
      ["youtube-playable-item-title-cleaned"] = function(self)
        local title = stringy.strip(self:get("youtube-playable-item-title"))
        title = replace(title, {
          { cond = {_r = mt._r.text_bloat.youtube.video, _ignore_case = true}, mode="remove" },
          { cond = {_r = mt._r.text_bloat.youtube.misc, _ignore_case = true}, mode="remove" },
        })
        local channel_cleaned = self:get("youtube-playable-item-channel-cleaned")
        if channel_cleaned ~= "" then
          title = eutf8.gsub(title, " *" .. channel_cleaned .. " *", "")
        end
        return title
      end,
      ["youtube-playable-item-channel"] = function (self)
        return self:get("single-attr", "uploader")
      end,
      ["youtube-playable-item-channel-cleaned"] = function(self)
        local channel = stringy.strip(self:get("youtube-playable-item-channel"))
        channel = replace(channel, {
          { cond = {_r = mt._r.text_bloat.youtube.channel_topic_producer, _ignore_case = true}, mode="remove" },
          { value = {_r = mt._r.text_bloat.youtube.slash_suffix, _ignore_case = true}, mode="remove" },
        })
        return channel
      end,
    },
  
    doThisables = {
      ["get-attrs-async-inner"] = function(self, specifier)
        run(
          self:get("attrs-inner-task-args", specifier.attrs),
          function(output)
            local res = self:get("process-raw-attrs", {
              raw_attr_string = output,
              attrs = specifier.attrs
            })
            specifier.do_after(res)
          end
        )
      end,
      ["extract-attrs-from-title-channel-via-ai"] = function(self, specifier)
        self:doThis("get-attrs-async-inner", {
          attrs = { "title", "uploader" },
          do_after = function(attrs)
            fillTemplateGPT(
              {
                in_fields = attrs,
                out_fields = specifier.out_fields,
              },
              specifier.do_after
            )
          end
        })
      end,
      ["add-as-m3u-deterministic"] = function(self)
        self:doThis("get-attrs-async-inner", {
          attrs = { "title", "uploader" },
          do_after = function(attrs)
            local tags = {
              tcrea = transf.string.romanized_snake(attrs.uploader),
              title = transf.string.romanized_snake(attrs.title)
            }
            self:doThis("add-as-m3u", tags)
          end
        })
      end,
      ["add-as-m3u-ai"] = function(self)
        self:doThis("extract-attrs-from-title-channel-via-ai", {
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
        local edited_tags = {}
        for k, v in fastpairs(deduced_tags) do
          local new_v = prompt("string", {
            prompt_args = {
              prompt = "Confirm value for " .. k,
              default = v
            },
          })
          if new_v ~= nil then
            edited_tags[k] = new_v
          end
        end
        specifier.tag = concat(edited_tags, promptUserToAddNKeyValuePairs("tag"))
---@diagnostic disable-next-line: param-type-mismatch
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
      },{
        description = "unavailable",
        emoji_icon = "🚫",
        key = "youtube-playable-item-unavailable"
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
