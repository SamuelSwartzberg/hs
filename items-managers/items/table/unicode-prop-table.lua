UnicodePropTableSpecifier = {
  type = "unicode-prop-table",
  action_table = {}
  
}
--- @type BoundRootInitializeInterface
CreateUnicodePropTable = bindArg(RootInitializeInterface, UnicodePropTableSpecifier)
