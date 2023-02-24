--- @type ItemSpecifier
YoutubePlayableItemItemSpecifier = {
  type = "youtube-playable-item",
  properties = {
    getables = {
      ["is-youtube-playlist"] = function(self)
        return stringy.endswith(self:get("url-path"), "playlist")
      end,
      ["is-youtube-video"] = function(self)
        return stringy.endswith(self:get("url-path"), "watch")
      end,
      ["attrs-inner-task-args"] = function(self, attrs)
        local attrs_mapped = mapValueNewValue(attrs, function(attr)
          return "%(" .. attr ..")s"
        end)
        local attrs_joined = table.concat(attrs_mapped, UNLIKELY_SEPARATOR)
        return {
          "youtube-dl", 
          "--get-filename",
          "-o",
          {value =  attrs_joined, type = "quoted"},
          {value = self:get("contents"), type = "quoted"}
        }
      end,
      ["process-raw-attrs"] = function(self, specifier)
        local fields = stringx.split(specifier.raw_attr_string, UNLIKELY_SEPARATOR)
        local res = {}
        for i, field in ipairs(fields) do
          res[specifier.attrs[i]] = stringy.strip(field)
        end
        return res
      end,
      ["attrs-sync-inner"] = function (self, attrs)
        local rawres = memoized.getOutputTaskSimple(
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
        local output, status = getOutputTask({"youtube-dl", "--get-title", self:get("contents")})
        if status ~= 0 then
          local lines = stringy.split(output, "\n")
          return valueFind(lines, function(line)
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
        title = transformString(title, {
          { value = "-Official Music Video-", presence = false, case_insensitive = true, adfix = "in" },
          { value = "Official Music Video", presence = false, case_insensitive = true, adfix = "in" },
          { value = "Official Video", presence = false, case_insensitive = true, adfix = "in" },
          { value = "Official MV", presence = false, case_insensitive = true, adfix = "in" },
          { value = "Music Video", presence = false, case_insensitive = true, adfix = "in" },
          { value = "MV full", presence = false, case_insensitive = true, adfix = "in" },
          { value = "(Audio)", presence = false, case_insensitive = true, adfix = "in" },
          { value = "【MV】", presence = false, case_insensitive = true, adfix = "in" },
          { value = " MV ", presence = false, case_insensitive = true, adfix = "in" },
          { value = "【OFFICIAL】", presence = false, case_insensitive = true, adfix = "in" },
          { value = "TVアニメ", presence = false, case_insensitive = true, adfix = "in" },
          { value = "Official", presence = false, case_insensitive = true, adfix = "suf" },
          { value = "Video", presence = false, case_insensitive = true, adfix = "suf" },
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
        channel = transformString(channel, {
          { value = "- Topic", presence = true, case_insensitive = false, adfix = "in" },
          { value = "(SMEJ)", presence = false, case_insensitive = true, adfix = "in" },
          { value = "Official YouTube Channel", presence = false, case_insensitive = true, adfix = "in" },
          { value = "【YouTube Official Channel】", presence = false, case_insensitive = true, adfix = "in" },
          { value = "Official Channel", presence = false, case_insensitive = true, adfix = "in" },
          { value = "Official", presence = false, case_insensitive = true, adfix = "suf" },
          { value = "Channel", presence = false, case_insensitive = true, adfix = "suf" },
          { value = "Music", presence = false, case_insensitive = true, adfix = "suf" },
          { value = "VEVO", presence = false, case_insensitive = true, adfix = "in", regex = true},
          { value = " */ *[^/]+$", presence = false, case_insensitive = true, adfix = "suf", regex = true},
          { value =  "チャンネル", presence = false, case_insensitive = true, adfix = "in", regex = true},
        })
        return channel
      end,
    },
  
    doThisables = {
      ["get-attrs-async-inner"] = function(self, specifier)
        runHsTaskProcessOutput(
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
            fillTemplateFromFieldsWithAI(
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
              tcrea = romanizeToLowerAlphanumUnderscore(attrs.uploader),
              title = romanizeToLowerAlphanumUnderscore(attrs.title)
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
            local cleaned = mapValueNewValue(tags, function(v)
              return romanizeToLowerAlphanumUnderscore(v)
            end)
            self:doThis("add-as-m3u", cleaned)
          end
        })
      end,
      ["add-as-m3u"] = function(self, deduced_tags)
        --- @type path_leaf_parts
        local specifier = {}
        local edited_tags = {}
        for k, v in pairs(deduced_tags) do
          local new_v = promptUserToEditValue(v, k)
          if new_v ~= nil then
            edited_tags[k] = new_v
          end
        end
        specifier.tag = mergeAssocArrRecursive(edited_tags, promptUserToAddNKeyValuePairs("tag"))
---@diagnostic disable-next-line: param-type-mismatch
        specifier.path  = chooseDirAndPotentiallyCreateSubdir(env.MAUDIOVISUAL, specifier.tag.srs or specifier.tag.tcrea)
        specifier.extension = "m3u"
        local path_string = CreatePathLeafParts(specifier):get("str-item", "path-leaf-parts-as-string")
        path_string:doThis("create-file", self:get("contents"))
      end,
      ["to-stream"] = function(self, specifier)
        return CreateArray({self.root_super}):doThis("to-stream", specifier)
      end,
    }
  },
  action_table = listConcat(
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
