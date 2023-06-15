SynSpecifierSpecifier = {
  type = "synonyms-table",
  properties = {
    getables = {
      ["to-string"] = bc(transf.syn_specifier.summary)
    },
  },
  
  action_table = {
    {
      i = "📚☯️",
      d = "ant",
      getnf = transf.syn_specifier.antonyms_array,
      act = "cia"
    },{
      i = "📚☯️",
      d = "ant",
      getnf = transf.syn_specifier.antonyms_array,
      act = "ci"
    },{
      i = "📚🟰",
      d = "syn",
      getnf = transf.syn_specifier.synoynms_array,
      act = "cia"
    },{
      i = "📚🟰",
      d = "syn",
      getnf = transf.syn_specifier.synoynms_array,
      act = "ci"
    }
  }
  
}
--- @type BoundRootInitializeInterface
CreateSynSpecifier = bindArg(RootInitializeInterface, SynSpecifierSpecifier)
