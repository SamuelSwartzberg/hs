--- @type hs
hs = hs
hs.ipc.cliInstall("/opt/homebrew") -- install the homebrew cli, stupidly has to be done on every launch

--- typedef for placeholder var `_`
--- @type any
_=nil

mode = "dev" -- "full-test", "dev" or "prod"
-- currently:
-- full-test: run all tests
-- dev: run all tests except those marked as "full-test"
-- prod: run no tests

log = hs.logger.new("init", "debug")
log.i("Log initialized.")

require("package-imports")

require("utils")

a_use = math.random(999999999)

comp = transf.dir.plaintext_dictonary_read_assoc_arr(env.MCOMPOSITE)
fstblmap = transf.dir.plaintext_dictonary_read_assoc_arr(env.MDICTIONARIES .. "/mappings")

require("items-managers")

projectDirsArray = ar(get.extant_path.absolute_path_array(env.ME, {recursion = 2, include_files = false})):get("to-string-item-array"):get("filter-to-new-array", function(item) return item:get("is-actually-project-dir") end)


envTable = dc(env)
compTable = transf.table.dot_notation_key_dict_by_primitive_and_arraylike_is_leaf(comp)

System:get("manager", "hotkey"):doThis("create", {key = "r", fn = hs.reload})

local function createCSLArray()
  return st(env.MCITATIONS)
    :get("descendant-file-only-string-item-array")
    :get("map-to-new-array", function(file) 
      return transf.table_array.item_array_of_item_tables(transf.bib_file.array_of_csl_tables(file:get("contents")))
    end)
end

--- @alias key_inner_specifier { explanation: string, fn: function, mnemonic?: string }

--- @type { [string]: key_inner_specifier | nil}
local keymap = {
  ["tab"] = {
    explanation = "Grid cell mapper",
    fn = bindArg(act.hs_geometry_size_like.show_grid, {y = 2, x = 4})
  },
  ["1"] = {
    explanation = "Command palette for frontmost app",
    fn = function() 
      ar(
        transf.running_application.menu_item_table_item_array(
          hs.application.frontmostApplication()
        )
      ):doThis("choose-item", function(item)
        dothis.menu_item_table.execute(item:get("c"))
      end)
    end,
  },
  a_use, {
    explanation = "Choose contact and action on that contact (from local vcf files)",
    fn = function()
      ar(
        get.fn.rt_or_nil_by_memoized(transf["nil"].contact_table_array)
      ):doThis("choose-item-and-then-action") 
    end,
    mnemonic = "2 by association with @"
  },
  ["3"] = {
    explanation = "Choose a volume and eject it",
    fn = function() 
      System
        :get("all-non-root-volumes-string-item-array")
        :doThis("choose-item-and-eject") 
    end,
  },
  ["4"] = {
    explanation = "Choose a screenshot and action on it",
    fn = function() 
      st(env.SCREENSHOTS)
        :get("child-string-item-array")
        :doThis("choose-item-and-then-action")
      end,
  },
  ["6"] = {
    explanation = "Enable and disable mullvad",
    fn = dothis.["nil"].mullvad_toggle
  },
  ["7"] = {
    explanation = "Switch ·to a different mullvad server",
    fn = function ()
      ar(transf["nil"].mullvad_relay_identifier_array)
        :doThis("choose-item", act.mullvad_relay_identifier.set_active_mullvad_relay_dentifier)
    end
  },
  ["8"] = {
    explanation = "Choose a email in your inbox and action on it",
    fn = function()
      ar(get.maildir_dir.sorted_email_paths(env.MBSYNC_INBOX, true))
        :get("to-string-item-array")
        :doThis("choose-email-and-then-action")
    end,
  },
  ["9"] = {
    explanation = "Switch the active input audiodevice",
    fn = function()
      System
        :get("all-input-devices-audiodevice-array")
        :doThis("choose-and-set-default")
    end,
  },
  ["0"] = {
    explanation = "Switch the active output audiodevice",
    fn = function() 
      System
        :get("all-output-devices-audiodevice-array")
        :doThis("choose-and-set-default")
    end,
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
          if stringy.startswith(val, "magrep") then
            results = get.maildir_dir.sorted_email_paths(env.MBSYNC_ARCHIVE, true, true_val)
          elseif stringy.startswith(val, "mpick") then
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
    fn = function ()
      envTable:doThis("choose-item-and-then-action")
    end,
  },
  r = {
    explanation = "Record some audio, then choose an action on it",
    fn = function() 
      dothis.sox.sox_rec_toggle_cache(function(file)
        st(file):doThis("choose-action")
      end)
    end,
  },
  t = {
    explanation = "Choose an action on the current date.",
    fn = function() 
      dat(date())
        :doThis("choose-action") 
    end,
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
        return st(env.MAUDIOVISUAL)
          :get("descendant-string-item-array")
          :get("map-to-table-of-path-and-path-content-items")
      end)():doThis("choose-item-and-then-action")
    end,
  },
  i = {
    explanation = "Choose a favorite stream",
    fn = function() 
      ar(transf.plaintext_file.line_array("/Users/sam/me/state/init_playlists"))
        :doThis("choose-item", function(item)
          System:get("manager", "stream"):doThis("create-background-stream", item)
        end)

          
    end,
  },
  o = nil, -- unassigned
  p = {
    explanation = "Choose a pass and fill it",
    fn = function()
      dothis.array.choose_item(
        transf["nil"].passw_pass_item_name_array(),
        dothis.login_pass_item_name.fill
      )
    end,
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
      projectDirsArray:doThis("choose-item-and-then-action")
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
        st(get.string.evaled_as_template(item)):doThis("choose-action")
      end)
    end,
  },
  g = {
    explanation = "Choose an item from the clipboard and then an action on it.",
    fn = function()
      System:get("manager", "clipboard")
        :get("first")
        :doThis("choose-action")
    end,
  },
  h = nil, -- unassigned
  j = nil, -- unassigned
  k = nil, -- unassigned
  l = nil, -- unassigned
  [";"] = nil, -- currently used somewhere else
  ["'"] = {
    explanation = "Choose a citation item, and then choose an action on it.",
    fn = function()
      get.fn.rt_or_nil_by_memoized(createCSLArray)()
        :doThis("choose-item-and-then-action")
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
    fn = function()
      local first_playing_stream = System:get("manager", "stream"):get("first-playing-stream")
      if first_playing_stream then
        first_playing_stream:doThis("choose-action")
      else 
        hs.alert.show("No playing stream")
      end
    end,
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
    fn = function() 
      System:get("manager", "input-method")
        :doThis("activate-next") 
    end
  }

}

