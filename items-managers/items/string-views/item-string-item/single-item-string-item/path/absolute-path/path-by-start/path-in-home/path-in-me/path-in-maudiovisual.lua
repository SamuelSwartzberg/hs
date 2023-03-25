--- @type ItemSpecifier
PathInMaudiovisualItemSpecifier = {
  type = "path-in-maudivisual-item",
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
      ["do-unavailable-urls"] = function(self, do_after)
        local urls = self:get("media-urls-array"):get("contents")
        runThreaded(map(urls, function(url)
          return url, {"youtube-dl", "--get-title", "--flat-playlist", { value = url, type = "quoted" }}
        end, {"k", "kv"}), 10, nil, function (command_results)
          for url, result in prs(command_results) do
            local err_lines = stringy.split(result.std_err, "\n")
            local is_unavailable = find(err_lines, function(line)
              return stringy.startswith(line, "ERROR: Private video")
            end)
            print("is_unavailable: " .. tostring(is_unavailable))
            if is_unavailable then
              do_after(url)
            end
          end
        end)
      end,
      ["qf-unavailable-urls"] = function (self)
        self:doThis("do-unavailable-urls", function(url)
          writeFile(env.MQFMUSIC, url .. " (unavailable)\n", "exists", false, "a")
        end)
      end
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathInMaudiovisualItem = bindArg(NewDynamicContentsComponentInterface, PathInMaudiovisualItemSpecifier)