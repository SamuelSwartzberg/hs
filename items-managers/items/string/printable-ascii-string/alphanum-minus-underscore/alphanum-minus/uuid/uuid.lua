--- @type ItemSpecifier
UuidItemSpecifier = {
  type = "uuid",
  properties = {
    getables = {
      ["is-contact"] = bc(is.uuid.contact)
    }
  },
  ({
    { key = "contact", value = CreateContactItem },
   
  }),
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateUuidItem = bindArg(NewDynamicContentsComponentInterface, UuidItemSpecifier)