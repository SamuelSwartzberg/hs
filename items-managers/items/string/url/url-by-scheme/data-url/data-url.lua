--- @type ItemSpecifier
DataURLItemSpecifier = {
  type = "data-url",
  properties = {
    getables = {
      ["data-content-type"] = function(self)
        return transf.data_url.content_type(self:get("c"))
      end,
      ["is-image-data-url"] = function(self)
        return is.media_type.image_media_type(self:get("data-content-type"))
      end,
      ["is-base-64-data-url"] = function (self)
        return is.data_url.base64_data_url(self:get("c"))
      end,
      ["payload-part"] = function (self)
        return transf.data_url.payload_part(self:get("c"))
      end
    }, 
    doThisables = {
      
    }
  },

  action_table ={
    {
      i = "📊🔗🎒",
      d = "dturlct.",
      key = "payload-part"
    },
  },
  ({
    { key = "image-data-url", value = CreateImageDataURLItem },
    { key = "base-64-data-url", value = CreateBase64DataURLItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDataURLItem = bindArg(NewDynamicContentsComponentInterface, DataURLItemSpecifier)