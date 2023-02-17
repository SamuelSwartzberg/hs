--- @type ItemSpecifier
SynonymsCommandSpecifier = {
  type = "synonyms-command",
  properties = {
    getables = {
      ["synonyms-raw"] = function(self, str)
        local res = getOutputTask({
          "synonym",
          {
            value = str,
            type = "quoted"
          }
        })
        return res
      end,
      ["synoyms-to-array"] = function(self, str)
        return CreateArray(stringy.split(self:get("synonyms-raw", str), "\t"))
      end,
    },
    doThisables = {
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateSynonymsCommand = bindArg(NewDynamicContentsComponentInterface, SynonymsCommandSpecifier)
