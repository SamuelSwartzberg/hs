--- @type ItemSpecifier
SystemSpecifier = {
  type = "system",
  properties = {
    getables = {
      ["all-non-root-volumes-string-array"] = function()
        local volume_arr = CreateArray(listFilter(
          keys(hs.fs.volume.allVolumes()),
          function(volume)
            return volume ~= "/"
          end
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
        return CreateArray(mapValueNewValue(
          values(
            hs.audiodevice["all" .. changeCasePre(subtype, 1, "up") .. "Devices"]()
          ),
          bindNthArg(CreateAudiodeviceItem, 2, subtype)
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
        return CreateArray(mapValueNewValue(
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
  system:get("contents")["global-hotkey-manager"] = CreateManagedHotkeyArrayDirectly()
  system:get("contents")["global-timer-manager"] = CreateManagedTimerArrayDirectly()
  system:get("contents")["global-clipboard-manager"] = CreateManagedClipboardArrayDirectly()
  system:get("contents")["global-stream-manager"] = CreateManagedStreamArrayDirectly(system:get("contents")["global-timer-manager"])
  system:get("contents")["global-api-manager"] = CreateManagedApiArrayDirectly(system:get("contents")["global-timer-manager"])
  system:get("contents")["global-watcher-manager"] = CreateManagedWatcherArrayDirectly()
  system:get("contents")["global-task-manager"] = CreateManagedTaskArrayDirectly()
  system:get("contents")["global-input-method-manager"] = CreateManagedInputMethodArrayDirectly()
  return system
end
