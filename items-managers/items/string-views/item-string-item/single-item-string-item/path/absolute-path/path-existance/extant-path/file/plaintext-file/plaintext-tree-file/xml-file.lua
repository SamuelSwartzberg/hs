

--- @type ItemSpecifier
XmlFileItemSpecifier = {
  type = "xml-file",
  properties = {
    getables = {
      ["parse-to-lua-table"] = function(self)
        return xml.parseFile(self:get("contents"))
      end,
      ["lua-table-to-string"] = function(_, tbl)
        -- not implemented
      end,
    },
    doThisables = {
      
    }
  },
  action_table = {},
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateXmlFileItem = bindArg(NewDynamicContentsComponentInterface, XmlFileItemSpecifier)