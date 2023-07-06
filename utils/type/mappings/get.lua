get = {
  string_or_number = {
    number = function(t, base)
      if type(t) == "string" then
        t = eutf8.gsub(t, "[ \t\n\r_]", "")
        t = eutf8.gsub(t, ",", ".")
        return get.string_or_number.number(t, base)
      else
        return t
      end
    end,
    int = function(t, base)
      return transf.number.int(
        get.string_or_number.number(t, base)
      )
    end,
    pos_int_or_nil = function(t, base)
      return transf.number.pos_int_or_nil(
        get.string_or_number.number(t, base)
      )
    end,
  },
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
      return transf.string.lines(run("upkg list-package-managers"))
    end,
    backed_up_packages = function(mgr)
      return transf.string.lines(run("upkg " .. (mgr or "") .. " read-backup"))
    end,
    missing_packages = function(mgr)
      return transf.string.lines(run("upkg " .. (mgr or "") .. " missing"))
    end,
    added_packages = function(mgr)
      return transf.string.lines(run("upkg " .. (mgr or "") .. " added"))
    end,
    difference_packages = function(mgr)
      return transf.string.lines(run("upkg " .. (mgr or "") .. " difference"))
    end,
    package_manager_version = function(mgr)
      return run("upkg " .. (mgr or "") .. " package-manager-version")
    end,
    which_package_manager = function(mgr)
      return run("upkg " .. (mgr or "") .. " which-package-manager")
    end,
    package_managers_with_missing_packages = function()
      return transf.string.lines(run("upkg missing-package-manager"))
    end,
    list = function(mgr) return transf.string.lines(run("upkg " .. (mgr or "") .. " list ")) end,
    list_version = function(mgr) return transf.string.lines(run("upkg " .. (mgr or "") .. " list-version ")) end,
    list_no_version = function(mgr) return transf.string.lines(run("upkg " .. (mgr or "") .. " list-no-version ")) end,
    list_version_package_manager = function(mgr) return transf.string.lines(run("upkg " .. (mgr or "") .. " list-version-package-manager ")) end,
    list_with_package_manager = function(mgr) return transf.string.lines(run("upkg " .. (mgr or "") .. " list-with-package-manager ")) end,
    count = function(mgr) return transf.string.lines(run("upkg " .. (mgr or "") .. " count ")) end,
    with_version = function(mgr, arg) return transf.string.lines(run("upkg " .. (mgr or "") .. " with-version " .. (arg or ""))) end,
    with_version_package_manager = function(mgr, arg) return transf.string.lines(run("upkg " .. (mgr or "") .. " with-version-package-manager " .. (arg or ""))) end,
    with_package_manager = function(mgr, arg) return transf.string.lines(run("upkg " .. (mgr or "") .. " with-package-manager " .. (arg or ""))) end,
    version = function(mgr, arg) return transf.string.lines(run("upkg " .. (mgr or "") .. " version " .. (arg or ""))) end,
    which = function(mgr, arg) return transf.string.lines(run("upkg " .. (mgr or "") ..  " which " .. (arg or "")))
    end,
    is_installed = function(mgr, arg) return pcall(run, "upkg " .. (mgr or "") .. " is-installed " .. (arg or "")) end,
    installed_package_manager = function(arg) return transf.string.lines(run("upkg " .. (arg or "") .. " installed-package-manager")) end,
  
  },
  khal = {
    all_calendars = function()
      return transf.string.lines(run("khal printcalendars"))
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
      if include then command = command .. transf.string_array.repeated_option_string(include, "--include-calendar") end
      if exclude then command = command .. transf.string_array.repeated_option_string(exclude, "--exclude-calendar") end
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
    path = function(type, item, ext)
      return env.PASSWORD_STORE_DIR .. "/" .. type .. "/" .. item .. "." .. (ext or "gpg")
    end,
    exists = function(type, item, ext)
      return testPath(get.pass.path(type, item, ext))
    end,
    json = function(type, item)
      return runJSON("pass show " .. type .. "/" .. item)
    end,
    contact_json = function(type, item)
      return get.pass.json("contacts/" .. type, item)
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
  audiodevice_specifier = {

  },
  audiodevice = {
    is_default = function (device, type)
      return device == get.audiodevice_system.default(type)
    end,
    
  },
  contact_table = {
    encrypted_data = function(contact_table, type)
      return get.pass.contact_json(type, contact_table.uid)
    end,
    tax_number = function(contact_table, type)
      return get.contact_table.encrypted_data(contact_table, "taxnr/" .. type)
    end,
    email = function(contact_table, type)
      return transf.contact_table.vcard_type_email_dict(contact_table)[type]
    end,
    phone_number = function(contact_table, type)
      return transf.contact_table.vcard_type_phone_dict(contact_table)[type]
    end,
    address_table = function(contact_table, type)
      return transf.contact_table.vcard_type_address_dict(contact_table)[type]
    end,
  },
  table = {
    ---@param table table
    ---@param keystop integer
    ---@param valuestop integer
    ---@param depth integer
    ---@return string[]
    yaml_lines_aligned_with_predetermined_stops = function(table, keystop, valuestop, depth)
      local lines = {}
      for value_k, value_v in fastpairs(table) do
        local pre_padding_length = depth * 2
        local key_length = #value_k
        local key_padding_length = keystop - (key_length + pre_padding_length)
        if type(value_v) == "table" and not (value_v.value or value_v.comment) then 
          push(lines, string.rep(" ", depth * 2) .. value_k .. ":" .. string.rep(" ", key_padding_length) .. " ")
          lines = concat(lines, get.table.yaml_lines_aligned_with_predetermined_stops(value_v, keystop, valuestop, depth + 1))
        elseif type(value_v) == "table" and (value_v.value or value_v.comment) then 
          local key_part = string.rep(" ", pre_padding_length) .. value_k .. ":" .. string.rep(" ", key_padding_length) .. " "
          local value_length = 0
          local value_part = ""
          if value_v.value then
            value_length = #value_v.value
            value_part = value_v.value
          end
          local comment_part = ""
          if value_v.comment then
            local value_padding_length = valuestop - value_length
            comment_part = string.rep(" ", value_padding_length) .. " # " .. value_v.comment
          end
          push(lines, key_part .. value_part .. comment_part)
        else
          -- do nothing
        end
      end
      
      return lines
    end
    
  },
  dict = {
    array_by_array = function(dict, arr)
      return map(
        arr,
        function(i, v)
          return i, dict[v]
        end,
        "k"
      )
    end
  },
  dict_with_timestamp = {
    array_by_array_with_timestamp_first = function(dict, arr)
      arr = glue({"timestamp"}, arr)
      return get.dict.array_by_array(dict, arr)
    end,
    timestamp_key_array_value_dict_by_array = function(dict, arr)
      return {
        [dict.timestamp] = get.dict.array_by_array(dict, arr)
      }
    end,
  },
  dict_of_dicts = {
    dict_of_arrays_by_array = function(dict_of_dicts, arr)
      return hs.fnutils.map(
        dict_of_dicts,
        bind(get.dict.array_by_array, {a_use, arr})
      )
    end
  },
  relative_path_dict = {
    absolute_path_dict = function(relative_path_dict, starting_point, extension)
      return map(relative_path_dict, function(k)
        local ext_part = ""
        if extension then ext_part = "." .. extension end
        return (starting_point or "") .. "/" .. k .. ext_part
      end, "k")
    end,
  },
  assoc_arr = {
    absolute_path_dict = function(t, starting_point, extension)
      return get.relative_path_dict.absolute_path_dict(
        transf.assoc_arr.to_relative_path_dict(t),
        starting_point,
        extension
      )
    end,
    first_matching_value_for_keys= function(t, keys)
      return find(t, {_list = keys}, {"k", "v"})
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
      return slice(arr, 1, n or 10)
    end,
    tail = function(arr, n)
      return slice(arr, -(n or 10))
    end,
    nth_element = function(arr, n)
      return arr[n]
    end,
    next = function(arr, n)
      return arr[n + 1]
    end,
    next_wrapping = function(arr, n)
      return arr[(n % #arr) + 1]
    end,
    previous = function(arr, n)
      return arr[n - 1]
    end,
    previous_wrapping = function(arr, n)
      return arr[(n - 2) % #arr + 1]
    end,
    sorted = function(list, comp)
      local new_list = copy(list, false)
      table.sort(new_list, comp)
      return new_list
    end,
    min = function(list, comp)
      return get.array.sorted(list, comp)[1]
    end,
    max = function(list, comp)
      return get.array.sorted(list, comp)[#list]
    end,
    revsorted = function(arr, comp)
      return rev(get.array.sorted(arr, comp))
    end,
    --- @generic T
    --- @param list T[]
    --- @param comp? fun(a: T, b: T):boolean
    --- @param if_even? "lower" | "higher" | "average" | "both"
    --- @return T
    median = function (list, comp, if_even)
      if_even = if_even or "lower"
      list = copy(list, false) -- don't modify the original list
      table.sort(list, comp)
      local mid = math.floor(#list / 2)
      if #list % 2 == 0 then
        if if_even == "lower" then
          return list[mid]
        elseif if_even == "higher" then
          return list[mid + 1]
        elseif if_even == "average" then
          return (list[mid] + list[mid + 1]) / 2
        else
          return {list[mid], list[mid + 1]}
        end
      else
        return list[mid + 1]
      end
    end,
    dict_by_array = function(arr, arr2)
      return map(
        arr,
        arr2,
        "k"
      )
    end,
    
  },
  string = {
    split_single_char = stringy.split,
    split_single_char_stripped = function(str, sep)
      return transf.string_array.stripped_string_array(
        transf.string.split_single_char(str, sep)
      )
    end,
    split = stringx.split,
    split_unpacked = function(str, sep, n)
      return table.unpack(transf.string.split(str, sep, n))
    end,
    lines_tail = function(path, n)
      return slice(transf.string.lines(path), -(n or 10))
    end,
    lines_head = function(path, n)
      return slice(transf.string.lines(path), 1, n or 10)
    end,
    content_lines_tail = function(path, n)
      return slice(transf.string.content_lines(path), -(n or 10))
    end,
    content_lines_head = function(path, n)
      return slice(transf.string.content_lines(path), 1, n or 10)
    end,
    startswith = stringy.startswith,
    endswith = stringy.endswith,
    split2d = function(str, upper_sep, lower_sep)
      local upper = transf.string.split(str, upper_sep)
      return hs.fnutils.imap(upper, function(v)
        return transf.string.split(v, lower_sep)
      end)
    end,
    search_engine_search_url = function(str, search_engine)
      return tblmap.search_engine.url[search_engine]:format(
        transf.string.urlencoded_search(str, tblmap.search_engine.spaces_percent[search_engine])
      )
    end,
    --- get a deterministic transformation of a string, either zero or few-shot
    deterministic_gpt_transformation = function(str, query, shots)
      local msgs = {
        {
          role = "user",
          content = query
        }, {
          role = "user",
          content = "If the input is already valid, echo the input."
        }, {
          role = "user",
          content = "If you are unable to fulfill the request, return 'IMPOSSIBLE'."
        }
      }
      if shots then
        for _, shot in ipairs(shots) do
          table.insert(msgs, {
            role = "user",
            content = shot[1]
          })
          table.insert(msgs, {
            role = "assistant",
            content = shot[2]
          })
        end
      end
      table.insert(msgs, {
        role = "user",
        content = str
      })
      local res = memoize(gpt, refstore.params.memoize.opts.permanent_fs)(
        msgs,
        refstore.params.gpt.opts.temperature_0
      )
      if res == "IMPOSSIBLE" then
        return nil
      else
        return res
      end
    end,
    deterministic_gpt_json = function(str, query, keys, shots)
      query = query .. "\nAlways return json." 
      if keys then
        query = query .. "\nValid keys are: " .. table.concat(keys, ", ")
      end
      local res = get.string.deterministic_gpt_transformation(str, query, shots)
      return transf.json_string.not_userdata_or_function(res)
    end,
    window_array_by_pattern = function(str, app_name)
      return get.running_application.window_array_by_pattern(
        transf.mac_application_name.running_application(app_name),
        str
      )
    end,
    window_by_title = function(str, app_name)
      return get.running_application.window_by_title(
        transf.mac_application_name.running_application(app_name),
        str
      )
    end,
      

  },
  string_array = {
    join = function(arr, sep)
      return table.concat(arr, sep)
    end,
    resplit_by_oldnew = function(arr, sep)
      return get.string.split(
        get.string_array.join(
          arr,
          sep
        ),
        sep
      )
    end,
    resplit_by_new = function(arr, sep)
      return get.string.split(
        get.string_array.join(
          arr,
          ""
        ),
        sep
      )
    end,
    resplit_by_oldnew_single_char = function(arr, sep)
      return get.string.split_single_char(
        get.string_array.join(
          arr,
          sep
        ),
        sep
      )
    end,
    resplit_by_oldnew_single_char_noempty = function(arr, sep)
      return filter(get.string.split_single_char(
        get.string_array.join(
          arr,
          sep
        ),
        sep
      ), true)
    end,
    resplit_by_new_single_char = function(arr, sep)
      return get.string.split_single_char(
        get.string_array.join(
          arr,
          ""
        ),
        sep
      )
    end,
    find = find,
    find_nocomment_noindent = function(arr, cond, opts)
      return find(transf.string_array.nocomment_noindent_string_array(arr), cond, opts)
    end,

  },
  array_of_string_arrays = {
    array_of_string_records = function(arr, field_sep)
      return hs.fnutils.imap(arr, function(x) return table.concat(x, field_sep) end)
    end,
    string_table = function(arr, field_sep, record_sep)
      return table.concat(get.array_of_string_arrays.array_of_string_records(arr, field_sep), record_sep)
    end,
    
  },
  path_leaf_specifier = {
    tag_value = function(parts, key)
      return transf.path_leaf_specifier.fs_tag_assoc(parts)[key]
    end,
    tag_raw_value = function(parts, key)
      return transf.path_leaf_specifier.fs_tag_string_dict(parts)[key]
    end,
  },
  path = {
    usable_as_filetype = function(path, filetype)
      path = transf.string.path_resolved(path)
      local extension = pathSlice(path, "-1:-1", { ext_sep = true, standartize_ext = true })[1]
      if find(mt._list.filetype[filetype], extension) then
        return true
      else
        return false
      end
    end,
    with_different_extension = function(path, ext)
      return transf.path.no_extension(path) .. "." .. ext
    end,
    leaf_starts_with = function(path, str)
      return stringy.startswith(transf.path.leaf(path), str)
    end,
    is_extension = function(path, ext)
      return transf.path.extension(path) == ext
    end,
    is_standartized_extension = function(path, ext)
      return transf.path.standartized_extension(path) == ext
    end,
    is_filename = function(path, filename)
      return transf.path.filename(path) == filename
    end,
    is_leaf = function(path, leaf)
      return transf.path.leaf(path) == leaf
    end,
    window_with_leaf_as_title = function(path, app_name)
      return get.string.window_by_title(
        transf.path.leaf(path),
        app_name
      )
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
    find_self_or_ancestor = function(path, fn)
      local ancestor = path
      while ancestor ~= "/" or ancestor ~= "" do
        if fn(ancestor) then
          return ancestor
        else
          ancestor = transf.path.parent_path(ancestor)
        end
      end
    end,
    find_ancestor = function(path, fn)
      return get.extant_path.find_self_or_ancestor(transf.path.parent_path(path), fn)
    end,
    find_self_or_ancestor_siblings = function(path, cond, opts)
      return get.extant_path.find_self_or_ancestor(path, function(x)
        return find(transf.dir.children_array(transf.path.parent_path(x)), cond, opts)
      end)
    end,
    cmd_output_from_path = function(path, cmd)
      if is.path.dir(path) then
        return get.dir.cmd_output_from_path(path, cmd)
      else
        return get.dir.cmd_output_from_path(transf.path.parent_path(path), cmd)
      end
    end,

    

  },
  dir = {
    find_child = function(dir, cond, opts)
      return find(transf.dir.children_array(dir), cond, opts)
    end,
    find_child_ending_with = function(dir, ending)
      return get.path_array.find_ending_with(transf.dir.children_array(dir), ending)
    end,
    find_leaf_of_child = function(dir, filename)
      return get.path_array.find_leaf(transf.dir.children_array(dir), filename)
    end,
    find_extension_of_child = function(dir, extension)
      return get.path_array.find_extension(transf.dir.children_array(dir), extension)
    end,
    find_child_with_leaf = function(dir, leaf)
      return get.path_array.find_path_with_leaf(transf.dir.children_array(dir), leaf)
    end,
    find_child_with_extension = function(dir, extension)
      return get.path_array.find_path_with_extension(transf.dir.children_array(dir), extension)
    end,
    find_child_with_leaf_ending = function(dir, leaf_ending)
      return get.path_array.find_path_with_leaf_ending(transf.dir.children_array(dir), leaf_ending)
    end,
    find_descendant = function(dir, cond, opts)
      return find(transf.dir.descendants_array(dir), cond, opts)
    end,
    find_descendant_ending_with = function(dir, ending)
      return get.path_array.find_ending_with(transf.dir.descendants_array(dir), ending)
    end,
    find_leaf_of_descendant = function(dir, filename)
      return get.path_array.find_leaf(transf.dir.descendants_array(dir), filename)
    end,
    find_extension_of_descendant = function(dir, extension)
      return get.path_array.find_extension(transf.dir.descendants_array(dir), extension)
    end,
    find_descendant_with_leaf = function(dir, leaf)
      return get.path_array.find_path_with_leaf(transf.dir.descendants_array(dir), leaf)
    end,
    find_descendant_with_extension = function(dir, extension)
      return get.path_array.find_path_with_extension(transf.dir.descendants_array(dir), extension)
    end,
    find_descendant_with_leaf_ending = function(dir, leaf_ending)
      return get.path_array.find_path_with_leaf_ending(transf.dir.descendants_array(dir), leaf_ending)
    end,

    cmd_output_from_path = function(path, cmd)
      return run("cd " .. transf.string.single_quoted_escaped(path) .. " && " .. cmd)
    end
  },
  git_root_dir = {
    hook_path = function(path, hook)
      return transf.git_root_dir.hooks_dir(path) .. "/" .. hook
    end,
    hook_res = function(path, hook)
      local hook_path = get.git_root_dir.hook_path(path, hook)
      return run(hook_path)
    end,
  },
  in_git_dir = {
    remote_blob_url = function(path, branch)
      local remote_type = transf.in_git_dir.remote_type(path)
      branch = branch or transf.in_git_dir.current_branch(path)
      local remote_owner_item = transf.in_git_dir.remote_owner_item(path)
      local relative_path = transf.in_git_dir.relative_path_from_git_root_dir(path)
      return get.git_hosting_service.file_url(
        transf.in_git_dir.remote_blob_host(path),
        tblmap.remote_type.blob_indicator[remote_type],
        remote_owner_item,
        branch,
        relative_path
      )
    end,
    remote_raw_url = function(path, branch)
      local remote_type = transf.in_git_dir.remote_type(path)
      branch = branch or transf.in_git_dir.current_branch(path)
      local remote_owner_item = transf.in_git_dir.remote_owner_item(path)
      local relative_path = transf.in_git_dir.relative_path_from_git_root_dir(path)
      return get.git_hosting_service.file_url(
        transf.in_git_dir.remote_raw_host(path),
        tblmap.remote_type.raw_indicator[remote_type],
        remote_owner_item,
        branch,
        relative_path
      )
    end,
  },
  plaintext_file = {
    lines_tail = function(path, n)
      return get.string.lines_tail(transf.plaintext_file.contents(path), n)
    end,
    lines_head = function(path, n)
      return get.string.lines_head(transf.plaintext_file.contents(path), n)
    end,
    nth_line = function(path, n)
      return transf.plaintext_file.lines(path)[n]
    end,
    contents_lines_appended = function(path, lines)
      local extlines = transf.plaintext_file.lines(path)
      return glue(extlines, lines)
    end,
    contents_line_appended = function(path, line)
      return dothis.plaintext_file.contents_lines_appended(path, {line})
    end,
    contents_lines_appended_to_string = function(path, lines)
      return table.concat(dothis.plaintext_file.contents_lines_appended(path, lines), "\n")
    end,
    contents_line_appended_to_string = function(path, line)
      return dothis.plaintext_file.content_lines_appended_to_string(path, {line})
    end,
    find_line = function(path, cond, opts)
      return find(transf.plaintext_file.lines(path), cond, opts)
    end,
    find_nocomment_noindent_content_lines = function(path, cond, opts)
      return find(transf.plaintext_file.nocomment_noindent_content_lines(path), cond, opts)
    end,

  },
  plaintext_table_file = {
    dict_of_dicts_by_first_element_and_array = function(plaintext_file, arr2)
      local array_of_arrays = transf.plaintext_table_file.array_of_array_of_fields(plaintext_file)
      return get.array_of_arrays.dict_of_dicts_by_first_element_and_array(array_of_arrays, arr2)
    end,
    dict_of_dicts_by_header_file = function(plaintext_file, header_file)
      local array_of_arrays = transf.plaintext_table_file.array_of_array_of_fields(plaintext_file)
      return get.array_of_arrays.dict_of_dicts_by_header_file(array_of_arrays, transf.plaintext_file.lines(header_file))
    end,
  },
  timestamp_first_column_plaintext_table_file = {
    something_newer_than_timestamp = function(path, timestamp, assoc_arr)
      local rows = transf.plaintext_table_file.iter_of_array_of_fields(path)
      local _, first_row = rows()
      local _, second_row = rows()
      if not first_row then return nil end
      if not second_row then second_row = {"0"} end
      local first_timestamp, second_timestamp = get.string_or_number.number(first_row[1]), get.string_or_number.number(second_row[1])
      if first_timestamp < second_timestamp then
        error("Timestamps are not in descending order. This is not recommended, as it forces us to read the entire file.")
      end
      local res
      if assoc_arr then 
        res = ovtable.new()
        table.remove(first_row, 1)
        res[first_timestamp] = first_row
        table.remove(second_row, 1)
        res[second_timestamp] = second_row
      else
        res = {first_row, second_row}
      end
      for i, row in rows do
        local current_timestamp = row[1]
        if get.string_or_number.number(current_timestamp) > timestamp then
          if assoc_arr then 
            table.remove(row, 1)
            res[current_timestamp] = row
          else
            table.insert(res, row)
          end
        else
          break
        end
      end
      return res
    end,
    array_of_fields_newer_than_timestamp = function(path, timestamp)
      return transf.timestamp_first_column_plaintext_table_file.something_newer_than_timestamp(path, timestamp, false)
    end,
    timestamp_key_array_value_dict_newer_than_timestamp = function(path, timestamp)
      return transf.timestamp_first_column_plaintext_table_file.something_newer_than_timestamp(path, timestamp, true)
    end,
  },
  bib_file = {
    raw_citations = function(path, format)
      get.csl_table_or_csl_table_array.raw_citations(transf.bib_file.array_of_csl_tables(path), format)
    end,
  },
  csl_table_or_csl_table_array = {
    raw_citations = function(csl_table, style)
      return run(
        "pandoc --citeproc -f csljson -t plain --csl=" .. transf.csl_style.path(style) .. transf.not_userdata_or_function.json_here_string(csl_table)
      )
    end,
    
  },
  csl_table_array = {
    
  },
  csl_table = {
    key_date_parts_single_or_range = function(csl_table, key)
      return csl_table[key]
    end,
    key_rf3339like_dt_or_interval = function(csl_table, key)
      return transf.date_parts_single_or_range.rf3339like_dt_or_interval(
        transf.csl_table.key_date_parts_single_or_range(csl_table, key)
      )
    end,
    key_rfc3339like_dt_force_first = function(csl_table, key)
      return transf.date_parts_single_or_range.rfc3339like_dt_force_first(
        transf.csl_table.key_date_parts_single_or_range(csl_table, key)
      )
    end,
    key_date_force_first = function(csl_table, key)
      return transf.date_parts_single_or_range.date_force_first(
        transf.csl_table.key_date_parts_single_or_range(csl_table, key)
      )
    end,
    key_prefix_partial_date_component_name_value_dict_force_first = function(csl_table, key)
      return transf.date_parts_single_or_range.prefix_partial_date_component_name_value_dict_force_first(
        transf.csl_table.key_date_parts_single_or_range(csl_table, key)
      )
    end,
    key_year_force_first = function(csl_table, key)
      return transf.csl_table.key_prefix_partial_date_component_name_value_dict_force_first(csl_table, key).year
    end,
  },
  shellscript_file = {
    lint_table = function(path, severity)
      return runJSON("shellcheck --format=json --severity=" .. severity .. transf.string.single_quoted_escaped(path))
    end,
    lint_gcc_string = function(path, severity)
      return run("shellcheck --format=gcc --severity=" .. severity .. transf.string.single_quoted_escaped(path))
    end,
  },
  email_file = {
    with_body_quoted = function(path, response)
      return response .. "\n\n" .. transf.email_file.quoted_body(path)
    end,
    prefixed_header = function(path, header)
      return run(
        "mshow -qh" .. transf.string.single_quoted_escaped(header) .. transf.string.single_quoted_escaped(path)
      )
    end,
    header = function(path, header)
      local prefixed_header = transf.email_file.prefixed_header(path, header)
      return eutf8.sub(prefixed_header, #header + 2) -- +2 for the colon and the space
    end,
    addresses = function(path, header, only)
      if not listContains(mt._list.email_headers_containin_emails, header) then
        error("Header can't contain email addresses")
      end
      only = defaultIfNil(only, true)
      local headerpart
      if header then
        headerpart = "-h" .. transf.string.single_quoted_escaped(header)
      else
        headerpart = ""
      end
      local res = run("maddr " .. (only and "-a" or "")  .. headerpart .. transf.string.single_quoted_escaped(path))
      return toSet(transf.string.lines(res))
    end,
    displayname_addresses_dict_of_dicts = function(path, header)
      local w_displaynames = transf.email_file.addresses(path, header, false)
      return hs.fnutils.imap(w_displaynames, transf.email_or_displayname_email.displayname_email_dict)
    end,

  },
  maildir_dir = {
    --- @param path string
    --- @param reverse? boolean
    --- @param magrep? string
    --- @param mpick? string
    --- @return string[]
    sorted_email_paths = function(path, reverse, magrep, mpick)
      local flags = "-d"
      if reverse then
        flags = flags .. "r"
      end
      local cmd = "mlist" .. transf.string.single_quoted_escaped(path)
      if magrep then
        cmd = cmd .. " | magrep -i" .. transf.string.single_quoted_escaped(magrep)
      end
      if mpick then
        cmd = cmd .. " | mpick -i" .. transf.string.single_quoted_escaped(mpick)
      end
      cmd = cmd .. " | msort " .. flags

      return transf.string.lines(run(cmd))
    end

  },
  email_specifier = {
    
  },
  logging_dir = {
    log_path_for_date = function(path, date)
      return transf.string.path_resolved(path) .. "/" .. transf.date.y_ym_ymd_path(date) .. ".csv"
    end,
    array_of_arrays_for_date = function(path, date)
      return transf.plaintext_table_file.array_of_array_of_fields(
        transf.logging_dir.log_path_for_date(path, date)
      )
    end,
    time_dict_of_dicts_for_date = function(path, date)
      return get.array_of_arrays.dict_of_dicts_by_first_element_and_array(
        get.logging_dir.array_of_arrays_for_date(path, date),
        transf.logging_dir.headers(path)
      )
    end,
    entry_dict_for_date = function(path, date)
      return get.logging_dir.time_dict_of_dicts_for_date(path, date)[transf.date.full_rfc3339like_time(date)]
    end,
  },
  path_array = {
    filter_to_same_filename = function(path_array, filename)
      return hs.fnutils.ifilter(path_array, function(path)
        return get.path.is_filename(path, filename)
      end)
    end,
    filter_to_different_filename = function(path_array, filename)
      return hs.fnutils.ifilter(path_array, function(path)
        return not get.path.is_filename(path, filename)
      end)
    end,
    filter_to_same_extension = function(path_array, extension)
      return hs.fnutils.ifilter(path_array, function(path)
        return get.path.is_extension(path, extension)
      end)
    end,
    filter_to_different_extension = function(path_array, extension)
      return hs.fnutils.ifilter(path_array, function(path)
        return not get.path.is_extension(path, extension)
      end)
    end,
    find_ending_with = function(path_array, ending)
      return find(path_array, {_stop = ending})
    end,
    find_leaf = function(path_array, leaf)
      return find(transf.path_array.leaves_array(path_array), {_exactly = leaf})
    end,
    find_extension = function(path_array, extension)
      return find(transf.path_array.extensions_array(path_array), {_exactly = extension})
    end,
    find_path_with_leaf = function(path_array, leaf)
      return hs.fnutils.find(path_array, function(path)
        return get.path.leaf(path) == leaf
      end)
    end,
    find_path_with_extension = function(path_array, extension)
      return hs.fnutils.find(path_array, function(path)
        return get.path.extension(path) == extension
      end)
    end,
    find_path_with_leaf_ending = function(path_array, leaf_ending)
      return hs.fnutils.find(path_array, function(path)
        return stringy.endswith(get.path.leaf(path), leaf_ending)
      end)
    end,
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
  },
  git_hosting_service = {
    file_url = function(host, indicator, owner_item, branch, relative_path)
      return "https://" .. host .. "/" .. owner_item .. "/" .. indicator .. branch .. "/" .. relative_path
    end,
  },
  date_component_name = {
    next = function(component, n)
      n = n or 0
      return get.array.next(mt._list.date.date_component_names, transf.date_component_name.index(component) + n)
    end,
    previous = function(component, n)
      n = n or 0
      return get.array.previous(mt._list.date.date_component_names, transf.date_component_name.index(component) - n)
    end,
  },
  date = {
    with_added = function(date, amount, component)
      local dtcp = date:copy()
      return dtcp["add" .. tblmap.date_component_name.date_component_name_long[component] .. "s"](dtcp, amount)
    end,
    with_subtracted = function(date, amount, component)
      return get.date.with_added(date, -amount, component)
    end,
    component_value = function(date, component)
      return date["get" .. tblmap.date_component_name.date_component_name_long[component]](date)
    end,
    surrounding_date_sequence_specifier = function(date, amount, step, unit)
      return {
        start = get.date.with_subtracted(date, amount, step),
        stop = get.date.with_added(date, amount, step),
        step = step,
        unit = unit,
      }
    end,
    date_sequence_specifier_of_lower_component = function(date, step, component)
      return get.full_date_component_name_value_dict.date_sequence_specifier_of_lower_component(
        transf.date.full_date_component_name_value_dict(date),
        step,
        component
      )
    end,
    hours_date_sequence_specifier = function(date, amount)
      return get.date.date_sequence_specifier_of_lower_component(date, amount, "day")
    end,
    to_precision = function(date, component)
      return get.full_date_component_name_value_dict.to_precision_date(
        transf.date.full_date_component_name_value_dict(date),
        component
      )
    end,
    --- accepts both format strings and format names
    formatted = function(date, format)
      local retrieved_format = tblmap.date_format_name.date_format[format]
      return date:fmt(retrieved_format or format)
    end,
    rfc3339like_dt_of_precision = function(date, precision)
      return get.date.formatted(date, tblmap.date_component_name.rfc3339like_dt_format_string[precision])
    end,

  },
  timestamp_s = {
    formatted = function(timestamp_s, format)
      return get.date.formatted(
        transf.timestamp_s.date(timestamp_s),
        format
      )
    end,
  },
  timestamp_ms = {
    formatted = function(timestamp_s, format)
      return get.date.formatted(
        transf.timestamp_s.date(timestamp_s),
        format
      )
    end,
  },
  date_component_name_list = {
    date_component_value_list = function(date_component_name_list, date_component_name_value_dict)
      return map(
        date_component_name_list,
        date_component_name_value_dict
      )
    end,
    date_component_value_ordered_list = function(date_component_name_list, date_component_name_value_dict)
      return map(
        transf.date_component_name_list.date_component_name_ordered_list(date_component_name_list),
        date_component_name_value_dict
      )
    end,
  },
  date_component_name_value_dict = {
    date_sequence_specifier = function(date_component_name_value_dict, step, unit)
      return {
        start = date(transf.date_component_name_value_dict.min_full_date_component_name_value_dict(date_component_name_value_dict)),
        stop = date(transf.date_component_name_value_dict.max_full_date_component_name_value_dict(date_component_name_value_dict)),
        step = step or 1,
        unit = unit or "sec"
      }
    end,
  },
  interval_specifier = {
    sequence_specifier = function(interval_specifier, step, unit)
      return {
        start = transf.interval_specifier.start(interval_specifier),
        stop = transf.interval_specifier.stop(interval_specifier),
        step = step or 1,
        unit = unit
      }
    end,
    array = function(interval_specifier, step, unit)
      return transf.sequence_specifier.array(
        get.interval_specifier.sequence_specifier(interval_specifier, step, unit)
      )
    end,
    is_in = function(interval_specifier, element)
      return interval_specifier.start <= element and element <= interval_specifier.stop
    end,
    is_contained_in = function(interval_specifier, other_interval_specifier)
      return get.interval_specifier.is_in(other_interval_specifier, interval_specifier.start) and
        get.interval_specifier.is_in(other_interval_specifier, interval_specifier.stop)
    end,
  },
  sequence_specifier = {

  },
  date_interval_specifier = {
    event_tables_within_range = function(date_interval_specifier, specifier, include, exclude)
      specifier = glue(transf.date_interval_specifier.event_table(date_interval_specifier), specifier)
      return get.khal.list_event_tables(
        specifier,
        include,
        exclude
      )
    end,
  },
  full_date_component_name_value_dict = {
    prefix_partial_date_component_name_value_dict = function(full_date_component_name_value_dict, component)
      return map(
        transf.date_component_name.date_component_name_value_dict_larger_or_same(component),
        full_date_component_name_value_dict
      )
    end,
    date_sequence_specifier_of_lower_component = function (full_date_component_name_value_dict, step, component, additional_steps_down)
      return get.date_component_name_value_dict.date_sequence_specifier(
        transf.full_date_component_name_value_dict.prefix_partial_date_component_name_value_dict(full_date_component_name_value_dict, component),
        step,
        get.date_component_name.next(component, additional_steps_down)
      )      
    end,
    to_precision_full_date_component_name_value_dict = function(full_date_component_name_value_dict, component)
      return transf.full_date_component_name_value_dict.min_full_date_component_name_value_dict(
        transf.full_date_component_name_value_dict.prefix_partial_date_component_name_value_dict(full_date_component_name_value_dict, component)
      )
    end,
    to_precision_date = function(full_date_component_name_value_dict, component)
      return date(transf.full_date_component_name_value_dict.to_precision_full_date_component_name_value_dict(full_date_component_name_value_dict, component))
    end,
  },
  rfc3339like_dt = {
    min_date_formatted = function(str, format)
      return transf.date.formatted(
        transf.rfc3339like_dt.min_date(str),
        format
      )
    end,
    max_date_formatted = function(str, format)
      return transf.date.formatted(
        transf.rfc3339like_dt.max_date(str),
        format
      )
    end,
  },
  array_of_arrays = {
    column = array2d.column,
    row = array2d.row,
    array_of_dicts_by_array = function(arr_of_arr, arr2)
      return hs.fnutils.imap(
        arr_of_arr,
        bind(get.array.dict_by_array, {a_use, arr2})
      )
    end,
    dict_of_arrays_by_first_element = function(arr_of_arr)
      return map(
        arr_of_arr,
        transf.array.first_rest,
        {"v", "kv"}
      )
    end,
    dict_of_dicts_by_first_element_and_array = function(arr_of_arr, arr2)
      return get.dict_of_arrays.dict_of_dicts_by_array(
        get.array_of_arrays.dict_of_arrays_by_first_element(arr_of_arr),
        arr2
      )
    end
  },
  dict_of_arrays = {
    dict_of_dicts_by_array = function(dict_of_arr, arr2)
      return hs.fnutils.map(
        dict_of_arr,
        bind(get.array.dict_by_array, {a_use, arr2})
      )
    end,
  },
  application_name = {
    in_tmp_dir = function(app_name, file)
      return get.string.in_tmp_dir("app/" .. app_name, file)
    end,
  },
  mac_application_name = {
    
  },
  firefox = {
  },
  chat_mac_application_name = {

  },
  running_application = {
    window_by_title = function(app, title)
      return app:getWindow(title)
    end,
    window_array_by_pattern = function(app, pattern)
      return app:findWindow(pattern)
    end,
  },
  window = {
    hs_geometry_point_with_offset = function(window, from, delta)
      return transf.window[
        "hs_geometry_point_" .. from
      ]:move(delta)
    end,
  },
  jxa_window_specifier = {
    jxa_tab_specifier = function(window_specifier, tab_index)
      return {
        application_name = window_specifier.application_name,
        window_index = window_specifier.window_index,
        tab_index = tab_index
      }
    end,
    property = function(window_specifier, property)
      return getViaOSA("js", ("Application('%s').windows()[%d].%s()"):format(
        window_specifier.application_name,
        window_specifier.window_index,
        property
      ))
    end,
  },
  jxa_tab_specifier = {
    property = function(tab_specifier, property)
      return getViaOSA("js", ("Application('%s').windows()[%d].tabs()[%d].%s()"):format(
        tab_specifier.application_name,
        tab_specifier.window_index,
        tab_specifier.tab_index,
        property
      ))
    end,
  },
  --- point-implementing = can be treated as a hs.geometry.point = hs.geometry.point or hs.geometry.rect but not hs.geometry.size
  hs_geometry_point_implementing = {
    hs_geometry_point_implementing_with_offset = function(point, delta)
      return point:move(delta)
    end,
  },
  event_table = {
    date_sequence_specifier = function(event_table, step, unit)
      return {
        start = transf.event_table.start_date(event_table),
        stop = transf.event_table.end_date(event_table),
        step = step or 1,
        unit = unit or "sec"
      }
    end,
  },
  detailed_env_node = {
    self_env_var_name_value_dict = function(node, prev_key, key)
      prev_key = prev_key or ""
      if node.value then
        local value = node.value
        if type(node.value) == 'table' then -- list value
          value = table.concat(
            map(node.value, {_f = prev_key .. "%s"}), 
            ":"
          )
        else
          value = prev_key .. value
        end
        local values = {
          [key] = value
        }
        if node.aliases then
          for _, alias in ipairs(node.aliases) do
            values[alias] = value
          end
        end
        return values
      else
        return {}
      end
    end,
    env_var_name_value_dict = function(node, prev_key, key)
      local self_dict = get.detailed_env_node.self_env_var_name_value_dict(node, prev_key, key)
      local dependent_dict
      if node.dependents then
        dependent_dict = get.detailed_env_node.env_var_name_value_dict(node.dependents, key)
      else
        dependent_dict = {}
      end
      return concat({self_dict, dependent_dict})
    end,
  },
  env_var_name_env_node_dict = {
    env_var_name_value_dict = function(dict, prev_key)
      if prev_key then prev_key = prev_key .. "/" else prev_key = "" end
      local values = {}
      for key, value in pairs(dict) do
        if type(value) == "string" then
          values[key] = prev_key .. value
        else
          local subvalues = get.detailed_env_node.env_var_name_value_dict(value, prev_key, key)
          values = concat({values, subvalues})
        end
      end
      return values
    end,
  },
  system = {
    all_applications = function()
      return transf.dir.children_filenames_array("/Applications")
    end
  },
  url = {

  },
  html_string = {
    html_query_selector_all = function(str, selector)
      return memoize(run)(
        "htmlq" .. transf.string.single_quoted_escaped(selector) .. transf.string.here_string(str)
      )
    end,
    text_query_selector_all = function(str, selector)
      return memoize(run)(
        "htmlq --text" .. transf.string.single_quoted_escaped(selector) .. transf.string.here_string(str)
      )
    end,
    attribute_query_selector_all = function(str, selector, attribute)
      return memoize(run)(
        "htmlq --attribute " .. transf.string.single_quoted_escaped(attribute) .. transf.string.single_quoted_escaped(selector) .. transf.string.here_string(str)
      )
    end,
    -- non-all seems to not be possible with htmlq. At least for html_, it would be possible if we parsed the html, but for text_, there seems to be no indication of when each result ends.
  },
  html_url = {
    html_query_selector_all = function(url, selector)
      return get.html_string.html_query_selector_all(
        transf.html_url.html_string(url),
        selector
      )
    end,
    text_query_selector_all = function(url, selector)
      return get.html_string.text_query_selector_all(
        transf.html_url.html_string(url),
        selector
      )
    end,
    attribute_query_selector_all = function(url, selector, attribute)
      return get.html_string.attribute_query_selector_all(
        transf.html_url.html_string(url),
        selector,
        attribute
      )
    end,
  },
  url_array = {
    absolute_path_dict_of_url_files = function(arr, root)
      return get.relative_path_dict.absolute_path_dict(
        transf.url_array.relative_path_dict_of_url_files(arr),
        root
      )
    end,
  },
  omegat_project_dir = {
    source_files_extension = function(dir, ext)
      return get.path_array.filter_to_same_extension(
        transf.omegat_project_dir.source_files(dir),
        ext
      )
    end,
    target_files_extension = function(dir, ext)
      return get.path_array.filter_to_same_extension(
        transf.omegat_project_dir.source_files(dir),
        ext
      )
    end,
  },
  project_dir = {
    local_project_material_path = function(dir, type)
      return transf.path.ending_with_slash(dir) .. type .. "/"
    end,
    local_subtype_project_material_path = function(dir, type, subtype)
      return get.project_dir.local_project_material_path(dir, type) .. subtype .. "/"
    end,
    local_universal_project_material_path = function(dir, type)
      return get.project_dir.local_subtype_project_material_path(dir, type, "universal")
    end,
    global_project_material_path = function(dir, type)
      return transf.path.ending_with_slash(env.MPROJECT_MATERIALS) .. type .. "/"
    end,
    global_subtype_project_material_path = function(dir, type, subtype)
      return get.project_dir.global_project_material_path(dir, type) .. subtype .. "/"
    end,
    global_universal_project_material_path = function(dir, type)
      return get.project_dir.global_subtype_project_material_path(dir, type, "universal")
    end,
  },
  iso_3366_1_alpha_2 = {
    --- don't use this for english, use transf.iso_3366_1_alpha_2.iso_3336_1_full_name instead
    full_name_in_language = function(code, language_identifier_string)
      return get.string.deterministic_gpt_transformation(
        "Get the short name of a country from its ISO 3366-1 alpha-2 code in the language '" .. language_identifier_string .. "'",
        code
      )
    end,
    --- don't use this for english, use transf.iso_3366_1_alpha_2.iso_3336_1_short_name instead
    short_name_in_language = function(code, language_identifier_string)
      return get.string.deterministic_gpt_transformation(
        "Get the short name of a country from its ISO 3366-1 alpha-2 code in the language '" .. language_identifier_string .. "'",
        code
      )
    end,
  },
  any = {
    join_if_array = function(arg, separator)
      if isListOrEmptyTable(arg) then
        return table.concat(arg, separator)
      else
        return arg
      end
    end,
    array_repeated = function(arg, times)
      local result = {}
      for i = 1, times do
        table.insert(result, arg)
      end
      return result
    end,
    repeated = function(arr, times)
      return table.unpack(get.any.array_repeated(arr, times))
    end,
    applicable_thing_name_hierarchy = function(any, local_thing_name_hierarchy, parent)
      local_thing_name_hierarchy = local_thing_name_hierarchy or copy(thing_name_hierarchy, true)
      parent = parent or "any"
      local res = {}
      for thing_name, child_thing_name_hierarchy_or_leaf_indication_string in pairs(thing_name_hierarchy) do
        local passes = is[parent][thing_name](any)
        if passes then
          if type(child_thing_name_hierarchy_or_leaf_indication_string) == "table" then
            res[thing_name] = get.any.applicable_thing_name_hierarchy(any, child_thing_name_hierarchy_or_leaf_indication_string, thing_name)
          else
            res[thing_name] = child_thing_name_hierarchy_or_leaf_indication_string
          end



      
    end
  },
  table_and_table = {
    larger_table_by_key = function(table1, table2, key)
      if table1[key] > table2[key] then
        return table1
      else
        return table2
      end
    end,
    smaller_table_by_key = function(table1, table2, key)
      if table1[key] < table2[key] then
        return table1
      else
        return table2
      end
    end,
  }
}