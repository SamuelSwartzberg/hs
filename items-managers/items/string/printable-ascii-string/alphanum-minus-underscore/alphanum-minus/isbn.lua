-- isbn means \w+

--- @type ItemSpecifier
IsbnItemSpecifier = {
  type = "isbn",
  properties = {
    getables = {
      ["is-citable-object-id"] = transf["nil"]["true"],
    }
  },
  ({
    { key = "citable-object-id", value = CreateIndicatedCitableObjectIdItem },
  }),
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateIsbnItem = bindArg(NewDynamicContentsComponentInterface, IsbnItemSpecifier)