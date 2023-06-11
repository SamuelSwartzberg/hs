--- @type ItemSpecifier
DateRelatedItemSpecifier = {
  type = "date-related",
  properties = {
    getables = {
      ["to-date-obj"] = function(self)
        return date(self:get("c"))
      end,
      ["to-date-obj-item"] = function(self)
        return dat(self:get("to-date-obj"))
      end,
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDateRelatedItem = bindArg(NewDynamicContentsComponentInterface, DateRelatedItemSpecifier)


