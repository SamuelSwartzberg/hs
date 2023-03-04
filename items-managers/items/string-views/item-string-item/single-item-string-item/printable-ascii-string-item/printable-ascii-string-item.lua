--- @type ItemSpecifier
PrintableAsciiStringItemSpecifier = {
  type = "printable-ascii-string-item",
  properties = {
    getables = {
      ["is-alphanum-minus-underscore"] = function(self) 
        return not string.find(self:get("contents"), "[^%w%-_]")
      end,
      ["is-iban"] = function(self)
        local contents = self:get("contents")
        return contents:len() < 42 -- 30 (BBAN) + 2 (country code) + 2 (check digits) + 8 (optional spaces)
          and contents:find("^%w%w")
          and not contents:find("[^%w%-%_ ]")
      end,
      ["is-doi"] = function(self) return memoize(onig.find)(self:get("contents"), whole(matchers.id.doi._r)) end,
      ["is-num"] = function(self) return tonumber(self:get("contents")) ~= nil end,
      ["is-email-address"] = function(self) -- trying to determine what string is and is not an email is a notoriously thorny problem. In our case, we don't care much about false positives, but want to avoid false negatives to a certain extent.
        local contents = self:get("contents")
        return stringy.find(contents, "@") and stringy.find(contents, ".") and not eutf8.find(contents, "%s")
      end,
      ["is-phone-number"] = function(self)
        return isPotentiallyPhoneNumber(self:get("contents"))
      end,
      ["is-digit-string"] = function(self) return onig.find(self:get("contents"), "^-?[0-9a-fA-F]*[\\.,]?[0-9a-fA-F]+$") end,
      ["is-date-related-item"] = function(self) 
        return memoize(onig.find)(self:get("contents"), whole(matchers.date.rfc3339._r))
      end,
      ["is-dice-notation-item"] = function(self)
        return onig.match(self:get("contents"), whole(matchers.syntax.dice._r))
      end,
      ["is-unicode-codepoint"] = function(self)
        return stringy.startswith(self:get("contents"), "U+") and string.match(self:get("contents"), "^U+%x+$")
      end,
      ["is-handle"] = function(self)
        return stringy.startswith(self:get("contents"), "@")
      end,
      ["is-url-base64"] = function(self)
        return onig.find(self:get("contents"), whole(matchers.b.b64.url._r))
      end,
      ["is-general-base64"] = function(self)
        return onig.find(self:get("contents"), whole(matchers.b.b64.gen._r))
      end,
      ["is-general-base32"] = function(self)
        return onig.find(self:get("contents"), whole(matchers.b.b32.gen._r))
      end,
      ["is-crockford-base32"] =  function(self)
        return onig.find(self:get("contents"), whole(matchers.b.b32.crockford._r))
      end,

    },
    doThisables = {
      ["add-as-password"] = function(self, name)
        CreateShellCommand("pass"):doThis("add-password", {name = name, password = self:get("contents")})
      end,
      ["add-as-username"] = function(self, name)
        CreateShellCommand("pass"):doThis("add-username", {name = name, username = self:get("contents")})
      end,
      ["add-as-password-with-prompt-username"] = function(self, name)
        local username = prompt("string", "Username")
        local pass = CreateShellCommand("pass")
        pass:doThis("add-password", {name = name, password = self:get("contents")})
        pass:doThis("add-username", {name = name, username = username})
      end,

    }
  },
  potential_interfaces = ovtable.init({
    { key = "alphanum-minus-underscore", value = CreateAlphanumMinusUnderscoreItem },
    { key = "iban", value = CreateIbanItem },
    { key = "doi", value = CreateDoiItem },
    { key = "num", value = CreateNumItem },
    { key = "email-address", value = CreateEmailAddressItem },
    { key = "phone-number", value = CreatePhoneNumberItem },
    { key = "digit-string", value = CreateDigitStringItem },
    { key = "date-related-item", value = CreateDateRelatedItem },
    { key = "dice-notation-item", value = CreateDiceNotationItem },
    { key = "unicode-codepoint", value = CreateUnicodeCodepointItem },
    { key = "handle", value = CreateHandleItem },
    { key = "url-base64", value = CreateUrlBase64Item },
    { key = "general-base64", value = CreateGeneralBase64Item },
    { key = "general-base32", value = CreateGeneralBase32Item },
    { key = "crockford-base32", value = CreateCrockfordBase32Item },
  }),
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
    },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePrintableAsciiStringItem = bindArg(NewDynamicContentsComponentInterface, PrintableAsciiStringItemSpecifier)


