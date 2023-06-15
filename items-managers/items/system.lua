--- @type ItemSpecifier
SystemSpecifier = {
  type = "system",
  properties = {
    getables = {
      ["all-non-root-volumes-string-array"] = function()
        local volume_arr = ar(filter(
          keys(hs.fs.volume.allVolumes()),
          {
            _exactly = "/",
            _invert = true
          }
        ))
        if volume_arr:get("length") > 0 then
          return volume_arr
        else 
          error("No non-root volumes found.", 0)
        end
      end,
      ["all-non-root-volumes-string-item-array"] = function(self)
        return self:get("all-non-root-volumes-string-array"):get("to-string-item-array")
      end,
      ["all-devices-of-type-audiodevice-array"] = function(self, subtype)
        return ar(map(
          values(
            hs.audiodevice["all" .. replace(subtype, to.case.capitalized) .. "Devices"]()
          ),
          bind(CreateAudiodeviceSpecifierItem, {a_use, subtype })
        ))
      end,
      ["all-output-devices-audiodevice-array"] = function(self)
        return self:get("all-devices-of-type-audiodevice-array", "output")
      end,
      ["all-input-devices-audiodevice-array"] = function(self)
        return self:get("all-devices-of-type-audiodevice-array", "input")
      end,
      ["all-windows-array"] = function(self)
        local all_windows_raw = hs.window.filter.default:getWindows()
        return ar(map(
          all_windows_raw,
          CreateWindowlikeItem
        ))
      end,
      ["manager"] = function(self, name)
        return self.contents["global-" .. name .. "-manager"]
      end,
    },
    doThisables = {
     
    }
  },
  action_table = {},
}

function CreateSystem()
  local system = RootInitializeInterface(SystemSpecifier, {})
  system:get("c")["global-hotkey-manager"] = CreateManagedHotkeyArrayDirectly()
  system:get("c")["global-timer-manager"] = CreateManagedTimerArrayDirectly()
  system:get("c")["global-clipboard-manager"] = CreateManagedClipboardArrayDirectly()
  system:get("c")["global-stream-manager"] = CreateManagedStreamArrayDirectly(system:get("c")["global-timer-manager"])
  system:get("c")["global-watcher-manager"] = CreateManagedWatcherArrayDirectly()
  system:get("c")["global-task-manager"] = CreateManagedTaskArrayDirectly()
  system:get("c")["global-input-method-manager"] = CreateManagedInputMethodArrayDirectly()
  return system
end
