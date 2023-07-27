-- alphanumminus means \w+

--- @type ItemSpecifier
AlphanumMinusItemSpecifier = {
  type = "alphanum-minus",
  properties = {
    getables = {
      ["is-isbn"] = bc(is.alphanum_minus.isbn),
      ["is-issn"] = bc(is.printable_ascii_string.issn),
      ["is-uuid"] = bc(is.printable_ascii_string.uuid),
      ["is-package-manager"] = bc(is.string.package_manager),

    }
  },
  ({
    { key = "isbn", value = CreateIsbnItem },
    { key = "issn", value = CreateIssnItem },
    { key = "uuid", value = CreateUuidItem },
    { key = "package-manager", value = CreatePackageManagerItem },
  }),
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateAlphanumMinusItem = bindArg(NewDynamicContentsComponentInterface, AlphanumMinusItemSpecifier)