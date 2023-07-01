--- @type ItemSpecifier
URLItemSpecifier = {
  type = "url",
  properties = {
    getables = {
      ["parsed-url"] = function(self)
        return memoize(parseGuessScheme)(self:get("c"))
      end,
      ["is-url-by-contenttype"] = function(self)
        return self:get("url-path") and is.path.has_extension(self:get("url-path"))
      end,
      ["is-url-by-host"] = function(self)
        return self:get("url-host")
      end,
      ["is-url-by-path"] = function(self)
        return self:get("url-path")
      end,
      ["is-url-by-scheme"] = function(self)
        return self:get("url-scheme")
      end,
      ["html-d"] = function (self)
        return self:get("text-by-selector", "meta[name=d]")
      end,
      
    },
    doThisables = {
      ["download-url"] = function(self, path)
        dothis.url.download_to(self:get("c"), path, true)
      end,
      ["download-url-to-downloads"] = function(self)
        self:doThis("download-url", { value = "$HOME/Downloads", type = "quoted" })
      end,
      ["add-to-newsboat"] = function(self, category)
        st(env.NEWSBOAT_URLS):doThis("append-newsboat-url", {
          url = self:get("c"),
          title = self:get("html-title"),
          category = category
        })
      end,
      ["add-to-urls"] = function(self, name)
        local path = st(env.MURLS):get("related-path-with-subdirs-gui")
        path:doThis('create-file-with-contents', {
          contents = self:get("c"),
          name = ((name and #name > 0) and name) or self:get("html-title") .. ".url2"
        })
      end,
      ["subscribe-to-calendar"] = function(self)
        local name = self:get("url-domain")
        local khal_config = st(env.KHAL_CONFIG .. "/config")
        local vdirsyncer_config = st(env.VDIRSYNCER_CONFIG .. "/config" )
        local vdirsyncer_pair_specifier = vdirsyncer_config:get("vdirsyncer-pair-and-corresponding-storages-for-webcal", self:get("c"))
        local path  = env.XDG_STATE_HOME .. "/vdirsyncer/" .. vdirsyncer_pair_specifier.name
        local khal_data = khal_config:get("table-to-ini-section", {
          header = "[ro:" .. name .. "]", -- this results in double [[ ]] in the file, which is the format khal expects (don't ask me why)
          body = {
            path = path,
            priority = 0
          }
        })
        khal_config:doThis("append-file-contents", "\n\n" .. khal_data)
        vdirsyncer_config:doThis("append-file-contents", "\n\n" .. transf.vdirsyncer_pair_specifier.ini_string(vdirsyncer_pair_specifier))
        createPath(path)
        run({
          "vdirsyncer",
          "discover",
          { value = vdirsyncer_pair_specifier.name, type = "quoted" }
        }, {
          "vdirsyncer",
          "sync",
          { value = vdirsyncer_pair_specifier.name, type = "quoted" }
        }, true)
        khal_config:doThis("git-commit-self", "Add web-calendar " .. name)
        khal_config:doThis("git-push")
      end,
      ["add-events-to-calendar"] = function(self)
        ar(get.khal.writeable_calendars()):doThis("choose-item", function(calendar)
          dothis.khal.add_event_from_url(calendar, self:get("c"))
        end)
      end,

    }
  },
  potential_interfaces = ovtable.init({
    { key = "url-by-contenttype", value = CreateURLByContenttypeItem },
    { key = "url-by-host", value = CreateURLByHostItem },
    { key = "url-by-path", value = CreateURLByPathItem },
    { key = "url-by-scheme", value = CreateURLBySchemeItem }
  }),
  action_table = concat(getChooseItemTable({
    {
      i = "🏛⚙️🔗",
      d = "wbmchurl",
      key = "url-in-wayback-machine",
    },{
      key = "url-scheme",
      i = "🔗：⁄⁄",
      d = "urlschm",
    },{
      key = "url-host",
      i = "🔗👩‍💼",
      d = "urlhst"
    },{
      key = "url-domain-and-tld",
      i = "🔗🌐",
      d = "urldntld"
    },{
      key = "url-path",
      i = "🔗📁",
      d = "urlpth"
    },{
      key = "url-query",
      i = "🔗🔍",
      d = "urlqry"
    },{
      key = "url-fragment",
      i = "🔗#️⃣",
      d = "urlfrg"
    },{
      key = "url-port",
      i = "🔗🔌",
      d = "urlprt"
    },{
      key = "html-title",
      i = "🔗🔶🏧",
      d = "urlhtmlttl"
    },{
      key = "html-d",
      i = "🔗🔶💬",
      d = "urlhtmldsc"
    }
  }),{
    {
      text = "📌🔗⛵️ addurlnwsb.",
      key = "do-interactive",
      args = { key = "add-to-newsboat", thing = "category" }
    },
    {
      text = "📌🔗 addurls.",
      key = "do-interactive",
      args = { key = "add-to-urls", thing = "name" }
    },
    {
      text = "📥🔗 dlurl.",
      key = "do-interactive",
      args = { key = "download-url", thing = "path_from:" .. env.DOWNLOADS }
    },
    {
      key = "subscribe-to-calendar",
      text = "🔔📅 sbcal",
    },{
      key = "add-events-to-calendar",
      text = "➕📅 addevcal",
    }
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateURLItem = bindArg(NewDynamicContentsComponentInterface, URLItemSpecifier)