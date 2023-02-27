--- @type ItemSpecifier
ArrayOfNonEmptyTablesSpecifier = {
  type = "array-of-non-empty-tables",
  properties = {
    getables = {
      ["flatten-to-single-table"] = function(self)
        return CreateTable(flattenListOfAssocArrs(self:get("map-to-table-of-contents")))
      end,
      ["is-array-of-shrink-specifier-tables"] = bind(isArrayOfInterfacesOfType, { ["2"] = "shrink-specifier-table" }),
    },
    doThisables = { },
  },
  potential_interfaces = ovtable.init({
    { key = "array-of-shrink-specifier-tables", value = CreateArrayOfShrinkSpecifierTables },
  }),
  action_table = {}
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfNonEmptyTables = bindArg(NewDynamicContentsComponentInterface, ArrayOfNonEmptyTablesSpecifier)


