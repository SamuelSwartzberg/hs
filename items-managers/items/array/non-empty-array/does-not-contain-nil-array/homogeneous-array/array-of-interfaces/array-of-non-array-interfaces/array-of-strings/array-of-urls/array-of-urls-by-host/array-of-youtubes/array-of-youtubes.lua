
ArrayOfYoutubesSpecifier = {
  type = "array-of-youtubes",
  properties = {
    getables = {
      ["is-array-of-youtube-playable-items"] = bind(isArrayOfInterfacesOfType, {a_use, "youtube-playable" }),
    },
    doThisables = {
    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-youtube-playable-items", value = CreateArrayOfYoutubePlayableItems },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfYoutubes = bindArg(NewDynamicContentsComponentInterface, ArrayOfYoutubesSpecifier)