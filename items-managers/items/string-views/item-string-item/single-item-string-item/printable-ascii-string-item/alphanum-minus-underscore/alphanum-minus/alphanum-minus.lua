-- alphanumminus means \w+

--- @type ItemSpecifier
AlphanumMinusItemSpecifier = {
  type = "alphanum-minus-item",
  properties = {
    getables = {
      ["is-isbn"] = function(self) return isIsbn(self:get("contents")) end,
      ["is-issn"] = function(self) return isIssn(self:get("contents")) end,
      ["is-uuid"] = function(self)
        return onig.find(self:get("contents"), "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", 1, "i")
      end,
      ["is-mullvad-relay-identifier"] = function(self)
        return 
          onig.find(
            self:get("contents"), 
            "^[a-z]{2}-[a-z]{3}(?:-(?:wg|ovpn))?-\\d{3}$"
          )
          or 
          onig.find(
            self:get("contents"), 
            "^[a-z]{2}\\d-wireguard$"
          )
      end,

    }
  },
  potential_interfaces = ovtable.init({
    { key = "isbn", value = CreateIsbnItem },
    { key = "issn", value = CreateIssnItem },
    { key = "uuid", value = CreateUuidItem },
    { key = "mullvad-relay-identifier", value = CreateMullvadRelayIdentifierItem },
  }),
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateAlphanumMinusItem = bindArg(NewDynamicContentsComponentInterface, AlphanumMinusItemSpecifier)