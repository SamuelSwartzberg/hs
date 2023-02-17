AudioShrinkSpecifierTableSpecifier = {
  type = "audio-shrink-specifier-table",
  properties = {
    getables = {
      ["score"] = function() return 1 end -- currently no dynamic scoring of audio-shrink-specifier-tables since we don't distinguish between different quality settings
        
    },
    doThisables = {
      ["shrink"] = function(self, path)
        runHsTask({
          "fmmpeg",
          "-hide_banner", "-loglevel", "warning",
          "-i", { value = path, type = "quoted" },
          "-c:a","libvorbis", "-map", "0:a:0", "-q:a 4",
          { value = self:get("shrunken-path", path), type = "quoted" },
        })
      end,
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateAudioShrinkSpecifierTable = bindArg(NewDynamicContentsComponentInterface, AudioShrinkSpecifierTableSpecifier)
