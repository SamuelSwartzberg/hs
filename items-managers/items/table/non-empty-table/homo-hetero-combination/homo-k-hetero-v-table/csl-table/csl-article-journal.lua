CslArticleJournalSpecifier = {
  type = "csl-article-journal",
  properties = {
    getables = {
      ["volume-str"] = function(self)
        return self:get("value", "volume") and "Vol. " .. self:get("value", "volume") or ""
      end,
      ["issue-str"] = function(self)
        return self:get("value", "issue") and "No. " .. self:get("value", "issue") or ""
      end,
      ["page-str"] = function(self)
        return self:get("value", "page") and "pp. " .. self:get("value", "page") or ""
      end,
      ["journal-str"] = function (self)
        return 
          (self:get("value", "container-title") or "No journal")
          .. "(" .. (self:get("value", "ISSN") or "No ISSN") .. ")"
      end,
      ["to-string-unique"] = function(self)
        return 
          (self:get("journal-str") .. " " ..
          (self:get("volume-str")) .. " " ..
          (self:get("issue-str")) .. " " ..
          (self:get("page-str")) .. ". " ..
          "DOI: " .. (self:get("value", "DOI") or "No DOI"))
      end,
      ["to-citable-object-id"] = function(self)
        return CreateStringItem(self:get("value", "DOI"))
      end,

        
    },
    doThisables = {
     
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateCslArticleJournal = bindArg(NewDynamicContentsComponentInterface, CslArticleJournalSpecifier)
