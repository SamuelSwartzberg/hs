--- @type ItemSpecifier
DataURLItemSpecifier = {
  type = "data-url",
  properties = {
    getables = {
      ["data-content-type"] = function(self)
        return transf.data_url.content_type(self:get("contents"))
      end,
      ["is-image-data-url"] = function(self)
        return is.media_type.image(self:get("data-content-type"))
      end,
      ["is-base-64-data-url"] = function (self)
        return is.data_url.base64(self:get("contents"))
      end,
      ["payload-part"] = function (self)
        return transf.data_url.payload_part(self:get("contents"))
      end
    }, 
    doThisables = {
      
    }
  },

  action_table =concat(getChooseItemTable({
    {
      emoji_icon = "📊🔗🎒",
      description = "dturlct.",
      key = "payload-part"
    },
  }),{}),
  potential_interfaces = ovtable.init({
    { key = "image-data-url", value = CreateImageDataURLItem },
    { key = "base-64-data-url", value = CreateBase64DataURLItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDataURLItem = bindArg(NewDynamicContentsComponentInterface, DataURLItemSpecifier)