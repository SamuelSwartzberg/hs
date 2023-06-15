--- @type ItemSpecifier
AudiodeviceSpecifierItemSpecifier = {
  type = "audiodevice-specifier",
  properties = {
    getables = {
      ["to-string"] = bc(transf.audiodevice_specifier.name),
      ["chooser-initial-selected"] = bc(is.audiodevice_specifier.default)
    }
  }
}

function CreateAudiodeviceSpecifierItem(device, subtype)

  if subtype ~= "input" and subtype ~= "output" then
    error("subtype of audiodevice item must be either 'input' or 'output'")
  end

  return RootInitializeInterface(
    AudiodeviceSpecifierItemSpecifier,
    {
      device = device,
      subtype = subtype
    }
  )
end

