
ArrayOfUrlsSpecifier = {
  type = "array-of-urls",
  properties = {
    getables = {
      ["is-array-of-urls-by-host"] = bind(isArrayOfInterfacesOfType, {a_use, "url-by-host" }),
    },
    doThisables = {
      ["create-session"] = function(self, session_name)
        local path = st(env.MSESSIONS):get("related-path-with-subdirs-gui")
        path:doThis('create-file-with-contents', {
          contents = self:get("joined-string-contents", "\n"),
          name = session_name
        })
      end,
      ["create-all-as-urls"] = function(self)
        local path = st(env.MURLS):get("related-path-with-subdirs-gui")
        self:doThis("for-all", function(item)
          path:doThis('create-file-with-contents', {
            contents = item:get("c"),
            name = item:get("html-title") .. ".url2"
          })
        end)
      end,
      ["open-all-in-browser"] = function(self)
        self:doThis("for-all", function(item)
          item:doThis("open-contents-in-browser")
        end)
      end
    },
  },
  action_table = {
    {
      text = "🌄📚 crsess.",
      key = "do-interactive",
      args = {
        key = "create-session",
        thing = "session name"
      }
    },
    {
      text = "🌐 br.",
      key = "open-all-in-browser",
    },
    {
      text = "📌🔗 addurls.",
      key = "create-all-as-urls",
    }
  },
  potential_interfaces = ovtable.init({
    { key = "array-of-urls-by-host", value = CreateArrayOfUrlsByHost },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfUrls = bindArg(NewDynamicContentsComponentInterface, ArrayOfUrlsSpecifier)