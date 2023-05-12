-- alphanumminus means \w+

--- @type ItemSpecifier
AlphanumMinusItemSpecifier = {
  type = "alphanum-minus-item",
  properties = {
    getables = {
      ["alphanum"] = function(self)
        return select(1, eutf8.gsub(self:get("contents"), "-", ""))
      end,
      ["is-isbn"] = function(self) return memoize(onig.find)(self:get("alphanum"), whole(mt._r.id.isbn)) end,
      ["is-issn"] = function(self) return memoize(onig.find)(self:get("contents"), whole(mt._r.id.issn)) end,
      ["is-uuid"] = function(self)
        return onig.find(self:get("contents"), whole(mt._r.id.uuid), 1, "i")
      end,
      ["is-package-manager"] = function(self)
        return find(lines(
          memoize(run)("upkg list-package-managers")
        ), self:get("contents"))
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
    { key = "package-manager", value = CreatePackageManagerItem },
    { key = "mullvad-relay-identifier", value = CreateMullvadRelayIdentifierItem },
  }),
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateAlphanumMinusItem = bindArg(NewDynamicContentsComponentInterface, AlphanumMinusItemSpecifier)