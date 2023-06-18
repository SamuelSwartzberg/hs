CslTableSpecifier = {
  type = "csl-table",
  properties = {
    getables = {
      ["to-string"] = bc(transf.csl_table.apa_string)
    }
  },
  action_table = {
    {
      i = "📖",
      d = "cttn",
      getfn = transf.csl_table.apa_string
    },
    {
      i = "🔬",
      d = "indcitid",
      getfn = transf.csl_table.indicated_citable_object_id
    },{
      i = "🔗",
      d = "url",
      getfn = transf.csl_table.url
    },
  }
  
  
}
--- @type BoundRootInitializeInterface
CreateCslTable = bindArg(RootInitializeInterface, CslTableSpecifier)
