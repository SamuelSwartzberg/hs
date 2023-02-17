--- @type ItemSpecifier
AudiodeviceItemSpecifier = {
  type = "audiodevice-item",
  properties = {
    getables = {
      ["name"] = function (self)
        return self:get("contents").device:name()
      end,
      ["default-device-subtype"] = function(self) 
        return "default" .. changeCasePrefix(self:get("contents").subtype) .. "Device"
      end,
      ["is-default-device"] = function (self) 
        return self:get("device") == hs.audiodevice[self:get("default-device-subtype")]()
      end,
      ["to-string"] = function(self)
        return self:get("name")
      end,
      ["chooser-initial-selected"] = function(self)
        return self:get("is-default-device")
      end,
      ["device"] = function (self)
        return self:get("contents").device
      end,
      ["subtype"] = function (self)
        return self:get("contents").subtype
      end,
    },
    doThisables = {
      ["set-default"] = function(self)
        self:get("device")["set" .. changeCasePrefix(self:get("default-device-subtype"))](self:get("device"))
      end,
    }
  }
}

function CreateAudiodeviceItem(device, subtype)

  if subtype ~= "input" and subtype ~= "output" then
    error("subtype of audiodevice item must be either 'input' or 'output'")
  end

  return RootInitializeInterface(
    AudiodeviceItemSpecifier,
    {
      device = device,
      subtype = subtype
    }
  )
end

