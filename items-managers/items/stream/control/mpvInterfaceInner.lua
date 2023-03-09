--- @type ItemSpecifier
MPVInterfaceInnerSpecifier = {
  type = "mpv-interface-inner",
  
  properties = {
    getables = {
      ["socket"] = function(self)
        return self.contents:getSocket()
      end,
      ["alive"] = function(self)
        return self.contents:getResponse({ command = { "get_property", "pid" } }) ~= nil
      end,
      --- @alias getsetable_key "time-pos" | "playlist-pos" | "playlist-play-index" | "percent-pos" | "chapter" | "pause" | "shuffle" | "loop" | "loop-playlist" | "video"
      --- @alias getable_key getsetable_key | "duration" |  "media-title" | "eof-reached" | "playlist-count" | "stream-open-filename" | "filename"
      --- @param key getable_key
      ["key"] = function(self, key)
        return self.contents:getResponse({ command = { "get_property", key } })
      end,
      ["as-int"] = function(self, key)
        local res = toNumber(self:get("key", key), "pos-int")
        return res
      end,
    },
  
    doThisables = {
      --- @param specifier { key: getsetable_key, args: any[] | any}
      ["set"] = function(self, specifier)
        self.contents:getResponse({ command = { "set_property", specifier.key, returnUnpackIfTable(specifier.args) } })
      end,
      --- @alias execable_key "playlist-shuffle" | "playlist-next" | "playlist-prev" | "quit" | "cycle"
      --- @param specifier { key: execable_key, args: any[] | any}
      ["exec"] = function(self, specifier)
        self.contents:getResponse({ command = { specifier.key, returnUnpackIfTable(specifier.args) } })
      end,
      --- @param key getsetable_key
      ["cycle"] = function(self, key)
        self.contents:getResponse({ command = { "cycle", key } })
      end,
    }
  }
}

function GetMPVInterfaceInner(super)
  local interface =  concat(
    MPVInterfaceInnerSpecifier,
    {contents = BuildIPCSocket()}
  )
  return NewDynamicContentsComponentInterface(interface, super)
end
