--- @type ItemSpecifier
UuidItemSpecifier = {
  type = "uuid",
  properties = {
    getables = {
      ["is-contact"] = function(self)
        return is.uuid.contact(self:get("contents"))
      end
    }
  },
  potential_interfaces = ovtable.init({
    { key = "contact", value = CreateContactItem },
   
  }),
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateUuidItem = bindArg(NewDynamicContentsComponentInterface, UuidItemSpecifier)