

ImageShrinkSpecifierTableSpecifier = {
  type = "image-shrink-specifier-table",
  properties = {
    getables = {
      ["multiplier"] = function(self)
        local multiplier = 1 
        if self:get("value", "format") == "png" then
          multiplier = multiplier * 0.65
        end
        if self:get("value", "resize") then 
          multiplier = multiplier * 0.6
        end
        return multiplier
      end,
      ["result-file"] = function(self)
        return CreateStringItem(self:get("value", "result"))
      end,
      ["score"] = function(self)
        return self:get("value", "size") * self:get("multiplier")
      end,
      ["quality-part"] = function(self)
        if self:get("value", "format") == "png" then
          return {"-quality=80"}
        else
          return {}
        end
      end,
      ["resize-part"] = function(self, path)
        if self:get("value", "resize") then
          local filesize = hs.fs.attributes(path, "size")
          -- ensure that we don't resize files that are too small, and that we only resize to unit fractions of the original size (e.g. 1/2, 1/3, 1/4, etc.), to avoid quality loss due to averaging
          if filesize > 6 * (10^6) then
            return {"-resize=50%"}
          elseif filesize > 12 * (10^6) then
            return {"-resize=33%"}
          elseif filesize > 18 * (10^6) then
            return {"-resize=25%"}
          else
            return {}
          end
        else
          return {}
        end
      end,

    },
    doThisables = {
      ["shrink"] = function(self, path)
        runHsTask({
          "convert",
          { value = path, type = "quoted" },
          table.unpack(self:get("quality-part")),
          table.unpack(self:get("resize-part", path)),
          { value = self:get("shrunken-path", path), type = "quoted" },
        })
      end,
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateImageShrinkSpecifierTable = bindArg(NewDynamicContentsComponentInterface, ImageShrinkSpecifierTableSpecifier)
