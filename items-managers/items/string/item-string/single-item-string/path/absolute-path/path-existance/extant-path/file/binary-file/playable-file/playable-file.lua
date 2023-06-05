--- @type ItemSpecifier
PlayableFileItemSpecifier = {
  type = "playable-file",
  properties = {
    getables = {
      ["is-whisper-file"] = function(self)
        return is.path.usable_as_filetype(self:get("contents"), "whisper_audio")
      end,
    },
    doThisables = {
    }
  },
  potential_interfaces = ovtable.init({
    { key = "whisper-file", value = CreateWhisperFileItem },
  }),
  action_table = {},
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePlayableFileItem = bindArg(NewDynamicContentsComponentInterface, PlayableFileItemSpecifier)