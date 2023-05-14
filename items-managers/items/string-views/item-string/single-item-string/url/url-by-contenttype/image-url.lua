--- @type ItemSpecifier
ImageURLItemSpecifier = {
  type = "image-url",
  properties = {
    getables = {
      ["booru-url"] = function(self)
        return run({
          "saucenao",
          "--url",
          {
            value = self:get("contents"),
            type = "quoted"
          },
          "--output-properties",
          "booru-url"
        })
      end,
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