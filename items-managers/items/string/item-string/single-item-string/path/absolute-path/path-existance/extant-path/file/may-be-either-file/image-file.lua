

--- @type ItemSpecifier
ImageFileItemSpecifier = {
  type = "image-file",
  properties = {
    getables = {
      ["as-hs-image"] = function(self)
        return transf.real_image_path.hs_image(self:get("completely-resolved-path"))
      end,
      ["chooser-image"] = function(self)
        return self:get("as-hs-image")
      end,
      ["booru-url"] = function(self)
        return transf.real_image_path.booru_url(self:get("completely-resolved-path"))
      end,
      ["qr-data"] = function(self)
        return transf.real_image_path.qr_data(self:get("completely-resolved-path"))
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
      ["add-as-otp"] = function(self, name)
        dothis.pass.add_otp_url(transf.real_image_path.qr_data(self:get("completely-resolved-path")), name)
      end,
      ["shrink"] = function(self)
        local shrink_specifier_array = CreateArray(map( {
          { type = "image", format = "png" },
          { type = "image", format = "jpg" },
          { type = "image", format = "png", resize = true },
          { type = "image", format = "jpg", resize = true },
        },CreateTable ))
        shrink_specifier_array:doThis("create-shrunken-versions", self:get("completely-resolved-path"))
        self:doThis("move-replace-self", shrink_specifier_array:get("best-version"))
        shrink_specifier_array:doThis("delete-non-best-versions")
      end,
    }
  },
  action_table = concat(
    getChooseItemTable({
      {
        emoji_icon = "🍡",
        description = "bruurl",
        key = "booru-url"
      },
      {
        emoji_icon = "🔳🎒",
        description = "qrcnt",
        key = "qr-data"
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
      {
        text = "📌⌚️🗝 addotp.",
        key = "do-interactive",
        args = { key = "add-as-otp", thing = "name" }
      }
    }
  )
}

--- @type BoundNewDynamicContentsComponentInterface
CreateImageFileItem = bindArg(NewDynamicContentsComponentInterface, ImageFileItemSpecifier)