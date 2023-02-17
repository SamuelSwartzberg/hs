ArrayOfNonArrayInterfacesSpecifier = {
  type = "array-of-non-array-interfaces",
  properties = {
    getables = {
      ["is-array-of-string-items"] = bindNthArg(isArrayOfInterfacesOfType, 2, "string-item"),
      ["is-array-of-audiodevices"] = bindNthArg(isArrayOfInterfacesOfType, 2, "audiodevice-item"),
      ["is-array-of-tables"] = bindNthArg(isArrayOfInterfacesOfType, 2, "table"),
      ["is-array-of-dates"] = bindNthArg(isArrayOfInterfacesOfType, 2, "date"),
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



