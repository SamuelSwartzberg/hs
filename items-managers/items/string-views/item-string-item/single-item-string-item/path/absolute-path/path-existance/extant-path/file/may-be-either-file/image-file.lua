

--- @type ItemSpecifier
ImageFileItemSpecifier = {
  type = "image-file",
  properties = {
    getables = {
      ["as-hs-image"] = function(self)
        return memoized.imageFromPath(self:get("contents"))
      end,
      ["chooser-image"] = function(self)
        return self:get("as-hs-image")
      end,
      ["booru-url"] = function(self)
        return run({
          "saucenao",
          "--file",
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
      ["copy-as-image"] = function(self)
        hs.pasteboard.writeObjects(self:get("as-hs-image"))
      end,
      ["paste-as-image"] = function(self)
        hs.pasteboard.writeObjects(self:get("as-hs-image"))
        hs.eventtap.keyStroke({"cmd"}, "v")
      end,
      ["shrink"] = function(self)
        local shrink_specifier_array = CreateArray(mapValueNewValue( {
          { type = "image", format = "png" },
          { type = "image", format = "jpg" },
          { type = "image", format = "png", resize = true },
          { type = "image", format = "jpg", resize = true },
        },CreateTable ))
        shrink_specifier_array:doThis("create-shrunken-versions", self:get("contents"))
        self:doThis("move-replace-self", shrink_specifier_array:get("best-version"))
        shrink_specifier_array:doThis("delete-non-best-versions")
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
      },
      {
        text = "📋🏞 cpasimg.",
        key = "copy-as-image",
      },
      {
        text = "📎🏞 pstasimg.",
        key = "paste-as-image",
      },
      {
        text = "📎🏞🗑 pstasimgrm.",
        key = "do-multiple",
        args = { { key = "paste-as-image" }, { key = "rm-file" } }
      },
    }
  )
}

--- @type BoundNewDynamicContentsComponentInterface
CreateImageFileItem = bindArg(NewDynamicContentsComponentInterface, ImageFileItemSpecifier)