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
      return ar(
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
      return run("upkg " .. (mgr or "") .. " package-manager-version")
    end,
    which_package_manager = function(mgr)
      return run("upkg " .. (mgr or "") .. " which-package-manager")
    end,
    package_managers_with_missing_packages = function()
      return lines(run("upkg missing-package-manager"))
    end,
    list = function(mgr) return lines(run("upkg " .. (mgr or "") .. " list ")) end,
    list_version = function(mgr) return lines(run("upkg " .. (mgr or "") .. " list-version ")) end,
    list_no_version = function(mgr) return lines(run("upkg " .. (mgr or "") .. " list-no-version ")) end,
    list_version_package_manager = function(mgr) return lines(run("upkg " .. (mgr or "") .. " list-version-package-manager ")) end,
    list_with_package_manager = function(mgr) return lines(run("upkg " .. (mgr or "") .. " list-with-package-manager ")) end,
    count = function(mgr) return lines(run("upkg " .. (mgr or "") .. " count ")) end,
    with_version = function(mgr, arg) return lines(run("upkg " .. (mgr or "") .. " with-version " .. (arg or ""))) end,
    with_version_package_manager = function(mgr, arg) return lines(run("upkg " .. (mgr or "") .. " with-version-package-manager " .. (arg or ""))) end,
    with_package_manager = function(mgr, arg) return lines(run("upkg " .. (mgr or "") .. " with-package-manager " .. (arg or ""))) end,
    version = function(mgr, arg) return lines(run("upkg " .. (mgr or "") .. " version " .. (arg or ""))) end,
    which = function(mgr, arg) return lines(run("upkg " .. (mgr or "") ..  " which " .. (arg or "")))
    end,
    is_installed = function(mgr, arg) return pcall(run, "upkg " .. (mgr or "") .. " is-installed " .. (arg or "")) end,
    installed_package_manager = function(arg) return lines(run("upkg " .. (arg or "") .. " installed-package-manager")) end,
  
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
  },
  audiodevice_system = {
    default = function(type)
      return hs.audiodevice["default" .. transf.word.capitalized(type) .. "Device"]()
    end,
  },
  audiodevice = {
    is_default = function (device, type)
      return device == get.audiodevice_system.default(type)
    end,
    name = function(device)
      return device:name()
    end,
  },
  array = {
    some_pass = function(arr, cond)
      return find(arr, cond, {"v", "boolean"})
    end,
    none_pass = function(arr, cond)
      return not get.array.some_pass(arr, cond)
    end,
    all_pass = function(arr, cond)
      if type(cond) == "table" then
        cond._invert = not cond._invert
      elseif type(cond) == "function" then
        local oldcond = cond
        cond = function(x) return not oldcond(x) end
      else
        error("Due to the transformations we need to do to the condition, it needs to be either a table or a function")
      end
      return get.array.none_pass(arr, cond)
    end,
    head = function(arr, n)
      return slice(arr, 1, n)
    end,
    tail = function(arr, n)
      return slice(arr, -n)
    end,

  },
  absolute_path = {
    relative_path_from = function(path, starting_point)
      return mustNotStart(path, mustEnd(starting_point, "/"))
    end,
  },
  extant_path = {
    attr = function(path, attr)
      return hs.fs.attributes(transf.string.path_resolved(path, true))[attr]
    end,
    date_attr = function(path, attr) -- attr must be one of "access", "modification", "change", "creation"
      return date(get.extant_path.attr(path, attr))
    end,
    

  },
  dir_path = {
    find_child = function(dir_path, cond, opts)
      return find(transf.dir_path.children_array(dir_path), cond, opts)
    end,
    find_child_ending_with = function(dir_path, ending)
      return get.dir_path.find_child(dir_path, {_stop = ending})
    end,
    find_child_with_leaf = function(dir_path, filename)
      return find(transf.dir_path.children_leaves_array(dir_path), {_exactly = filename})
    end,
    find_child_with_extension = function(dir_path, extension)
      return find(transf.dir_path.children_extensions_array(dir_path), {_exactly = extension})
    end,
  },
  bib_file = {
    citation = function(path, format)
      return run({
        "pandoc",
        "--citeproc",
        "-t", "plain",
        "--csl",
        { value = "styles/" .. format, type = "quoted" },
        {
          value = path,
          type = "quoted"
        }
      })
    end,
  },
  logging_dir = {
    log_for_date = function(path, date)
      return transf.string.path_resolved(path) .. "/" .. transf.date.y_ym_ymd_path(date) .. ".csv"
    end
  },
  extant_path_array = {
    sorted_by_attr_extant_path_array = function(arr, attr)
      return table.sort(arr, function(a, b)
        return get.extant_path.attr(a, attr) < get.extant_path.attr(b, attr)
      end)
    end,
    largest_by_attr = function(arr, attr)
      return get.extant_path_array.sorted_by_attr_extant_path_array(arr, attr)[1]
    end,
  }
}