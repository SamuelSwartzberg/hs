--- @type hs
hs = hs
hs.ipc.cliInstall("/opt/homebrew") -- install the homebrew cli, stupidly has to be done on every launch

--- typedef for placeholder var `_`
--- @type any
_=nil

require("package-imports")
require("types")
require("external-typings")
require("globals")
require("logic")

comp = transf.dir.plaintext_dictonary_read_assoc(env.MCOMPOSITE)
fstblmap = transf.dir.plaintext_dictonary_read_assoc(env.MDICTIONARIES .. "/mappings")

timer_arr = {}
timer_arr_refresher = hs.timer.doEvery(1, get.fn.fn_by_1st_n_bound(dothis.timer_spec_array.fire_all_if_ready_and_space_if_necessary, timer_arr))

env = transf.string.table_or_err_by_evaled_env_bash_parsed_json("env | jc --ini")

watcher_arr = {}
hotkey_arr = {}
pasteboard_arr = {}
stream_arr = {}
source_id_arr = {}

dothis.created_item_specifier_array.create(
  hotkey_arr,
  {
    key = "r",
    fn = hs.reload
  }
)

dothis.created_item_specifier_array.create_all(
  watcher_arr,
  {
    {
      type = "watcher",
      watcher_type = hs.application.watcher,
      fn = function(mac_application_name, hs_applicaton_event_type, running_application)
        if mac_application_name == "Firefox" and hs_applicaton_event_type == hs.application.watcher.terminated then
          hs.timer.doAfter(3, dothis["nil"].ff_backup)
        end
      end
    },{ 
      type = "watcher",
      watcher_type = hs.pasteboard.watcher, 
      fn = act.string.add_to_pasteboard_arr
    },
    {
      type = "watcher",
      watcher_type = hs.fs.volume,
      fn = function(event, information)
        if event == hs.fs.volume.didMount then
          if is.volume_local_extant_path.static_time_machine_volume_local_extant_path(information.path) then
            hs.alert.show("Starting backup...")
            dothis.string.env_bash_eval_async("tmutil startbackup")
          end
        elseif event == hs.fs.volume.didUnmount then
          if is.volume_local_extant_path.dynamic_time_machine_volume_local_extant_path(information.path) then
            hs.timer.doAfter(30, 
              get.fn.fn_by_1st_n_bound(act.volume_local_extant_path.eject_or_msg, env.TMBACKUPVOL)
            )
          end
        end
      end
    },
  }
  
)

main_qspec = {}
main_qspec = {
  fn_array = {},
  hotkey_created_item_specifier = dothis.creation_specifier.create({
    type = "hotkey",
    key = "/",
    fn = act["nil"].pop_main_qspec
  })
}

--- @alias key_inner_specifier { explanation: string, fn: function, mnemonic?: string }

