--- @type ItemSpecifier
NonRootVolumeItemSpecifier = {
  type = "non-root-volume",
  properties = {
    getables = {
      ["is-time-machine-volume"] = function(self)
        return self:get("path-ensure-final-slash") == env.TMBACKUPVOL .. "/"
      end,
      ["is-dynamic-time-machine-volume"] = function(self)
        return stringy.startswith(self:get("contents"), "/Volumes/com.apple.TimeMachine.localsnapshots/Backups.backupdb/" .. hs.host.localizedName() .. "/" .. os.date("%Y-%m-%d-%H"))
      end
    },
    doThisables = {
      eject = function (self)
        hs.fs.volume.eject(self:get("contents"))
        if valuesContain(hs.fs.volume.allVolumes(), self:get("contents")) then
          error("Volume could not be ejected.", 0)
        else 
          hs.alert.show("Volume ejected successfully.")
        end
      end
    }
  },
  potential_interfaces = ovtable.init({
    { key = "time-machine-volume", value = CreateTimeMachineVolumeItem },
    { key = "dynamic-time-machine-volume", value = CreateDynamicTimeMachineVolumeItem },
  }),
  action_table = {
    {
      text = "🤮 ej.",
      key = "eject"
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNonRootVolumeItem = bindArg(NewDynamicContentsComponentInterface, NonRootVolumeItemSpecifier)