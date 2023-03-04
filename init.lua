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


comp = fsTree(env.MCOMPOSITE, "as-tree")
require("items-managers")

projectDirsArray = CreateArray(itemsInPath({path = env.ME, recursion = 2, include_files = false})):get("to-string-item-array"):get("filter-to-new-array", function(item) return item:get("is-actually-project-dir") end)


envTable = CreateTable(env)
compTable = CreateTable(flatten(comp, {
  mode = "path-assoc",
  val = "plain",
  join_path = ".",
  treat_as_leaf = "list",
}))

System = CreateSystem()

System:get("manager", "hotkey"):doThis("create", {key = "r", fn = hs.reload})

local function createCSLArray()
  return CreateStringItem(env.MCITATIONS)
    :get("descendant-file-only-string-item-array")
    :get("map-to-new-array", function(file) 
      return file:get("to-csl-table") 
    end)
end

--- @alias key_inner_specifier { explanation: string, fn: function, mnemonic?: string }


--- @type { [string]: key_inner_specifier | nil}
local keymap = {
  ["tab"] = {
    explanation = "Window & tab cycling",
    fn = function() 
      System:get("all-windows-array"):get("flat-map", function(window)
        return window:get("corresponding-tabs-or-self")
      end):doThis("choose-item-and-do", "focus")
    end
  },
  ["1"] = {
    explanation = "Command palette for frontmost app",
    fn = function() 
      CreateRunningApplicationItem(
        hs.application.frontmostApplication()
      ):doThis("choose-menu-action")
    end,
  },
  ["2"] = {
    explanation = "Choose contact and action on that contact (from local vcf files)",
    fn = function()
      CreateShellCommand("khard")
        :doThis("get-array-of-contact-tables", function(arr)
          arr:doThis("choose-item-and-then-action") 
        end)
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
      CreateStringItem(env.SCREENSHOTS)
        :get("child-string-item-array")
        :doThis("choose-item-and-then-action")
      end,
  },
  ["6"] = {
    explanation = "Enable and disable mullvad",
    fn = function() 
      CreateShellCommand("mullvad")
        :doThis("toggle")
      end,
  },
  ["7"] = {
    explanation = "Switch ·to a different mullvad server",
    fn = function ()
      local mullvad = CreateShellCommand("mullvad")
      mullvad
        :get("flat-relay-array")
        :doThis("choose-item", 
          function(relay_code) 
            mullvad:doThis("relay-set", relay_code)
          end
        )
    end
  },
  ["8"] = {
    explanation = "Choose a email in your inbox and action on it",
    fn = function()
      CreateArray(getSortedEmailPaths(env.MBSYNC_INBOX, true))
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
      CreateTable(searches)
        :doThis("choose-item", function(val)
          local true_val = returnLast(stringy.split(val, " ")) -- ignore all the `magrep -i` or `mpick -t` stuff, that's just for user comprehension
          true_val = string.format(true_val, prompt("string", "Search for: "))
          local results
          if stringy.startswith(val, "magrep") then
            results = getSortedEmailPaths(env.MBSYNC_ARCHIVE, true, true_val)
          elseif stringy.startswith(val, "mpick") then
            results = getSortedEmailPaths(env.MBSYNC_ARCHIVE, true, nil, true_val)
          end
          CreateArray(results)
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
  r = nil, -- assigned above
  t = {
    explanation = "Choose an action on the current date.",
    fn = function() 
      CreateDate(date())
        :doThis("choose-action") 
    end,
  },
  y = {
    explanation = "Choose action on tag name and value in MAUDIOVISUAL (mostly for interacting with streams)",
    fn = function() 
      CreateStringItem(env.MAUDIOVISUAL)
        :get("descendant-string-item-array")
        :doThis("choose-tag-name-value-and-then-action")
    end,
  },
  u = {
    explanation = "Choose item and action on it in MAUDIOVISUAL (mostly for interacting with streams)",
    fn = function() 
      memoize(function()
        return CreateStringItem(env.MAUDIOVISUAL)
          :get("descendant-string-item-array")
          :get("map-to-table-of-path-and-path-content-items")
      end)():doThis("choose-item-and-then-action")
    end,
  },
  i = {
    explanation = "Choose a favorite stream",
    fn = function() 
      CreateStringItem("/Users/sam/me/state/init_playlists")
        :get("array", "lines-of-file-contents")
        :doThis("choose-item", function(item)
          System:get("manager", "stream"):doThis("create-background-stream", item)
        end)

          
    end,
  },
  o = nil, -- unassigned
  p = {
    explanation = "Choose a pass and fill it",
    fn = function()
      CreateArray(
        map(itemsInPath(env.MPASSPASSW), function(fl) return pathSlice(fl, "-2:-2", { ext_sep = true })[1] end)
      ):doThis("choose-item-and-then-action")
    end,
  },
  ["["] = nil, -- unassigned
  ["]"] = nil, -- unassigned
  a = {
    explanation = "Choose a file in MAUDIOVISUAL and an action on it.",
    fn = function()
      CreateStringItem(env.MAUDIOVISUAL)
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
      CreateStringItem(env.MAC_DOWNLOADS)
        :get("child-string-item-array")
        :doThis("choose-item-and-then-action") 
    end,
  },
  f = {
    explanation = "Choose a composite item, eval and choose an action on it.",
    fn = function()
      compTable:doThis("choose-item", function (item)
        inspPrint(item)
        CreateStringItem(le(item)):doThis("choose-action")
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
      memoize(createCSLArray)()
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
      local res = prompt("string", "String to act on")
      if res then 
        CreateStringItem(res):doThis("choose-action")
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
  ["/"] = nil -- unassigned
}

System:get("manager", "hotkey"):doThis("register-all", keymap)


System:get("manager", "hotkey"):doThis(
  "create", 
  {
    key = "`", 
    modifiers = {"cmd", "alt"}, 
    fn = function() 
      System:get("manager", "input-method")
        :doThis("activate-next") 
    end
  }
)

System:get("manager", "input-method"):doThis("register-all", {
  "com.apple.keylayout.US",
  "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese"
})

System:get("manager", "api"):doThis("register-all", {
  "https://www.googleapis.com/youtube",
  "https://yt.lemnoslife.com/"
})

-- structure below is not final, more OO way will emerge in the course of working on this I think

System:get("manager", "watcher"):doThis("register-all", {
  { 
    type = hs.pasteboard.watcher, 
    fn = function(item)
      System:get("manager", "clipboard"):doThis("create", item)
    end 
  },
  {
    type = hs.fs.volume,
    fn = function(event, information)
      if event == hs.fs.volume.didMount then
        local vol = CreateStringItem(information.path)
        if vol:get("is-time-machine-volume") then
          hs.alert.show("Starting backup...")
          run({"tmutil", "startbackup"})
        end
      elseif event == hs.fs.volume.didUnmount then
        local vol = CreateStringItem(information.path)
        if vol:get("is-dynamic-time-machine-volume") then
          hs.timer.doAfter(30, function()
            hs.alert.show("Backup completed. Ejecting...")
            CreateStringItem(env.TMBACKUPVOL):doThis("eject")
          end)
        end
      end
    end
  }
})



System:get("manager", "timer"):doThis("register-all", {
  bindArg(run, {"newsboat", "-x", "reload"}),
  syncVdirSyncer,
  bind(syncHomeRelativePath, {"me/state/todo", "push"}),
  CreateStringItem(env.MEDIA_QUEUE):get("timer-that-does", { 
    interval = "*/3 * * * * *", 
    key = "lines-as-stream-queue" }),
  { 
    fn = bindArg(run, {
      "mbsync",
      "-c",
      { value = "$XDG_CONFIG_HOME/isync/mbsyncrc", type = "quoted"},
      "mb-channel"
    }), 
    interval = "* * * * *"
  },
  CreateStringItem(env.MENV):get("refresh-env-task"),
  --[[CreateApplicationItem("Firefox"):get("backup-timer"),
  CreateApplicationItem("Signal"):get("backup-timer"),
  CreateApplicationItem("Discord"):get("backup-timer"),]]
}) 

System:get("manager", "task"):doThis("register-all", {
  { "jcwserve", env.JSON_SHELL_API_LAYER_SERVER_PORT }
})

processSetupDirectivesInFiles(env.MACTABLE_PATHS)

hs.alert.show("Config loaded")