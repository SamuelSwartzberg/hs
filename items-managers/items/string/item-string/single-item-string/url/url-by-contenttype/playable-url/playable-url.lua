--- @type ItemSpecifier
PlayableURLItemSpecifier = {
  type = "playable-url",
  properties = {
    getables = {
      ["is-whisper-url"] = function(self)
        return is.path.usable_as_filetype(self:get("url-path"), "whisper-audio")
      end,
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
  ),
  potential_interfaces = ovtable.init({
    { key = "whisper-url", value = CreateWhisperURLItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePlayableURLItem = bindArg(NewDynamicContentsComponentInterface, PlayableURLItemSpecifier)