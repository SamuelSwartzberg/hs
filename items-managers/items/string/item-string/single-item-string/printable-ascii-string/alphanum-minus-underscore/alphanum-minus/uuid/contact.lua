--- @type ItemSpecifier
ContactItemSpecifier = {
  type = "contact",
  properties = {
    getables = {
      ["to-contact-table"] = function(self)
        return transf.uuid.contact_table(self:get("c"))
      end,

    }
  },
  
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateContactItem = bindArg(NewDynamicContentsComponentInterface, ContactItemSpecifier)