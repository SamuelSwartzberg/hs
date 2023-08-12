--- @type ItemSpecifier
ChatApplicationItemSpecifier = {
  type = "chat-application",
  properties = {
    getables = {
      ["is-discord"] = function(self) return self:get("c") == "Discord" end,
      ["is-facebook"] = function(self) return self:get("c") == "Facebook" end,
      ["is-signal"] = function(self) return self:get("c") == "Signal" end,
      ["is-telegram"] = function(self) return self:get("c") == "Telegram Lite" end,
    },
    doThisables = {
      ["log-chat-messages"] = function(self, chat_obj)
        local chat_parent = st(env.MCHATS_DISCORD):get(
          "find-or-create-logging-date-managed-child-dir", 
          {
            find_identifier_suffix = self:get("convo-id", chat_obj),
            readable_name_part = self:get("author", chat_obj),
          }
        )
        st(chat_parent):doThis("log-timestamp-table", chat_obj.processed_messages)
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
  ({
    { key = "discord", value = CreateDiscordItem },
    { key = "facebook", value = CreateFacebookItem },
    { key = "signal", value = CreateSignalItem },
    { key = "telegram", value = CreateTelegramItem },
  }),
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateChatApplicationItem = bindArg(NewDynamicContentsComponentInterface, ChatApplicationItemSpecifier)

