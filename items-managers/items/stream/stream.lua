--- @type BoundRootInitializeInterface
function CreateStreamItem(specified_contents)
  local interface_specifier = {
    potential_interfaces = ovtable.init({
      {key = "control", value = CreateStreamControlItem},
    }),
    type = "stream",
    
    properties = {
      getables = {
        ["is-control"] = returnTrue,
        --- @return "booting" | "active" | "ended"
        ["state"] = function(self) 
          return self:get("contents").state
        end,
        ["initial-flag"] = function(self, flag)
          return self:get("contents").initial_flags[flag]
        end,
        ["initial-data"] = function(self, key)
          return self:get("contents").initial_data[key]
        end,
        ["initial-stream-config"] = function(self, key)
          return self:get("contents").initial_stream_config[key]
        end,
        ["initial-urls-to-string-item-array"] = function(self)
          return CreateArray(self:get("initial-data", "urls"))
        end,
        ["summary-line-plain"] = function(self)
          return string.format(
            "%s %s %s",
            self:get("playback-progress") or "No progress",
            self:get("playlist-progress") or "No playlist progress",
            self:get("key", "media-title") or "No title"
          )
        end,
        ["to-string"] = function(self)
          return self:get("summary-line-plain")
        end,
        ["summary-line"] = function(self)
          if  self:get("state") == "booting" then
            return "Booting..."
          else
            local line = ""
            line = line .. self:get("emoji-for-control-boolean-getable", "pause")
            line = line .. self:get("emoji-for-control-boolean-getable", "loop")
            line = line .. self:get("emoji-for-control-boolean-getable", "shuffle") 
            line = line .. self:get("emoji-for-control-boolean-getable", "video") .. ""
    
            line = line .. self:get("summary-line-plain")
            return line
          end
        end,
        ["to-initial-args"] = function(self)
          local args = {}
          for key, value in pairs(self:get("contents").initial_flags) do
            if value then
              table.insert(args, "--" .. key)
            end
          end
          args[#args + 1] = "--msg-level=all=warn"
          args[#args + 1] = "--input-ipc-server=" .. self:get("initial-stream-config", "socket")
          args[#args + 1] = "--start=" .. self:get("initial-stream-config", "start")
          -- args[#args + 1] = "--keep-open"
          return args
        end,
        ["urls-as-command-parts"] = function(self)
          return self:get("initial-data", "urls"):get("map",
            function(url_item)
              return { value = url_item:get("contents"), type = "quoted" }
            end
          )
        end,
        ["command-parts"] = function(self)
          return listConcat(
            "mpv",
            self:get("to-initial-args"),
            self:get("urls-as-command-parts")
          )
        end,
        ["chooser-text"] = function(self) return self:get("summary-line") end,
        ["chooser-subtext-part"] = function(self) 
          local path = self:get("initial-data", "path")
          if path then 
            return self:get("initial-data", "path"):get("to-string") 
          else
            return nil
          end
        end,
        ["is-valid"] = function(self)
          return not (self:get("state") == "ended")
        end,
      },
      doThisables = {
        ["update"] = function(self)
          if self:get("state") == "booting" then
            if self:get("alive") then
              self:get("contents").state = "active"
            end
          elseif self:get("state") == "active" then
            if not self:get("alive") then
              self:get("contents").state = "ended"
            end
          end
          -- no update for ended
        end,
      }
    },

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

  local contents = mergeAssocArrRecursive(
    {
      initial_flags = {
        ["loop-playlist"] = false,
        shuffle = false,
        pause = false,
        ["no-video"] = false,
      },
      initial_stream_config = {
        start = 0,
      },
      state = "booting",
    },specified_contents
  )

  local interface = RootInitializeInterface(interface_specifier, contents)

  interface:get("contents").initial_stream_config.socket = interface:get("socket")
  interface:get("contents")["task"] = run(interface:get("command-parts"), true)
  return interface
end
