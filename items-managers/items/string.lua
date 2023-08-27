StringItemSpecifier = {
  type = "string",
  hs.fnutils.imap(
    mt._list.search_engine_names,
    transf.search_engine.action_table_item
  ),
}