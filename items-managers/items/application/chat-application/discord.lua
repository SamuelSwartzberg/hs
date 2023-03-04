--- @type ItemSpecifier
DiscordItemSpecifier = {
  type = "discord-item",
  properties = {
    getables = {
      ["convo-id"] = function(self, chat_obj)
        return chat_obj.channel.id
      end,
      ["author"] = function(self, chat_obj)
        return chat_obj.channel.name
      end,
      ["raw-messages"] = function(self, chat_obj)
        return chat_obj.messages
      end,
      ["find-messages-by-id"] = function(self, specifier)
        return find(
          self:get("raw-messages", specifier.chat_obj), 
          function (msg) return msg.id == specifier.id end
        )
      end,
      ["msg-timestamp"] = function(self, msg)
        return date.diff(msg.timestamp, date.epoch()):spanseconds()
      end,
      ["msg-author"] = function(self, msg)
        return ("%s#%s"):format(msg.author.name, msg.author.discriminator)
      end,
      ["msg-content"] = function(self, msg)
        return msg.content
      end,
      ["msg-raw-attachments"] = function(self, msg)
        local raw_attachments = {}
        
        for _, attachment in ipairs(msg.attachments) do
          local attachment_leaf = getLeafWithoutPath(attachment.uri)
          local attachment_path = self:get("media-dir-for-chat", msg.chat_obj) .. "/" .. attachment_leaf
          table.insert(raw_attachments, attachment_path)
        end
    
        return raw_attachments
      end,
      ["msg-raw-reactions"] = function(self, msg)
        local raw_reactions = {}
        for _, reaction in ipairs(msg.reactions) do
          local reaction_str = ("%s (%s)"):format(reaction.emoji.name, reaction.count)
          table.insert(raw_reactions, reaction_str)
        end
        return raw_reactions
      end,

      ["msg-call-duration"] = function(self, msg)
        if msg.callEndedTimestamp then
          return date.diff(msg.callEndedTimestamp, msg.timestamp):spanminutes()
        else
          return nil
        end
      end,
      ["msg-replying-to-timestamp"] = function(self, msg)
        if msg.reference then
          local referenced_msg_id = msg.reference.messageId
          local referenced_msg = self:get("find-messages-by-id", { chat_obj = msg.chat_obj, id = referenced_msg_id })
          if referenced_msg then
            return self:get("msg-timestamp", referenced_msg)
          else
            return nil
          end
        else
          return nil
        end
      end,
      ["chat-obj"] = function(self, chat_dir)
        local message_json_file = chat_dir:get("child-ending-with", ".json")
        local chat_obj = json.decode(message_json_file:get("contents"))
        chat_obj.found_in = chat_dir:get("contents")
        return chat_obj
      end,
      ["backup-interval"] = function(self)
        return 60 * processors.dt_component_seconds_map["minute"]
      end,
    },
    doThisables = {
      ["generate-backup"] = function(self, do_after)
        delete(env.TMP_DISCORD_EXPORT_PARENT, "dir", "empty")
        runHsTaskProcessOutput( { 
          "dscexport",
          "exportdm",
          "--media",
          "--reuse-media",
          "-f", "json",
          "--dateformat", "unix",
          "-o", { value = "$TMP_DISCORD_EXPORT_ITEM", type = "quoted" } },
          do_after
        )
      end,
      ["foreach-chat"] = function(self, func)CreateStringItem(env.TMP_DISCORD_EXPORT_PARENT):get("child-dir-only-string-item-array"):doThis("for-all", func)
      end,
      ["pre-process-chat-messages-hook"] = function (self, chat_obj)
        local media_dir = CreateStringItem(chat_obj.found_in):get("child-ending-with", "_Files")
        srctgt("move", media_dir, self:get("media-dir-for-chat", chat_obj), "any", false, false, true)
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateDiscordItem = bindArg(NewDynamicContentsComponentInterface, DiscordItemSpecifier)