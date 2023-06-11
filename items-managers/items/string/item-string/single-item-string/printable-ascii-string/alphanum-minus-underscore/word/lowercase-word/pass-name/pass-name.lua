--- @type ItemSpecifier
PassNameItemSpecifier = {
  type = "pass-name",
  properties = {
    getables = {
      ["pass-value"] = function(self, type)
        return get.pass.value(type, self:get("c"))
      end,
      ["as-gpg-file"] = function(self)
        return self:get("c") .. ".gpg"
      end,

      
      ["pass-passw-path"] = function(self)
        return env.MPASSPASSW .. "/" .. self:get("c") .. ".gpg"
      end,
      ["pass-otp-path"] = function(self)
        return env.MPASSOTP .. "/" .. self:get("c") .. ".gpg"
      end,
      ["pass-recovery-path"] = function(self)
        return env.MPASSRECOVERY .. "/" .. self:get("c") .. ".gpg"
      end,
      ["pass-security-question-path"] = function(self)
        return env.MPASSSECQ .. "/" .. self:get("c") .. ".gpg"
      end,
      ["pass-username-path"] = function(self)
        return env.MPASSUSERNAME .. "/" .. self:get("c") .. ".txt"
      end,
      
      ["is-pass-otp"] = function(self) return testPath(self:get("pass-otp-path")) end,
      ["is-pass-passw"] = function(self) return testPath(self:get("pass-passw-path")) end,
      ["is-pass-recovery-keys"] = function(self) return testPath(self:get("pass-recovery-path")) end,
      ["is-pass-security-question"] = function(self) return testPath(self:get("pass-security-question-path")) end,
      ["is-pass-username"] = function(self) return testPath(self:get("pass-username-path")) end,
      ["pass-username"] = function(self)
        return self:get("pass-username") or env.MAIN_EMAIL
      end,
      ["username-and-password-as-string-array"] = function(self)
        return CreateArray({
          self:get("pass-username"),
          self:get("pass-passw") or ""
        })
      end,
    },
    doThisables = {
      ["fill-pass"] = function(self)
        local arr = self:get("username-and-password-as-string-array")
          :get("to-string-item-array")
        arr:doThis("tab-fill-with")
      end,
      ["copy-pass"] = function(self)
        hs.pasteboard.setContents(self:get("pass-username"))
        hs.pasteboard.setContents(self:get("pass-passw"))
      end,
    }
  },
  action_table = concat({{
    {
      text = "✍️🔑 fllpss",
      key = "fill-pass"
    },{
      text = "📋🔑 cpypss",
      key = "copy-pass"
    },
  }}),
  potential_interfaces = ovtable.init({
    { key = "pass-passw", value = CreatePassPasswItem },
    { key = "pass-otp", value = CreatePassOtpItem },
    { key = "pass-recovery-keys", value = CreatePassRecoveryKeysItem },
    { key = "pass-security-question", value = CreatePassSecurityQuestionItem },
    { key = "pass-username", value = CreatePassUsernameItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassNameItem = bindArg(NewDynamicContentsComponentInterface, PassNameItemSpecifier)
