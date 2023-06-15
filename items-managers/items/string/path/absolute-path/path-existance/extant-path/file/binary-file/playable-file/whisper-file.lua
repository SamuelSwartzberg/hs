--- @type ItemSpecifier
WhisperFileItemSpecifier = {
  type = "whisper-file",
  properties = {
    getables = {
      ["transcribed"] = function (self)
        return (self:get("completely-resolved-path"))
      end
    },
    doThisables = {
    }
  },
  potential_interfaces = ovtable.init({
  }),
  action_table = {
    {
      i = "🗣️➡️📝",
      d = "trsc",
      filter = st,
      get = "c",
      getfn = transf.audio_file.transcribed,
      key = "transcribed"
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateWhisperFileItem = bindArg(NewDynamicContentsComponentInterface, WhisperFileItemSpecifier)