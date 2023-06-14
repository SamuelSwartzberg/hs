CslMotionPictureSpecifier = {
  type = "csl-motion-picture",
  properties = {
    getables = {
      ["to-string-unique"] = function(self)
        return 
          (self:get("value", "URL") or "No URL") .. ", " 
          .. "accessed at " .. (self:get("csl-date-to-rfc3339", "accessed") or "No access date")
      end,

        
    },
    doThisables = {
     
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateCslMotionPicture = bindArg(NewDynamicContentsComponentInterface, CslMotionPictureSpecifier)
