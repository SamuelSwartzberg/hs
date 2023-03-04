--- @type ItemSpecifier
SignalItemSpecifier = {
  type = "signal-item",
  properties = {
    getables = {
      ["convo-id"] = function(self, chat_obj)
        return chat_obj[1].conversationId
      end,
      ["author"] = function(self, chat_obj)
        return chat_obj.author
      end,
      ["raw-messages"] = function(self, chat_obj)
        return chat_obj.messages
      end,
      ["msg-timestamp"] = function(self, msg)
        return msg.sent_at / 1000
      end,
      ["msg-author"] = function(self, msg)
        if msg.type == "outgoing" then
          return "me"
        else
          return msg.global_author
        end
      end,
      ["msg-content"] = function(self, msg)
        return msg.body
      end,
      ["msg-raw-attachments"] = function(self, msg)
        if msg.attachments then
          local attachments = {}
          for _, att in ipairs(msg.attachments) do
            local actual_attachment_path = msg.media_map[att.contentType][att.size]
            if not actual_attachment_path then
              print(("No attachment of type %s and size %s found for message %s"):format(att.contentType, att.size, msg.id))
            else
              table.insert(attachments, self:get("media-dir-for-chat", msg.chat_obj) .. "/" .. actual_attachment_path)
            end
          end
          return attachments
        end
      end,
      ["msg-raw-reactions"] = function(self, msg)
        if msg.reactions then
          local reactions = {}
          for _, react in ipairs(msg.reactions) do
            table.insert(reactions, react.emoji .. " (1)")
          end
          return reactions
        end
      end,
      ["msg-call-duration"] = function(self, msg)
        if msg.callHistoryDetails then
          local call_ended_timestamp = msg.callHistoryDetails.endedTime / 1000
          return (call_ended_timestamp - self:get("msg-timestamp", msg)) / 60
        end
      end,
      ["msg-replying-to-timestamp"] = function(self, msg)
        if msg.quote then 
          return msg.quote.id / 1000 -- yes, the id field is a timestamp in ms. Why call it id? Who knows.
        end
      end,
      ["chat-obj"] = function(self, exp_item)
        local chat_obj = exp_item:get("parse-to-lua-table")
        chat_obj.author = exp_item:get("path-leaf"):match("^([^(]+)")
        chat_obj.media_dir = exp_item:get("find-sibling-dir-with-same-filename")
        return chat_obj
      end,
      ["backup-interval"] = function(self)
        return 10 * processors.dt_component_seconds_map.minute
      end,
    },
    doThisables = {
      --- @param self ItemSpecifier
      --- @param do_after function
      ["generate-backup"] = function(self, do_after)
        delete(env.TMP_SIGNAL_EXPORT_PARENT, "dir", "empty")
        run({
          "sigtop",
          "export-messages",
          "-f", "json",
          { value = "$TMP_SIGNAL_EXPORT_PARENT", type = "quoted" }
        },  function()
          delete(env.TMP_SIGNAL_EXPORT_MEDIA_PARENT, "dir", "empty")
          run(
            { 
              args = {
                "sigtop",
                "export-attachments",
                { value = "$TMP_SIGNAL_EXPORT_MEDIA_PARENT", type = "quoted" }
              }, 
              and_then = do_after
            }, 
            true
          )
          end)
      end,
      --- @param self ItemSpecifier
      --- @param func function
      ["foreach-chat"] = function(self, func)
        CreateStringItem(env.TMP_SIGNAL_EXPORT_PARENT):get("child-dir-only-string-item-array"):doThis("for-all", func)
      end,
      ["pre-process-chat-messages-hook"] = function (self, chat_obj)
        -- annoyingly, the attachments object in a given message json object doesn't include the name of the attachment (just a hash of something), so we need to create a map of (mimetypes to) filesizes (!) to filenames, since the attachment object does include a filesize field and it is fairly likely that no two attachments will have the same filesize in bytes, especially if we control for file type

        chat_obj.media_map = {}
        chat_obj.media_dir:get("child-string-array"):doThis("for-all", function(media_item)
          local mimetype = mimetypes.guess(media_item)
          local filesize = hs.fs.attributes(media_item, "size")
          if not chat_obj.media_map[mimetype] then
            chat_obj.media_map[mimetype] = {}
          end
          chat_obj.media_map[mimetype][filesize] = media_item
        end)
        chat_obj.media_dir:doThis("move-contents", env.MCHATS_SIGNAL_MEDIA .. "/" .. self:get("convo-id", chat_obj))
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateSignalItem = bindArg(NewDynamicContentsComponentInterface, SignalItemSpecifier)