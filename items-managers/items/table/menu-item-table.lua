--- @type ItemSpecifier
MenuItemTableSpecifier = {
  type = "menu-item-table",
  properties = {
    getables = {
      ["to-string"] = bc(transf.menu_item_table.summary)
    }
  }

}

--- @type BoundRootInitializeInterface
CreateMenuItemTable = bindArg(RootInitializeInterface, MenuItemTableSpecifier)
