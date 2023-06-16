CslTableSpecifier = {
  type = "csl-table",
  properties = {
    getables = {
      ["to-string"] = function(self)
        return 
          (self:get("issued") or "No date") .. ", " ..
          (self:get("author") or "No author") .. ": " ..
          (self:get("title") or "No title") .. ". " ..
          self:get("to-string-unique")
      end,
    },
    doThisables = {

    },
  },
  potential_interfaces = ovtable.init({
    { key = "csl-book", value = CreateCslBook },
    { key = "csl-article-journal", value = CreateCslArticleJournal },
    { key = "csl-webpage", value = CreateCslWebpage },
    { key = "csl-motion-picture", value = CreateCslMotionPicture },
    
  }),
  action_table = {
      {
        i = "📖",
        d = "cttn",
        key = "get-interactive",
        args = { key = "to-citation", thing = "citation style (e.g.apa or apa-6th-edition)" }
      },
      {
        text = "👉🔬 ccitid.",
        key ="choose-action-on-result-of-get",
        args = { key = "to-citable-object-id" }
      },{
        text = "👉🔗 ccururl.",
        key = "choose-action-on-result-of-get",
        args = { key = "to-url-item"}
      },
    }
  
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateCslTable = bindArg(NewDynamicContentsComponentInterface, CslTableSpecifier)
