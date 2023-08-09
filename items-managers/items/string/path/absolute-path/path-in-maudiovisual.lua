--- @type ItemSpecifier
PathInMaudiovisualItemSpecifier = {
  type = "path-in-maudivisual",
  properties = {
    doThisables = {
      ["to-stream"] = function(self, specifier)
        specifier = conclat(specifier, { initial_data = { path = self.root_super } })
        self
          :get("media-urls-string-item-array")
          :doThis("to-stream", specifier)
      end,
      ["lines-as-stream-queue"] = function(m3ufile)
        ar(transf.plaintext_file.string_array_by_lines(m3ufile:get("c"))):doThis("for-all", function(url)
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