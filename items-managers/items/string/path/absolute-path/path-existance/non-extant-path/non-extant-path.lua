--- @type ItemSpecifier
NonExtantPathItemSpecifier = {
  type = "non-extant-path",
  properties = {
    getables = {
      ["is-path-with-intra-file-locator"] =bc(is.path.path_with_intra_file_locator)
    },
  },
  ({
    {key = "path-with-intra-file-locator", value = CreatePathWithIntraFileLocator},
  }),
  action_table = {
    {
      text = "👉🌄📁 ccrdir.",
      key = "do-multiple",
      args = {
        { key = "create-self-as-empty-dir" },
        { key = "choose-action-on-str-item-result-of-get", args = "c" } 
      }
    },{
      text = "👉🌄📄 ccrfl.",
      key = "do-multiple",
      args = {
        { key = "write-file-contents" },
        { key = "choose-action-on-str-item-result-of-get", args = "c" } 
      }
    },
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNonExtantPathItem = bindArg(NewDynamicContentsComponentInterface, NonExtantPathItemSpecifier)
