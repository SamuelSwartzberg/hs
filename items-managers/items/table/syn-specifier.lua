SynSpecifierSpecifier = {
  type = "synonyms-table",
  properties = {
    getables = {
      ["to-string"] = bc(transf.syn_specifier.summary)
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateSynSpecifier = bindArg(NewDynamicContentsComponentInterface, SynSpecifierSpecifier)
