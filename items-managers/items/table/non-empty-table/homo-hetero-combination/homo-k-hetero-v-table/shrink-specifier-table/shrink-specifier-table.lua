ShrinkSpecifierTableSpecifier = {
  type = "shrink-specifier-table",
  properties = {
    getables = {
      ["is-audio-shrink-specifier-table"] = function(self)
        return self:get("value", "type") == "audio"
      end,
      ["is-image-shrink-specifier-table"] = function(self)
        return self:get("value", "type") == "image"
      end,
      ["to-string"] = function(self)
        local outstr = ""
        local contents = self:get("contents")
        for k, v in fastpairs(contents) do
          outstr = outstr .. k .. ": " .. v .. "; "
        end
        return outstr
      end,
      ["shrunken-path"] = function(self, original_path)
        return env.TMPDIR .. "/shrink/" .. basexx.to_url64(self:get("to-string") .. original_path):sub(1, 255)
      end,
      ["result-file"] = function(self)
        return CreateStringItem(self:get("value", "result"))
      end,
    },
    doThisables = {
      
    },
  },
  potential_interfaces = ovtable.init({
    { key = "audio-shrink-specifier-table", value = CreateAudioShrinkSpecifierTable },
    { key = "image-shrink-specifier-table", value = CreateImageShrinkSpecifierTable },
  }),
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateShrinkSpecifierTable = bindArg(NewDynamicContentsComponentInterface, ShrinkSpecifierTableSpecifier)
