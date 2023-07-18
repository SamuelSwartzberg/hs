--- @type ItemSpecifier
FacebookItemSpecifier = {
  type = "facebook",
  properties = {
    getables = {
      ["convo-id"] = function(self, chat_obj)
        return chat_obj.thread_path:match("_(%d+)$")
      end,
      ["author"] = function(self, chat_obj)
        return chat_obj.title
      end,
      ["raw-messages"] = function(self, chat_obj)
        return chat_obj.messages
      end,
      ["msg-timestamp"] = function(self, msg)
        return msg.timestamp_ms / 1000
      end,
      ["msg-author"] = function(self, msg)
        return msg.sender_name
      end,
      ["msg-content"] = function(self, msg)
        return msg.content
      end,
      ["msg-raw-attachments"] = function(self, msg)
        local raw_attachments = {}

        for _, attachment_type in transf.array.index_value_stateless_iter({"photos", "videos", "files", "audio_files", "gifs", "share", "sticker", "animated_image_attachments"}) do
          if msg[attachment_type] then
            for _, attachment in transf.array.index_value_stateless_iter(msg[attachment_type]) do
              local attachment_leaf = transf.path.leaf(attachment.uri)
              local attachment_path = self:get("media-dir-for-chat", msg.chat_obj) .. "/" .. attachment_leaf
              table.insert(raw_attachments, attachment_path)
            end
          end
        end

        return raw_attachments
      end,
      ["msg-raw-reactions"] = function(self, msg)
        local raw_reactions = {}
        if msg["reactions"] then
          local reaction_tally = {}
          for _, reaction in transf.array.index_value_stateless_iter(msg["reactions"]) do
            reaction_tally[reaction.reaction] = (reaction_tally[reaction.reaction] or 0) + 1
          end
          for reaction, count in transf.native_table.key_value_stateless_iter(reaction_tally) do
            table.insert(raw_reactions, ("%s (%d)"):format(reaction, count))
          end
        end
        return raw_reactions
      end,

      ["msg-call-duration"] = function(self, msg)
        if msg["call_log"] then
          return msg["call_log"].duration / (1000 * 60)
        end
      end,
      ["msg-replying-to-timestamp"] = function(self, msg)
        return nil -- facebook doesn't include this in the export
      end,
      ["chat-obj"] = function(self, chat_dir)
        local chat_obj = json.decode(transf.file.contents(env.chat_dir .. "/messages_1.json"))
        chat_obj.found_in = chat_dir
        return chat_obj
      end,

    },
    doThisables = {
      ["generate-backup"] = function(self, do_after) 
        doWhenReady(
          function()
            run({
              args = {
                "open",
                "-a",
                "Firefox",
                { value = "https://www.facebook.com/dyi/?referrer=yfi_settings", type = "quoted"}
              },
              delay = 1,
            }, function()
              hs.eventtap.keyStroke({"cmd"}, "0") -- reset zoom
              local ff_window = CreateRunningApplicationItem(hs.application.get("Firefox")):get("focused-window-item")
              ff_window:doThis("set-grid", {x = 2, y = 1})
              ff_window:doThis("set-cell", {x = 1, y = 1, h = 1, w = 1})
              doSeries({ 
                "-100x-410 %c", -- format open
                ".",
                "-100x-310 %c", -- format select
                ".",
                "-100x-270 %c", -- date open
                ".",
                "-100x-200 %c", -- date select
                ".",
                "-80x690 %tr", -- deselect all
                ".",
                "-63x945 %tr", -- select messages
                ".",
                { mode = "scroll", target_point = {x = 0, y = -4000}, duration = 2.5 }, -- scroll to end of page
                "530x1548 %l", -- export button
                ".",
              })
              ff_window:doThis("set-grid", {x = 3, y = 3})
              do_after()
            end)
          end
        )
      end,
      ["preprocess-backup-files"] = function()
        for _, subdir in itemsInPath({path = env.TMP_FACEBOOK_EXPORT_PARENT, include_files = false}) do
          if not find({"photos", "stickers_used"}, transf.path.leaf(subdir)[1]) then
            srctgt("move", subdir, env.MCHATS_GLOBAL_FACEBOOK_MEDIA, "any", true, false, true) dothis.absolute_path.delete(subdir))
          end
        end
      end,
      ["foreach-chat"] = function(self, func)
        for _, chat_dir in itemsInPath({path = env.TMP_FACEBOOK_EXPORT_CHATS, include_files = false}) do 
          func(chat_dir)
        end
      end,
      ["pre-process-chat-messages-hook"] = function (self, chat_obj)
        for _, subdir in itemsInPath({ path = env.TMP_FACEBOOK_EXPORT_CHATS .. "/" .. chat_obj.found_in, include_files = false }) do
          srctgt("move", subdir,  env.MCHATS_FACEBOOK_MEDIA .. "/" .. self:get("convo-id", chat_obj), "any", true, false, true)
          dothis.absolute_path.delete(subdir))
        end
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateFacebookItem = bindArg(NewDynamicContentsComponentInterface, FacebookItemSpecifier)