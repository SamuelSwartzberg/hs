

--- @type ItemSpecifier
PlaintextTableFileItemSpecifier = {
  type = "plaintext-table-file",
  properties = {
    getables = {
      ["is-csv-table-file"] = bc(get.path.is_extension, "csv"),
      ["is-tsv-table-file"] = bc(get.path.is_extension, "tsv"),
    },
  },
  potential_interfaces = ovtable.init({
    { key = "csv-table-file", value = CreateCsvTableFileItem },
    { key = "tsv-table-file", value = CreateTsvTableFileItem },

  }),
  action_table = {}
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePlaintextTableFileItem = bindArg(NewDynamicContentsComponentInterface, PlaintextTableFileItemSpecifier)