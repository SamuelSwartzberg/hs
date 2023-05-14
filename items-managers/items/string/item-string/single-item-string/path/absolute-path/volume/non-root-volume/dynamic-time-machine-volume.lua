--- @type ItemSpecifier
DynamicTimeMachineVolumeItemSpecifier = {
  type = "dynamic-time-machine-volume",
  properties = {
    doThisables = {
     
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDynamicTimeMachineVolumeItem = bindArg(NewDynamicContentsComponentInterface, DynamicTimeMachineVolumeItemSpecifier)