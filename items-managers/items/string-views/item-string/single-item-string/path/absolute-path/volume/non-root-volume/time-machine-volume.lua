--- @type ItemSpecifier
TimeMachineVolumeItemSpecifier = {
  type = "time-machine-volume",
  properties = {
    doThisables = {
     
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTimeMachineVolumeItem = bindArg(NewDynamicContentsComponentInterface, TimeMachineVolumeItemSpecifier)