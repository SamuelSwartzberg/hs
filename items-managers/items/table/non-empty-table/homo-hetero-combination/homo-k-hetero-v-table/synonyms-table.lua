SynonymsTableSpecifier = {
  type = "synonyms-table",
  properties = {
    getables = {
      ["synonyms"] = function(self)
        return self:get("contents").synonyms
      end,
      ["antonyms"] = function (self)
        return self:get("contents").antonyms
      end,
      ["to-string"] = function(self)
        local contents = self:get("contents")
        local outstr = contents.term .. ": "
        if contents.synonyms then 
          outstr = outstr .. "synonyms: " .. listSampleString(contents.synonyms) .. "; "
        end
        if contents.antonyms then 
          outstr = outstr .. "antonyms: " .. listSampleString(contents.antonyms) .. "; "
        end
        return outstr
      end,
        
    },
    doThisables = {
      ["choose-synonym"] = function(self, callback)
        self:get("new-array-from-result-of-get", { key = "synonyms" }):doThis("choose-item", callback)
      end,
      ["choose-antonym"] = function(self, callback)
        self:get("new-array-from-result-of-get", { key = "antonyms" }):doThis("choose-item", callback)
      end,
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateSynonymsTable = bindArg(NewDynamicContentsComponentInterface, SynonymsTableSpecifier)
