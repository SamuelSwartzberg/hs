--- @type ItemSpecifier
PlayableURLItemSpecifier = {
  type = "playable-url",
  properties = {
    getables = {
      ["is-whisper-url"] = bc(get.path.usable_as_filetype, "whisper-audio")
    },
  },
  ({
    { key = "whisper-url", value = CreateWhisperURLItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePlayableURLItem = bindArg(NewDynamicContentsComponentInterface, PlayableURLItemSpecifier)