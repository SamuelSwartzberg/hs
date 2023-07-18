

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
    },
    doThisables = {
    }
  },
  action_table = {
    {
      text = "👉#️⃣💎 ctbl.",
      get = "parse-to-lua-table" -- TODO `get` no longer exists in action_tables (now action_specifier_array anyway)

    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
--- @type BoundNewDynamicContentsComponentInterface
CreatePlaintextDictionaryFileItem = bindArg(NewDynamicContentsComponentInterface, PlaintextDictionaryFileItemSpecifier)