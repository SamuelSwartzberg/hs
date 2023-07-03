-- it's ok to use builtin regexes instead of eutf8 regexes for path leaves, since I guarantee that path leaves are ascii

--- @type ItemSpecifier
PathLeafSpecifier = {
  type = "path-leaf",
  properties = {
    getables = {
    },
  },
  potential_interfaces = ovtable.init({
    { key = "path-leaf-date", value = CreatePathLeafDate },
    { key = "path-leaf-general-name", value = CreatePathLeafGeneralName },
    { key = "path-leaf-tags", value = CreatePathLeafTags },
    { key = "path-leaf-extension", value = CreatePathLeafExtension },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathLeaf = bindArg(NewDynamicContentsComponentInterface, PathLeafSpecifier)