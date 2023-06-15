--- @type ItemSpecifier
FirefoxPlacesSqliteFileItemSpecifier = {
  type = "firefox-places-sqlite-file",
}

--- @type BoundNewDynamicContentsComponentInterface
CreateFirefoxPlacesSqliteFileItem = bindArg(NewDynamicContentsComponentInterface, FirefoxPlacesSqliteFileItemSpecifier)