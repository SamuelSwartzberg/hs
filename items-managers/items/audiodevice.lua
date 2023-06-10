--- @type ItemSpecifier
AudiodeviceItemSpecifier = {
  type = "audiodevice",
  properties = {
    getables = {
      ["name"] = function (self)
        return get.audiodevice.name(self:get("device"))
      end,
      ["is-default-device"] = function (self) 
        return get.audiodevice.is_default(self:get("device"), self:get("subtype"))
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
        dothis.audiodevice.set_default(self:get("device"), self:get("subtype"))
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

