SynonymsTableSpecifier = {
  type = "synonyms-table",
  properties = {
    getables = {
      ["synonyms"] = function(self)
        return self:get("c").synonyms
      end,
      ["antonyms"] = function (self)
        return self:get("c").antonyms
      end,
      ["to-string"] = function(self)
        local contents = self:get("c")
        local outstr = contents.term .. ": "
        if contents.synonyms then 
          outstr = outstr .. "synonyms: " .. table.concat(slice(contents.synonyms, {stop = 2, sliced_indicator = "..."})) .. "; "
        end
        if contents.antonyms then 
          outstr = outstr .. "antonyms: " .. table.concat(slice(contents.antonyms, {stop = 2, sliced_indicator = "..."})) .. "; "
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
