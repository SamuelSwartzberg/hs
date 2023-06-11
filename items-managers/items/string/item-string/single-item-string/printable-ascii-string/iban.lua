--- @type ItemSpecifier
IbanItemSpecifier = {
  type = "iban",
  properties = {
    getables = {
      ["cleaned-iban"] = function(self)
        return transf.iban.cleaned_iban(self:get("c"))
      end,
      ["bic"] = function (self)
        return transf.iban.bic(self:get("c"))
      end,
      ["bank-name"] = function (self)
        return transf.iban.bank_name(self:get("c"))
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