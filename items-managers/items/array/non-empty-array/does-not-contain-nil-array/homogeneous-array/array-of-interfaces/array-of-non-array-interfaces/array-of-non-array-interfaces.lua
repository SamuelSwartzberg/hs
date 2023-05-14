ArrayOfNonArrayInterfacesSpecifier = {
  type = "array-of-non-array-interfaces",
  properties = {
    getables = {
      ["is-array-of-string-items"] = bind(isArrayOfInterfacesOfType, {a_use, "string" }),
      ["is-array-of-audiodevices"] = bind(isArrayOfInterfacesOfType, {a_use, "audiodevice" }),
      ["is-array-of-tables"] = bind(isArrayOfInterfacesOfType, {a_use, "table" }),
      ["is-array-of-dates"] = bind(isArrayOfInterfacesOfType, {a_use, "date" }),
    },
    doThisables = {
    },
  },
  potential_interfaces = ovtable.init({
    { key = "array-of-string-items", value = CreateArrayOfStringItems },
    { key = "array-of-audiodevices", value = CreateArrayOfAudiodevices },
    { key = "array-of-tables", value = CreateArrayOfTables },
    { key = "array-of-dates", value = CreateArrayOfDates },
  }),
  action_table = {}
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfNonArrayInterfaces = bindArg(NewDynamicContentsComponentInterface, ArrayOfNonArrayInterfacesSpecifier)



