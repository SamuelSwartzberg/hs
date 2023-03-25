--- @type ItemSpecifier
TelegramItemSpecifier = {
  type = "telegram-item",
  properties = {
    getables = {
      ["convo-id"] = function(self, chat_obj)
        return chat_obj.id
      end,
      ["author"] = function(self, chat_obj)
        return chat_obj.name
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
        return msg.date_unixtime
      end,
      ["msg-author"] = function(self, msg)
        return msg.from
      end,
      ["msg-content"] = function(self, msg)
        return msg.text
      end,
      ["msg-raw-attachments"] = function(self, msg)
        return {self:get("media-dir-for-chat", msg.chat_obj) .. "/" .. pathSlice(msg.file, "-1:-1")[1]}
      end,
      ["msg-raw-reactions"] = function(self, msg)
        local raw_reactions = {}
        if msg["reactions"] then
          local reaction_tally = {}
          for _, reaction in iprs(msg["reactions"]) do
            reaction_tally[reaction.reaction] = (reaction_tally[reaction.reaction] or 0) + 1
          end
          for reaction, count in prs(reaction_tally) do
            table.insert(raw_reactions, ("%s (%d)"):format(reaction, count))
          end
        end
        return raw_reactions
      end,

      ["msg-sticker-emoji"] = function(self, msg)
        return msg.sticker_emoji
      end,
      ["msg-replying-to-timestamp"] = function(self, msg)
        if msg.reply_to_message_id then
          local referenced_msg = self:get("find-messages-by-id", { chat_obj = msg.chat_obj, id = msg.reply_to_message_id })
          if referenced_msg then
            return self:get("msg-timestamp", referenced_msg)
          else
            return nil
          end
        else
          return nil
        end
      end,
      ["chat-obj"] = function(self, chat)
        return chat
      end,
    },
    doThisables = {
      ["generate-backup"] = function(self, do_after) 
        doWhenReady(
          function()
            local window = self:get("running-application-item"):get("main-window-item")
            window:doThis("focus")
            window:doThis("set-size", {w = 800, h = 1500})
            window:doThis("set-position", {x = 0, y = 0})
            window:doThis("click-series", {
              { mode = "moveandclick", tl = {x = 30, y = 65} },
              { mode = "moveandclick", tl = {x = 40, y = 395} },
              { mode = "moveandclick", c = { x = 0, y = -300} },
              { mode = "moveandclick", c = { x = 0, y = 295} },
              { mode = "moveandclick", c = { x = -150, y = -155} },
              { mode = "moveandclick", c = { x = -150, y = -65} },
              { mode = "scroll", target_point = { x = 0, y = -200} },
              { mode = "moveandclick", c = { x = 0, y = 0} },
              { mode = "scroll", target_point = { x = 0, y = -200} },
              { mode = "scroll", target_point = { x = 0, y = -200} },
              { mode = "scroll", target_point = { x = 0, y = -70} },
              { mode = "click", c = { x = 0, y = 0} },
              { mode = "move", c = { x = 0, y = -100} },
              { mode = "scroll", target_point = {x = 0, y = -300}},
              { mode = "scroll", target_point = {x = 0, y = -300}},
              { mode = "moveandclick", c = { x = 0, y = 170} },
              { mode = "moveandclick", c = { x = 130, y = 215} },
            })
            hs.timer.doAfter(300, do_after)
          end
        )
      end,
      ["foreach-chat"] = function(self, func)
        local export_dir = CreateStringItem(env.TMP_TELEGRAM_EXPORT_PARENT)
        local export_json = CreateStringItem(export_dir:get("child-ending-with", "result.json")):get("parse-to-lua-table")
        local chats = export_json.chats.list

        for chat_index, chat in iprs(chats) do
          chat.chat_index = chat_index
          func(chat, chat_index)
        end
      end,
      ["pre-process-chat-messages-hook"] = function(self, chat_obj)
        -- we need to figure out which directory contains the attachments for this chat, and then move them. The dirs are named chat_<index>. I assume (hope) that the index is the same as the index in the chats array in the json file. Otherwise, I cry. :(
        local attachment_dir_path = env.TMP_TELEGRAM_EXPORT_PARENT .. "/chats/chat_" .. chat_obj.chat_index
        -- for some reason, telegram separates the media into subdirs by type, so we need to move each subdir separately
        CreateStringItem(attachment_dir_path):get("child-dir-only-string-item-array"):doThis("for-all", function(attachment_dir)
          attachment_dir:doThis("move-contents", self:get("media-dir-for-chat", chat_obj))
        end)
      end
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateTelegramItem = bindArg(NewDynamicContentsComponentInterface, TelegramItemSpecifier)