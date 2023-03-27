
ArrayOfAlphanumMinusUnderscoreItemsSpecifier = {
  type = "array-of-alphanum-minus-underscore-items",
  properties = {
    getables = {
      ["is-array-of-youtube-ids"] = bind(isArrayOfInterfacesOfType, {a_use, "youtube-id-item" }),
      ["is-array-of-alphanum-minus-items"] = bind(isArrayOfInterfacesOfType, {a_use, "alphanum-minus-item" }),
    },
    doThisables = {

    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-youtube-ids", value = CreateArrayOfYoutubeIds },
    { key = "array-of-alphanum-minus-items", value = CreateArrayOfAlphanumMinusItems },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfAlphanumMinusUnderscoreItems = bindArg(NewDynamicContentsComponentInterface, ArrayOfAlphanumMinusUnderscoreItemsSpecifier)