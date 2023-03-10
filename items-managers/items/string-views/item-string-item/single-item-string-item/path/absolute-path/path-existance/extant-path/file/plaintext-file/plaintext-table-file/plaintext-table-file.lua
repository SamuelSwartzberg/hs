

--- @type ItemSpecifier
PlaintextTableFileItemSpecifier = {
  type = "plaintext-table-file",
  properties = {
    getables = {
      ["read-to-list-rows"] = function(self)
        return ftcsv.parse(self:get("contents"), self:get("field-separator"), {headers = false})
      end,
      ["read-to-list-row-iter"] = function (self)
        local iter = ftcsv.parseLine(self:get("contents"), self:get("field-separator"), {headers = false})
        iter() -- skip the header
        return iter
      end,
      ["read-to-assoc-rows"] = function(self)
        return ftcsv.parse(self:get("contents"), self:get("field-separator"))
      end,
      ["read-to-assoc-row-iter"] = function (self)
        return ftcsv.parseLine(self:get("contents"), self:get("field-separator"))
      end,
      ["is-timestamp-first-column-plaintext-table-file"] = function(self) -- this only checks the first line with content for performance reasons.
        local line = self:get("nth-line-of-file-contents", 2)
        if not line then return false end
        local leading_number = eutf8.match(line, "^(%d+)%D")
        if leading_number and #leading_number < 11 then -- a unix timestamp will only be larger than 10 digits starting at 2286-11-20, at which point this code will need to be updated
          return true
        else
          return false
        end
      end,
      ["is-csv-table-file"] = function(self)
        return stringy.endswith(self:get("contents"), ".csv")
      end,
      ["is-tsv-table-file"] = function(self)
        return stringy.endswith(self:get("contents"), ".tsv")
      end,
      ["rows-to-lines"] = function(self, rows)
        return map(rows, function(row)
          return table.concat(map(row, transf.string.escaped_csv_field), self:get("field-separator"))
        end)
      end,
    },
    doThisables = {
      
      ["append-rows"] = function(self, rows)
        self:doThis("append-lines", self:get("rows-to-lines", rows))
      end,
      ["set-rows"] = function(self, rows)
        self:doThis("set-lines", self:get("rows-to-lines", rows))
      end,
      ["append-assoc-arr-as-rows"] = function(self, assoc_arr)
        local rows = self:get("read-to-rows") or {}
        local field_sep = self:get("field-separator")
        for key, fields in pairs(assoc_arr) do 
          local line = transf.string.escaped_csv_field(key) .. field_sep .. table.concat(map(fields, transf.string.escaped_csv_field), field_sep)
          table.insert(rows, line)
        end
        table.sort(rows)
        self:doThis("overwrite-file-contents", stringx.join("\n", rows))
      end,
      ["transform-rows"] = function(self, transformer)
        local rows = self:get("read-to-rows")
        local new_rows = map(rows, transformer)
        self:doThis("set-rows", new_rows)
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "timestamp-first-column-plaintext-table-file", value = CreateTimestampFirstColumnTableFileItem },
    { key = "csv-table-file", value = CreateCsvTableFileItem },
    { key = "tsv-table-file", value = CreateTsvTableFileItem },

  }),
  action_table = {}
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePlaintextTableFileItem = bindArg(NewDynamicContentsComponentInterface, PlaintextTableFileItemSpecifier)