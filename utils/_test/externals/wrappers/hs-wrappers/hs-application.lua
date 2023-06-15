local menu_item_list_finder = transf.running_application.menu_item_table_array("Finder")

local new_folder_menu_item = find(
  menu_item_list_finder,
  function(menu_item)
    return menu_item:get("c").AXTitle == "New Folder"
  end
)

assertMessage(
  new_folder_menu_item ~= nil,
  true
)

assertMessage(
  new_folder_menu_item:get("full-path-string"),
  "File > New Folder"
)