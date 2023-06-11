

--- @type ItemSpecifier
XmlFileItemSpecifier = {
  type = "xml-file",
  action_table = {},
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateXmlFileItem = bindArg(NewDynamicContentsComponentInterface, XmlFileItemSpecifier)