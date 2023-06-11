--- @type ItemSpecifier
ChatApplicationItemSpecifier = {
  type = "chat-application",
  properties = {
    getables = {
      ["is-discord"] = function(self) return self:get("c") == "Discord" end,
      ["is-facebook"] = function(self) return self:get("c") == "Facebook" end,
      ["is-signal"] = function(self) return self:get("c") == "Signal" end,
      ["is-telegram"] = function(self) return self:get("c") == "Telegram Lite" end,
      ["chat-dir"] = function(self)
        return env["MCHATS_" .. self:get("upper-name")]
      end,
      ["media-dir"] = function(self)
        return env["MCHATS_" .. self:get("upper-name") .. "_MEDIA"]
      end,
      ["media-dir-for-chat"] = function(self, chat_obj)
        return self:get("media-dir") .. "/" .. self:get("convo-id", chat_obj)
      end,
      ["msg-attachments"] = function(self, msg)
        return stringx.join(",", self:get("msg-raw-attachments", msg))
      end,
      ["msg-reactions"] = function(self, msg)
        return stringx.join(",", self:get("msg-raw-reactions", msg))
      end,
      ["assemble-messages"] = function(self, chat_obj)
        local messages = {}
        local last_backup = self:get("last-backup", self:get("chat-id", chat_obj))
        for _, msg in ipairs(self:get("raw-messages", chat_obj)) do
          local msg_timestamp = tonumber(self:get("msg-timestamp", msg))
          if msg_timestamp > last_backup then
            local msg_author = self:get("msg-author", msg)
            local msg_content = self:get("msg-content", msg)
            local msg_attachments = self:get("msg-attachments", msg)
            local msg_reactions = self:get("msg-reactions", msg)
            local msg_call_duration = self:get("msg-call-duration", msg)
            local msg_sticker_emoji = self:get("msg-sticker-emoji", msg)
            local msg_replying_to_timestamp = self:get("msg-replying-to-timestamp", msg)
            messages[msg_timestamp] = {msg_author, msg_content, msg_attachments, msg_reactions, msg_call_duration, msg_sticker_emoji, msg_replying_to_timestamp}
          end
        end
        return messages
      end,
    },
    doThisables = {
      ["log-chat-messages"] = function(self, chat_obj)
        local chat_parent = CreateStringItem(env.MCHATS_DISCORD):get(
          "find-or-create-logging-date-managed-child-dir", 
          {
            find_identifier_suffix = self:get("convo-id", chat_obj),
            readable_name_part = self:get("author", chat_obj),
          }
        )
        CreateStringItem(chat_parent):doThis("log-timestamp-table", chat_obj.processed_messages)
      end,
      ["process-chat-messages"] = function(self, chat_obj)
        local messages = self:get("assemble-messages", chat_obj)
        chat_obj.processed_messages = messages
        self:doThis("log-chat-messages", chat_obj)
      end,
      ["process-chat"] = function(self, chat_obj)
        local convo_id = self:get("convo-id", chat_obj)
        local author = self:get("author", chat_obj)
        local raw_messages = self:get("raw-messages", chat_obj)
        for _, msg in raw_messages do
          msg.global_author = author
          msg.global_convo_id = convo_id
          msg.chat_obj = chat_obj -- pointer back up to the chat object
        end
        self:doThis("pre-process-chat-messages-hook", chat_obj)
        self:doThis("process-chat-messages", chat_obj)
      end,
      ["backup-application"] = function(self)
        self:doThis("generate-backup", function()
          self:doThis("preprocess-backup-files")
          self:doThis("foreach-chat", function(chat)
            local chat_obj = self:get("chat-object", chat)
            self:doThis("process-chat", chat_obj)
          end)
        end)
      end,

    }
  },
  potential_interfaces = ovtable.init({
    { key = "discord", value = CreateDiscordItem },
    { key = "facebook", value = CreateFacebookItem },
    { key = "signal", value = CreateSignalItem },
    { key = "telegram", value = CreateTelegramItem },
  }),
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateChatApplicationItem = bindArg(NewDynamicContentsComponentInterface, ChatApplicationItemSpecifier)

