StrKeyStrValueTableSpecifier = {
  type = "str-key-str-value-table",
  properties = {
    getables = {
      ["is-vcard-email-table"] = function(self)
        return self:get("vcard-email-key-table")
      end,
      ["is-vcard-phone-table"] = function(self)
        return self:get("vcard-phone-key-table")
      end,
      ["is-single-address-table"] = function(self)
        return self:get("is-single-address-key-table")
      end,
      ["is-unicode-prop-table"] = function(self)
        return self:get("is-unicode-prop-key-table")
      end,
      ["is-emoji-prop-table"] = function(self)
        return self:get("is-emoji-prop-key-table")
      end,
      ["is-env-var-table"] = function(self)
        return self:get("is-env-var-key-table")
      end,
      
    },
    doThisables = {
   
    },
  },
  potential_interfaces = ovtable.init({
    { key = "vcard-email-table", value = CreateVcardEmailTable },
    { key = "vcard-phone-table", value = CreateVcardPhoneTable },
    { key = "single-address-table", value = CreateSingleAddressTable },
    { key = "unicode-prop-table", value = CreateUnicodePropTable },
    { key = "emoji-prop-table", value = CreateEmojiPropTable },
    { key = "env-var-table", value = CreateEnvVarTable },
  }),
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateStrKeyStrValueTable = bindArg(NewDynamicContentsComponentInterface, StrKeyStrValueTableSpecifier)
