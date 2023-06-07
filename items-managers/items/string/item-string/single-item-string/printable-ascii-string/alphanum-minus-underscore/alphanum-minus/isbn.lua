-- isbn means \w+

--- @type ItemSpecifier
IsbnItemSpecifier = {
  type = "isbn",
  properties = {
    getables = {
      ["bibtex-from-internet"] = function(self)
        return transf.isbn.bibtex(self:get("contents"))
      end,
      ["is-citable-object-id"] = function() return true end,
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