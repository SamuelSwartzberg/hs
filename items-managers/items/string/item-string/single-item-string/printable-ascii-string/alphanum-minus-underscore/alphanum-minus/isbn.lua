-- isbn means \w+

--- @type ItemSpecifier
IsbnItemSpecifier = {
  type = "isbn",
  properties = {
    getables = {
      ["is-citable-object-id"] = returnTrue,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "citable-object-id", value = CreateCitableObjectIdItem },
  }),
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateIsbnItem = bindArg(NewDynamicContentsComponentInterface, IsbnItemSpecifier)