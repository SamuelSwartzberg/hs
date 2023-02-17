--- @type ItemSpecifier
ContactItemSpecifier = {
  type = "contact-item",
  properties = {
    getables = {
      ["to-contact-table"] = function(self)
        return CreateShellCommand("khard"):get("show-contact-to-contact-table", self:get("contents"))
      end,

    }
  },
  
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateContactItem = bindArg(NewDynamicContentsComponentInterface, ContactItemSpecifier)