--- @type { [string]: key_inner_specifier | nil}
local keymap = {
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
    fn = act["nil"].choose_item_and_action_on_contact_table_array,
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
    fn = dothis["nil"].mullvad_toggle
  },
  ["7"] = {
    explanation = "Switch ·to a different mullvad server",
    fn = act["nil"].choose_item_and_set_active_mullvad_relay_identifier
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
    fn = function() 
      System
        :get("manager", "hotkey")
        :get("sorted-to-string-to-new-array")
        :doThis("choose-item")
    end,
  },
  ["="] = {
    explanation = "Various searches on mail",
    fn = function()
      local searches = ovtable.new()
      searches["from_cont"] = "magrep -i from:%s"
      searches["to_cont"] = "magrep -i to:%s"
      searches["subj_cont"] = "magrep -i subject:%s"
      searches["body_cont"] = "magrep -i /:%s"
      searches["adv"] = "mpick -t %s"
      dc(searches)
        :doThis("choose-item", function(val)
          local true_val = transf.array.t_by_last(stringy.split(val, " ")) -- ignore all the `magrep -i` or `mpick -t` stuff, that's just for user comprehension
          true_val = string.format(true_val, get.string.string_by_prompted_once_from_default("", "Search for: "))
          local results
          if get.string.bool_by_startswith(val, "magrep") then
            results = get.maildir_dir.sorted_email_paths(env.MBSYNC_ARCHIVE, true, true_val)
          elseif get.string.bool_by_startswith(val, "mpick") then
            results = get.maildir_dir.sorted_email_paths(env.MBSYNC_ARCHIVE, true, nil, true_val)
          end
          ar(results)
            :get("to-string-item-array")
            :doThis("choose-email-and-then-action-parallel")
        end)
    end,
  },
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
    explanation = "Choose an action on the current date.",
    fn = act["nil"].choose_action_on_current_timestamp_s
  },
  y = {
    explanation = "Choose action on tag name and value in MAUDIOVISUAL (mostly for interacting with streams)",
    fn = function() 
      st(env.MAUDIOVISUAL)
        :get("descendant-string-item-array")
        :doThis("choose-tag-name-value-and-thenx-action")
    end,
  },
  u = {
    explanation = "Choose item and action on it in MAUDIOVISUAL (mostly for interacting with streams)",
    fn = function() 
      get.fn.rt_or_nil_by_memoized(function()
        return st()
          :get("descendant-string-item-array")
          :get("map-to-table-of-path-and-path-content-items")
      end)():doThis("choose-item-and-then-action")
    end,
  },
  i = {
    explanation = "Choose a favorite stream",
    fn = function() 
      ar(transf.plaintext_file.string_array_by_lines("/Users/sam/me/state/init_playlists"))
        :doThis("choose-item", function(item)
          System:get("manager", "stream"):doThis("create-background-stream", item)
        end)

          
    end,
  },
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
    explanation = "Choose a file in MAUDIOVISUAL and an action on it.",
    fn = function()
      st(env.MAUDIOVISUAL)
        :get("child-string-item-array")
        :doThis("choose-dir-until-file-then-choose-action")
    end,
  },
  s = {
    explanation = "Choose a project and choose an action on it.",
    fn = function()
      act.array.choose_item_and_action(
        transf.local_extant_path.project_dir_array_by_descendants_depth_3(env.ME)
      )
    end,
  },
  d = {
    explanation = "Choose an file in DOWNLOADS and an action on it.",
    fn = function()
      st(env.MAC_DOWNLOADS)
        :get("child-string-item-array")
        :doThis("choose-item-and-then-action") 
    end,
  },
  f = {
    explanation = "Choose a composite item, eval and choose an action on it.",
    fn = function()
      compTable:doThis("choose-item", function (item)
        st(get.string.string_by_evaled_as_template(item)):doThis("choose-action")
      end)
    end,
  },
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
    fn = function()
      act.array.choose_item_and_action(
        transf.path_array.csl_table_array_by_filtered_mapped(
          transf.extant_path.file_array_by_descendants(
            env.MCITATIONS
          )
        )
      )
    end,
  },
  ["\\"] = {
    explanation = "Choose an action on the current application",
    fn = function()
      CreateRunningApplicationItem(
        hs.application.frontmostApplication()
      ):doThis("choose-action")
    end,
  },
  ["`"] = {
    explanation = "Choose an action on a user-entered string",
    fn = function()
      local res = get.string.string_by_prompted_once_from_default("", "String to act on")
      if res then 
        st(res):doThis("choose-action")
      end
    end,
  },
  z = nil, -- unassigned
  x = nil,
  c = {
    explanation = "Choose an item from the clipboard and paste it.",
    fn = function()
      System:get("manager", "clipboard")
        :doThis("choose-item-and-paste")
    end,
  },
  b = {
    explanation = "Choose an item from the clipboard and then an action on it.",
    fn = function()
      System:get("manager", "clipboard")
        :doThis("choose-item-and-then-action")
    end,
  },
  n = {
    explanation = "Choose an action on the first playing stream.",
    fn = act["nil"].choose_action_on_first_running_stream
  },
  m = {
    explanation = "Choose a stream and then an action on it. (Stream management)",
    fn = function()
      System:get("manager", "stream")
        :doThis("choose-item-and-then-action")
    end,
  },
  [","] = nil, -- unassigned
  ["."] = nil, -- unassigned
  ["/"] = nil, -- unassigned
  {
    key = "`", 
    modifiers = {"cmd", "alt"}, 
    fn = act["nil"].activate_next_source_id
  }

}

System:get("manager", "creatable"):doThis("create-all", keymap)


-- structure below is not final, more OO way will emerge in the course of working on this I think

System:get("manager", "creatable"):doThis("create-all", {
  
  { type = "task", args = {"jcwserve", env.JSON_SHELL_API_LAYER_SERVER_PORT} },
  { type = "task", args = "oauth2callback"}
})



System:get("manager", "timer"):doThis("create-all", {
  dothis["nil"].newsboat_reload,
  dothis.vdirsyncer.sync,
  hs.fnutils.partial(dothis.local_nonabsolute_path_relative_to_home.copy_local_to_labelled_remote, "me/state/todo"),
  st(env.MEDIA_QUEUE):get("timer-that-does", { 
    interval = "*/3 * * * * *", 
    key = "lines-as-stream-queue" }),
  { 
    fn = dothis["nil"].mbsync_sync, 
    interval = "* * * * *"
  },
  {
    fn = function()
      act.env_yaml_file_container.write_env_and_check(env.ENVFILE)
      env = transf.string.table_or_err_by_evaled_env_bash_parsed_json("env | jc --ini")
    end,
    interval = "*/5 * * * *",
  },
  {
    fn = act.package_manager_name.upgrade_all,
    interval = "0 0 * * *"
  },{
    fn = act["nil"].maintain_state_stream_arr,
    interval = "*/3 * * * *"
  }
  --[[CreateApplicationItem("Firefox"):get("backup-timer"),
  CreateApplicationItem("Signal"):get("backup-timer"),
  CreateApplicationItem("Discord"):get("backup-timer"),]]
}) 
processSetupDirectivesInFiles(env.MACTABLE_PATHS)

hs.alert.show("Config loaded")