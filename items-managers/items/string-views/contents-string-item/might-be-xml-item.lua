--- @type ItemSpecifier
MightBeXmlItemSpecifier = {
  type = "might-be-xml-item",
  properties = {
    getables = {
      ["parse-as-xml"] = function(self)
        return xml.parse(self:get("contents"))
      end,
      ["parse-as-rooted-xml-to-table"] = function(self)
        return CreateTable(self:get("parse-as-xml").children[1])
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateMightBeXmlItem = bindArg(NewDynamicContentsComponentInterface, MightBeXmlItemSpecifier)