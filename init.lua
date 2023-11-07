require("type-imports")
hs.ipc.cliInstall("/opt/homebrew") -- install the homebrew cli, stupidly has to be done on every launch
require("package-imports")
require("logic")

act["nil"].fill_initial_dynamic_permanents()

timer_arr_refresher = hs.timer.doEvery(1, get.fn.fn_by_1st_n_bound(act.timer_spec_arr.fire_all_if_ready_and_space_if_necessary, dynamic_permanents.timer_spec_arr))

act["nil"].create_hotkeys()

act["nil"].create_watchers()


act["nil"].start_oauth2callback_server()
act["nil"].create_fn_queue_specifier()

-- structure below is not final, more OO way will emerge in the course of working on this I think


System:get("manager", "timer"):doThis("create-all", {
  act["nil"].newsboat_reload,
  dothis.vdirsyncer.sync,
  st(dynamic_permanents.str_key_str_value_assoc_by_env.MEDIA_QUEUE):get("timer-that-does", { 
    interval = "*/3 * * * * *", 
    key = "lines-as-stream-queue" }),
  { 
    fn = act["nil"].mbsync_sync, 
    interval = "* * * * *"
  },
  {
    fn = function()
      act.env_yaml_file_container.write_env_and_check(dynamic_permanents.str_key_str_value_assoc_by_env.ENVFILE)
      dynamic_permanents.str_key_str_value_assoc_by_env = transf.str.table_or_err_by_evaled_env_bash_parsed_json("env | jc --ini")
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
processSetupDirectivesInFiles(dynamic_permanents.str_key_str_value_assoc_by_env.MACTABLE_PATHS)

hs.alert.show("Config loaded")