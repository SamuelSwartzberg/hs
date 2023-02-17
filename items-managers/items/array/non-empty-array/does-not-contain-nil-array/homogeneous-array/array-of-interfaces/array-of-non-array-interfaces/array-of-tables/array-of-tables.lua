ArrayOfTablesSpecifier = {
  type = "array-of-tables",
  properties = {
    getables = {
      ["is-array-of-non-empty-tables"] = bindNthArgs(isArrayOfInterfacesOfType, 2, "non-empty-table"),
    },
    doThisables = {
      
    },
  },
  potential_interfaces = ovtable.init({
    { key = "array-of-non-empty-tables", value = CreateArrayOfNonEmptyTables },
  }),
  action_table = {}
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfTables = bindArg(NewDynamicContentsComponentInterface, ArrayOfTablesSpecifier)



