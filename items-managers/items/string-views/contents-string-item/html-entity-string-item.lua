--- @type ItemSpecifier
HTMLEntityEncodedStringItemSpecifier = {
  type = "html-entity-encoded-string-item",
  properties = {
    getables = {
      ["html-entities-decoded"] = function(self)
        return htmlEntities.decode(self:get("contents"))
      end
    }
  },
  action_table = getChooseItemTable({
    {
      description = "hendc",
      emoji_icon = "πΆπ",
      key = "html-entities-decoded"
    }
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateHTMLEntityEncodedStringItem = bindArg(NewDynamicContentsComponentInterface, HTMLEntityEncodedStringItemSpecifier)

--- @type ItemSpecifier
HTMLEntityDecodedStringItemSpecifier = {
  type = "html-entity-decoded-string-item",
  properties = {
    getables = {
      ["html-entities-encoded"] = function(self)
        return htmlEntities.encode(self:get("contents"))
      end
    }
  },
  action_table = getChooseItemTable({
    {
      description = "henec",
      emoji_icon = "πΆπ¦",
      key = "html-entities-encoded"
    }
  })
}


--- @type BoundNewDynamicContentsComponentInterface
CreateHTMLEntityDecodedStringItem = bindArg(NewDynamicContentsComponentInterface, HTMLEntityDecodedStringItemSpecifier)


