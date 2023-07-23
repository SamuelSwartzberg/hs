

--- @type ItemSpecifier
ImageFileItemSpecifier = {
  type = "image-file",

  action_table = concat(
    getChooseItemTable({{
      {
        text = "📌 addtbru.",
        key = "add-to-local-booru",
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