-- alphanumminus means \w+

--- @type ItemSpecifier
AlphanumMinusItemSpecifier = {
  type = "alphanum-minus",
  properties = {
    getables = {
      ["is-isbn"] = bc(is.alphanum_minus.isbn),
      ["is-issn"] = bc(is.ascii.issn),
      ["is-uuid"] = bc(is.ascii.uuid),
      ["is-package-manager"] = bc(is.string.package_manager),
      ["is-mullvad-relay-identifier"] = bc(is.ascii.relay_identifier)

    }
  },
  potential_interfaces = ovtable.init({
    { key = "isbn", value = CreateIsbnItem },
    { key = "issn", value = CreateIssnItem },
    { key = "uuid", value = CreateUuidItem },
    { key = "package-manager", value = CreatePackageManagerItem },
    { key = "mullvad-relay-identifier", value = CreateMullvadRelayIdentifierItem },
  }),
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateAlphanumMinusItem = bindArg(NewDynamicContentsComponentInterface, AlphanumMinusItemSpecifier)