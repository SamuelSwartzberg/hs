--- @type ItemSpecifier
SynCommandSpecifier = {
  type = "syn-command",
  properties = {
    getables = {
      ["synonyms-raw"] = function(self, str)
        return memoize(run)({
          "syn",
          "-p",
          {
            value = str,
            type = "quoted"
          }
        })

      end,
      ["synonyms-to-raw-array-of-tables"] = function(self, str)
        local synonym_parts = stringx.split(stringy.strip(self:get("synonyms-raw", str)), "\n\n")
        local synonym_tables = map(
          synonym_parts,
          function (synonym_part)
            local synonym_part_lines = stringy.split(synonym_part, "\n")
            local synonym_term = eutf8.sub(synonym_part_lines[1], 2) -- syntax: ❯<term>
            local synonyms_raw = eutf8.sub(synonym_part_lines[2], 12) -- syntax:  ⬤synonyms: <term>{, <term>}
            local antonyms_raw = eutf8.sub(synonym_part_lines[3], 12) -- syntax:  ⬤antonyms: <term>{, <term>}
            local synonyms = map(stringy.split(synonyms_raw, ", "), stringy.strip)
            local antonyms = map(stringy.split(antonyms_raw, ", "), stringy.strip)
            return {
              term = synonym_term,
              synonyms = synonyms,
              antonyms = antonyms,
            }
          end
        )
        return synonym_tables
      end,
      ["synonyms-to-array-of-synonyms-tables"] = function(self, str)
        return CreateArray(map(
          self:get("synonyms-to-raw-array-of-tables", str),
          function (synonym_table)
            return CreateTable(synonym_table)
          end
        ))
      end,
    },
    doThisables = {
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateSynCommand = bindArg(NewDynamicContentsComponentInterface, SynCommandSpecifier)
