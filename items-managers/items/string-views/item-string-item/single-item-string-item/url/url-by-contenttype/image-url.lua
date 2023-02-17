--- @type ItemSpecifier
ImageURLItemSpecifier = {
  type = "image-url-item",
  properties = {
    getables = {
      ["booru-url"] = function(self)
        local res = getOutputTask({
          "saucenao",
          "--url",
          {
            value = self:get("contents"),
            type = "quoted"
          },
          "--output-properties",
          "booru-url"
        })

        return res
      end,
    },
    doThisables = {
      ["add-to-local-booru"] = function(self)
        self:get("str-item", "booru-url"):doThis("add-to-local")
      end,
    }
  },
  action_table = listConcat(
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