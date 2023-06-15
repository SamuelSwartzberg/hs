--- @type ItemSpecifier
MenuItemTableSpecifier = {
  type = "menu-item-table",

}

--- @type BoundNewDynamicContentsComponentInterface
CreateMenuItemTable = bindArg(NewDynamicContentsComponentInterface, MenuItemTableSpecifier)
