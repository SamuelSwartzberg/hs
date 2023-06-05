--- @type ItemSpecifier
ImageURLItemSpecifier = {
  type = "image-url",
  properties = {
    getables = {
      ["booru-url"] = function (self)
        return transf.image_url.booru_url(self:get("contents"))
      end
    },
    doThisables = {
      ["add-to-local-booru"] = function(self)
        self:get("str-item", "booru-url"):doThis("add-to-local")
      end,
    }
  },
  action_table = concat(
    getChooseItemTable({
      {
        emoji_icon = "🍡",
        description = "bruurl",
        key = "booru-url"
      }
    }),{
      {
        text = "📌 addtbru.",
        key = "add-to-local-booru",
      }
    }
  )
}

--- @type BoundNewDynamicContentsComponentInterface
CreateImageURLItem = bindArg(NewDynamicContentsComponentInterface, ImageURLItemSpecifier)