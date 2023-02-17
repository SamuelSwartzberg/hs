ArrayOfAudiodevicesSpecifier = {
  type = "array-of-audiodevices",
  properties = {
    getables = {
    },
    doThisables = {
      ["choose-and-set-default"] = function(self)
        self:doThis("choose-item", function(item) item:doThis("set-default") end)
      end,
    },
  },
  action_table = {}
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfAudiodevices = bindArg(NewDynamicContentsComponentInterface, ArrayOfAudiodevicesSpecifier)



