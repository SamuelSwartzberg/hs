CslBookSpecifier = {
  type = "csl-book",
  properties = {
    getables = {
      ["publisher-info"] = function(self)
        return self:get("value", "publisher") .. ": " .. self:get("value", "publisher-place")
      end,
      ["to-string-unique"] = function(self)
        return 
          (self:get("value", "edition")) .. " ed. " ..
          "Published by " .. (self:get("publisher-info") or "No publisher") .. ". " .. 
          "ISBN: " .. (self:get("value", "ISBN") or "No ISBN")
      end,
      ["to-citable-object-id"] = function(self)
        return CreateStringItem(self:get("value", "ISBN"))
      end,
    },
    doThisables = {
     
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateCslBook = bindArg(NewDynamicContentsComponentInterface, CslBookSpecifier)
