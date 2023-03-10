

--- @type ItemSpecifier
BibFileItemSpecifier = {
  type = "bib-file",
  properties = {
    getables = {
      ["parse-to-lua-table"] = function(self)
        return runJSON({
          "citation-js",
          "--input",
          {
            value = self:get("contents"),
            type = "quoted"
          },
          "--output-language", "json"
        })
      end,
      ["lua-table-to-string"] = function(_, tbl)
        local res = run({
          "echo",
          {
            value = json.encode(tbl),
            type = "quoted"
          },
          "|",
          "citation-js",
          "--output-language", "bib"
        })
        return res
      end,
      ["to-csl-table"] = function(self)
        local raw_table = self:get("parse-to-lua-table")
        return CreateArray(map(raw_table, function(entry)
          return CreateTable(entry)
        end))
      end,
      ["to-citation"] = function(self, format)
        return run({
          "pandoc",
          "--citeproc",
          "-t", "plain",
          "--csl",
          { value = "styles/" .. format, type = "quoted" },
          {
            value = self:get("contents"),
            type = "quoted"
          }
        })
      end,
    },
    doThisables = {
      
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBibFileItem = bindArg(NewDynamicContentsComponentInterface, BibFileItemSpecifier)