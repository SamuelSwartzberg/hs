--- @type ItemSpecifier
PathWithLineAndorCharacterNumberItemSpecifier = {
  type = "path-with-intra-file-locator",
  action_table = {
    {
      text = "🔷🆙 vsgt.",
      dothis = dothis.path_with_intra_file_locator.open_go_to
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathWithIntraFileLocator = bindArg(NewDynamicContentsComponentInterface, PathWithLineAndorCharacterNumberItemSpecifier)
