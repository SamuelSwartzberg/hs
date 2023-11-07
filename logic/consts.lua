consts = {
  printable_ascii_not_whitespace_str_by_unique_record_separator  = "__ENDOFRECORD5579__",
  printable_ascii_not_whitespace_str_by_unique_field_separator = "Y:z:Y",
  int_by_nearly_largest_with_wiggle_room = 2^51, -- a bit smaller than the maximum 2^53 to allow for some wiggle room
  global_value_taking_root_hydrus_tag_namespace_by_default = "global",
  digit_str_by_lua_server_port = "11793",
  number_by_polling_interval = 0.01,
  nil_singleton = {},
  use_singleton = {},
  keymap_spec_by_cmd_shift_alt = {
    modifiers = { "cmd", "shift", "alt" },
    map = {
      ["tab"] = {
        explanation = "Grid cell mapper",
        fn = act["nil"].show_2_by_4_grid
      },
      ["1"] = {
        explanation = "Command palette for frontmost app",
        fn = act["nil"].choose_menu_item_table_and_execute_by_frontmost_application
      },
      ["2"] = {
        explanation = "Choose contact and action on that contact (from local vcf files)",
        fn = act["nil"].choose_item_and_action_on_contact_table_arr,
        mnemonic = "2 by association with @"
      },
      ["3"] = {
        explanation = "Choose a volume and eject it",
        fn = act["nil"].choose_item_and_eject_or_msg_by_all_volumes,
      },
      ["4"] = {
        explanation = "Choose a screenshot and action on it",
        fn = act["nil"].choose_item_and_action_on_screenshot_children
      },
      ["6"] = {
        explanation = "Enable and disable mullvad",
        fn = act["nil"].mullvad_toggle
      },
      ["7"] = {
        explanation = "Switch ·to a different mullvad server",
        fn = act["nil"].choose_item_and_set_active_relay_identifier
      },
      ["8"] = {
        explanation = "Choose a email in your inbox and action on it",
        fn = act["nil"].choose_inbox_email_and_action
      },
      ["9"] = {
        explanation = "Switch the active input audiodevice",
        fn = act["nil"].choose_input_audiodevice_specifier_and_set_default
      },
      ["0"] = {
        explanation = "Switch the active output audiodevice",
        fn = act["nil"].choose_output_audiodevice_specifier_and_set_default
      },
      ["-"] = {
        explanation = "Show information on hotkeys",
        fn = act["nil"].choose_item_and_action_on_hotkey_creation_specifier_arr,
      },
      ["="] = nil, -- unassigned
      q = nil, -- never assign anything to q, since it's too risky to accidentally miss a modifier key and log out (cmd shift q)
      w = nil, -- never assign anything to w, since too many 'close window' hotkeys use it
      e = {
        explanation = "Choose an environment variable, and an action on it",
        fn = act["nil"].choose_item_and_action_by_env_var
      },
      r = {
        explanation = "Record some audio, then choose an action on it",
        fn = act["nil"].sox_rec_toggle_and_act
      },
      t = {
        explanation = "Choose an action on the current timestamp.",
        fn = act["nil"].choose_action_on_current_timestamp_s
      },
      y = nil, -- unassigned
      u = nil, -- unassigned
      i = nil, -- unassigned
      o = {
        explanation = "Choose a otp and paste it",
        fn = act["nil"].choose_otp_pass_item_name_and_paste
      }, -- unassigned
      p = {
        explanation = "Choose a pass and fill it",
        fn = act["nil"].choose_login_pass_item_name_and_fill
      },
      ["["] = nil, -- unassigned
      ["]"] = nil, -- unassigned
      a = {
        explanation = "Choose a default search, and create a stream based on it.",
        fn = act["nil"].choose_default_search_and_create_background_stream
      },
      s = {
        explanation = "Choose a project and choose an action on it.",
        fn = function()
          act.arr.choose_item_and_action(
            transf.local_extant_path.project_dir_arr_by_descendants_depth_3(dynamic_permanents.str_key_str_value_assoc_by_env.ME)
          )
        end,
      },
      d = {
        explanation = "Choose an file in DOWNLOADS and an action on it.",
        fn = act["nil"].choose_item_and_action_on_local_extant_path_in_downloads,
      },
      f = nil, -- unassigned
      g = {
        explanation = "Choose an item from the clipboard and then an action on it.",
        fn = act["nil"].choose_action_on_first_item_in_pasteboard_arr,
      },
      h = nil, -- unassigned
      j = nil, -- unassigned
      k = nil, -- unassigned
      l = nil, -- unassigned
      [";"] = nil, -- currently used somewhere else
      ["'"] = {
        explanation = "Choose a citation item, and then choose an action on it.",
        fn = act["nil"].choose_item_and_action_on_mcitation_csl_table
      },
      ["\\"] = {
        explanation = "Choose an action on the current application",
        fn = act["nil"].choose_action_on_running_application_by_frontmost
      },
      ["`"] = {
        explanation = "Choose an action on a user-entered str",
        fn = act["nil"].choose_action_on_user_entered_str,
      },
      z = nil, -- unassigned
      x = nil,
      c = {
        explanation = "Choose an item from the clipboard and paste it.",
        fn = act["nil"].choose_item_and_paste_on_pasteboard_arr
      },
      b = {
        explanation = "Choose an item from the clipboard and then an action on it.",
        fn = act["nil"].choose_item_and_action_on_pasteboard_arr
      },
      n = {
        explanation = "Choose an action on the first playing stream.",
        fn = act["nil"].choose_action_on_first_running_stream
      },
      m = {
        explanation = "Choose a stream and then an action on it. (Stream management)",
        fn = act["nil"].choose_stream_and_then_action
      },
      [","] = nil, -- unassigned
      ["."] = nil, -- unassigned
      ["/"] = nil, -- unassigned
    
    }
  },
  keymap_spec_by_cmd_alt = {
    modifiers = { "cmd", "alt" },
    map = {
      ["~"] = {
        fn = act["nil"].activate_next_source_id
      }
    }
  },
  task_creation_specifier_by_oauth2callback_server = {  args = "oauth2callback"},
  task_creation_specifier_by_redis_server = {
    args = "redis-server /Users/sam/me/spec/dotconfig/redis/redis.conf",
  },
  hotkey_creation_specifier_by_reload = {
    key = "r",
    modifiers = { "cmd", "shift", "alt" },
    fn = hs.reload
  },
  hotkey_creation_specifier_by_pop_fn_queue = {
    modifiers = { "cmd", "shift", "alt" },
    key = "/",
    fn = act["nil"].pop_main_qspec
  },
}