
ArrayOfUrlsSpecifier = {
  type = "array-of-urls",
  properties = {
    getables = {
      ["is-array-of-urls-by-host"] = bind(isArrayOfInterfacesOfType, {a_use, "url-by-host" }),
    },
  },
  action_table = {
    {
      text = "🌄📚 crsess.",
      dothis = dothis.url_array.create_as_session_in_msessions
    },
    {
      text = "🌐 br.",
      dothis = dothis.url_array.open_all
    },
    {
      text = "📌🔗 addurls.",
      dothis = dothis.url_array.create_as_url_files_in_murls
    }
  },
  potential_interfaces = ovtable.init({
    { key = "array-of-urls-by-host", value = CreateArrayOfUrlsByHost },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfUrls = bindArg(NewDynamicContentsComponentInterface, ArrayOfUrlsSpecifier)