--- @type ItemSpecifier
MightBeXmlItemSpecifier = {
  type = "might-be-xml",
  properties = {
    getables = {
      ["parse-as-xml"] = function(self)
        return xml.parse(self:get("c"))
      end,
      ["parse-as-rooted-xml-to-table"] = function(self)
        return tb(self:get("parse-as-xml").children[1])
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateMightBeXmlItem = bindArg(NewDynamicContentsComponentInterface, MightBeXmlItemSpecifier)