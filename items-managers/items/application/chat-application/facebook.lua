--- @type ItemSpecifier
FacebookItemSpecifier = {
  type = "facebook",
  properties = {
    getables = {
      ["chat-obj"] = function(self, chat_dir)
        local chat_obj = json.decode(transf.file.contents(env.chat_dir .. "/messages_1.json"))
        chat_obj.found_in = chat_dir
        return chat_obj
      end,

    },
    doThisables = {       
      ["preprocess-backup-files"] = function()
        for _, subdir in transf.local_dir.children_absolute_path_value_stateful_iter(env.TMP_FACEBOOK_EXPORT_PARENT) do
          if not hs.fnutils.find({"photos", "stickers_used"}, transf.path.leaf(subdir)[1]) then
            dothis.dir.move_children_absolute_path_array_into_absolute_path(subdir, env.MCHATS_GLOBAL_FACEBOOK_MEDIA)
          end
        end
      end,
      ["pre-process-chat-messages-hook"] = function (self, chat_obj)
        for _, subdir in transf.local_dir.children_absolute_path_value_stateful_iter(env.TMP_FACEBOOK_EXPORT_CHATS .. "/" .. chat_obj.found_in) do
          dothis.dir.move_children_absolute_path_array_into_absolute_path(subdir,  env.MCHATS_FACEBOOK_MEDIA .. "/" .. self:get("convo-id", chat_obj))
          dothis.absolute_path.delete(subdir))
        end
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateFacebookItem = bindArg(NewDynamicContentsComponentInterface, FacebookItemSpecifier)