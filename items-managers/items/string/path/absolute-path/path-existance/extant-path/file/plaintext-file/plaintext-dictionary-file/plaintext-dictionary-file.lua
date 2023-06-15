

--- @type ItemSpecifier
--- @type ItemSpecifier
PlaintextDictionaryFileItemSpecifier = {
  type = "plaintext-dictionary-file",
  properties = {
    getables = {
      ["is-yaml-file"] = bc(get.path.is_extension, "yaml"),
      ["is-json-file"] = bc(get.path.is_extension, "json"),
      ["is-bib-file"] = bc(get.path.is_extension, "bib"),
      ["is-toml-file"] = bc(get.path.is_extension, "toml" ),
      ["is-ini-file"] = bc(get.path.is_extension, "ini"),
      ["is-ics-file"] = bc(get.path.is_extension, "ics"),
      ["to-env-map"] = function(self)
        local table = self:get("parse-to-lua-table")
        local env_map_item = dc(table)
        return env_map_item:get("parse-to-env-map")
      end,
    },
    doThisables = {
    }
  },
  potential_interfaces = ovtable.init({
    { key = "bib-file", value = CreateBibFileItem },
    { key = "yaml-file", value = CreateYamlFileItem },
    { key = "json-file", value = CreateJsonFileItem },
    { key = "toml-file", value = CreateTomlFileItem },
    { key = "ini-file", value = CreateIniFileItem },
    { key = "ics-file", value = CreateIcsFileItem },
  }),
  action_table = {
    {
      text = "👉#️⃣💎 ctbl.",
      filter = dc,
      getfn = returnSame,
      get = "parse-to-lua-table"

    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
--- @type BoundNewDynamicContentsComponentInterface
CreatePlaintextDictionaryFileItem = bindArg(NewDynamicContentsComponentInterface, PlaintextDictionaryFileItemSpecifier)