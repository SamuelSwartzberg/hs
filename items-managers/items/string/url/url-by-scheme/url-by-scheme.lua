--- @type ItemSpecifier
URLBySchemeItemSpecifier = {
  type = "url-by-scheme",
  properties = {
    getables = {
      ["is-mailto-url"] = function (self)
        return is.url.mailto_url(self:get("c"))
      end,
      ["is-tel-url"] = function (self)
        return is.url.tel_url(self:get("c"))
      end,
      ["is-otpauth-url"] = function (self)
        return is.url.otpauth_url(self:get("c"))
      end,
      ["is-data-url"] = function(self)
        return is.url.data_url(self:get("c"))
      end,
    }
  },
  ({
    { key = "mailto-url", value = CreateMailtoURLItem },
    { key = "tel-url", value = CreateTelURLItem },
    { key = "otpauth-url", value = CreateOtpauthURLItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateURLBySchemeItem = bindArg(NewDynamicContentsComponentInterface, URLBySchemeItemSpecifier)