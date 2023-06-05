--- @type ItemSpecifier
WhisperFileItemSpecifier = {
  type = "whisper-file",
  properties = {
    getables = {
      ["transcribed"] = function (self)
        return transf.real_audio_path.transcribed(self:get("completely-resolved-path"))
      end
    },
    doThisables = {
    }
  },
  potential_interfaces = ovtable.init({
  }),
  action_table = concat(
    getChooseItemTable({
      {
        emoji_icon = "🗣️➡️📝",
        description = "trsc",
        key = "transcribed"
      }
    }),{
      
    }
  ),
}

--- @type BoundNewDynamicContentsComponentInterface
CreateWhisperFileItem = bindArg(NewDynamicContentsComponentInterface, WhisperFileItemSpecifier)