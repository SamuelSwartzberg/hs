--- @type ItemSpecifier
URLItemSpecifier = {
  type = "url",
  properties = {
    getables = {
      ["parsed-url"] = function(self)
        return memoize(parseGuessScheme)(self:get("c"))
      end,
      ["url-scheme"] = function(self) return self:get("parsed-url").scheme end,
      ["url-host"] = function(self) return self:get("parsed-url").host end,
      ["url-domain-and-tld"] = function(self) 
        return string.match(self:get("url-host"), "(%w+%.%w+)$") end,
      ["url-domain"] = function(self) 
        return string.match(self:get("url-host"), "(%w+)%.%w+$") end,
      ["url-tld"] = function(self)
        return string.match(self:get("url-host"), "%w+%.(%w+)$") end,
      ["url-path"] = function(self) return self:get("parsed-url").path end,
      ["url-query"] = function(self) return self:get("parsed-url").query end,
      ["url-fragment"] = function(self) return self:get("parsed-url").fragment end,
      ["url-port"] = function(self) return self:get("parsed-url").port end,
      ["url-user"] = function(self) return self:get("parsed-url").user end,
      ["url-password"] = function(self) return self:get("parsed-url").password end,
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
      ["by-selector"] = function(self, specifier)
        return memoize(queryPage)(self:get("c"), specifier.selector, specifier.only_text)
      end,
      ["text-by-selector"] = function(self, selector)
        return self:get("by-selector", {
          selector = selector,
          only_text = true
        })
      end,
      ["html-title"] = function (self)
        return stringy.split(self:get("text-by-selector", "title"), "\n")[1]
      end,
      ["html-description"] = function (self)
        return self:get("text-by-selector", "meta[name=description]")
      end,
      ["default-negotation-url-contents"] = function(self)
        return transf.url.default_negotation_url_contents(self:get("c"))
      end,
      ["url-in-wayback-machine"] = function (self)
        return transf.url.in_wayback_machine(self:get("c"))
      end,
      ["param-table"] = function(self)
        return transf.url.param_table(self:get("c"))
      end
      
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
        local vdirsyncer_data = vdirsyncer_config:get("vdirsyncer-pair-and-corresponding-storages-for-webcal", self:get("c"))
        local khal_data = khal_config:get("table-to-ini-section", {
          header = "[ro:" .. name .. "]", -- this results in double [[ ]] in the file, which is the format khal expects (don't ask me why)
          body = {
            path = vdirsyncer_data.at,
            priority = 0
          }
        })
        khal_config:doThis("append-file-contents", "\n\n" .. khal_data)
        vdirsyncer_config:doThis("append-file-contents", "\n\n" .. vdirsyncer_data.value)
        createPath(vdirsyncer_data.at)
        run({
          "vdirsyncer",
          "discover",
          { value = vdirsyncer_data.name, type = "quoted" }
        }, {
          "vdirsyncer",
          "sync",
          { value = vdirsyncer_data.name, type = "quoted" }
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
      emoji_icon = "🏛⚙️🔗",
      description = "wbmchurl",
      key = "url-in-wayback-machine",
    },{
      key = "url-scheme",
      emoji_icon = "🔗：⁄⁄",
      description = "urlschm",
    },{
      key = "url-host",
      emoji_icon = "🔗👩‍💼",
      description = "urlhst"
    },{
      key = "url-domain-and-tld",
      emoji_icon = "🔗🌐",
      description = "urldntld"
    },{
      key = "url-path",
      emoji_icon = "🔗📁",
      description = "urlpth"
    },{
      key = "url-query",
      emoji_icon = "🔗🔍",
      description = "urlqry"
    },{
      key = "url-fragment",
      emoji_icon = "🔗#️⃣",
      description = "urlfrg"
    },{
      key = "url-port",
      emoji_icon = "🔗🔌",
      description = "urlprt"
    },{
      key = "html-title",
      emoji_icon = "🔗🔶🏧",
      description = "urlhtmlttl"
    },{
      key = "html-description",
      emoji_icon = "🔗🔶💬",
      description = "urlhtmldsc"
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