--- @type ItemSpecifier
DiscordItemSpecifier = {
  type = "discord",
  properties = {
    getables = {
      ["msg-raw-attachments"] = function(self, msg)
        local raw_attachments = {}
        
        for _, attachment in transf.array.index_value_stateless_iter(msg.attachments) do
          local attachment_leaf = transf.path.leaf(attachment.uri)
          local attachment_path = self:get("media-dir-for-chat", msg.chat_obj) .. "/" .. attachment_leaf
          table.insert(raw_attachments, attachment_path)
        end
    
        return raw_attachments
      end,
      ["chat-obj"] = function(self, chat_dir)
        local message_json_file = chat_dir:get("child-ending-with", ".json")
        local chat_obj = json.decode(message_json_file:get("c"))
        chat_obj.found_in = chat_dir:get("c")
        return chat_obj
      end,
    },
    doThisables = {
      ["generate-backup"] = function(self, do_after)
        dothis.absolute_path.empty_dir(env.TMP_DISCORD_EXPORT_PARENT)
        dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped(
          "dscexport exportdm --media --reuse-media -f json --dateformat unix -o" .. transf.string.single_quoted_escaped("$TMP_DISCORD_EXPORT_ITEM"),
          do_after
        )
      end,
      ["foreach-chat"] = function(self, func)st(env.TMP_DISCORD_EXPORT_PARENT):get("child-dir-only-string-item-array"):doThis("for-all", func)
      end,
      ["pre-process-chat-messages-hook"] = function (self, chat_obj)
        local media_dir = st(chat_obj.found_in):get("child-ending-with", "_Files")
        dothis.dir.move_children_absolute_path_array_into_absolute_path(media_dir, self:get("media-dir-for-chat", chat_obj))
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateDiscordItem = bindArg(NewDynamicContentsComponentInterface, DiscordItemSpecifier)