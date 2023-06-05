--- @type ItemSpecifier
IbanItemSpecifier = {
  type = "iban",
  properties = {
    getables = {
      ["cleaned-iban"] = function(self)
        return transf.iban.cleaned_iban(self:get("contents"))
      end,
      ["bic"] = function (self)
        return transf.iban.bic(self:get("contents"))
      end,
      ["bank-name"] = function (self)
        return transf.iban.bank_name(self:get("contents"))
      end
    },
    doThisables = {
      
    }
  },
 
  action_table = {

  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateIbanItem = bindArg(NewDynamicContentsComponentInterface, IbanItemSpecifier)