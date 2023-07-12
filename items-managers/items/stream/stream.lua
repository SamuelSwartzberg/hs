--- @type BoundRootInitializeInterface
function CreateStreamItem(specified_contents)
  local interface_specifier = {
    action_table = { {
      text = "⏯ tgl.",
      key = "cycle",
      args = "pause"
    },
    {
      text = "⏹ end.",
      key = "exec", 
      args = {key = "quit"}
    },
    {
      text = "◀️ plres.",
      key = "playlist-first"
    },
    {
      text = "⏮ curres.",
      key = "restart-current"
    },
    {
      text = "➡️ nxt.",
      key = "exec",
      args = { key = "playlist-next"}
    },
    {
      text = "⬅️ prev.",
      key = "exec",
      args = { key = "playlist-prev"}
    },
    {
  
      text = "🔀 shuf.",
      key = "cycle",
      args = "shuffle",
    },
    {
      text = "🔂 loop.",
      key = "loop",
    },
    {
      text = "🔁 looppl.",
      key = "loop-playlist",
    },
    {
      text = "⏩1️⃣5️⃣ 15s+.",
      key = "set-time-relative",
      args = 15
    },
    {
      text = "⏪1️⃣5️⃣ 15s-.",
      key = "set-time-relative",
      args = -15
    },
    {
      text = "⏩6️⃣0️⃣ 1m+.",
      key = "set-time-relative",
      args = 60
    },
    {
      text = "⏪6️⃣0️⃣ 1m-.",
      key = "set-time-relative",
      args = -60
    },
    {
      text = "↗️ nxtch.",
      key = "chapter-next"
    },
    {
      text = "↖️ prvch.",
      key = "chapter-prev"
    },
    {
      text = "👉🔗 ccururl.",
      key = "choose-action-on-str-item-result-of-get",
      args =  "current-url"
    },
    {
      text = "👉👒 ccurttl.",
      key = "choose-action-on-str-item-result-of-get",
      args = { key = "key", args = "media-title"}
    },
    {
      text = "👉🛣 cinitpth.",
      key = "choose-action-on-result-of-get",
      args = { key = "initial-data", args = "path"}
    },
    {
      text = "👉🔗 ciniturl.",
      key = "choose-action-on-result-of-get",
      args = { key = "initial-urls-to-string-item-array"}
    },
  }
    
  }

  local contents = concat(
    {
      initial_flags = ,
      initial_stream_config = {
        start = 0,
      },
      state = "booting",
    },
    specified_contents
  )

  interface:get("c").initial_stream_config.socket = interface:get("socket")
  interface:get("c")["task"] = run(interface:get("command-parts"), true)
  return interface
end

StreamControlItemSpecifier = {
  type = "stream-control",
  properties = {
    getables = {
      ["emoji-for-control-boolean-getable"] = function(self, key)
        local true_getable_map = {
          loop = "🔂",
          shuffle = "🔀",
        }
        local false_getable_map =
        local res
        if self:get("key", key) then 
          res = true_getable_map[key]
        else
          res = false_getable_map[key]
        end
        return res or ""
      end,
    },

    doThisables = {
      ["restart-complete"] = function(self)
        self:doThis("playlist-first")
        self:doThis("restart-current")
      end,
      ["restart-current"] = function(self) self:doThis("set", {key =  "time-pos", args = 0}) end,
      ["copy-current-url"] = function(self) hs.pasteboard.setContents("https://youtube.com/" .. self:get("key", "filename")) end,
      ["open-current-url-in-browser"] = function(self) hs.urlevent.openURL("https://youtube.com/" .. self:get("key", "filename")) end,
      ["chapter-next"] = function(self) self:doThis("set", {key =  "chapter", args = self:get("as-int", "chapter") + 1}) end,
      ["chapter-prev"] = function(self) self:doThis("set", {key =  "chapter", args = self:get("as-int", "chapter") - 1}) end
    }
  },
  potential_interfaces = ovtable.init({
    { key = "mpv-inner", value = GetMPVInterfaceInner}
  }),
}

--- @type BoundNewDynamicContentsComponentInterface
CreateStreamControlItem = bindArg(NewDynamicContentsComponentInterface, StreamControlItemSpecifier)