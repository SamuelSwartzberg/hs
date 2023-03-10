--- @type ItemSpecifier
IbanItemSpecifier = {
  type = "iban-item",
  properties = {
    getables = {
      ["cleaned-iban"] = function(self)
        local res = string.gsub(self:get("contents"), "[ %-_]", "")
        return res
      end,
    },
    doThisables = {
      ["get-iban-api-data"] = function(self, do_after)
        memoize(makeSimpleRESTApiRequest, {mode="fs"})({
          host = "https://openiban.com/",
          endpoint = "validate/" .. self:get("cleaned-iban"),
          params = { getBIC = "true" },
        }, function(res)
          local data = res.bankData
          data.valid = res.valid
          do_after(data) -- data is a table with keys: valid, bankCode, bic, city, name, zip
        end)
      end,
      ["get-bic"] = function (self, do_after)
        self:doThis("get-iban-api-data", function(data)
          do_after(data.bic)
        end)
      end,
      ["get-bank-name"] = function (self, do_after)
        self:doThis("get-iban-api-data", function(data)
          do_after(data.name)
        end)
      end,
    }
  },
 
  action_table = {

  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateIbanItem = bindArg(NewDynamicContentsComponentInterface, IbanItemSpecifier)