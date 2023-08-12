--- @type ItemSpecifier
SignalItemSpecifier = {
  type = "signal",
  properties = {
    getables = {
      ["msg-raw-attachments"] = function(self, msg)
        if msg.attachments then
          local attachments = {}
          for _, att in transf.array.index_value_stateless_iter(msg.attachments) do
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
      ["chat-obj"] = function(self, exp_item)
        local chat_obj = exp_item:get("parse-to-lua-table")
        chat_obj.author = exp_item:get("path-leaf"):match("^([^(]+)")
        chat_obj.media_dir = exp_item:get("find-sibling-dir-with-same-filename")
        return chat_obj
      end,
    },
    doThisables = {
      --- @param self ItemSpecifier
      --- @param do_after function
      ["generate-backup"] = function(self, do_after)
        dothis.absolute_path.empty_dir(env.TMP_SIGNAL_EXPORT_PARENT)
        dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped(
          "sigtop export-messages -f json" ..
          transf.string.double_quoted_escaped("$TMP_SIGNAL_EXPORT_PARENT"),  function()
          dothis.absolute_path.empty_dir(env.TMP_SIGNAL_EXPORT_MEDIA_PARENT)
          dothis.string.env_bash_eval_async("sigtop export-attachments" ..
          transf.string.double_quoted_escaped("$TMP_SIGNAL_EXPORT_MEDIA_PARENT"))
          end)
      end,
      --- @param self ItemSpecifier
      --- @param func function
      ["foreach-chat"] = function(self, func)
        st(env.TMP_SIGNAL_EXPORT_PARENT):get("child-dir-only-string-item-array"):doThis("for-all", func)
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