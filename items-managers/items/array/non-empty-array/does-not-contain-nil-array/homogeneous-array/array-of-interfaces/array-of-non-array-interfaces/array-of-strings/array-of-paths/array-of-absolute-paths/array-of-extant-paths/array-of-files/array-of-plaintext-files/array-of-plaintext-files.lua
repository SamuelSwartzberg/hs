
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
      getfn = transf.plaintext_file_array.content_lines_array,
      act = "cia"
    },
    {
      text = "👉⩶📜👊　clnarract.",
      getfn = transf.plaintext_file_array.content_lines_array,
      act = "ca"

    }
  },
  potential_interfaces = ovtable.init({
    { key = "array-of-plaintext-dictionary-files", value = CreateArrayOfPlaintextDictionaryFiles },
    { key = "array-of-email-files", value = CreateArrayOfEmailFiles },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfPlaintextFiles = bindArg(NewDynamicContentsComponentInterface, ArrayOfPlaintextFilesSpecifier)