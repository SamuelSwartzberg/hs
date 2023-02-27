
ArrayOfUrlsByHostSpecifier = {
  type = "array-of-urls-by-host",
  properties = {
    getables = {
      ["is-array-of-youtubes"] = bind(isArrayOfInterfacesOfType, { ["2"] = "youtube" }),
    },
    doThisables = {
    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-youtubes", value = CreateArrayOfYoutubes },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfUrlsByHost = bindArg(NewDynamicContentsComponentInterface, ArrayOfUrlsByHostSpecifier)