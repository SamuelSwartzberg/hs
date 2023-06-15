--- @type ItemSpecifier
PathInMeItemSpecifier = {
  type = "path-in-me",
  properties = {
    getables = {
      ["is-path-in-maudiovisual"] = bc(stringy.startswith, env.MAUDIOVISUAL),
      ["is-path-in-mspec"] = bc(stringy.startswith, env.MSPEC),
    },
  },
  potential_interfaces = ovtable.init({
    { key = "path-in-maudiovisual", value = CreatePathInMaudiovisualItem },
    { key = "path-in-mspec", value = CreatePathInMspecItem },
  }),
  action_table = {
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathInMeItem = bindArg(NewDynamicContentsComponentInterface, PathInMeItemSpecifier)