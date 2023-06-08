get = {
  mullvad = {
    status = function()
      return run("mullvad status")
    end,
    connected = function()
      return stringy.startswith(get.mullvad.status(),"Connected")
    end,
    relay_list_raw = function()
      return memoize(run)("mullvad relay list")
    end,
    flat_relay_array = function()
      return CreateArray(
        flatten(
          transf.multiline_string.relay_table(
            get.mullvad.relay_list_raw()
          )
        )
      )
    end,
    relay = function()
      return run("mullvad relay get"):match("hostname ([^ ]+)")
    end,
  },
  khard = {
    list = function()
      return memoize(run)(
        "khard list --parsable"
      )
    end,
    all_contact_uids = function()
      local res = map(
        stringy.split(get.khard.list(), "\n"), 
        function (line)
          return stringy.split(line, "\t")[1]
        end
      )
      return res
    end,
    all_contact_tables = function()
      return hs.fnutils.imap(
        get.khard.all_contact_uids(),
        function(uid)
          return transf.uuid.contact_table(uid)
        end
      )
    end
  },
  upkg = {
    package_managers = function()
      return lines(run("upkg list-package-managers"))
    end,
    backed_up_packages = function(mgr)
      return lines(run("upkg " .. (mgr or "") .. " read-backup"))
    end,
    missing_packages = function(mgr)
      return lines(run("upkg " .. (mgr or "") .. " missing"))
    end,
    added_packages = function(mgr)
      return lines(run("upkg " .. (mgr or "") .. " added"))
    end,
    difference_packages = function(mgr)
      return lines(run("upkg " .. (mgr or "") .. " difference"))
    end,
    package_manager_version = function(mgr)
      return lines(run("upkg " .. (mgr or "") .. " package-manager-version"))
    end,
    which_package_manager = function(mgr)
      return lines(run("upkg " .. (mgr or "") .. " which-package-manager"))
    end,
    package_managers_with_missing_packages = function(mgr)
      return lines(run("upkg " .. (mgr or "") .. " missing-package-managers"))
    end,
    list = function(mgr) return lines(run("upkg " .. (mgr or "") .. " list ")) end,
    count = function(mgr) return lines(run("upkg " .. (mgr or "") .. " count ")) end,
    with_version = function(mgr, arg) return lines(run("upkg " .. (mgr or "") .. " with-version " .. (arg or ""))) end,
    with_version_package_manager = function(mgr, arg) return lines(run("upkg " .. (mgr or "") .. " with-version-package-manager " .. (arg or ""))) end,
    version = function(mgr, arg) return lines(run("upkg " .. (mgr or "") .. " version " .. (arg or ""))) end,
    which = function(mgr, arg) return lines(run("upkg " .. (mgr or "") ..  " which " .. (arg or "")))
    end,
    is_installed = function(mgr, arg) return pcall(run, "upkg " .. (mgr or "") .. " is-installed " .. (arg or "")) end,
    installed_package_manager = function(arg) return lines(run("upkg " .. (arg or "") .. " is-installed-package-manager")) end,
  
  },
  khal = {
    all_calendars = function()
      return lines(run("khal printcalendars"))
    end,
    writeable_calendars = function()
      return filter(
        get.khal.all_calendars(),
        { _start =  "r-:", _invert = true }
      )
    end,
    writeable_calendar_string = function()
      return table.concat(
        get.khal.writeable_calendars(),
        ","
      )
    end,
    parseable_format_specifier = function()
      return table.concat(
        map(
          mt._list.khal.parseable_format_components,
          {_f ="{%s}"}
        ), mt._contains.unique_field_separator
      ) .. mt._contains.unique_record_separator
    end,
    basic_command_parts = function(include, exclude)
      local command = " --format=" .. transf.string.single_quoted_escaped(get.khal.parseable_format_specifier())
      if include then command = command .. transf.array_of_strings.repeated_option_string(include, "--include-calendar") end
      if exclude then command = command .. transf.array_of_strings.repeated_option_string(exclude, "--exclude-calendar") end
      return command
    end,
       
    search_event_tables = function(searchstr, include, exclude)
      local command = "khal search" .. get.khal.basic_command_parts(include, exclude)
      command = command .. " " .. transf.string.single_quoted_escaped(searchstr)
      return transf.multiline_string.array_of_event_tables(run(command, true))
    end,
    list_event_tables = function(specifier, include, exclude)
      local command = {
        'khal list -df ""',
        get.khal.basic_command_parts(include, exclude),
      }
      if specifier.once then
        push(command, "--once")
      end
      if specifier.notstarted then
        push(command, "--notstarted")
      end
      specifier.start = specifier.start or "today"
      specifier["end"] = specifier["end"] or date(os.time()):adddays(60):fmt("%Y-%m-%d")
      push(command, { value = specifier.start, type = "quoted" })
      push(command, { value = specifier["end"], type = "quoted" })
      return transf.multiline_string.array_of_event_tables(run(table.concat(command, " "), true))
    end,
    calendar_template_empty = function()
      CALENDAR_TEMPLATE_SPECIFIER = ovtable.new()
      CALENDAR_TEMPLATE_SPECIFIER.calendar = { 
        comment = 'one of: {{[ get.khal.writeable_calendar_string() ]}}' ,
        value = "default"
      }
      CALENDAR_TEMPLATE_SPECIFIER.start = {
        value = date():fmt("%Y-%m-%dT%H:%M"),
      }
      CALENDAR_TEMPLATE_SPECIFIER.title = {}
      CALENDAR_TEMPLATE_SPECIFIER.description = {}
      CALENDAR_TEMPLATE_SPECIFIER.location = {}
      CALENDAR_TEMPLATE_SPECIFIER["end"] = {
        comment = 'end of the event, either as a date, or as a delta in the form of [<n>d][<n>h][<n>m][<n>s]'
      }
      CALENDAR_TEMPLATE_SPECIFIER.alarms = {
        comment = 'array of alarms as deltas'
      }
      CALENDAR_TEMPLATE_SPECIFIER.url = {}
      CALENDAR_TEMPLATE_SPECIFIER.timezone = {
        comment = 'leave empty for local timezone'
      }
      CALENDAR_TEMPLATE_SPECIFIER["repeat"] = ovtable.new()
      CALENDAR_TEMPLATE_SPECIFIER["repeat"].freq = {
        comment = 'valid values: d[aily], w[eekly], m[onthly], y[early]. leave empty for no repeat'
      }
      CALENDAR_TEMPLATE_SPECIFIER["repeat"].interval = {
        comment = 'number of freq units between repeats'
      }
      CALENDAR_TEMPLATE_SPECIFIER["repeat"]["until"] = {
        comment = 'date to stop repeating'
      }
      CALENDAR_TEMPLATE_SPECIFIER["repeat"].count = {
        comment = 'number of times to repeat'
      }
      CALENDAR_TEMPLATE_SPECIFIER["repeat"].wkst = {
        comment = 'day to start week on (MO, TU, WE, TH, FR, SA, SU)',
        value = "MO"
      }
      CALENDAR_TEMPLATE_SPECIFIER["repeat"].byday = {
        comment = 'valid values: valid values: array of [sign]<integer><weekday>; meaning: occurrences to repeat on within freq'
      }
      CALENDAR_TEMPLATE_SPECIFIER["repeat"].bymonthday = {
        comment = 'only if freq is m[onthly]; valid values: array of [sign]<integer>; meaning: days of month to repeat on'
      }
      CALENDAR_TEMPLATE_SPECIFIER["repeat"].bymonth = {
        comment = 'only if freq is y[early]; valid values: array of [sign]<integer>; meaning: months to repeat on'
      }
      CALENDAR_TEMPLATE_SPECIFIER["repeat"].byyearday = {
        comment = 'only if freq is y[early]; valid values: array of [sign]<integer>; meaning: days of year to repeat on'
      }
      return CALENDAR_TEMPLATE_SPECIFIER
    end
  },
  pandoc = {
    full_md_extension_set = function()
      return flatten(
        mt._list.markdown_extensions,
        { mode="list"}
      )
    end
  }, 
  pass = {
    value = function(type, item)
      return memoize(run, refstore.params.memoize.opts.invalidate_1_day)("pass show " .. type .. "/" .. item)
    end,
    json = function(type, item)
      return runJSON("pass show " .. type .. "/" .. item)
    end,
    contact_json = function(type, item)
      return get.pass.json("contacts/" .. type, item)
    end,
    otp = function(item)
      return run("pass otp otp/" .. item)
    end,
  },
  sox = {
    is_recording = function()
      local succ, res = pcall(run, "pgrep -x rec")
      return succ
    end,
  }
}