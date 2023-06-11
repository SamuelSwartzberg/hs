

--- @type ItemSpecifier
--- @type ItemSpecifier
PlaintextDictionaryFileItemSpecifier = {
  type = "plaintext-dictionary-file",
  properties = {
    getables = {
      ["is-yaml-file"] = function(self)
        return pathSlice(self:get("resolved-path"), "-1:-1", { ext_sep = true, standartize_ext = true })[1] == "yaml"
      end,
      ["is-json-file"] = function(self)
        return pathSlice(self:get("resolved-path"), "-1:-1", { ext_sep = true, standartize_ext = true })[1] == "json"
      end,
      ["is-bib-file"] = function(self)
        return pathSlice(self:get("resolved-path"), "-1:-1", { ext_sep = true, standartize_ext = true })[1] == "bib"
      end,
      ["is-toml-file"] = function(self)
        return pathSlice(self:get("resolved-path"), "-1:-1", { ext_sep = true, standartize_ext = true })[1] == "toml" 
      end,
      ["is-ini-file"] = function(self)
        return pathSlice(self:get("resolved-path"), "-1:-1", { ext_sep = true, standartize_ext = true })[1] == "ini"
      end,
      ["is-ics-file"] = function(self)
        return pathSlice(self:get("resolved-path"), "-1:-1", { ext_sep = true, standartize_ext = true })[1] == "ics"
      end,
      ["to-env-map"] = function(self)
        local table = self:get("parse-to-lua-table")
        local env_map_item = CreateTable(table)
        return env_map_item:get("parse-to-env-map")
      end,
      ["parse-to-table-item"] = function(self)
        return CreateTable(self:get("parse-to-lua-table"))
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
  action_table = concat({{
    {
      text = "👉#️⃣💎 ctbl.",
      key = "choose-action-on-result-of-get",
      args = "parse-to-table-item"

    }
  }})
}

--- @type BoundNewDynamicContentsComponentInterface
--- @type BoundNewDynamicContentsComponentInterface
CreatePlaintextDictionaryFileItem = bindArg(NewDynamicContentsComponentInterface, PlaintextDictionaryFileItemSpecifier)