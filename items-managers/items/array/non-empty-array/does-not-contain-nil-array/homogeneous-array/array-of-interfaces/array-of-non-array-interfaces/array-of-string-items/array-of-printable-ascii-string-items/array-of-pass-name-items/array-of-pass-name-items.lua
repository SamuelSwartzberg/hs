
ArrayOfPassNameItemsSpecifier = {
  type = "array-of-pass-name-items",
  properties = {
    getables = {
      ["is-array-of-pass-otp-items"] = bind(isArrayOfInterfacesOfType, { ["2"] = "pass-otp" }),
      ["is-array-of-pass-passw-items"] = bind(isArrayOfInterfacesOfType, { ["2"] = "pass-passw" }),
    },
    doThisables = {
    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-pass-otp-items", value = CreateArrayOfPassOtpItems },
    { key = "array-of-pass-passw-items", value = CreateArrayOfPassPasswItems },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfPassNameItems = bindArg(NewDynamicContentsComponentInterface, ArrayOfPassNameItemsSpecifier)