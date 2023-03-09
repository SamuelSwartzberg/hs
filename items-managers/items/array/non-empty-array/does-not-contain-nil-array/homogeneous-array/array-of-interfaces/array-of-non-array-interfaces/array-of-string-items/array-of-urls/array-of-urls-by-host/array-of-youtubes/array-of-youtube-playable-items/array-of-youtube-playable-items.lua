
ArrayOfYoutubePlayableItemsSpecifier = {
  type = "array-of-youtube-playable-items",
  properties = {
    getables = {
      ["is-array-of-youtube-videos"] = bind(isArrayOfInterfacesOfType, { ["2"] = "youtube-video" }),
     
    },
    doThisables = {
      ["to-stream"] = function(self, specifier)
        local specified_contents = concat(
          specifier,
          {
            initial_data = {
              urls = self
            }
          }
        )
        System:get("manager", "stream"):doThis("create", specified_contents)
      end,
    },
  },
  action_table = concat(
    {},
    createAllCreationEntryCombinations()
  ),
  potential_interfaces = ovtable.init({
    { key = "array-of-youtube-videos", value = CreateArrayOfYoutubeVideos },
  })
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfYoutubePlayableItems = bindArg(NewDynamicContentsComponentInterface, ArrayOfYoutubePlayableItemsSpecifier)
