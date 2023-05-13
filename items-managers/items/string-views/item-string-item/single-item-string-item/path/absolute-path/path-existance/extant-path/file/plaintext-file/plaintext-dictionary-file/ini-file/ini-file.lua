

--- @type ItemSpecifier
IniFileItemSpecifier = {
  type = "ini-file",
  properties = {
    getables = {
      ["parse-to-lua-table"] = function(self)
        return runJSON({
          "cat",
          { value = self:get("completely-resolved-path"), type = "quoted" },
          "|",
          "jc",
          "--ini"
        })
      end,
      ["lua-table-to-string"] = function(_, tbl)
        -- not implemented yet
      end,
      ["table-to-ini-section"] = function(_, specifier)
        local out_lines = { "[" .. specifier.header .. "]" }
        for k, v in prs(specifier.body) do
          local val
          if stringy.startswith(v, "noquote:") then
            val = v:match("noquote:(.+)")
          else
            val = "\"" .. v .. "\""
          end
          table.insert(out_lines, k .. " = " .. val)
        end
        return table.concat(out_lines, "\n")
      end,
      ["is-vdirsyncer-config-file"] = function(self)
        return self:get("parent-dir-name") == "vdirsyncer"
      end,
      ["is-khal-config-file"] = function(self)
        return self:get("parent-dir-name") == "khal"
      end,
    },
    doThisables = {
      
    }
  },
  potential_interfaces = ovtable.init({
    { key = "vdirsyncer-config-file", value = CreateVdirsyncerConfigFileItem },
    { key = "khal-config-file", value = CreateKhalConfigFileItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateIniFileItem = bindArg(NewDynamicContentsComponentInterface, IniFileItemSpecifier)