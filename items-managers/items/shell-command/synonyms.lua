--- @type ItemSpecifier
SynonymsCommandSpecifier = {
  type = "synonyms-command",
  properties = {
    getables = {
      ["synonyms-raw"] = function(self, str)
        return run({
          "synonym",
          {
            value = str,
            type = "quoted"
          }
        })
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
