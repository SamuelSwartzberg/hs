--- @type hs
hs = hs
hs.ipc.cliInstall("/opt/homebrew") -- install the homebrew cli, stupidly has to be done on every launch

log = hs.logger.new("init", "debug")
log.i("Log initialized.")

--- @type pl.stringx
stringx = require("pl.stringx")
--- @type pl.dir
dir = require("pl.dir")
--- @type pl.file
file = require("pl.file")
--- @type pl.tablex
tablex = require("pl.tablex")
--- @type pl.array2d
array2d = require("pl.array2d")
--- @type pl.data 
data = require("pl.data")
--- @type ftcsv
ftcsv = require('ftcsv')
--- @type date
date = require("date")
curl = require("cURL")
--- @type lyaml
yaml = require("lyaml")
--- @type cjson
json = require("cjson")
--- @type toml
toml = require("toml")
oldutf8 = utf8
--- @type eutf8
eutf8 = require 'lua-utf8'
onig = require("rex_onig") -- oniguruma regex engine. Not faster than lua's built in regex engine, but has more features, and can deal with unicode.
--- @type stringy
stringy = require("stringy")
xml = require "xmllpegparser"
--- @type basexx
basexx = require("basexx")
--- @type memoize
memoize = require 'memoize'
--- @type mimetypes
mimetypes = require "mimetypes"
combine = require "combine"

--- @type hashings 
hashings = require("hashings")

--- @type promiselib | fun(fn: promisefn): PromiseObj
Promise = require 'promise'

require("utils")

memoized = {}
fsmemoized = {}
fsmemoizedasync = {}

for key, item in pairs(_G) do
  if type(item) == "function" then
    memoized[key] = memoize(item) -- memoize all functions, though not all of them make sense to actually use memoized. Use your judgement.
    fsmemoized[key] = fsmemoize(item, key)
    fsmemoizedasync[key] = fsmemoizeAsyncFunc(item, key)
  end
end



memoizer = createMemoizer()
item_cache = createItemCache()

comp = hybridFsDictFileTreeToTable(env.MCOMPOSITE)
require("items-managers")

projectDirsArray = CreateArray(getAllInPath(env.ME, 2, true, false, usefulFileValidator)):get("to-string-item-array"):get("filter-to-new-array", function(item) return item:get("is-actually-project-dir") end)


envTable = CreateTable(env)
compTable = CreateTable(nestedAssocArrToFlatPathAssocArrWithDotNotation(comp))

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
          local true_val = getLast(stringy.split(val, " ")) -- ignore all the `magrep -i` or `mpick -t` stuff, that's just for user comprehension
          true_val = string.format(true_val, promptString("Search for: "))
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
      item_cache:getOrCreate(
        CreateStringItem,
        env.MAUDIOVISUAL,
        {
          "descendant-string-item-array",
          "map-to-table-of-path-and-path-content-items",
        },
        "invalidate",
        toSeconds(1, "h")
      ):exec():doThis("choose-item-and-then-action")
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
        mapValueNewValue(getChildren(env.MPASSPASSW), function(fl) return getLeafWithoutPathOrExtension(fl) end)
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
      memoizer
        :getOrCreate(createCSLArray, "invalidate", toSeconds(1, "h"))
        :exec()
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
      local res = promptString("String to act on")
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
      print("hey")
      print(hs.inspect(event == hs.fs.volume.didUnmount))
      print(hs.inspect(information))
      if event == hs.fs.volume.didMount then
        local vol = CreateStringItem(information.path)
        if vol:get("is-time-machine-volume") then
          hs.alert.show("Starting backup...")
          runHsTask({"tmutil", "startbackup"})
        end
      elseif event == hs.fs.volume.didUnmount then
        local vol = CreateStringItem(information.path)
        if vol:get("is-dynamic-time-machine-volume") then
          print("will eject")
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
  bindArg(runHsTask, {"newsboat", "-x", "reload"}),
  syncVdirSyncer,
  bindArgsVararg(syncHomeRelativePath, "me/state/todo", "push"),
  -- bindArgsVararg(syncHomeRelativePath, "me/bin_res/papers", "push"),
  bindArgsVararg(syncHomeRelativePath, "Pictures/Android", "pull", "move"),
  bindArgsVararg(syncHomeRelativePath, env.TACHIYOMI_STATE_DIR, "pull", "move"),
  bindArgsVararg(syncHomeRelativePath, env.NEWPIPE_STATE_DIR, "pull", "move"),
  CreateStringItem(env.MEDIA_QUEUE):get("timer-that-does", { interval = 3, key = "lines-as-stream-queue" }),
  { 
    fn = bindArg(runHsTask, {
      "mbsync",
      "-c",
      { value = "$XDG_CONFIG_HOME/isync/mbsyncrc", type = "quoted"},
      "mb-channel"
    }), 
    interval = 60
  },{
    fn = bindArgsVararg(runJsonServerAtPort, env.JSON_SERVER_PORT, env.LOCAL_JSON_SERVER_DIR),
    interval = 60
  },
  CreateStringItem(env.MENV):get("refresh-env-task"),
  CreateStringItem(env.MURLS):get("autocommit-and-push-task", toSeconds(1, "h")),
  CreateStringItem(env.MCONTACTS):get("autocommit-and-push-task", toSeconds(1, "h")),
  CreateStringItem(env.MACTABLE_PATHS):get("autocommit-and-push-task", toSeconds(1, "h")),
  CreateStringItem(env.MCERTS):get("autocommit-and-push-task", toSeconds(1, "h")),
  CreateStringItem(env.MDEPENDENCIES):get("autocommit-and-push-task", toSeconds(1, "h")),
  CreateStringItem(env.MDICTIONARIES):get("autocommit-and-push-task", toSeconds(1, "h")),
  CreateStringItem(env.MENV):get("autocommit-and-push-task", toSeconds(1, "h")),
  CreateStringItem(env.MGNUPG):get("autocommit-and-push-task", toSeconds(1, "h")),
  CreateStringItem(env.MKEYS):get("autocommit-and-push-task", toSeconds(1, "h")),
  CreateStringItem(env.MMEMORY):get("autocommit-and-push-task", toSeconds(1, "h")),
  CreateStringItem(env.MPASS):get("autocommit-and-push-task", toSeconds(1, "h")),
  CreateStringItem(env.MSTATE):get("autocommit-and-push-task", toSeconds(1, "h")),
  --[[CreateApplicationItem("Firefox"):get("backup-timer"),
  CreateApplicationItem("Signal"):get("backup-timer"),
  CreateApplicationItem("Discord"):get("backup-timer"),]]
  CreateStringItem(env.ME):get("timer-that-does", { interval = 300, key = "pull-all" }),
}) 

persistent_shell_tasks = {
  runHsTask({
    "http-server",
    "-a",
    "127.0.0.1",
    "-p",
    env.FS_HTTP_SERVER_PORT, 
    "-c60",
    env.ME
  }),
  
}

processSetupDirectivesInFiles(env.MACTABLE_PATHS)

GlobalChordManager = createGlobalChordManager()
AnkiChordManager = GlobalChordManager:createChordManager({ "cmd", "shift" }, ";")

hs.alert.show("Config loaded")