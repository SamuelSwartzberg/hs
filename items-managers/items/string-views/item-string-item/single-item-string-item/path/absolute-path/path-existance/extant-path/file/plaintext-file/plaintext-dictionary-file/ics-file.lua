

--- @type ItemSpecifier
IcsFileItemSpecifier = {
  type = "ics-file",
  properties = {
    getables = {
      ["parse-to-lua-table"] = function(self)
        local basename = self:get("leaf-without-extension")
        local tmpdir_ics_path = env.TMPDIR .. "/" .. basename .. ".ics"
        local tmpdir_json_path = env.TMPDIR .. "/" .. basename .. ".json"
        srctgt("copy", self:get("contents"), tmpdir_ics_path)
        getOutputArgs(
          "ical2json",
          { value = tmpdir_ics_path, type = "quoted" }
        )
        local res = json.decode(readFile(tmpdir_json_path))
        delete(tmpdir_ics_path)
        delete(tmpdir_json_path)
        return res
      end,
      ["lua-table-to-string"] = function(self, tbl)
        local basename = self:get("leaf-without-extension")
        local tmpdir_ics_path = env.TMPDIR .. "/" .. basename .. ".ics"
        local tmpdir_json_path = env.TMPDIR .. "/" .. basename .. ".json"
        writeFile(tmpdir_json_path, json.encode(tbl))
        getOutputArgs(
          "ical2json",
          "-r",
          { value = tmpdir_ics_path, type = "quoted" }
        )
        local res = readFile(tmpdir_ics_path)
        delete(tmpdir_ics_path)
        delete(tmpdir_json_path)
        return res
      end,
      
    },
    doThisables = {
      ["add-events-to-calendar"] = function(self)
        local khal = CreateShellCommand("khal")
        khal:doThis("choose-writable-calendar", function(calendar)
          khal:doThis("add-event-from-file", {
            path = self:get("contents"),
            calendar = calendar
          })
        end)
      end,
    }
  },
  action_table = listConcat({
    {
      key = "add-events-to-calendar",
      text = "➕📅 addevcal",
    }
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateIcsFileItem = bindArg(NewDynamicContentsComponentInterface, IcsFileItemSpecifier)