System:get("manager", "creatable"):doThis("create-all", keymap)

System:get("manager", "input-method"):doThis("create-all", {
  "com.apple.keylayout.US",
  "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese"
})

-- structure below is not final, more OO way will emerge in the course of working on this I think

System:get("manager", "creatable"):doThis("create-all", {
  { 
    type = "watcher",
    watchertype = hs.pasteboard.watcher, 
    fn = function(item)
      System:get("manager", "clipboard"):doThis("create", item)
    end 
  },
  {
    type = "watcher",
    watchertype = hs.fs.volume,
    fn = function(event, information)
      if event == hs.fs.volume.didMount then
        local vol = st(information.path)
        if vol:get("is-time-machine-volume") then
          hs.alert.show("Starting backup...")
          run({"tmutil", "startbackup"})
        end
      elseif event == hs.fs.volume.didUnmount then
        local vol = st(information.path)
        if vol:get("is-dynamic-time-machine-volume") then
          hs.timer.doAfter(30, function()
            hs.alert.show("Backup completed. Ejecting...")
            st(env.TMBACKUPVOL):doThis("eject")
          end)
        end
      end
    end
  },
  { type = "task", args = {"jcwserve", env.JSON_SHELL_API_LAYER_SERVER_PORT} },
  { type = "task", args = "oauth2callback"}
})



System:get("manager", "timer"):doThis("create-all", {
  dothis["nil"].newsboat_reload,
  dothis.vdirsyncer.sync,
  hs.fnutils.parital(dothis.local_nonabsolute_path_relative_to_home.copy_local_to_labelled_remote, "me/state/todo"),
  st(env.MEDIA_QUEUE):get("timer-that-does", { 
    interval = "*/3 * * * * *", 
    key = "lines-as-stream-queue" }),
  { 
    fn = dothis["nil"].mbsync_sync, 
    interval = "* * * * *"
  },
  {
    fn = function()
      dothis.env_yaml_file_container.write_env_and_check(env.ENVFILE)
      env = run("env | jc --ini")
    end,
    interval = "*/5 * * * *",
  },
  {
    fn = act.package_manager_name.upgrade_all,
    interval = "0 0 * * *"
  }
  --[[CreateApplicationItem("Firefox"):get("backup-timer"),
  CreateApplicationItem("Signal"):get("backup-timer"),
  CreateApplicationItem("Discord"):get("backup-timer"),]]
}) 
processSetupDirectivesInFiles(env.MACTABLE_PATHS)

hs.alert.show("Config loaded")