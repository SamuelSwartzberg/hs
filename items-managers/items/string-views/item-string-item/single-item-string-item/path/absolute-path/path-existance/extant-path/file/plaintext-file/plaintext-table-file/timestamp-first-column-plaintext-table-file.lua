

--- @type ItemSpecifier
TimestampFirstColumnTableFileItemSpecifier = {
  type = "timestamp-first-column-table-file",
  properties = {
    getables = {
      ["last-access-path"] = function(self)
        return env.MLAST_BACKUP .. "/" .. self:get("leaf-without-extension") .. ".lastbackup"
      end,
      ["rows-newer-than-timestamp"] = function(self, specifier)
        local rows = self:get("read-to-list-row-iter")
        local _, first_row = rows()
        local _, second_row = rows()
        if not first_row then return nil end
        if not second_row then second_row = {"0"} end
        local first_timestamp, second_timestamp = tonumber(first_row[1]), tonumber(second_row[1])
        if first_timestamp < second_timestamp then
          error("Timestamps are not in descending order. This is not recommended, as it forces us to read the entire file.")
        end
        local res
        if specifier.assoc_arr then 
          res = ovtable.new()
          table.remove(first_row, 1)
          res:add(tostring(first_timestamp), first_row)
          table.remove(second_row, 1)
          res:add(tostring(second_timestamp), second_row)
        else
          res = {first_row, second_row}
        end
        for i, row in rows do
          local current_timestamp = row[1]
          if tonumber(current_timestamp) > specifier.timestamp then
            if specifier.assoc_arr then 
              table.remove(row, 1)
              res:add(current_timestamp, row)
            else
              table.insert(res, row)
            end
          else
            break
          end
        end
        return res
      end,
      ["rows-after-using-last-access"] = function(self, assoc_arr)
        local current_timestamp = os.time()
        local last_access = readFile(self:get("last-access-path")) or 0
        writeFile(self:get("last-access-path"), tostring(current_timestamp))
        return self:get("rows-newer-than-timestamp", {
          timestamp = tonumber(last_access),
          assoc_arr = assoc_arr
        })
      end,
    },
    doThisables = {
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTimestampFirstColumnTableFileItem = bindArg(NewDynamicContentsComponentInterface, TimestampFirstColumnTableFileItemSpecifier)