local rrq = bindArg(relative_require, "items-managers.items.stream.control")
rrq("mpvInterfaceInner")

--- @type ItemSpecifier
StreamControlItemSpecifier = {
  type = "stream-control",
  properties = {
    getables = {
      ["is-mpv-inner"] = returnTrue,
      ["emoji-for-control-boolean-getable"] = function(self, key)
        local true_getable_map = {
          loop = "🔂",
          shuffle = "🔀",
        }
        local false_getable_map = {
          video = "🙈",
          pause = "▶️",
        }
        local res
        if self:get("key", key) then 
          res = true_getable_map[key]
        else
          res = false_getable_map[key]
        end
        return res or ""
      end,
      ["current-url"] = function(self) return self:get("key", "stream-open-filename") end,
      ["playback-progress"] = function(self) 
        return string.format("(%i/%is - %s%%)", self:get("as-int", "time-pos"), self:get("as-int", "duration"), self:get("as-int", "percent-pos"))
      end,
      ["playlist-progress"] = function(self)
        return string.format("[%i/%i]", self:get("as-int", "playlist-pos"), self:get("as-int", "playlist-count"))
      end,
    },

    doThisables = {
      ["restart-complete"] = function(self)
        self:doThis("playlist-first")
        self:doThis("restart-current")
      end,
      ["set-time-relative"] = function(self, value)
        self:doThis("set", {key =  "time-pos", args = self:get("as-int", "time-pos") + value})
      end,
      ["set-percent-relative"] = function(self, value)
        self:doThis("set", {key =  "percent-pos", args = self:get("as-int", "percent-pos") + value})
      end,
      ["playlist-first"] = function(self) self:doThis("set", {key =  "playlist-pos", args = 0}) end,
      ["playlist-last"] = function(self) self:doThis("set", {key =  "playlist-pos", args = self:get("key", "playlist-count")}) end,
      ["restart-current"] = function(self) self:doThis("set", {key =  "time-pos", args = 0}) end,
      ["cycle-inf-no"] = function(self, prop)
        self:doThis("set", {key =  prop, args = InfNo:inv(self:get("key", prop))})
      end,
      ["loop-playlist"] = function (self)
        self:doThis("cycle-inf-no", "loop-playlist")
      end,
      ["loop"] = function (self)
        self:doThis("cycle-inf-no", "loop-file")
      end,
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