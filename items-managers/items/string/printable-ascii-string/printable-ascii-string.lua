--- @type ItemSpecifier
PrintableAsciiStringItemSpecifier = {
  type = "printable-ascii-string",
  properties = {
    getables = {
      ["is-alphanum-minus-underscore"] = function(self) 
        return not string.find(self:get("c"), "[^%w%-_]")
      end,
      ["is-iban"] = function(self)
        local contents = self:get("c")
        return contents:len() < 42 -- 30 (BBAN) + 2 (country code) + 2 (check digits) + 8 (optional spaces)
          and contents:find("^%w%w")
          and not contents:find("[^%w%-%_ ]")
      end,
      ["is-doi"] = function(self) return memoize(onig.find)(self:get("c"), transf.string.whole_regex(mt._r.id.doi)) end,
      ["is-num"] = function(self) return get.string_or_number.number_or_nil(self:get("c")) ~= nil end,
      ["is-email-address"] = function(self) -- trying to determine what string is and is not an email is a notoriously thorny problem. In our case, we don't care much about false positives, but want to avoid false negatives to a certain extent.
        local contents = self:get("c")
        return stringy.find(contents, "@") and stringy.find(contents, ".") and not eutf8.find(contents, "%s")
      end,
      ["is-phone-number"] = function(self)
        return is.string.potentially_phone_number(self:get("c"))
      end,
      ["is-digit-string"] = function(self) return onig.find(self:get("c"), "^-?[0-9a-fA-F]*[\\.,]?[0-9a-fA-F]+$") end,
      ["is-date-related-item"] = function(self) 
        return memoize(onig.find)(self:get("c"), transf.string.whole_regex(mt._r.date.rfc3339like_dt))
      end,
      ["is-dice-notation-item"] = function(self)
        return onig.match(self:get("c"), transf.string.whole_regex(mt._r.syntax.dice))
      end,
      ["is-unicode-codepoint"] = function(self)
        return stringy.startswith(self:get("c"), "U+") and string.match(self:get("c"), "^U+%x+$")
      end,
      ["is-installed-package"] = function(self, mgr)
        return get.upkg.boolean_array_installed(mgr, self:get("c"))
      end,
    },
    doThisables = {
      ["add-as-password"] = function(self, name)
        run("yes" .. transf.string.single_quoted_escaped(self:get("c")) .. "| pass insert passw/" .. name, true)
      end,
      ["add-as-username"] = function(self, name)
        dothis.absolute_path.write_file(env.MPASSUSERNAME .. "/" .. name .. ".txt", self:get("c"))
      end,
      ["add-as-password-with-prompt-username"] = function(self, name)
        local username = get.string.prompted_once_string_from_default("", "Username")
        self:doThis("add-as-password", name)
        st(username):doThis("add-as-username", name)
      end,

    }
  },
  action_table = concat(getChooseItemTable({
   
  }),{
    {
      text = "📌🔑 addpsspw.",
      key = "do-interactive",
      args = {
        key = "add-as-password",
        thing = "pass entry name"
      }
    },{
      text = "📌👤 addpssun.",
      key = "do-interactive",
      args = {
        key = "add-as-username",
        thing = "pass entry name"
      }
    },  {
      text = "📌🔑👤 addpsspwun.",
      key = "do-interactive",
      args = {
        key = "add-as-password-with-prompt-username",
        thing = "pass entry name"
      }
    }, {
      text = "📦➡️💻 inspkg.",
      key = "upkg-install",
      
    }, {
      key = "choose-item-and-then-action-on-result-of-get",
      args = {
        key = "with-version-package-manager-array",
      },
      text = "📦💽🔢👨‍💻📦 wvrspkgmgr."
    }
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePrintableAsciiStringItem = bindArg(NewDynamicContentsComponentInterface, PrintableAsciiStringItemSpecifier)


