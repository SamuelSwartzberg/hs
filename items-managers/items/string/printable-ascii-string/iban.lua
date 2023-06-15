--- @type ItemSpecifier
IbanItemSpecifier = {
  type = "iban",
 
  action_table = {
    {
      i = "🌐💳",
      d = "iban",
      getfn = transf.iban.cleaned_iban
    },{
      i = "🌐💳✂️",
      d = "ibansp",
      getfn = transf.iban.separated_iban
    },{
      i = "🔍🏦",
      d = "bic",
      getfn = transf.iban.bic
    },{
      i = "🏷️🏦",
      d = "bnknm",
      getfn = transf.iban.bank_name
    },{
      i = "🌐💳🔍🏦🏷️🏦",
      d = "ibanbicbnknmarr",
      getfn = transf.iban.iban_bic_bank_name_array
    }
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateIbanItem = bindArg(NewDynamicContentsComponentInterface, IbanItemSpecifier)