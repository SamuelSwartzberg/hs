--- @type ItemSpecifier
WhisperURLItemSpecifier = {
  type = "whisper-url",
  properties = {
    getables = {
      ["transcribed"] = function (self)
        return transf.whisper_url.transcribed(self:get("url-path"))
      end
    },
    doThisables = {
    
    }
  },
  action_table = concat(
    getChooseItemTable({
      {
        emoji_icon = "🍡",
        description = "bruurl",
        key = "booru-url"
      }
    }),{
    }
  )
}

--- @type BoundNewDynamicContentsComponentInterface
CreateWhisperURLItem = bindArg(NewDynamicContentsComponentInterface, WhisperURLItemSpecifier)