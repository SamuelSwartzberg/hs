StringKeyTableSpecifier = {
  type = "string-key-table",
  properties = {
    getables = {
      ["is-vcard-email-key-table"] = function(self)
        return self:get("all-keys-are-in-list", mt._list.vcard.email_key)
      end,
      ["is-vcard-phone-key-table"] = function(self)
        return self:get("all-keys-are-in-list", mt._list.vcard.phone_key)
      end,
      ["is-single-address-key-table"] = function(self)
        return self:get("all-keys-are-in-list", mt._list.addr_key)
      end,
      ["is-unicode-prop-key-table"] = function(self) -- keys are those provided by the `uni` command provided by the unicode consortium itself
        return self:get("all-keys-are-in-list", mt._list.unicode_prop)
      end,
      ["is-emoji-prop-key-table"] = function(self) -- keys are those provided by the `uni emoji` subcommand of the aforementioned `uni` command
        return self:get("all-keys-are-in-list", mt._list.emoji_prop)
      end,
      ["is-csl-key-table"] = function(self)
        return self:get("all-keys-are-in-list", mt._list.csl_key)
      end,
      ["is-synonyms-key-table"] = function(self)
        return self:get("all-keys-are-in-list", mt._list.synonyms_key)
      end,
      ["is-shrink-specifier-key-table"] = function(self)
        return self:get("all-keys-are-in-list", mt._list.shrink_specifier_key)
      end,
      ["is-tree-node-key-table"] = function(self)
        return self:get("all-keys-are-in-list", mt._list.tree_node_keys)
      end,
      ["is-env-var-key-table"] = function(self)
        return not find(self:get("keys"), {_r = whole(mt._r.case.upper_snake), _invert = true}, "boolean") == nil
      end,
      ["is-menu-item-key-table"] = function(self)
        return self:get("all-keys-are-in-list", mt._list.menu_item_key)
      end,
    },
    doThisables = {
   
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateStringKeyTable = bindArg(NewDynamicContentsComponentInterface, StringKeyTableSpecifier)
