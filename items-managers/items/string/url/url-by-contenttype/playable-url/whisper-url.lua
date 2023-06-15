--- @type ItemSpecifier
WhisperURLItemSpecifier = {
  type = "whisper-url",
  action_table = {
      {
        i = "",
        d = "",
        getfn = transf.whisper_url.transcribed
      }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateWhisperURLItem = bindArg(NewDynamicContentsComponentInterface, WhisperURLItemSpecifier)