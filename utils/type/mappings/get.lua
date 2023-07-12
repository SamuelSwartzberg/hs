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
  int = {
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
        dothis.array.push(command, "--once")
      end
      if specifier.notstarted then
        dothis.array.push(command, "--notstarted")
      end
      specifier.start = specifier.start or "today"
      specifier["end"] = specifier["end"] or date(os.time()):adddays(60):fmt("%Y-%m-%d")
      dothis.array.push(command, { value = specifier.start, type = "quoted" })
      dothis.array.push(command, { value = specifier["end"], type = "quoted" })
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
      for value_k, value_v in transf.table.pair_stateless_iter(table) do
        local pre_padding_length = depth * 2
        local key_length = #value_k
        local key_padding_length = keystop - (key_length + pre_padding_length)
        if type(value_v) == "table" and not (value_v.value or value_v.comment) then 
          dothis.array.push(lines, string.rep(" ", depth * 2) .. value_k .. ":" .. string.rep(" ", key_padding_length) .. " ")
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
          dothis.array.push(lines, key_part .. value_part .. comment_part)
        else
          -- do nothing
        end
      end
      
      return lines
    end,
    has_key = function(t, key)
      return t[key] ~= nil
    end,
    --- Copy a table, optionally deep, return other types as-is.  
    --- Ensures that changes to the copy do not affect the original.  
    --- Handles self-referential tables.
    copy = function(t, deeop, copied_tables)
      if type(t) ~= "table" then return t end -- non-tables don't need to be copied
      deep = get.any.default_if_nil(deep, true)
      copied_tables = get.any.default_if_nil(copied_tables, {})
      if not t then return t end
      local new
      if t.isovtable then -- orderedtable
        new = ovtable.new()
      else
        new = {}
      end
      copied_tables[tostring(t)] = new
      for k, v in transf.table.pair_stateless_iter(t) do
        if type(v) == "table" and deep then
          if copied_tables[tostring(v)] then -- we've already copied this table, so just reference it
            new[k] = copied_tables[tostring(v)]
          else -- we haven't copied this table yet, so copy it and reference it
            new[k] = get.table.copy(v, deep, copied_tables)
          end
        else
          new[k] = v
        end
      end
      setmetatable(new, getmetatable(t)) -- I don't I currently have any metatables where data is stored and thus copy(getmetatable(t)) would be necessary, but this comment is here so that I remember to add it if I ever do
      return new
    end,
    key_value_equals = function(t, key, value)
      return t[key] == value
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
    next_by_index = function(arr, n)
      return arr[n + 1]
    end,
    next_by_index_wrapping = function(arr, n)
      return arr[(n % #arr) + 1]
    end,
    next_by_item = function(arr, item)
      local index = get.indexable.index_by_item(arr, item)
      return get.array.next_by_index(arr, index)
    end,
    next_by_item_wrapping = function(arr, item)
      local index = get.indexable.index_by_item(arr, item)
      return get.array.next_by_index_wrapping(arr, index)
    end,
    next_by_fn = function(arr, fn)
      local index = find(arr, fn, {"i"})
      return get.array.next_by_index(arr, index)
    end,
    next_by_fn_wrapping = function(arr, fn)
      local index = find(arr, fn, {"i"})
      return get.array.next_by_index_wrapping(arr, index)
    end,
    previous = function(arr, n)
      return arr[n - 1]
    end,
    previous_wrapping = function(arr, n)
      return arr[(n - 2) % #arr + 1]
    end,
    sorted = function(list, comp)
      local new_list = get.table.copy(list, false)
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
      list = get.table.copy(list, false) -- don't modify the original list
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
    contains = function(arr, v)
      for _, v2 in transf.array.index_value_stateless_iter(arr) do
        if v2 == v then return true end
      end
      return false
    end,
    combination_array = function(arr, k)
      k = k or #arr
      if k == 0 or #arr == 0 then
        return {{}}
      else 
        return get.any_stateful_generator.array(combine.combn, arr, k)
      end
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
        for _, shot in transf.array.index_value_stateless_iter(shots) do
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
    styledtext = function(str, styledtext_attributes_specifier)
      return hs.styledtext.new(str, styledtext_attributes_specifier)
    end,
    contains_any = function(str, anyof)
      for i = 1, #anyof do
        local res = stringy.find(str, anyof[i])
        if res then
          return true
        end
      end
      return false
    end,
    contains_all = function(str, allof)
      for i = 1, #allof do
        local res = stringy.find(str, allof[i])
        if not res then
          return false
        end
      end
      return true
    end,
    starts_ends = function(str, start, ends)
      return transf.string.startswith(str, start) and transf.string.endswith(str, ends)
    end,
  },
  string_or_styledtext = {
    styledtext_ignore_styled = function(str, styledtext_attributes_specifier)
      if type(str) == "string" then
        return hs.styledtext.new(str, styledtext_attributes_specifier)
      else
        return str
      end
    end,
    styledtext_merge = function(str, styledtext_attributes_specifier)
      if type(str) == "string" then
        return hs.styledtext.new(str, styledtext_attributes_specifier)
      else
        return transf.styledtext.styledtext_merge(str, styledtext_attributes_specifier)
      end
    end,
  },
  styledtext = {
    styledtext_merge = function(styledtext, styledtext_attributes_specifier)
      local existing_style = styledtext:asTable()
      local text_string = slice(existing_style, 1, 1)[1]
      local style = slice(existing_style, 2, #existing_style)
      local new_styledtext = hs.styledtext.new(text_string, styledtext_attributes_specifier)
      for _, v in transf.array.index_value_stateless_iter(style) do
        new_styledtext = new_styledtext:setStyle(v.styledtext_attributes_specifier, v.starts, v.ends)
      end
      return new_styledtext
    end
  },
  string_or_styledtext_array = {
    styledtext_array_merge = function(arr, styledtext_attributes_specifier)
      return hs.fnutils.imap(
        arr,
        bind(get.string_or_styledtext.styledtext_merge, {a_use, styledtext_attributes_specifier})
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
      if not get.array.contains(mt._list.email_headers_containin_emails, header) then
        error("Header can't contain email addresses")
      end
      only = get.any.default_if_nil(only, true)
      local headerpart
      if header then
        headerpart = "-h" .. transf.string.single_quoted_escaped(header)
      else
        headerpart = ""
      end
      local res = run("maddr " .. (only and "-a" or "")  .. headerpart .. transf.string.single_quoted_escaped(path))
      return transf.array.set(transf.string.lines(res))
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
      return get.array.next_by_index(mt._list.date.date_component_names, transf.date_component_name.index(component) + n)
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
          for _, alias in transf.array.index_value_stateless_iter(node.aliases) do
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
      for key, value in transf.native_table.key_value_stateless_iter(dict) do
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
      if is.any.array(arg) then
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
      local_thing_name_hierarchy = local_thing_name_hierarchy or get.table.copy(thing_name_hierarchy, true)
      parent = parent or "any"
      local res = {}
      for thing_name, child_thing_name_hierarchy_or_leaf_indication_string in transf.native_table.key_value_stateless_iter(thing_name_hierarchy) do
        local passes = is[parent][thing_name](any)
        if passes then
          if type(child_thing_name_hierarchy_or_leaf_indication_string) == "table" then
            res[thing_name] = get.any.applicable_thing_name_hierarchy(any, child_thing_name_hierarchy_or_leaf_indication_string, thing_name)
          else
            res[thing_name] = child_thing_name_hierarchy_or_leaf_indication_string
          end
        end
      end
      return res
    end,
    has_key = function(any, key)
      return is.any.table(any) and get.table.has_key(any, key)
    end,
    default_if_nil = function(any, default)
      if any == nil then
        return default
      else
        return any
      end
    end,
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
  },
  retriever_specifier = {
    result = function(retriever_specifier, value)
      return transf[
        retriever_specifier.thing_name
      ][
        retriever_specifier.target
      ](value)
    end,
  },
  retriever_specifier_array = {
    result_highest_precedence = function(arr, value)
      return get.retriever_specifier.result(
        transf.retriever_specifier_array.highest_precedence_retriever_specifier(arr),
        value
      )
    end,
    result_array = function(arr, value)
      return hs.fnutils.imap(
        arr, 
        bind(get.retriever_specifier.result, {a_use, value})
      )
    end,
    result_joined = function(arr, value)
      return table.concat(
        get.retriever_specifier.result_array(arr, value),
        " | "
      )
    end,
  },
  thing_name_array = {
    chooser_text = function(arr, value)
      return get.retriever_specifier_array.result_highest_precedence(
        transf.thing_name_array.chooser_text_retriever_specifier_array(arr),
        value
      )
    end,
    placeholder_text = function(arr, value)
      return get.retriever_specifier_array.result_highest_precedence(
        transf.thing_name_array.placeholder_text_retriever_specifier_array(arr),
        value
      )
    end,
    chooser_image = function(arr, value)
      return get.retriever_specifier_array.result_highest_precedence(
        transf.thing_name_array.chooser_image_retriever_specifier_array(arr),
        value
      )
    end,
    chooser_subtext = function(arr, value)
      return get.retriever_specifier_array.result_joined(
        transf.thing_name_array.chooser_subtext_retriever_specifier_array(arr),
        value
      )
    end,
  },
  hschooser_specifier = {
    partial_hschooser = function(spec, callback)
      return hs.chooser.new(function(chosen_chooser_item)
        if chosen_chooser_item then
          callback(chosen_chooser_item)
        else
          print("No item chosen, doing nothing")
        end
      end)
    end,
    choosing_hschooser_specifier = function(spec, key_name, tbl)
      return {
        hschooser_specifier = spec, 
        key_name = key_name,
        tbl = tbl,
      }
    end,
  },
  chooser_item_specifier_array = {
    styled_chooser_item_specifier_array = function(arr, chooser_item_specifier_text_key_styledtext_attributes_specifier_dict)
      local res = get.table.copy(arr)
      for i, chooser_item_specifier in transf.array.index_value_stateless_iter(res) do
        local text_styledtext_attribute_specifier = concat( {
          font = {size = 14 },
          color = { red = 0, green = 0, blue = 0, alpha = 0.7 },
        }, chooser_item_specifier_text_key_styledtext_attributes_specifier_dict.styledtext_attribute_specifier.text)
        local subtext_styledtext_attribute_specifier = concat( {
          font = {size = 12 },
          color = { red = 0, green = 0, blue = 0, alpha = 0.5 },
        }, chooser_item_specifier_text_key_styledtext_attributes_specifier_dict.styledtext_attribute_specifier.subtext)
        res[i].text = get.string_or_styledtext.styledtext_merge(
          chooser_item_specifier.text,
          text_styledtext_attribute_specifier
        )
        res[i].subText = get.string_or_styledtext.styledtext_merge(
          chooser_item_specifier.subText,
          subtext_styledtext_attribute_specifier
        )
      end
    end
  },
  ipc_socket_id = {
    response_table_or_nil = function(ipc_socket_id, request_table)
        
      local succ, res = pcall(runJSON, {
        args = 
          "echo '" .. json.encode(request_table) .. "' | /opt/homebrew/bin/socat UNIX-CONNECT:" .. transf.ipc_socket_id.ipc_socket_path(ipc_socket_id) .. " STDIO"
        ,
        key_that_contains_payload = "data"
      })

      if succ then
        return res
      else
        return nil
      end

    end
  },
  mpv_ipc_socket_id = {
    string = function(id, key)
      return get.ipc_socket_id.response_table_or_nil(id, {
        command = { "get_property", key }
      } )
    end,
    int = function(id, key)
      return get.string_or_number.int(
        get.mpv_ipc_socket_id.string(id, key)
      )
    end,
    boolean_emoji = function(id, key)
      local res = get.mpv_ipc_socket_id.string(id, key)
      if res then return tblmap.stream_attribute.true_emoji[key]
      else return tblmap.stream_attribute.false_emoji[key] end
    end,
  },
  created_item_specifier_array = {
    find_created_item_specifier_with_creation_specifier = function(arr, creation_specifier)
      return hs.fnutils.find(
        arr,
        bind(get.table.key_value_equals, {a_use, "creation_specifier", creation_specifier})
      )
    end,
  },
  indexable = {
    --- pairs dropin replacement that is ordered by default, supports start/stop/step and works with any indexable
    --- difference from iprs is that it returns the key instead of the index
    --- in case of a list/string, the key is the index, so it's the same as iprs
    --- guarantees the same order every time, thus may have a different order than pairs
    --- @param thing indexable
    --- @param start? integer
    --- @param stop? integer
    --- @param step? integer
    --- @param limit? integer
    --- @return function, indexable, integer
    key_value_stateless_iter = function(thing, start, stop, step, limit)
      local tblkeys = transf.native_table_or_nil.key_array(thing)
      local iter, tbl, idx = get.indexable.index_value_stateless_iter(thing, start, stop, step, limit, tblkeys)
      return function(tbl)
        local i, v = iter(tbl, idx)
        if i then
          idx = i
          return elemAt(thing, i, "kv", tblkeys)
        end
      end, tbl, idx
    end,
    --- @param thing indexable
    --- @param start? integer
    --- @param stop? integer
    --- @param step? integer
    --- @param limit? integer
    --- @return function, indexable, integer
    reversed_key_value_stateless_iter = function(thing, start, stop, step, limit)
      return get.indexable.key_value_stateless_iter(thing, start, stop, step and -math.abs(step) or -1, limit)
    end,
    --- ipairs dropin replacement that supports start/stop/step and works with any indexable
    --- slow though
    --- guarantees the same order every time, and typically also the same order as ipairs (though this is not guaranteed)
    --- @param indexable indexable
    --- @param start? integer
    --- @param stop? integer
    --- @param step? integer
    --- @param limit? integer limit the number of iterations, regardless of the index
    --- @param precalc_keys? any[] precalculated keys 
    --- @return function, indexable, integer
    index_value_stateless_iter = function(indexable, start, stop, step, limit, precalc_keys)
      local len_thing = len(indexable)
      if len_thing == 0 then
        return function() end, indexable, 0
      end
      start = start or 1 -- default to first elem
      if start < 0 then -- if negative, count from the end
        start = len_thing + start + 1 -- e.g. 8 + -1 + 1 = 8 -> last elem
      end
      stop = stop or len_thing -- default to last elem
      if stop < 0 then -- if negative, count from the end
        stop = len_thing + stop + 1
      end
      step = step or 1
      limit = limit or math.huge
      local iters = 0
      if (start - stop) * (step/math.abs(step)) > 0 then
        start, stop = stop, start -- swap if they're in the wrong order
      end
      local tblkeys = precalc_keys or transf.native_table_or_nil.key_array(indexable)
      return function(thing, i)
        i = i + step
        iters = iters + 1
        if 
          ((step > 0 and i <= stop) or
          (step < 0 and i >= stop)) and
          iters <= limit
        then
          return i, elemAt(thing, i, nil, tblkeys)
        end
      end, indexable, start - step
    end,
    --- @param thing indexable
    --- @param start? integer
    --- @param stop? integer
    --- @param step? integer
    --- @param limit? integer
    --- @return function, indexable, integer
    reversed_index_value_stateless_iter = function(thing, start, stop, step, limit)
      return get.indexable.index_value_stateless_iter(thing, start, stop, step and -math.abs(step) or -1, limit)
    end,
    index_by_item = function(arr, item)
      return find(
        arr,
        {_exactly = item},
        {"i"}
      )
    end,


  },
  stateless_generator = {
    --- stateful generator will create iterators that return values until they are over, at which point they return nil once, and then error on subsequent calls
    --- @generic T, U, V, W
    --- @param gen fun(...: `W`): fun(state: `T`, control_var: `U`): (...: `V`), T, U
    --- @param start_res_at? integer
    --- @param end_res_at? integer
    --- @return fun(...: W): fun(): V | nil
    stateful_generator = function(gen, start_res_at, end_res_at)
      start_res_at = start_res_at or 1
      end_res_at = end_res_at or nil
      return function(...)
        local stateless_next, state, initial_val = gen(...)
        local control_var = initial_val
        return function()
          local res = {stateless_next(state, control_var)}
          control_var = res[1]
          if control_var == nil then
            return nil
          else
            return table.unpack(res, start_res_at, end_res_at)
          end
        end
      end
    end
  },
  two_anys_stateful_generator = {
    assoc_arr = function(gen, ...)
      local res = {}
      local iter = gen(...)
      while true do
        local val = {iter()}
        if #val == 0 then
          break
        end
        res[val[1]] = val[2]
      end
      return res
    end
  },
  any_stateful_generator = {
    array = function(gen, ...)
      local res = {}
      local iter = gen(...)
      while true do
        local val = {iter()}
        if #val == 0 then
          break
        end
        table.insert(res, val)
      end
      return res
    end
  },
  binary_specifier = {
    string = function(binary_specifier, bool)
      if bool then
        return binary_specifier.vt
      else
        return binary_specifier.vf
      end
    end,
    boolean = function(binary_specifier, str)
      if str == binary_specifier.vt then
        return true
      elseif str == binary_specifier.vf then
        return false
      else
        error("invalid argument")
      end
    end,
    inverted_string = function(binary_specifier, bool)
      return get.binary_specifier.string(binary_specifier, not bool)
    end,
    inverted_boolean = function(binary_specifier, str)
      if str == binary_specifier.vt then
        return false
      elseif str == binary_specifier.vf then
        return true
      else
        error("invalid argument")
      end
    end,
    inverted = function(binary_specifier, str_or_bool)
      if type(str_or_bool) == "string" then
        return get.binary_specifier.inverted_string(binary_specifier, str_or_bool)
      else
        return get.binary_specifier.inverted_boolean(binary_specifier, str_or_bool)
      end
    end
  },
  two_numbers = {
    sum_modulo_n = function(a, b, n)
      return (a + b) % n
    end,
    difference_modulo_n = function(a, b, n)
      return (a - b) % n
    end,
  },
  comparable = {
    clamped = function(comparable, min, max)
      if comparable < min then
        return min
      elseif comparable > max then
        return max
      else
        return comparable
      end
    end,
  },
  two_comparables = {
    is_close = function(a, b, distance)
      return math.abs(a - b) < distance
    end,
  },
  stateless_iter_component_array = {
    table = function(stateless_iter_component_array, opts)
      opts = defaultOpts(opts, "kv")
    
      local res = getEmptyResult({}, opts)
    
      for a1, a2, a3, a4, a5, a6, a7, a8, a9 in transf.stateless_iter_component_array.stateless_iter(stateless_iter_component_array) do
        local as = {a1, a2, a3, a4, a5, a6, a7, a8, a9}
        addToRes(as, res, opts, nil, nil)
      end
    
      return res
    end
  }, 
  stream_creation_specifier = {
  }
}