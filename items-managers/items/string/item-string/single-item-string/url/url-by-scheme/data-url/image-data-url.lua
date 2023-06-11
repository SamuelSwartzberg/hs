--- @type ItemSpecifier
ImageDataURLItemSpecifier = {
  type = "image-data-url",
  properties = {
    getables = {
      ["as-hs-image"] = function (self)
        return transf.image_url.hs_image(self:get("c"))
      end,
      ["chooser-image"] = function(self)
        return self:get("as-hs-image")
      end,
    }, 
    doThisables = {
      
    }
  },

  action_table =concat(getChooseItemTable({
    
  }),{})
}

--- @type BoundNewDynamicContentsComponentInterface
CreateImageDataURLItem = bindArg(NewDynamicContentsComponentInterface, ImageDataURLItemSpecifier)