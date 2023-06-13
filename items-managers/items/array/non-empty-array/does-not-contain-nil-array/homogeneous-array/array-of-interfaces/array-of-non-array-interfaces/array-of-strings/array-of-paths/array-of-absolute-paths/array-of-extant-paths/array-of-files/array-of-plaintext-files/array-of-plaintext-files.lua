
ArrayOfPlaintextFilesSpecifier = {
  type = "array-of-plaintext-files",
  properties = {
    getables = {
      ["is-array-of-plaintext-dictionary-files"] = bind(isArrayOfInterfacesOfType, {a_use, "plaintext-dictionary-file" }),
      ["is-array-of-email-files"] = bind(isArrayOfInterfacesOfType, {a_use, "email-file" }),
    },
  },
  action_table = {
    {
      text = "👉⩶👊　clnact.",
      key = "choose-item-and-then-action-on-result-of-get",
      args = { key = "map-to-line-array-of-file-contents-with-no-empty-strings" }
    },
    {
      text = "👉⩶📜👊　clnarract.",
      key = "choose-action-on-result-of-get",
      args = { key = "map-to-line-array-of-file-contents-with-no-empty-strings" }

    }
  },
  potential_interfaces = ovtable.init({
    { key = "array-of-plaintext-dictionary-files", value = CreateArrayOfPlaintextDictionaryFiles },
    { key = "array-of-email-files", value = CreateArrayOfEmailFiles },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfPlaintextFiles = bindArg(NewDynamicContentsComponentInterface, ArrayOfPlaintextFilesSpecifier)