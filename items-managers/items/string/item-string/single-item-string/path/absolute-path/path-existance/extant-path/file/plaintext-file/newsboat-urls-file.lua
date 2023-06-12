

--- @type ItemSpecifier
NewsboatUrlsFileItemSpecifier = {
  type = "newsboat-urls-file",
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNewsboatUrlsFileItem = bindArg(NewDynamicContentsComponentInterface, NewsboatUrlsFileItemSpecifier)