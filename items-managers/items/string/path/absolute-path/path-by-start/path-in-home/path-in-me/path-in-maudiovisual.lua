--- @type ItemSpecifier
PathInMaudiovisualItemSpecifier = {
  type = "path-in-maudivisual",
  properties = {
    getables = {
      ["base-path"] = function()
        return env.MAUDIOVISUAL
      end,
      ["media-urls-array"] = function(self)
        return self
          :get("descendant-file-only-string-item-array")
          :get("filter-to-array-of-type", "m3u-file")
          :get("map-to-line-array-of-file-contents-with-no-empty-strings")
      end,
      ["media-urls-string-item-array"] = function(self)
        return self
          :get("media-urls-array")
          :get("to-string-item-array")
      end,

    },
    doThisables = {
      ["to-stream"] = function(self, specifier)
        specifier = concat(specifier, { initial_data = { path = self.root_super } })
        self
          :get("media-urls-string-item-array")
          :doThis("to-stream", specifier)
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathInMaudiovisualItem = bindArg(NewDynamicContentsComponentInterface, PathInMaudiovisualItemSpecifier)