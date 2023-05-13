--- @type ItemSpecifier
YoutubeApiExtensionItemSpecifier = {
  type = "youtube-api-extension",
  properties = {
    getables = {
      ["result"] = function(self, specifier)
        return rest({
          host = self:get("contents"),
          endpoint = specifier.endpoint,
          params = specifier.params,
        }).items
      end,
      ["result-youtube-data-api-wrapper"] = function(self, specifier)
        specifier.endpoint = "noKey/" .. specifier.endpoint
        specifier.params = specifier.params or {}
        specifier.params.part = specifier.params.part or "snippet"
        return self:get("result", specifier)
      end,
      ["result-youtube-data-api-wrapper-first"] = function(self, specifier)
        return self:get("result-youtube-data-api-wrapper", specifier)[1]
      end,
      ["result-youtube-data-api-wrapper-first-snippet"] = function(self, specifier)
        return self:get("result-youtube-data-api-wrapper-first", specifier).snippet
      end,
      ["channel-id-to-pretty-name"] = function(self, channel_id)
        return self:get("result-youtube-data-api-wrapper-first-snippet", {
          endpoint = "channels",
          params = {
            id = channel_id,
          },
        }).title
      end,
      ["channel-handle-to-channel-id"] = function(self, channel_handle)
        local result = self:get("result", {
          endpoint = "channels",
          params = {
            handle = channel_handle,
          }
        })
        return result[1].id
      end,
      
    },
    doThisables = {
      
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYoutubeApiExtensionItem = bindArg(NewDynamicContentsComponentInterface, YoutubeApiExtensionItemSpecifier)

