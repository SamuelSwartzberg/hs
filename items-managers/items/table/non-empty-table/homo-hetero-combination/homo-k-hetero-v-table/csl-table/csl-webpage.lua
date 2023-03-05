CslWebpageSpecifier = {
  type = "csl-webpage",
  properties = {
    getables = {
      ["to-string-unique"] = function(self)
        return 
          (self:get("value", "URL") or "No URL") .. ", " 
          .. "accessed at " .. (self:get("csl-date-to-rfc3339", "accessed") or "No access date")
      end,
      ["to-citable-object-id"] = function(self)
        return CreateStringItem(transf.string.base64_url(self:get("value", "url")))
      end,

        
    },
    doThisables = {
     
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateCslWebpage = bindArg(NewDynamicContentsComponentInterface, CslWebpageSpecifier)
