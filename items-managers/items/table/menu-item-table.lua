--- @type ItemSpecifier
MenuItemTableSpecifier = {
  type = "menu-item-table",

}

--- @type BoundRootInitializeInterface
CreateMenuItemTable = bindArg(RootInitializeInterface, MenuItemTableSpecifier)
