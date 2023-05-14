--- @type ItemSpecifier
VolumeItemSpecifier = {
  type = "volume",
  properties = {
    getables = {
      ["is-non-root-volume"] = function(self) return not self:get("is-root-dir") end
    }
  },
  potential_interfaces = ovtable.init({
    { key = "non-root-volume", value = CreateNonRootVolumeItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateVolumeItem = bindArg(NewDynamicContentsComponentInterface, VolumeItemSpecifier)