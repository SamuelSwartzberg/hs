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
      ["generate-backup"] = function(self, do_after) 
        dothis.fn_queue_specifier.push(main_qspec,
          function()
            dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped("open -a Firefox" .. 
            transf.string.single_quoted_escaped("https://www.facebook.com/dyi/?referrer=yfi_settings") " && sleep 1", function()
              hs.eventtap.keyStroke({"cmd"}, "0") -- reset zoom
              local ff_window = CreateRunningApplicationItem(hs.application.get("Firefox")):get("focused-window-item")
              ff_window:doThis("set-grid", {x = 2, y = 1})
              ff_window:doThis("set-cell", {x = 1, y = 1, h = 1, w = 1})
              dothis.input_spec_array.exec({ 
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
        for _, subdir in transf.local_dir.children_absolute_path_value_stateful_iter(env.TMP_FACEBOOK_EXPORT_PARENT) do
          if not hs.fnutils.find({"photos", "stickers_used"}, transf.path.leaf(subdir)[1]) then
            dothis.dir.move_children_absolute_path_array_into_absolute_path(subdir, env.MCHATS_GLOBAL_FACEBOOK_MEDIA)
          end
        end
      end,
      ["foreach-chat"] = function(self, func)
        for _, chat_dir in transf.local_dir.children_absolute_path_value_stateful_iter(env.TMP_FACEBOOK_EXPORT_CHATS) do 
          func(chat_dir)
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