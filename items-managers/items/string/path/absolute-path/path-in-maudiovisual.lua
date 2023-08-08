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
        specifier = conclat(specifier, { initial_data = { path = self.root_super } })
        self
          :get("media-urls-string-item-array")
          :doThis("to-stream", specifier)
      end,
      ["lines-as-stream-queue"] = function(m3ufile)
        ar(transf.plaintext_file.line_array(m3ufile:get("c"))):doThis("for-all", function(url)
            if url == "" then return end
            System:get("manager", "stream")
              :doThis(
                "create", 
                { initial_data = { urls = ar({st(url)})}}
              )
        end)
        m3ufile:doThis("empty-file")
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathInMaudiovisualItem = bindArg(NewDynamicContentsComponentInterface, PathInMaudiovisualItemSpecifier)