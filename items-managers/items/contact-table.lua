--- @type ItemSpecifier
ContactTableSpecifier = {
  type = "contact-table",
  properties = {
    getables = {
      ["prop-policy"] = function(self, prop)
        return self:get("c")[prop]
      end,
      ["encrypted-data"] = function(self, type)
        return get.pass.contact_json(type, self:get("uid"))
      end,

      ["iban"] = function(self)
        return self:get("encrypted-data", "iban")
      end,

      -- simple properties

      ["uid"] = function(self) return self:get("c").uid end,
      ["pref-name"] = function(self) return self:get("prop-policy", "Formatted name") end,
      ["name-pre"] = function(self) return self:get("prop-policy", "Prefix") end,
      ["first-name"] = function(self) return self:get("prop-policy", "First name") end,
      ["middle-name"] = function(self) return self:get("prop-policy", "Additional") end,
      ["last-name"] = function(self) return self:get("prop-policy", "Last name") end,
      ["name-suf"] = function(self) return self:get("prop-policy", "Suffix") end,
      ["nickname"] = function(self) return self:get("prop-policy", "Nickname") end,
      ["anniversary"] = function (self) return self:get("prop-policy", "Anniversary") end,
      ["birthday"] = function (self) return self:get("prop-policy", "Birthday") end,
      ["organization"] = function (self) return self:get("prop-policy", "Organization") end,
      ["title"] = function (self) return self:get("prop-policy", "Title") end,
      ["role"] = function (self) return self:get("prop-policy", "Role") end,
      ["homepage"] = function(self) return self:get("prop-policy", "Webpage") end,

      ["full-name-western"] = function(self)
        local parts = fixListWithNil({ 
          self:get("name-pref"),
          self:get("first-name"),
          self:get("middle-name"),
          self:get("last-name"),
          self:get("name-suf")
        })
        return table.concat(parts, " ")
      end,
      ["full-name-eastern"] = function(self)
        local parts = fixListWithNil({ 
          self:get("name-pref"),
          self:get("last-name"),
          self:get("first-name"),
          self:get("name-suf")
        })
        return table.concat(parts, " ")
      end,
      ["full-name"] = function(self)
        return self:get("full-name-western")
      end,

      -- tables

      ["table-prop-policy"] = function (self, prop)
        local potential_prop_table = self:get("prop-policy", prop)
        if potential_prop_table == nil then
          return nil
        else
          local transformed_table = {}
          for k, v in pairs(potential_prop_table) do
            local new_ks = stringy.split(k, ",")
            for _, raw_new_k in ipairs(new_ks) do
              local new_k = stringy.strip(raw_new_k)
              transformed_table[new_k] = v
            end
          end
          return transformed_table
        end
      end,
      ["contact-addr-table"] = function(self, type)
        return self:get("table-prop-policy", replace(type, to.case.capitalized))
      end,
      ["contact-addr-table-item"] = function (self, type)
        return CreateTable(self:get("contact-addr-table", type))
      end,
      ["contact-addr"] = function(self, specifier)
        local addr_table = self:get("contact-addr-table", specifier.type)
        if addr_table then 
          return addr_table[specifier.addr_type]
        end
      end,
      ["all-contact-addr-types"] = function(self, type)
        return keys(self:get("contact-addr-table", type))
      end,
      ["all-contact-addr"] = function(self, type)
        local all_contact_addr_raw = values(self:get("contact-addr-table", type))
        return toSet(all_contact_addr_raw)
      end,
      ["has-at-least-one-contact-addr"] = function (self, type)
        return #self:get("all-contact-addr", type) > 0
      end,
      ["addresses-table"] = function(self)
        local raw = self:get("table-prop-policy", "Address")
        local processed = map(raw, function(v)
          local raw_single = concat(
            v,
            {
              ["Formatted name"] = self:get("name"),
              ["First name"] = self:get("first-name"),
              ["Last name"] = self:get("last-name"),
            }
          )
          return CreateTable(raw_single)
        end)
        return CreateTable(processed)
      end,
      ["address-table-raw"] = function(self, type) -- type may be one of "home", "pref", "work" in VCard 4.0, more in VCard 3.0.
        return  self:get("table-prop-policy", "Address")[type]
      end,
      ["address-table"] = function(self, type)
        self:get("addresses-table"):get("value", type)
      end,
      ["all-address-types"] = function(self)
        return keys(self:get("addresses-table"))
      end,

      -- complex properties

      ["to-string"] = function(self)
        local str = self:get("full-name")
        for _, name_addition in ipairs({"nickname", "title", "organization", "role"}) do
          local name_addition_res = self:get(name_addition)
          if name_addition_res then
            str = str .. ", " .. name_addition_res
          end
        end
        local first_colon_val = true
        print(self:get("email", "pref"))
        for _, contact_method in ipairs({"email", "phone"}) do
          local contact_method_res = stringx.join(", ", self:get("all-contact-addr", contact_method))
          if contact_method_res ~= "" then
            if first_colon_val then
              str = str .. ": "
              first_colon_val = false
            else
              str = str .. "; "
            end
            str = str .. contact_method_res
          end
        end
        return str
      end,
    
      
    },
    doThisables = {
      ["edit"] = function (self)
        dothis.khard.edit(self:get("uid"))
      end,
      ["add-iban"] = function(self, iban)
        dothis.pass.add_contact_data(iban, "iban", self:get("uid"))
      end,
      ["do-bank-deets-array"] = function(self, do_after)
        local iban = self:get("iban")
        st(iban):doThis("get-iban-api-data", function(data)
          local bank_deets_array = ar({
            self:get("full-name"),
            iban,
            data.bic
          })
          do_after(bank_deets_array)
        end)
      end,
      ["choose-action-bank-deets-array"] = function(self)
        self:doThis("do-bank-deets-array", function(bank_deets_array)
          bank_deets_array:doThis("choose-action")
        end)
      end,

    }
  },
  
  action_table = concat(
    getChooseItemTable({
      { emoji_icon = "⏪🙋🏻‍♀️", description = "nmpr", key = "name-pre", check = true },
      { emoji_icon = "◀️🙋🏻‍♀️", description = "fnm", key = "first-name", check = true },
      { emoji_icon = "⏺🙋🏻‍♀️", description = "mnm", key = "first-name", check = true },
      { emoji_icon = "▶️🙋🏻‍♀️", description = "lnm", key = "last-name", check = true },
      { emoji_icon = "⏩🙋🏻‍♀️", description = "nmsf", key = "name-suf", check = true },
      { emoji_icon = "👩🏻‍🎤🙋🏻‍♀️", description = "nnm", key = "nickname", check = true },
      { emoji_icon = "全🙋🏻‍♀️🇺🇸", description = "flnmw", key = "full-name-western" },
      { emoji_icon = "全🙋🏻‍♀️🇯🇵", description = "flnme", key = "full-name-eastern" },
      { emoji_icon = "⭐️🙋🏻‍♀️", description = "pnm", key = "pref-name" },
      { emoji_icon = "🎂", description = "bday", key = "birthday", check = true },
      { emoji_icon = "🎉", description = "ann", key = "anniversary", check = true },
      { emoji_icon = "🏢", description = "org", key = "organization", check = true },
      { emoji_icon = "🎓", description = "ttl", key = "title", check = true },
      { emoji_icon = "👩🏻‍🏫", description = "rol", key = "role", check = true },
      { emoji_icon = "🌐", description = "hp", key = "homepage", check = true },
      { emoji_icon = "🆔", description = "uid", key = "uid", },
      { emoji_icon = "🏦🔢", description = "iban", key = "iban", },
      { emoji_icon = "✉♥️", description = "pmail", key = "contact-addr", args = { type = "email", addr_type = "pref" }, check = true },
      { emoji_icon = "📞♥️", description = "pphone", key = "contact-addr", args = { type = "phone", addr_type = "pref" }, check = true },
    }),
    {
      {
        text = "👉✉ cmail.",
        key = "choose-item-and-then-action-on-result-of-get",
        args = { key = "contact-addr-table-item", args = "email" },
      },
      {
        text = "👉📞 cphone.",
        key = "choose-item-and-then-action-on-result-of-get",
        args = { key = "contact-addr-table-item", args = "phone" },
      },
      {
        text = "👉🏡 caddr.",
        key = "choose-item-and-then-action-on-result-of-get",
        args = { key = "addresses-table" }
      },
      {
        text = "👉🏦 cbnkdt.",
        key = "choose-action-bank-deets-array"
      },
      {
        text = "✏️ ed.",
        key = "edit",
      }
    }
  )

}

--- @type BoundRootInitializeInterface
function CreateContactTableItem(contents)
  return RootInitializeInterface(ContactTableSpecifier, contents)
end

