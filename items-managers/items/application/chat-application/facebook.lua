--- @type ItemSpecifier
FacebookItemSpecifier = {
  type = "facebook-item",
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

        for _, attachment_type in ipairs({"photos", "videos", "files", "audio_files", "gifs", "share", "sticker", "animated_image_attachments"}) do
          if msg[attachment_type] then
            for _, attachment in ipairs(msg[attachment_type]) do
              local attachment_leaf = getLeafWithoutPath(attachment.uri)
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
          for _, reaction in ipairs(msg["reactions"]) do
            reaction_tally[reaction.reaction] = (reaction_tally[reaction.reaction] or 0) + 1
          end
          for reaction, count in pairs(reaction_tally) do
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
        local chat_obj = json.decode(readFile(env.chat_dir .. "/messages_1.json"))
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
              and_then = function()
                hs.eventtap.keyStroke({"cmd"}, "0") -- reset zoom
                local ff_window = CreateRunningApplicationItem(hs.application.get("Firefox")):get("focused-window-item")
                ff_window:doThis("set-tile", {
                  matrix = {2,1},
                  position = {1,1}
                })
                ff_window:doThis("click-series", { 
                  { mode = "moveandclick", c = { x = -100, y = -410} }, -- format open
                  { mode = "moveandclick", c = { x = -100, y = -310} }, -- format select
                  { mode = "moveandclick", c = { x = -100, y = -270} }, -- date open
                  { mode = "moveandclick", c = { x = -100, y = -200} }, -- date select
                  { mode = "moveandclick", tr = { x = -80, y = 690} }, -- deselect all
                  { mode = "moveandclick", tr = { x = -63, y = 945} }, -- select messages
                  { mode = "scroll", target_point = {x = 0, y = -4000}, duration = 2.5 }, -- scroll to end of page
                  { mode = "moveandclick", tl = { x = 530, y = 1548} } -- export button
                })
                do_after()
              end
            }, true)
          end
        )
      end,
      ["preprocess-backup-files"] = function()
        drainAllSubdirsTo(
          env.TMP_FACEBOOK_EXPORT_PARENT, 
          env.MCHATS_GLOBAL_FACEBOOK_MEDIA, 
          function(subdir)
            local leaf = getLeafWithoutPath(subdir)
            return valuesContain({"photos", "stickers_used"}, leaf)
          end
        )

        drainAllSubdirsTo(env.TMP_FACEBOOK_EXPORT_PARENT, env.TMP_FACEBOOK_EXPORT_CHATS)
      end,
      ["foreach-chat"] = function(self, func)
        for _, chat_dir in getAllInPath(env.TMP_FACEBOOK_EXPORT_CHATS, false, true, false) do 
          func(chat_dir)
        end
      end,
      ["pre-process-chat-messages-hook"] = function (self, chat_obj)
        drainAllSubdirsTo(env.TMP_FACEBOOK_EXPORT_CHATS .. "/" .. chat_obj.found_in, env.MCHATS_FACEBOOK_MEDIA .. "/" .. self:get("convo-id", chat_obj))
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateFacebookItem = bindArg(NewDynamicContentsComponentInterface, FacebookItemSpecifier)