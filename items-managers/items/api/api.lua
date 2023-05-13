--- @type ItemSpecifier
ApiItemSpecifier = {
  type = "api",
  properties = {
    getables = {
      ["is-youtube-api"] = function(self)
        return self:get("contents") == "https://www.googleapis.com/youtube"
      end,
      ["is-youtube-api-extension"] = function(self)
        return self:get("contents") == "https://yt.lemnoslife.com/"
      end,
    },
    doThisables = {

    }
  },
  potential_interfaces = ovtable.init({
    { key = "youtube-api", value = CreateYoutubeApiItem },
    { key = "youtube-api-extension", value = CreateYoutubeApiExtensionItem },
  })
}

--- @type BoundRootInitializeInterface
function CreateApiItem(url)
  local api = RootInitializeInterface(ApiItemSpecifier, url)
  -- api:doThis("refresh-tokens") TODO reenable
  return api
end

