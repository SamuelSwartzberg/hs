--- @type ItemSpecifier
URLBySchemeItemSpecifier = {
  type = "url-by-scheme",
  properties = {
    getables = {
      ["is-mailto-url"] = function (self)
        return is.url.mailto_url(self:get("contents"))
      end,
      ["is-tel-url"] = function (self)
        return is.url.tel_url(self:get("contents"))
      end,
      ["is-otpauth-url"] = function (self)
        return is.url.otpauth_url(self:get("contents"))
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "mailto-url", value = CreateMailtoUrlItem },
    { key = "tel-url", value = CreateTelUrlItem },
    { key = "otpauth-url", value = CreateOtpauthUrlItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateURLBySchemeItem = bindArg(NewDynamicContentsComponentInterface, URLBySchemeItemSpecifier)