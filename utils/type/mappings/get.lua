get = {
  string_or_number = {
    number_or_nil = function(t, base)
      if type(t) == "string" then
        return get.string.number_or_nil(t, base)
      else
        return t
      end
    end,
    int_by_rounded_or_nil = function(t, base)
      if type(t) == "string" then
        return get.string.int_by_rounded_or_nil(t, base)
      else
        return t
      end
    end,
    pos_int_or_nil = function(t, base)
      return transf.number.pos_int_or_nil(
        get.string_or_number.number_or_nil(t, base)
      )
    end,
  },
  int_or_nil = {
    prompted_once_int_from_default = function(int, message)
      return transf.prompt_spec.any({
        prompter = transf.prompt_args_string.string_or_nil_and_boolean,
        transformer = get.string.int_by_rounded_or_nil,
        prompt_args = {
          message = message or "Enter an int...",
          default = transf.number.nonindicated_decimal_number_string(int or 0),
        }
      })
    end,
  },
  number_or_nil = {
    prompted_once_number_from_default = function(no, message)
      return transf.prompt_spec.any({
        prompter = transf.prompt_args_string.string_or_nil_and_boolean,
        transformer = get.string.number_or_nil,
        prompt_args = {
          message = message or "Enter a number...",
          default = transf.number.nonindicated_decimal_number_string(no or 0),
        }
      })
    end,
  },

  package_manager_name_or_nil = {
    package_name_semver_compound_string_array = function(mgr, arg) return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " with-version " .. (arg or ""))) end,
    package_name_semver_package_manager_name_compound_string_array = function(mgr, arg) return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " with-version-package-manager " .. (arg or ""))) end,
    package_name_package_manager_name_compound_string = function(mgr, arg) return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " with-package-manager " .. (arg or ""))) end,
    semver_string_array = function(mgr, arg) return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " version " .. (arg or ""))) end,
    absolute_path_array = function(mgr, arg) return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") ..  " which " .. (arg or "")))
    end,
    boolean_array_installed = function(mgr, arg) return transf.string.bool_by_evaled_env_bash_success( "upkg " .. (mgr or "") .. " is-installed " .. (arg or "")) end,
  },
  calendar_name = {
   
  },
  khal = {
    parseable_format_specifier = function()
      return get.string_or_number_array.string_by_joined(
        get.array.string_array_by_mapped_values_w_fmt_string(
          mt._list.khal.parseable_format_component_array,
          "{%s}"
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
      return transf.multirecord_string.array_of_event_tables(transf.string.string_or_nil_by_evaled_env_bash_stripped(command))
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
      dothis.array.push(command, transf.string.single_quoted_escaped(specifier.start))
      dothis.array.push(command, transf.string.single_quoted_escaped(specifier["end"]))
      return transf.multirecord_string.array_of_event_tables(transf.string.string_or_nil_by_evaled_env_bash_stripped(get.string_or_number_array.string_by_joined(command, " "))
    end,
    calendar_template_empty = function()
      CALENDAR_TEMPLATE_SPECIFIER = ovtable.new()
      CALENDAR_TEMPLATE_SPECIFIER.calendar = { 
        comment = 'one of: {{[ transf["nil"].writeable_calendar_string() ]}}' ,
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
  pass_item_name = {
    value = function(item, type)
      return get.fn.rt_or_nil_by_memoized(transf.string.string_or_nil_by_evaled_env_bash_stripped, refstore.params.memoize.opts.invalidate_1_day)("pass show " .. type .. "/" .. item)
    end,
    path = function(item, type, ext)
      return env.PASSWORD_STORE_DIR .. "/" .. type .. "/" .. item .. "." .. (ext or "gpg")
    end,
    exists_as = function(item, type, ext)
      return is.absolute_path.extant_path(get.pass_item_name.path(item, type, ext))
    end,
    json = function(item, type)
      return transf.string.not_userdata_or_function_or_err_by_evaled_env_bash_parsed_json("pass show " .. type .. "/" .. item)
    end,
    contact_json = function(item, type)
      return get.pass_item_name.json(item, "contacts/" .. type)
    end,
    
  },
  ["nil"] = {
    default_audiodevice = function(type)
      return hs.audiodevice["default" .. transf.string.string_by_first_eutf8_upper(type) .. "Device"]()
    end,
    nth_arg_ret_fn = function(_, n)
      return function(...)
        return select(n, ...)
      end
    end,
  },
  audiodevice_specifier = {

  },
  audiodevice = {
    is_active_audiodevice_specifier = function (device, type)
      return device == get["nil"].default_audiodevice(type)
    end,
    
  },
  contact_table = {
    encrypted_data = function(contact_table, type)
      return get.pass_item_name.contact_json(contact_table.uid, type)
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
      for value_k, value_v in transf.table.stateless_key_value_iter(table) do
        local pre_padding_length = depth * 2
        local key_length = #value_k
        local key_padding_length = keystop - (key_length + pre_padding_length)
        if type(value_v) == "table" and not (value_v.value or value_v.comment) then 
          dothis.array.push(lines, string.rep(" ", depth * 2) .. value_k .. ":" .. string.rep(" ", key_padding_length) .. " ")
          lines = transf.two_arrays.array_by_appended(lines, get.table.yaml_lines_aligned_with_predetermined_stops(value_v, keystop, valuestop, depth + 1))
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
    bool_by_has_key = function(t, key)
      return t[key] ~= nil
    end,
    --- Copy a table, optionally deep, return other types as-is.  
    --- Ensures that changes to the copy do not affect the original.  
    --- Handles self-referential tables.
    --- @generic T
    --- @param t T
    --- @param deep? boolean
    --- @return T
    table_by_copy = function(t, deep, copied_tables)
      if type(t) ~= "table" then return t end -- non-tables don't need to be copied
      deep = get.any.default_if_nil(deep, true)
      copied_tables = get.any.default_if_nil(copied_tables, {})
      if not t then return t end
      local new = {}
      copied_tables[tostring(t)] = new
      for k, v in transf.table.stateless_key_value_iter(t) do
        if type(v) == "table" and deep then
          if copied_tables[tostring(v)] then -- we've already copied this table, so just reference it
            new[k] = copied_tables[tostring(v)]
          else -- we haven't copied this table yet, so copy it and reference it
            new[k] = get.table.table_by_copy(v, deep, copied_tables)
          end
        else
          new[k] = v
        end
      end
      setmetatable(new, getmetatable(t)) -- I don't I currently have any metatables where data is stored and thus copy(getmetatable(t)) would be necessary, but this comment is here so that I remember to add it if I ever do
      return new
    end,
    bool_by_key_equals_value = function(t, key, value)
      return t[key] == value
    end,
    vt_or_err = function(t, key)
      if t[key] then
        return t[key]
      else
        error("Table did not contain key " .. key)
      end
    end,
    array_of_arrays_by_label_root_to_leaf = function(t, table_arg_bool_by_is_leaf_ret_fn, visited, path)
      visited = get.any.default_if_nil(visited, {})
      local arr_o_arrs = {}
      for k, v in transf.table.stateless_key_value_iter(t) do
        local path = transf.array_and_any.array(path, k)
        if not is.any.table(v) or table_arg_bool_by_is_leaf_ret_fn(v) then -- this is inherently a leaf, or we've been told to treat it as one
          dothis.array.push(
            arr_o_arrs, 
            transf.array_and_any.array(path, v)
          )
        else -- not a leaf
          if not get.array.bool_by_contains(visited, v) then -- only if we've not seen this yet, to avoid infinite loops
            arr_o_arrs = transf.two_arrays.array_by_appended(
              arr_o_arrs,
              get.table.array_of_arrays_by_label_root_to_leaf(
                v,
                table_arg_bool_by_is_leaf_ret_fn,
                transf.two_arrays.array_by_appended(visited, v),
                path
              )
            )
          end
        end
      end
      return arr_o_arrs
    end,
    array_of_arrays_by_key_label = function(t, table_arg_bool_by_is_leaf_ret_fn, visited, path)
      visited = get.any.default_if_nil(visited, {})
      local arr_o_arrs = {}
      for k, v in transf.table.stateless_key_value_iter(t) do
        local path = transf.array_and_any.array(path, k)
        dothis.array.push(
          arr_o_arrs, 
          path
        )
        if is.any.table(v) and table_arg_bool_by_is_leaf_ret_fn(v) then -- not a leaf
          if not get.array.bool_by_contains(visited, v) then -- only if we've not seen this yet, to avoid infinite loops
            arr_o_arrs = transf.two_arrays.array_by_appended(
              arr_o_arrs,
              get.table.array_of_arrays_by_key_label(
                v,
                table_arg_bool_by_is_leaf_ret_fn,
                transf.two_arrays.array_by_appended(visited, v),
                path
              )
            )
          end
        end
      end
      return arr_o_arrs
    end,
    string_by_joined_key_any_value_dict = function(t, table_arg_bool_by_is_leaf_ret_fn, joiner)
      return get.array_of_arrays.string_by_joined_key_any_value_dict(
        get.table.array_of_arrays_by_label_root_to_leaf(t, table_arg_bool_by_is_leaf_ret_fn),
        joiner
      )
    end,
    stop_specifier = function(t, table_arg_bool_by_is_leaf_ret_fn)
      error("I never finished writing this???")
      return get 
    end,
    table_by_mapped_w_kt_vt_arg_kt_vt_ret_fn = function(t, fn)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(t) do
        local nk, nv = fn(k, v)
        res[nk] = nv
      end
      return res
    end,
    table_by_mapped_w_kt_vt_arg_kt_ret_fn = function(t, fn)
      return get.table.table_by_mapped_w_kt_vt_arg_kt_vt_ret_fn(t, function(k, v) return fn(k, v), v end)
    end,
    table_by_mapped_w_kt_vt_arg_vt_ret_fn = function(t, fn)
      return get.table.table_by_mapped_w_kt_vt_arg_kt_vt_ret_fn(t, function(k, v) return k, fn(k, v) end)
    end,
    table_by_mapped_w_kt_arg_kt_ret_fn = function(t, fn)
      return get.table.table_by_mapped_w_kt_vt_arg_kt_vt_ret_fn(t, function(k, v) return fn(k), v end)
    end,
    table_by_mapped_w_vt_arg_vt_ret_fn = hs.fnutils.map,
    table_by_mapped_w_vt_arg_kt_ret_fn = function(t, fn)
      return get.table.table_by_mapped_w_kt_vt_arg_kt_vt_ret_fn(t, function(k, v) return fn(v), v end)
    end,
    table_by_mapped_w_vt_arg_kt_vt_ret_fn = function(t, fn)
      return get.table.table_by_mapped_w_kt_vt_arg_kt_vt_ret_fn(t, function(k, v) return fn(v) end)
    end,
    table_by_mapped_w_kt_arg_vt_ret_fn = function(t, fn)
      return get.table.table_by_mapped_w_kt_vt_arg_kt_vt_ret_fn(t, function(k, v) return k, fn(k) end)
    end,
    table_by_mapped_w_kt_arg_kt_vt_ret_fn = function(t, fn)
      return get.table.table_by_mapped_w_kt_vt_arg_kt_vt_ret_fn(t, function(k, v) return fn(k) end)
    end,
    array_by_mapped_w_kt_vt_arg_vt_ret_fn = function(t, fn)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(t) do
        dothis.array.push(res, fn(k, v))
      end
      return res
    end,
    array_by_mapped_w_kt_arg_vt_ret_fn = function(t, fn)
      return get.table.array_by_mapped_w_kt_vt_arg_vt_ret_fn(t, function(k, v) return fn(k) end)
    end,
    array_by_mapped_w_vt_arg_vt_ret_fn = function(t, fn)
      return get.table.array_by_mapped_w_kt_vt_arg_vt_ret_fn(t, function(k, v) return fn(v) end)
    end,
    string_array_by_mapped_w_fmt_string = function(t, fmt_str)
      return get.table.array_by_mapped_w_kt_vt_arg_vt_ret_fn(
        t,
        function(k,v)
          return eutf8.format(fmt_str, k, v)
        end
      )
    end,
    table_by_mapped_w_vt_arg_vt_ret_fn_and_vt_arg_bool_ret_fn = function(t, fn, bool_fn)
      return get.table.table_by_mapped_w_vt_arg_vt_ret_fn(
        t,
        function(v)
          if bool_fn(v) then
            return fn(v)
          else
            return v
          end
        end
      )
    end,

    
  },
  
  dict = {
    array_by_mapped_w_kt_array = function(dict, arr)
      return get.array.array_by_mapped_w_t_key_dict(
        arr,
        dict
      )
    end,
    key_value_fn_filtered_dict = function(t, fn)
      return transf.pair_array.dict(
        hs.fnutils.ifilter(
          transf.dict.pair_array(t),
          function(pair)
            return fn(pair[1], pair[2])
          end
        )
      )
    end,
    value_fn_filtered_dict = function(t, fn)
      return get.dict.key_value_fn_filtered_dict(t, function(k, v) return fn(v) end)
    end,
    kt_or_nil_by_first_match_w_kt_vt_arg_fn = function(t, fn)
      local arr = transf.dict.pair_array_by_sorted_larger_key_first(t)
      for _, pair in transf.array.index_value_stateless_iter(arr) do
        if fn(pair[1], pair[2]) then
          return pair[1]
        end
      end
    end,
    kt_or_nil_by_first_match_w_kt_arg_fn = function(t, fn)
      return get.dict.kt_or_nil_by_first_match_w_kt_vt_arg_fn(t, function(k, v) return fn(k) end)
    end,
    kt_or_nil_by_first_match_w_vt_arg_fn = function(t, fn)
      return get.dict.kt_or_nil_by_first_match_w_kt_vt_arg_fn(t, function(k, v) return fn(v) end)
    end,
    kt_or_nil_by_first_match_w_vt = function(t, vt)
      return get.dict.kt_or_nil_by_first_match_w_vt_arg_fn(t, function(v) return v == vt end)
    end,
    kt_by_first_match_w_kt_arr = function(t, keys)
      return get.dict.kt_or_nil_by_first_match_w_kt_arg_fn(t, function(k) return get.array.bool_by_contains(keys, k) end)
    end,
    vt_by_first_match_w_kt_arr= function(t, keys)
      local key = get.dict.kt_or_nil_by_first_match_w_kt_arr(t, keys)
      if key then
        return t[key]
      else
        return nil
      end
    end,

  },
  dict_with_timestamp = {
    array_by_array_with_timestamp_first = function(dict, arr)
      arr = transf.any_and_array.array("timestamp", arr)
      return get.dict.array_by_mapped_w_kt_array(dict, arr)
    end,
    timestamp_key_array_value_dict_by_array = function(dict, arr)
      return {
        [dict.timestamp] = get.dict.array_by_mapped_w_kt_array(dict, arr)
      }
    end,
  },
  dict_of_dicts = {
    dict_of_arrays_by_array = function(dict_of_dicts, arr)
      return hs.fnutils.map(
        dict_of_dicts,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.dict.array_by_mapped_w_kt_array, {a_use, arr})
      )
    end
  },
  relative_path_dict = {
    absolute_path_dict = function(relative_path_dict, starting_point, extension)
      return get.table.table_by_mapped_w_kt_arg_kt_ret_fn(relative_path_dict, function(k)
        local ext_part = ""
        if extension then ext_part = "." .. extension end
        return (starting_point or "") .. "/" .. k .. ext_part
      end)
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
  },
  table_of_assoc_arrs = {
    array_of_assoc_arrs = function(assoc_arr, key)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(assoc_arr) do
        local copied = get.table.table_by_copy(v, true)
        copied[key] = k
        dothis.array.push(res, copied)
      end
      return res
    end,
  },
  complete_pos_int_slice_spec = {
    boolen_by_is_hit_w_pos_int = function(spec, i)
      return i >= spec.start and i <= spec.stop and (i - spec.start) % spec.step == 0 
    end,
  },
  array = {
    two_arrays_of_arrays_by_slice_w_slice_spec = function(arr, spec)
      
      if spec.start and not is.any.number(spec.start) then
        spec.start = get.array.pos_int_or_nil_by_first_match_w_t(arr, spec.start)
      end

      if spec.stop and  not is.any.number(spec.start) then
        spec.stop = get.array.pos_int_or_nil_by_first_match_w_t(arr, spec.stop)
      end

      local hits = {}
      local misses = {}

      -- set defaults

      if not spec.step then spec.step = 1 end
      if not spec.start then spec.start = 1 end
      if not spec.stop then spec.stop = transf.array.pos_int_by_length(arr) end

      -- resolve negative indices

      if spec.start < 0 then
        spec.start = transf.array.pos_int_by_length(arr) + spec.start + 1
      end
      if spec.stop < 0 then
        spec.stop = transf.array.pos_int_by_length(arr) + spec.stop + 1
      end

      -- clamp indices to ensure we don't go out of bounds (+/-1 because we want over/underindexing to produce an empty thing, not the last element)

      spec.start = get.comparable.comparable_by_clamped(spec.start, 1, transf.indexable.length(arr) + 1)
      spec.stop = get.comparable.comparable_by_clamped(spec.stop, 1-1, transf.indexable.length(arr))

      -- handle cases where users have passed conditions that will result in an infinite loop

      if spec.start > spec.stop and spec.step > 0 then
        return {}, arr
      elseif spec.start < spec.stop and spec.step < 0 then
        return {}, arr
      end

      -- I want to return an array of arrays, with each series of hits or misses being its own array
      local current = {}
      local current_type = nil

      for i = 1, #arr do
        if get.complete_pos_int_slice_spec.boolen_by_is_hit_w_pos_int(spec, i) then
          if current_type == "misses" then
            dothis.array.push(hits, current)
            current = {}
          end
          current_type = "hits"
          dothis.array.push(current, arr[i])
        else
          if current_type == "hits" then
            dothis.array.push(misses, current)
            current = {}
          end
          current_type = "misses"
          dothis.array.push(current, arr[i])
        end
        
      end

      if #current > 0 then
        if current_type == "hits" then
          dothis.array.push(hits, current)
        else
          dothis.array.push(misses, current)
        end
    end

      return hits, misses


    end,
    two_arrays_by_slice_w_slice_spec = function(arr, spec)
      local hits, misses = get.array.two_arrays_of_arrays_by_slice_w_slice_spec(arr, spec)
      return get.array.array_by_flatten(hits), get.array.array_by_flatten(misses)
    end,
    array_by_slice_w_slice_spec = function(arr, slice_spec)
      return select(
        1,
        get.array.two_arrays_by_slice_w_slice_spec(arr, slice_spec)
      )
    end,
    two_arrays_of_arrays_by_slice_w_3_int_any_or_nils = function(arr, start, stop, step)
      return get.array.two_arrays_of_arrays_by_slice_w_slice_spec(
        arr,
        {
          start = start,
          stop = stop,
          step = step,
        }
      )
    end,
    two_arrays_by_slice_w_3_int_any_or_nils = function(arr, start, stop, step)
      return get.array.two_arrays_by_slice_w_slice_spec(
        arr,
        {
          start = start,
          stop = stop,
          step = step,
        }
      )
    end,
    array_by_slice_w_3_pos_int_any_or_nils = function(arr, start, stop, step)
      return get.array.array_by_slice_w_slice_spec(
        arr,
        {
          start = start,
          stop = stop,
          step = step,
        }
      )
    end,
    two_arrays_of_arrays_by_slice_w_slice_notation = function(arr, notation)
      return get.array.two_arrays_of_arrays_by_slice_w_3_int_any_or_nils(
        arr,
        transf.slice_notation.three_pos_int_or_nils(notation)
      )
    end,
    two_arrays_by_slice_w_slice_notation = function(arr, notation)
      return get.array.two_arrays_by_slice_w_3_int_any_or_nils(
        arr,
        transf.slice_notation.three_pos_int_or_nils(notation)
      )
    end,
    array_by_slice_w_slice_notation = function(arr, notation)
      return get.array.array_by_slice_w_3_pos_int_any_or_nils(
        arr,
        transf.slice_notation.three_pos_int_or_nils(notation)
      )
    end,
    two_arrays_of_arrays_by_slice_and_removed_filler_w_slice_spec = function(arr, slice_spec, fill)
      local hits, removed = get.array.two_arrays_of_arrays_by_slice_w_slice_spec(arr, slice_spec)
      return hits, get.array_of_arrays.array_of_arrays_by_mapped(
        removed,
        function(arr)
          return hs.fnutils.imap(
            arr,
            function()
              return fill
            end
          )
        end
      )
    end,
    array_of_arrays_by_slice_and_removed_filler_w_slice_spec = function(arr, slice_spec, fill)
      local hits, fill = get.array.two_arrays_of_arrays_by_slice_and_removed_filler_w_slice_spec(arr, slice_spec, fill)
      return transf.two_arrays.array_by_interleaved_stop_longest(hits, fill)
    end,
    array_by_slice_removed_filler_and_flatten_w_slice_spec = function(arr, slice_spec, fill)
      return transf.array_of_arrays.array_by_flatten(
        get.array.array_of_arrays_by_slice_and_removed_filler_w_slice_spec(arr, slice_spec, fill)
      )
    end,
    --- the difference between this function and the _removed_filler one is that this will replace an array of removed elements with a single element (the indicator) unless length zero, whereas the other will replace it with an array of elements (the fill)
    two_array_of_arrays_by_slice_and_removed_indicator_w_slice_spec = function(arr, slice_spec, indicator)
      local hits, removed = get.array.two_arrays_of_arrays_by_slice_w_slice_spec(arr, slice_spec)
      return hits, get.array_of_arrays.array_of_arrays_by_mapped_if_not_length_0(
        removed,
        function(arr)
          return {indicator}
        end
      )
    end,
    array_of_arrays_by_slice_and_removed_indicator_w_slice_spec = function(arr, slice_spec, indicator)
      local hits, indicator = get.array.two_array_of_arrays_by_slice_and_removed_indicator_w_slice_spec(arr, slice_spec, indicator)
      return transf.two_arrays.array_by_interleaved_stop_longest(hits, indicator)
    end,
    array_by_slice_removed_indicator_and_flatten_w_slice_spec = function(arr, slice_spec, indicator)
      return transf.array_of_arrays.array_by_flatten(
        get.array.array_of_arrays_by_slice_and_removed_indicator_w_slice_spec(arr, slice_spec, indicator)
      )
    end,
    pos_int_or_nil_by_first_match_w_t = pltablex.find,
    pos_int_or_nil_by_last_match_w_t = pltablex.rfind,
    pos_int_or_nil_by_first_match_w_t_array = function(arr, t_arr)
      return get.array.pos_int_or_nil_by_first_match_w_fn(arr, function(t)
        return get.array.bool_by_first_match_w_t(t_arr, t)
      end)
    end,
    pos_int_or_nil_by_first_match_w_fn = hs.fnutils.find,
    t_or_nil_by_first_match_w_fn = function(arr, fn)
      local index = get.array.pos_int_or_nil_by_first_match_w_fn(arr, fn)
      if index then
        return arr[index]
      else
        return nil
      end
    end,
    bool_by_first_match_w_t = function(arr, t)
      return get.array.pos_int_or_nil_by_first_match_w_t(arr, t) ~= nil
    end,
    bool_by_last_match_w_t = function(arr, t)
      return get.array.pos_int_or_nil_by_last_match_w_t(arr, t) ~= nil
    end,
    bool_by_first_match_w_fn = function(arr, fn)
      return get.array.pos_int_or_nil_by_first_match_w_fn(arr, fn) ~= nil
    end,
    array_by_filtered = hs.fnutils.ifilter,
    pos_int_by_last_match_w_fn = function(arr, fn)
      local rev = transf.array.array_by_reversed(arr)
      local index = get.array.pos_int_or_nil_by_first_match_w_fn(rev, fn)
      if index then
        return #arr - index + 1
      else
        return nil
      end
    end,
    two_arrays_by_filtered_nonfiltered = function(arr, fn)
      local passes = {}
      local fails = {}
      for _, v in transf.array.key_value_stateless_iter(arr) do
        if fn(v) then
          dothis.array.push(passes, v)
        else
          dothis.array.push(fails, v)
        end
      end
      return passes, fails
    end,
    string_by_joined = function(arr, joiner)
      return get.string_or_number_array.string_by_joined(
        transf.array.string_array(arr),
        joiner
      )
    end,
    string_by_joined_any_pair = function(arr, joiner)
      local any = dothis.array.pop(arr)
      local str = get.string_or_number_array.string_by_joined(arr, joiner)
      return { str, any }
    end,
    bool_by_some_pass_w_fn = function(arr, fn)
      return get.array.bool_by_first_match_w_fn(arr, fn)
    end,
    bool_by_none_pass_w_fn = function(arr, cond)
      return not get.array.bool_by_some_pass_w_fn(arr, cond)
    end,
    bool_by_all_pass_w_fn = function(arr, cond)
      return get.array.bool_by_none_pass_w_fn(arr, function(x) return not cond(x) end)
    end,
    bool_by_some_pass_w_t = function(arr, t)
      return get.array.some_pass_w_fn(arr, function(x) return x == t end)
    end,
    bool_by_none_pass_w_t = function(arr, t)
      return get.array.none_pass_w_fn(arr, function(x) return x == t end)
    end,
    bool_by_all_pass_w_t = function(arr, t)
      return get.array.all_pass_w_fn(arr, function(x) return x == t end)
    end,
    array_by_head = function(arr, n)
      return get.array.array_by_slice_w_3_pos_int_any_or_nils(arr, 1, n or 10)
    end,
    array_by_tail = function(arr, n)
      return get.array.array_by_slice_w_3_pos_int_any_or_nils(arr, -(n or 10))
    end,
    any_w_index = function(arr, n)
      return arr[n]
    end,
    any_by_next_w_index = function(arr, n)
      return arr[n + 1]
    end,
    any_by_next_wrapping_w_index = function(arr, n)
      return arr[(n % #arr) + 1]
    end,
    next_by_item = function(arr, item)
      local index = get.array.pos_int_or_nil_by_first_match_w_t(arr, item)
      return get.array.any_by_next_w_index(arr, index)
    end,
    next_by_item_wrapping = function(arr, item)
      local index = get.array.pos_int_or_nil_by_first_match_w_t(arr, item)
      return get.array.any_by_next_wrapping_w_index(arr, index)
    end,
    t_by_next_w_fn = function(arr, fn)
      local index = get.array.pos_int_or_nil_by_first_match_w_fn(arr, fn)
      return get.array.any_by_next_w_index(arr, index)
    end,
    next_by_fn_wrapping = function(arr, fn)
      local index = get.array.pos_int_or_nil_by_first_match_w_fn(arr, fn)
      return get.array.any_by_next_wrapping_w_index(arr, index)
    end,
    previous = function(arr, n)
      return arr[n - 1]
    end,
    previous_wrapping = function(arr, n)
      return arr[(n - 2) % #arr + 1]
    end,
    array_by_sorted = function(list, comp)
      local new_list = get.table.table_by_copy(list, false)
      table.sort(new_list, comp)
      return new_list
    end,
    t_by_min = function(list, comp)
      return get.array.array_by_sorted(list, comp)[1]
    end,
    t_by_max = function(list, comp)
      return get.array.array_by_sorted(list, comp)[#list]
    end,
    revsorted = function(arr, comp)
      return transf.array.array_by_reversed(get.array.array_by_sorted(arr, comp))
    end,
    --- @generic T
    --- @param list T[]
    --- @param comp? fun(a: T, b: T):boolean
    --- @param if_even? "lower" | "higher" | "average" | "both"
    --- @return T
    median = function (list, comp, if_even)
      if_even = if_even or "lower"
      list = get.table.table_by_copy(list, false) -- don't modify the original list
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
    bool_by_contains = function(arr, v)
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
    raw_item_chooser_item_specifier_array = function(arr)
      return hs.fnutils.imap(
        arr,
        transf.any.item_chooser_item_specifier
      )
    end,
    item_chooser_item_specifier_array = function(arr, target_item_chooser_item_specifier_name)
      if target_item_chooser_item_specifier_name then
        return hs.fnutils.imap(
          get.array.raw_item_chooser_item_specifier_array(arr),
          transf.item_chooser_item_specifier[target_item_chooser_item_specifier_name .. "_item_chooser_item_specifier"]
        )
      else
        return get.array.raw_item_chooser_item_specifier_array(arr)
      end
    end,
    item_with_index_chooser_item_specifier_array = function(arr, target_item_chooser_item_specifier_name)
      return transf.assoc_arr_array.assoc_arr_with_index_as_key_array(
        get.array.item_chooser_item_specifier_array(arr, target_item_chooser_item_specifier_name)
      )
    end,
    hschooser_specifier = function(arr, target_item_chooser_item_specifier_name)
      return {
        chooser_item_specifier_array = get.array.item_with_index_chooser_item_specifier_array(arr, target_item_chooser_item_specifier_name),
        placeholder_text = transf.array.summary(arr),
        initial_selected_index = transf.array.initial_selected_index(arr),
      }
    end,
    choosing_hschooser_specifier = function(arr, target_item_chooser_item_specifier_name)
      return get.hschooser_specifier.choosing_hschooser_specifier(transf.array.hschooser_specifier(arr, target_item_chooser_item_specifier_name), "index", arr)
    end,
    array_by_mapped_w_t_arg_t_ret_fn = hs.fnutils.imap,
    array_by_mapped_w_pos_int_t_arg_t_ret_fn = function(arr, fn)
      local res = {}
      for i, v in transf.array.key_value_stateless_iter(arr) do
        dothis.array.push(res, fn(i, v))
      end
    end,
    array_by_mapped_w_t_key_dict = function(arr, dict)
      return get.array.array_by_mapped_w_t_arg_t_ret_fn(
        arr,
        function(v) return dict[v] end
      )
    end,
    string_array_by_mapped_values_w_fmt_string = function(arr, fmt_str)
      return get.array.array_by_mapped_w_t_arg_t_ret_fn(
        arr,
        get.fn.first_n_args_bound_fn(eutf8.format, fmt_str)
      )
    end,
    array_by_mapped_w_t_arg_t_ret_fn_and_t_arg_bool_ret_fn = function(arr, mapfn, condfn)
      return get.array.array_by_mapped_w_t_arg_t_ret_fn(
        arr,
        function(v)
          if condfn(v) then
            return mapfn(v)
          else 
            return v
          end
        end)
    end,
    
  },
  id_assoc_arr_array = {
    id_assoc_arr_by_first_match_w_id_assoc_arr = function(arr, assoc_arr)
      return get.array.t_or_nil_by_first_match_w_fn(
        arr,
        get.fn.first_n_args_bound_fn(
          transf.two_id_assoc_arrs.bool_by_equal,
          assoc_arr
        )
      )
    end
  },
  string = {
    string_array_split_single_char = stringy.split,
    string_array_split_single_char_noempty = function(str, sep)
      return transf.string_array.noemtpy_string_array(
        transf.string.string_array_split_single_char(str, sep)
      )
    end,
    string_array_split_single_char_stripped = function(str, sep)
      return transf.string_array.stripped_string_array(
        transf.string.split_single_char(str, sep)
      )
    end,
    string_array_split = plstringx.split,
    string_array_split_noempty = function(str, sep)
      return transf.string_array.noemtpy_string_array(
        transf.string.string_array_split(str, sep)
      )
    end,
    --- don't split on the edge of the string, i.e. don't return empty strings at the start or end
    string_array_split_noedge = function(str, sep)
      local res = transf.string.string_array_split(str, sep)
      if res[1] == "" then
        dothis.array.shift(res)
      end
      if res[#res] == "" then
        dothis.array.pop(res)
      end
      return res
    end,
    n_strings_split = function(str, sep, n)
      return transf.array.n_anys(get.string.string_array_split(str, sep, n))
    end,
    string_pair_split_or_nil = function(str, sep)
      local arr = get.string.string_array_split(str, sep, 2)
      if #arr ~= 2 then
        return nil
      else
        return arr
      end
    end,
    two_strings_split_or_nil = function(str, sep)
      local arr = get.string.string_array_split(str, sep, 2)
      if #arr ~= 2 then
        return nil
      else
        return arr[1], arr[2]
      end
    end,
    lines_tail = function(path, n)
      return get.array.array_by_slice_w_3_pos_int_any_or_nils(transf.string.lines(path), -(n or 10))
    end,
    lines_head = function(path, n)
      return get.array.array_by_slice_w_3_pos_int_any_or_nils(transf.string.lines(path), 1, n or 10)
    end,
    content_lines_tail = function(path, n)
      return get.array.array_by_slice_w_3_pos_int_any_or_nils(transf.string.noempty_line_string_array(path), -(n or 10))
    end,
    content_lines_head = function(path, n)
      return get.array.array_by_slice_w_3_pos_int_any_or_nils(transf.string.noempty_line_string_array(path), 1, n or 10)
    end,
    bool_startswith = stringy.startswith,
    bool_endswith = stringy.endswith,
    bool_not_startswith = function(str, prefix)
      return not transf.string.bool_startswith(str, prefix)
    end,
    bool_not_endswith = function(str, suffix)
      return not transf.string.bool_endswith(str, suffix)
    end,
    split2d = function(str, upper_sep, lower_sep)
      local upper = transf.string.split(str, upper_sep)
      return hs.fnutils.imap(upper, function(v)
        return transf.string.split(v, lower_sep)
      end)
    end,
    search_engine_search_url = function(str, search_engine)
      return tblmap.search_engine.url[search_engine]:format(
        transf.string.urlencoded_search(str, tblmap.search_engine.param_is_path[search_engine])
      )
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
    string_by_no_prefix = function(str, prefix)
      if stringy.startswith(str, prefix) then
        return str:sub(#prefix + 1)
      else
        return str
      end
    end,
    string_by_no_suffix = function(str, suffix)
      if stringy.endswith(str, suffix) then
        return str:sub(1, #str - #suffix)
      else
        return str
      end
    end,
    string_by_with_prefix = function(str, prefix)
      if stringy.startswith(str, prefix) then
        return str
      else
        return prefix .. str
      end
    end,
    string_by_with_suffix = function(str, suffix)
      if stringy.endswith(str, suffix) then
        return str
      else
        return str .. suffix
      end
    end,
    string_by_no_adfix = function(str, adfix)
      return transf.string.string_by_no_prefix(
        transf.string.string_by_no_suffix(str, adfix),
        adfix
      )
    end,
    string_by_with_adfix = function(str, adfix)
      return transf.string.string_by_with_prefix(
        transf.string.string_by_with_suffix(str, adfix),
        adfix
      )
    end,
    string_by_continuous_collapsed_onig_w_regex_quantifiable = function(str, regex_quantifiable)
      return onig.gsub(
        str,
        "(" .. regex_quantifiable .. "){2,}", -- using {2,} instead of + saves us some performance, given a match of length 1 just gets replaced with itself. However, this is not available in eutf8, so we have to use + there
        "%1"
      )
    end,
    string_by_continuous_collapsed_eutf8_w_regex_quantifiable = function(str, regex_quantifiable)
      return eutf8.gsub(
        str,
        "(" .. regex_quantifiable .. ")+",
        "%1"
      )
    end,
    string_by_continuous_replaced_onig_w_regex_quantifiable = function(str, regex_quantifiable, replacement)
      return onig.gsub(
        str,
        regex_quantifiable .. "+",
        replacement
      )
    end,
    string_by_continuous_replaced_eutf8_w_regex_quantifiable = function(str, regex_quantifiable, replacement)
      return eutf8.gsub(
        str,
        regex_quantifiable .. "+",
        replacement
      )
    end,
    string_by_removed_onig_w_regex_quantifiable = function(str, regex_quantifiable)
      return onig.gsub(
        str,
        regex_quantifiable,
        ""
      )
    end,
    string_by_removed_eutf8_w_regex_quantifiable = function(str, regex_quantifiable)
      return eutf8.gsub(
        str,
        regex_quantifiable,
        ""
      )
    end,
    string_by_replaced_all_eutf8_w_regex_string_array = function(str, regex_string_array, replacement)
      local res = str
      for _, regex_string in transf.array.key_value_stateless_iter(regex_string_array) do
        res = eutf8.gsub(
          res,
          regex_string,
          replacement
        )
      end
    end,
    string_by_replaced_first_eutf8_w_regex_string_array = function(str, regex_string_array, replacement)
      for _, regex_string in transf.array.key_value_stateless_iter(regex_string_array) do
        local res, matches = eutf8.gsub(
          str,
          regex_string,
          replacement,
          1
        )
        if matches > 0 then
          return res
        end
      end
    end,
    evaled_js_osa = function(str)
      local succ, parsed_res = hs.osascript.javascript(str)
      if succ then
        return parsed_res
      else
        return nil
      end
    end,
    evaled_as_osa = function(str)
      local succ, parsed_res = hs.osascript.applescript(str)
      if succ then
        return parsed_res
      else
        return nil
      end
    end,
    evaled_as_lua = function(str, d)
      if d then -- add d to global namespace so that it can be accessed in the string
        _G.d = d
      end
      local luaExecutable = load("return " .. str, "chunk", "t", _G)
      if luaExecutable ~= nil then -- expression
        return luaExecutable()
      else
        local luaExecutable = load(str, "chunk", "t", _G)
        if luaExecutable ~= nil then -- statement, must return within the statement itself
          return luaExecutable()
        else
          error("Neither a valid expression nor a valid statement.")
        end
      end
    end,
    evaled_as_template = function(str, d)
      local res = eutf8.gsub(str, "{{%[(.-)%]}}", function(item)
        return get.string.evaled_as_template(item, d)
      end)
      return res
    end,
    llm_response_string_freeform = function(str, temperature, max_tokens)
      return get.role_content_message_spec_array.llm_response_string(
        {{
          content = str,
          role = "user"
        }},
        temperature,
        max_tokens
      )
    end,
    llm_response_string_stringent = function(str, temperature, max_tokens)
      return get.role_content_message_spec_array.llm_response_string(
        transf.role_content_message_spec_array.api_role_content_message_spec_array({{
          content = str,
          role = "user"
        }}),
        temperature,
        max_tokens
      )
    end,
    string_by_prompted_once_from_default = function(str, message)
      return transf.prompt_spec.any({
        prompter = transf.prompt_args_string.string_or_nil_and_boolean,
        prompt_args = {
          message = message,
          default = str,
        }
      })
    end,
    alphanum_minus_underscore_string_by_prompted_once_from_default = function(str, message)
      return transf.prompt_spec.any({
        prompter = transf.prompt_args_string.string_or_nil_and_boolean,
        transformed_validator = is.string.alphanum_minus_underscore,
        prompt_args = {
          message = message,
          default = str,
        }
      })
    end,
    string_array_groups_ascii_fron_start = function(str, n)
      local res = {}
      for i = 1, #str, n do
        dothis.array.push(res, str:sub(i, i + n - 1))
      end
      return res
    end,
    string_with_separator_grouped_ascii_from_start = function(str, n, sep)
      return get.string_or_number_array.string_by_joined(get.string.string_array_groups_ascii_fron_start(str, n), sep)
    end,
    string_array_groups_ascii_from_end = function(str, n)
      local res = {}
      for i = #str, 1, -n do
        dothis.array.push(res, str:sub(i - n + 1, i))
      end
      return res
    end,
    string_with_separator_grouped_ascii_from_end = function(str, n, sep)
      return get.string_or_number_array.string_by_joined(get.string.string_array_groups_ascii_from_end(str, n), sep)
    end,
    string_array_groups_utf8_from_start = function(str, n)
      local res = {}
      for i = 1, eutf8.len(str), n do
        dothis.array.push(res, eutf8.sub(str, i, i + n - 1))
      end
      return res
    end,
    string_with_separator_grouped_utf8_from_start = function(str, n, sep)
      return get.string_or_number_array.string_by_joined(get.string.string_array_groups_utf8_from_start(str, n), sep)
    end,
    string_array_groups_utf8_from_end = function(str, n)
      local res = {}
      for i = eutf8.len(str), 1, -n do
        dothis.array.push(res, eutf8.sub(str, i - n + 1, i))
      end
      return res
    end,
    string_with_separator_grouped_utf8_from_end = function(str, n, sep)
      return get.string_or_number_array.string_by_joined(get.string.string_array_groups_utf8_from_end(str, n), sep)
    end,
    number_or_nil = function(str,  base)
      local nonindicated_number_string = transf.string.nonindicated_number_string(str)
      return get.nonindicated_number_string.number_or_nil(nonindicated_number_string, base)
    end,
    int_by_rounded_or_nil = function(str, base)
      local nonindicated_number_string = transf.string.nonindicated_number_string(str)
      return get.nonindicated_number_string.int_by_rounded_or_nil(nonindicated_number_string, base)
    end,
    two_integer_or_nils_by_onig_regex_match = onig.find,
    two_integer_or_nils_by_eutf8_regex_match = eutf8.find,
    string_array_by_onig_regex_match = function(str, regex)
      local res = {}
      for match in onig.gmatch(str, regex) do
        dothis.array.push(res, match)
      end
      return res
    end,
    two_string_arrays_by_onig_regex_match_nomatch = function(str, regex)
      local matches = {}
      local nomatches = {}
      local prev_index = 1
      while true do
        local start, stop = get.string.two_integer_or_nils_by_onig_regex_match(str, regex, prev_index)
        if start == nil then
          if prev_index <= #str then
            dothis.array.push(nomatches, str:sub(prev_index))
          end          
          return matches, nomatches
        else
          dothis.array.push(matches, str:sub(start, stop))
          if start > prev_index then
            dothis.array.push(nomatches, str:sub(prev_index, start - 1))
          end
          prev_index = stop + 1
        end
      end
    end,
    string_array_by_eutf8_regex_match = function(str, regex)
      local res = {}
      for match in eutf8.gmatch(str, regex) do
        dothis.array.push(res, match)
      end
      return res
    end,
    two_string_arrays_by_eutf8_regex_match_nomatch = function(str, regex)
      local matches = {}
      local nomatches = {}
      local prev_index = 1
      while true do
        local start, stop = get.string.two_integer_or_nils_by_eutf8_regex_match(str, regex, prev_index)
        if start == nil then
          if prev_index <= eutf8.len(str) then
            dothis.array.push(nomatches, eutf8.sub(str, prev_index))
          end          
          return matches, nomatches
        else
          dothis.array.push(matches, eutf8.sub(str, start, stop))
          if start > prev_index then
            dothis.array.push(nomatches, eutf8.sub(str, prev_index, start - 1))
          end
          prev_index = stop + 1
        end
      end
    end,
    string_by_shortened_start_ellipsis = function(str, len)
      return plstringx.shorten(str, len)
    end,
    string_by_shortened_end_ellipsis = function(str, len)
      return plstringx.shorten(str, len, true)
    end,
    string_by_with_yaml_metadata = function(str, tbl)
      if not str then return transf.table.yaml_metadata(tbl) end
      if not tbl then return str end
      if transf.table.pos_int_by_num_keys(tbl) == 0 then return str end
      local stripped_str = stringy.strip(str)
      local final_metadata, final_contents
      if stringy.startswith(stripped_str, "---") then
        -- splice in the metadata
        local parts = get.string.string_array_split_noempty(str, "---") -- this should now have the existing metadata as [1], and the content as [2] ... [n]
        local extant_metadata = table.remove(parts, 1)
        final_metadata = extant_metadata .. "\n" .. transf.not_userdata_or_string.yaml_string(tbl)
        final_contents = get.string_or_number_array.string_by_joined(parts)
        final_contents = final_contents .. "---"
      else
        final_metadata = transf.not_userdata_or_string.yaml_string(tbl)
        final_contents = str
      end
      return "---\n" .. final_metadata .. "\n---\n" .. final_contents
    end,
    not_userdata_or_function_or_err_by_evaled_env_bash_parsed_json_in_key = function(str, key)
      local tbl = transf.string.table_or_err_by_evaled_env_bash_parsed_json(str)
      return get.table.vt_or_err(tbl, key)
    end,
    not_userdata_or_function_or_nil_by_evaled_env_bash_parsed_json_in_key = function(str, key)
      return transf.n_anys_or_err_ret_fn.n_anys_or_nil_ret_fn_by_pcall(
        get.string.not_userdata_or_function_or_err_by_evaled_env_bash_parsed_json_in_key
      )(str, key)
    end,
    string_or_err_by_evaled_env_bash_parsed_json_in_key = function(str, key)
      local tbl = transf.string.table_or_err_by_evaled_env_bash_parsed_json(str)
      local res = get.table.vt_or_err(tbl, key)
      if type(res) == "string" then
        return res
      else
        error("Not a string.")
      end
    end,
    string_or_nil_by_evaled_env_bash_parsed_json_in_key = function(str, key)
      return transf.n_anys_or_err_ret_fn.n_anys_or_nil_ret_fn_by_pcall(
        get.string.string_or_err_by_evaled_env_bash_parsed_json_in_key
      )(str, key)
    end,
    string_or_err_by_evaled_env_bash_parsed_json_in_key_stripped = function(str, key)
      return stringy.strip(get.string.string_or_err_by_evaled_env_bash_parsed_json_in_key(str, key))
    end,
    string_or_nil_by_evaled_env_bash_parsed_json_in_key_stripped = function(str, key)
      return transf.n_anys_or_err_ret_fn.n_anys_or_nil_ret_fn_by_pcall(
        get.string.string_or_err_by_evaled_env_bash_parsed_json_in_key_stripped
      )(str, key)
    end,

  },
  nonindicated_number_string_array = {
    number_array = function(arr, base)
      return hs.fnutils.imap(
        arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(
          get.nonindicated_number_string.number_or_nil,
          {a_use, base}
        )
      )
    end,
  },
  nonindicated_number_string = {
    number_or_nil = tonumber,
    int_by_rounded_or_nil = function(num, base)
      return transf.number.int_by_rounded(
        get.nonindicated_number_string.number_or_nil(num, base)
      )
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
      local text_string, style = get.array.two_arrays_by_slice_w_3_pos_int_any_or_nils(existing_style, 1, 1)
      local new_styledtext = hs.styledtext.new(text_string, styledtext_attributes_specifier)
      for _, v in transf.array.index_value_stateless_iter(style) do
        new_styledtext = new_styledtext:setStyle(v.styledtext_attributes_specifier, v.starts, v.ends)
      end
      return new_styledtext
    end,
    styledtext_with_slice_styled = function(styledtext, style, start, stop)
      start = start or 1
      stop = stop or #styledtext
      if style == "light" then
        style = { color = { red = 0, green = 0, blue = 0, alpha = 0.3 } }
      end
      return styledtext:copy():setStyle(style, start, stop)
    end,
  },
  string_or_styledtext_array = {
    styledtext_array_merge = function(arr, styledtext_attributes_specifier)
      return hs.fnutils.imap(
        arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.string_or_styledtext.styledtext_merge, {a_use, styledtext_attributes_specifier})
      )
    end,
  },
  string_or_number_array = {
    string_by_joined = table.concat,
  },
  string_array = {
    resplit_by_oldnew = function(arr, sep)
      return get.string.string_array_split(
        get.string_array.string_joined(
          arr,
          sep
        ),
        sep
      )
    end,
    resplit_by_new = function(arr, sep)
      return get.string.string_array_split(
        get.string_array.string_joined(
          arr,
          ""
        ),
        sep
      )
    end,
    resplit_by_oldnew_single_char = function(arr, sep)
      return get.string.string_array_split_single_char(
        get.string_array.string_joined(
          arr,
          sep
        ),
        sep
      )
    end,
    resplit_by_oldnew_single_char_noempty = function(arr, sep)
      return get.string.string_array_split_single_char_noempty(
        get.string_array.string_joined(
          arr,
          sep
        ),
        sep
      )
    end,
    resplit_by_new_single_char = function(arr, sep)
      return get.string.string_array_split_single_char(
        get.string_array.string_joined(
          arr,
          ""
        ),
        sep
      )
    end,
    pos_int_or_nil_by_first_match_nocomment_noindent_w_string = function(arr, str)
      return get.array.pos_int_or_nil_by_first_match_w_t(
        transf.string_array.nocomment_noindent_string_array(arr),
        str
      )
    end,
    pos_int_or_nil_by_first_match_ending_w_string = function(arr, str)
      return get.array.pos_int_or_nil_by_first_match_w_fn(
        arr,
        get.fn.first_n_args_bound_fn(
          get.string.bool_endswith,
          str
        )
      )
    end,
    string_or_nil_by_first_match_ending_w_string = function(arr, str)
      return arr[
        get.array.pos_int_or_nil_by_first_match_ending_w_string(arr, str)
      ]
    end,
    pos_int_or_nil_by_first_match_starting_w_string = function(arr, str)
      return get.array.pos_int_or_nil_by_first_match_w_fn(
        arr,
        get.fn.first_n_args_bound_fn(
          get.string.bool_startswith,
          str
        )
      )
    end,
    string_or_nil_by_first_match_starting_w_string = function(arr, str)
      return arr[
        get.array.pos_int_or_nil_by_first_match_starting_w_string(arr, str)
      ]
    end,

  },
  array_of_string_arrays = {
    array_of_string_records = function(arr, field_sep)
      return hs.fnutils.imap(arr, function(x) return get.string_or_number_array.string_by_joined(x, field_sep) end)
    end,
    string_table = function(arr, field_sep, record_sep)
      return get.string_or_number_array.string_by_joined(get.array_of_string_arrays.array_of_string_records(arr, field_sep), record_sep)
    end,
    
  },
  array_of_tables = {
    array_of_vts_w_kt = function(arr, kt)
      return hs.fnutils.imap(arr, function(x) return x[kt] end)
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
      local extension = transf.path.normalized_extension(path)
      if get.array.contains(mt._list.filetype[filetype], extension) then
        return true
      else
        return false
      end
    end,
    with_different_extension = function(path, ext)
      return transf.path.path_without_extension(path) .. "." .. ext
    end,
    leaf_starts_with = function(path, str)
      return stringy.startswith(transf.path.leaf(path), str)
    end,
    is_extension = function(path, ext)
      return transf.path.extension(path) == ext
    end,
    is_standartized_extension = function(path, ext)
      return transf.path.normalized_extension(path) == ext
    end,
    is_extension_in = function(path, exts)
      return get.array.bool_by_contains(exts, transf.path.extension(path))
    end,
    is_standartized_extension_in = function(path, exts)
      return get.array.bool_by_contains(exts, transf.path.normalized_extension(path))
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
    path_component_array_by_slice_w_slice_spec = function(path, spec)
      local path_component_array = transf.path.path_component_array(path)
      return get.array.array_by_slice_w_slice_spec(path_component_array, spec)
    end,
    path_segment_array_by_slice_w_slice_spec = function(path, spec)
      local path_segment_array = transf.path.path_segment_array(path)
      return get.array.array_by_slice_w_slice_spec(path_segment_array, spec)
    end,
    path_from_sliced_path_component_array = function(path, spec)
      local sliced_path_component_array = transf.path.sliced_path_component_array(path, spec)
      dothis.array.push(sliced_path_component_array, "")
      return get.string_or_number_array.string_by_joined(sliced_path_component_array, "/")
    end,
    path_from_sliced_path_segment_array = function(path, spec)
      local sliced_path_segment_array = transf.path.sliced_path_segment_array(path, spec)
      dothis.array.push(sliced_path_segment_array, "")
      local extension = dothis.array.pop(sliced_path_segment_array)
      local filename = dothis.array.pop(sliced_path_segment_array)
      local leaf
      if extension == "" then
        leaf = filename
      else
        leaf = filename .. "." .. extension
      end
      if #sliced_path_segment_array == 0 then
        return leaf
      else
        return get.string_or_number_array.string_by_joined(sliced_path_segment_array, "/") .. "/" .. leaf
      end
    end,
    path_array_from_sliced_path_component_array = function(path, spec)
      local sliced_path_component_array = transf.path.sliced_path_component_array(path, spec)
      local whole_path_component_array = transf.path.path_component_array(path)
      local res = {}
      local started_with_slash = stringy.startswith(path, "/")
      
      -- Create a map for quick lookup of the index of each path component
      local path_component_index_map = {}
      for rawi, rawv in transf.array.index_value_stateless_iter(whole_path_component_array) do
        path_component_index_map[rawv] = rawi
      end
      
      for i, v in transf.array.index_value_stateless_iter(sliced_path_component_array) do
        -- Use the map to find the index of the current path component
        local rawi = path_component_index_map[v]
        if rawi then
          local relevant_path_components = get.array.array_by_slice_w_slice_spec(whole_path_component_array, { start = 1, stop = rawi })
          if started_with_slash then
            table.insert(relevant_path_components, 1, "") -- if we started with a slash, we need to reinsert an empty string at the beginning so that it will start with a slash again once we rejoin
          end
          res[i] = get.string_or_number_array.string_by_joined(relevant_path_components, "/")
        end
      end
      
      return res
    end
  },
  absolute_path = {
    relative_path_from = function(path, starting_point)
      return get.string.string_by_no_prefix(path, get.string.string_by_with_suffix(starting_point, "/"))
    end,
  },
  extant_path = {
    --- @class itemsInPathOpts
    --- @field recursion? boolean | integer Whether to recurse into subdirectories, and how much. Default false (no recursion)
    --- @field include_dirs? boolean Whether to include directories in the returned table. Default true
    --- @field include_files? boolean Whether to include files in the returned table. Default true
    --- @field follow_links? boolean Whether to follow symlinks. Default false

    --- @param path string
    --- @param opts? itemsInPathOpts
    --- @param is_recursive_call? boolean Whether this is a recursive call. Allows us to avoid some duplicate work.
    --- @param depth? integer Internal use only. The current depth of recursion.  
    --- @param seen_paths? string[] Internal use only. A table of paths we have already seen. Used to avoid infinite recursion
    --- @return string[] #A table of all things in the directory
    absolute_path_array = function(path, opts, is_recursive_call, depth, seen_paths)
      if is.absolute_path.file(path) then 
        if not opts or opts.include_files then
          return {path}
        else
          return {}
        end
      end
    
      local extant_paths = {}
      if not is_recursive_call then 
        if opts == nil then
          opts = {}
        end
        opts.recursion = get.any.default_if_nil(opts.recursion, false)
        opts.include_dirs = get.any.default_if_nil(opts.include_dirs, true)
        opts.include_files = get.any.default_if_nil(opts.include_files, true)
        opts.follow_links = get.any.default_if_nil(opts.follow_links, false)
      end
    
      path = transf.path.ending_with_slash(path)
    
      if opts.follow_links then
        seen_paths = seen_paths or {}
        local links_resolved_path = hs.fs.pathToAbsolute(path)
        if get.array.bool_by_contains(seen_paths, links_resolved_path) then
          return {}
        else
          dothis.array.push(seen_paths, links_resolved_path)
        end
      end
    
      for file_name in transf.dir.children_absolute_path_value_stateful_iter(path) do
        if file_name ~= "." and file_name ~= ".." and file_name ~= ".DS_Store" then
          local file_path = path .. get.string.string_by_no_suffix(file_name, "/")
          if is.extant_path.dir(file_name) then 
            if opts.include_dirs then
              extant_paths[#extant_paths + 1] = file_path
            end
            local shouldRecurse = opts.recursion
            if type(opts.recursion) == "number" then
              if depth and depth >= opts.recursion then
                shouldRecurse = false
              end
            end
            if 
              not opts.follow_links
              and hs.fs.symlinkAttributes(file_path, "mode") == "link" 
            then
              shouldRecurse = false
            end
              
            if shouldRecurse then
              depth = depth or 0
              local sub_files = get.extant_path.absolute_path_array(file_path, opts, true, depth + 1, seen_paths)
              for _, sub_file in transf.array.index_value_stateless_iter(sub_files) do
                extant_paths[#extant_paths + 1] = sub_file
              end
            end
          else
            if opts.include_files then
              extant_paths[#extant_paths + 1] = file_path
            end
          end
        end
      end
    
      return extant_paths
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
    extant_path_by_self_or_ancestor_siblings_w_fn = function(path, fn)
      return get.extant_path.find_self_or_ancestor(path, function(x)
        return hs.fnutils.find(transf.dir.children_absolute_path_array(transf.path.parent_path(x)), fn)
      end)
    end,
    extant_path_by_self_or_ancestor_sibling_w_leaf = function(path, leaf)
      return get.extant_path.extant_path_by_self_or_ancestor_siblings_w_fn(path, function(x)
        return transf.path.leaf(x) == leaf
      end)
    end,
    cmd_output_from_path = function(path, cmd)
      if is.path.dir(path) then
        return get.dir.cmd_output_from_path(path, cmd)
      else
        return get.dir.cmd_output_from_path(transf.path.parent_path(path), cmd)
      end
    end,
    extant_path_by_descendant_w_fn = function(dir, cond)
      return hs.fnutils.find(transf.extant_path.descendants_absolute_path_array(dir), cond)
    end,
    find_descendant_ending_with = function(dir, ending)
      return get.path_array.find_ending_with(transf.extant_path.descendants_absolute_path_array(dir), ending)
    end,
    find_leaf_of_descendant = function(dir, filename)
      return get.path_array.find_leaf(transf.extant_path.descendants_absolute_path_array(dir), filename)
    end,
    find_extension_of_descendant = function(dir, extension)
      return get.path_array.find_extension(transf.extant_path.descendants_absolute_path_array(dir), extension)
    end,
    find_descendant_with_leaf = function(dir, leaf)
      return get.path_array.find_path_with_leaf(transf.extant_path.descendants_absolute_path_array(dir), leaf)
    end,
    find_descendant_with_extension = function(dir, extension)
      return get.path_array.find_path_with_extension(transf.extant_path.descendants_absolute_path_array(dir), extension)
    end,
    find_descendant_with_leaf_ending = function(dir, leaf_ending)
      return get.path_array.find_path_with_leaf_ending(transf.extant_path.descendants_absolute_path_array(dir), leaf_ending)
    end,
    find_descendant_with_filename = function(dir, filename)
      return get.path_array.find_path_with_filename(transf.extant_path.descendants_absolute_path_array(dir), filename)
    end,
  },
  local_extant_path = {
    attr = function(path, attr)
      return hs.fs.attributes(hs.fs.pathToAbsolute(path, true))[attr]
    end,
    prompted_once_local_absolute_path_from_default = function(path, message)
      return transf.prompt_spec.any({
        prompter = transf.prompt_args_path.local_absolute_path_and_boolean,
        prompt_args = {default = path, message = message or "Choose an absolute path..."}
      })
    end,
    prompted_multiple_local_absolute_path_from_default = function(path, message)
      local intermediate_path = get.local_extant_path.prompted_once_local_absolute_path_from_default(path, message)
      return transf.local_absolute_path.prompted_multiple_local_absolute_path_from_default(intermediate_path)
    end,
    prompted_once_dir_from_default = function(path, message)
      return transf.prompt_spec.any({
        prompter = transf.prompt_args_path.local_absolute_path_and_boolean,
        prompt_args = {
          default = path,
          can_choose_files = false,
          message = message or "Choose a directory..."
        }
      })
    end,
    prompted_once_local_absolute_path_array_from_default = function(path, message)
      return transf.prompt_spec.any({
        prompter = transf.prompt_args_path.local_absolute_path_array_and_boolean,
        prompt_args = {default = path, message = message or "Choose absolute paths..."}
      })
    end,
  },
  dir = {
    extant_path_by_child_w_fn = function(dir, fn)
      return hs.fnutils.find(transf.dir.children_absolute_path_array(dir), fn)
    end,
    find_child_ending_with = function(dir, ending)
      return get.path_array.find_ending_with(transf.dir.children_absolute_path_array(dir), ending)
    end,
    find_leaf_of_child = function(dir, filename)
      return get.path_array.find_leaf(transf.dir.children_absolute_path_array(dir), filename)
    end,
    find_extension_of_child = function(dir, extension)
      return get.path_array.find_extension(transf.dir.children_absolute_path_array(dir), extension)
    end,
    find_child_with_leaf = function(dir, leaf)
      return get.path_array.find_path_with_leaf(transf.dir.children_absolute_path_array(dir), leaf)
    end,
    find_child_with_extension = function(dir, extension)
      return get.path_array.find_path_with_extension(transf.dir.children_absolute_path_array(dir), extension)
    end,
    find_child_with_leaf_ending = function(dir, leaf_ending)
      return get.path_array.find_path_with_leaf_ending(transf.dir.children_absolute_path_array(dir), leaf_ending)
    end,
    cmd_output_from_path = function(path, cmd)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("cd " .. transf.string.single_quoted_escaped(path) .. " && " .. cmd)
    end
  },
  git_root_dir = {
    hook_path = function(path, hook)
      return transf.git_root_dir.hooks_dir(path) .. "/" .. hook
    end,
    hook_res = function(path, hook)
      local hook_path = get.git_root_dir.hook_path(path, hook)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(hook_path)
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
  file = {
  },
  plaintext_file = {
    lines_tail = function(path, n)
      return get.string.lines_tail(transf.plaintext_file.contents(path), n)
    end,
    lines_head = function(path, n)
      return get.string.lines_head(transf.plaintext_file.contents(path), n)
    end,
    nth_line = function(path, n)
      return transf.plaintext_file.line_array(path)[n]
    end,
    contents_lines_appended = function(path, lines)
      local extlines = transf.plaintext_file.line_array(path)
      return transf.two_arrays.array_by_appended(extlines, lines)
    end,
    contents_line_appended = function(path, line)
      return dothis.plaintext_file.contents_lines_appended(path, {line})
    end,
    contents_lines_appended_to_string = function(path, lines)
      return get.string_or_number_array.string_by_joined(dothis.plaintext_file.contents_lines_appended(path, lines), "\n")
    end,
    contents_line_appended_to_string = function(path, line)
      return dothis.plaintext_file.content_lines_appended_to_string(path, {line})
    end,
  },
  plaintext_table_file = {
    dict_of_dicts_by_first_element_and_array = function(plaintext_file, arr2)
      local array_of_arrays = transf.plaintext_table_file.array_of_array_of_fields(plaintext_file)
      return get.array_of_arrays.dict_of_dicts_by_first_element_and_array(array_of_arrays, arr2)
    end,
    dict_of_dicts_by_header_file = function(plaintext_file, header_file)
      local array_of_arrays = transf.plaintext_table_file.array_of_array_of_fields(plaintext_file)
      return get.array_of_arrays.dict_of_dicts_by_header_file(array_of_arrays, transf.plaintext_file.line_array(header_file))
    end,
  },
  timestamp_first_column_plaintext_table_file = {
    something_newer_than_timestamp = function(path, timestamp, assoc_arr)
      local rows = transf.plaintext_table_file.iter_of_array_of_fields(path)
      local _, first_row = rows()
      local _, second_row = rows()
      if not first_row then return nil end
      if not second_row then second_row = {"0"} end
      local first_timestamp, second_timestamp = get.string_or_number.number_or_nil(first_row[1]), get.string_or_number.number_or_nil(second_row[1])
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
        if get.string_or_number.number_or_nil(current_timestamp) > timestamp then
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
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(
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
      return transf.string.table_or_err_by_evaled_env_bash_parsed_json("shellcheck --format=json --severity=" .. severity .. transf.string.single_quoted_escaped(path))
    end,
    lint_gcc_string = function(path, severity)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("shellcheck --format=gcc --severity=" .. severity .. transf.string.single_quoted_escaped(path))
    end,
  },
  email_file = {
    with_body_quoted = function(path, response)
      return response .. "\n\n" .. transf.email_file.quoted_body(path)
    end,
    prefixed_header = function(path, header)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(
        "mshow -qh" .. transf.string.single_quoted_escaped(header) .. transf.string.single_quoted_escaped(path)
      )
    end,
    header = function(path, header)
      local prefixed_header = transf.email_file.prefixed_header(path, header)
      return eutf8.sub(prefixed_header, #header + 2) -- +2 for the colon and the space
    end,
    addresses = function(path, header, only)
      if not get.array.bool_by_contains(mt._list.email_headers_containin_emails, header) then
        error("Header can't contain email addresses")
      end
      only = get.any.default_if_nil(only, true)
      local headerpart
      if header then
        headerpart = "-h" .. transf.string.single_quoted_escaped(header)
      else
        headerpart = ""
      end
      local res = transf.string.string_or_nil_by_evaled_env_bash_stripped("maddr " .. (only and "-a" or "")  .. headerpart .. transf.string.single_quoted_escaped(path))
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

      return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped(cmd))
    end

  },
  alphanum_minus_underscore = {
    
  },
  email_specifier = {
    
  },
  logging_dir = {
    log_path_for_date = function(path, date)
      return hs.fs.pathToAbsolute(path) .. "/" .. transf.date.y_ym_ymd_path(date) .. ".csv"
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
      return get.string.string_or_nil_by_first_match_ending_w_string(path_array, ending)
    end,
    find_leaf = function(path_array, leaf)
      return get.array.bool_by_contains(transf.path_array.leaves_array(path_array), leaf)
    end,
    find_extension = function(path_array, extension)
      return get.array.bool_by_contains(transf.path_array.extensions_array(path_array), extension)
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
    find_path_with_filename = function(path_array, filename)
      return hs.fnutils.find(path_array, function(path)
        return get.path.filename(path) == filename
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
      return get.array.any_by_next_w_index(mt._list.date.date_component_names, transf.date_component_name.date_component_index(component) + n)
    end,
    previous = function(component, n)
      n = n or 0
      return get.array.previous(mt._list.date.date_component_names, transf.date_component_name.date_component_index(component) - n)
    end,
  },
  date = {
    with_date_component_value_added = function(date, date_component_value, date_component_name)
      local dtcp = date:copy()
      return dtcp["add" .. tblmap.date_component_name.date_component_name_long[date_component_name] .. "s"](dtcp, date_component_value)
    end,
    with_date_component_value_subtracted = function(date, date_component_value, date_component_name)
      return get.date.with_date_component_value_added(date, -date_component_value, date_component_name)
    end,
    date_component_value = function(date, date_component_name)
      return date["get" .. tblmap.date_component_name.date_component_name_long[date_component_name]](date)
    end,
    surrounding_date_sequence_specifier = function(date, date_component_value, step, unit)
      return {
        start = get.date.with_date_component_value_subtracted(date, date_component_value, step),
        stop = get.date.with_date_component_value_added(date, date_component_value, step),
        step = step,
        unit = unit,
      }
    end,
    date_sequence_specifier_of_lower_component = function(date, step, date_component_name)
      return get.full_date_component_name_value_dict.date_sequence_specifier_of_lower_component(
        transf.date.full_date_component_name_value_dict(date),
        step,
        date_component_name
      )
    end,
    hours_date_sequence_specifier = function(date, date_component_value)
      return get.date.date_sequence_specifier_of_lower_component(date, date_component_value, "day")
    end,
    precision_date = function(date, date_component_name)
      return get.full_date_component_name_value_dict.precision_date(
        transf.date.full_date_component_name_value_dict(date),
        date_component_name
      )
    end,
    --- accepts both format strings and format names
    formatted_string = function(date, format)
      local retrieved_format = tblmap.date_format_name.date_format[format]
      return date:fmt(retrieved_format or format)
    end,
    rfc3339like_dt_of_precision = function(date, precision)
      return get.date.formatted_string(date, tblmap.date_component_name.rfc3339like_dt_format_string[precision])
    end,

  },
  timestamp_s = {
    formatted = function(timestamp_s, format)
      return get.date.formatted_string(
        transf.timestamp_s.date(timestamp_s),
        format
      )
    end,
  },
  timestamp_ms = {
    formatted = function(timestamp_s, format)
      return get.date.formatted_string(
        transf.timestamp_s.date(timestamp_s),
        format
      )
    end,
  },
  date_component_name_list = {
    date_component_value_list = function(date_component_name_list, date_component_name_value_dict)
      return get.array.array_by_mapped_w_t_key_dict(
        date_component_name_list,
        date_component_name_value_dict
      )
    end,
    date_component_value_ordered_list = function(date_component_name_list, date_component_name_value_dict)
      return get.array.array_by_mapped_w_t_key_dict(
        transf.date_component_name_array.date_component_name_ordered_array(date_component_name_list),
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
      specifier = transf.two_tables.table_nonrecursive(transf.date_interval_specifier.event_table(date_interval_specifier), specifier)
      return get.khal.list_event_tables(
        specifier,
        include,
        exclude
      )
    end,
  },
  full_date_component_name_value_dict = {
    prefix_partial_date_component_name_value_dict = function(full_date_component_name_value_dict, date_component_name)
      return get.array.array_by_mapped_w_t_key_dict(
        transf.date_component_name.date_component_name_value_dict_larger_or_same(date_component_name),
        full_date_component_name_value_dict
      )
    end,
    date_sequence_specifier_of_lower_component = function (full_date_component_name_value_dict, step, date_component_name, additional_steps_down)
      return get.date_component_name_value_dict.date_sequence_specifier(
        get.full_date_component_name_value_dict.prefix_partial_date_component_name_value_dict(full_date_component_name_value_dict, date_component_name),
        step,
        get.date_component_name.next(date_component_name, additional_steps_down)
      )      
    end,
    precision_full_date_component_name_value_dict = function(full_date_component_name_value_dict, date_component_name)
      return transf.full_date_component_name_value_dict.min_full_date_component_name_value_dict(
        get.full_date_component_name_value_dict.prefix_partial_date_component_name_value_dict(full_date_component_name_value_dict, date_component_name)
      )
    end,
    precision_date = function(full_date_component_name_value_dict, date_component_name)
      return date(get.full_date_component_name_value_dict.precision_full_date_component_name_value_dict(full_date_component_name_value_dict, date_component_name))
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
    column = plarray2d.column,
    row = plarray2d.row,
    array_of_arrays_by_mapped_if_not_length_0 = function(arr_of_arr, fn)
      return hs.fnutils.imap(
        arr_of_arr,
        function(arr)
          if #arr == 0 then
            return arr
          else
            return fn(arr)
          end
        end
      )
    end,
    string_by_joined_any_pair_array = function(arr, joiner)
      return hs.fnutils.imap(
        arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.n_string_or_number_any_array.string_by_joined_any_pair, {a_use, joiner})
      )
    end,
    string_by_joined_key_any_value_dict = function(arr, joiner)
      return transf.pair_array.dict(
        get.array_of_n_string_or_number_any_arrays.string_by_joined_any_pair_array(arr, joiner)
      )
    end,
    array_of_dicts_by_array = function(arr_of_arr, arr2)
      return hs.fnutils.imap(
        arr_of_arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(transf.two_arrays.dict_by_zip_stop_shortest, {arr2, a_use})
      )
    end,
    dict_of_arrays_by_first_element = function(arr_of_arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        arr_of_arr,
        transf.array.t_and_array_by_first_rest
      )
    end,
    dict_of_dicts_by_first_element_and_array = function(arr_of_arr, arr2)
      return get.dict_of_arrays.dict_of_dicts_by_array(
        get.array_of_arrays.dict_of_arrays_by_first_element(arr_of_arr),
        arr2
      )
    end,
    array_of_arrays_by_mapped = function(arr_of_arr, fn)
      return hs.fnutils.imap(
        arr_of_arr,
        get.fn.second_n_args_bound_fn(get.array.array_by_mapped, fn)
      )
    end,
    --- essentially flatMap
    array_by_mapped_w_vt_arg_vt_ret_fn_and_flatten = function(arr, fn)
      return transf.array.array_by_flatten(
        get.array.array_by_mapped_w_t_arg_t_ret_fn(arr, fn)
      )
    end,
  },
  dict_of_arrays = {
    dict_of_dicts_by_array = function(dict_of_arr, arr2)
      return hs.fnutils.map(
        dict_of_arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(transf.two_arrays.dict_by_zip_stop_shortest, {arr2, a_use})
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
      return get.string.evaled_js_osa( ("Application('%s').windows()[%d].%s()"):format(
        window_specifier.application_name,
        window_specifier.window_index,
        property
      ))
    end,
  },
  jxa_tab_specifier = {
    property = function(tab_specifier, property)
      return get.string.evaled_js_osa( ("Application('%s').windows()[%d].tabs()[%d].%s()"):format(
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
          value = get.string_or_number_array.string_by_joined(
            get.array.string_array_by_mapped_values_w_fmt_string(node.value,  prev_key .. "%s"), -- todo: currently refactoring and I'm not sure that node.value is an array, but I can't check rn. potentially needs replacing with a get.table call
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
      return transf.two_dict_or_nils.dict_by_take_new(self_dict, dependent_dict)
    end,
  },
  env_var_name_env_node_dict = {
    env_var_name_value_dict = function(dict, prev_key)
      if prev_key then prev_key = prev_key .. "/" else prev_key = "" end
      local values = {}
      for key, value in transf.table.key_value_stateless_iter(dict) do
        if type(value) == "string" then
          values[key] = prev_key .. value
        else
          local subvalues = get.detailed_env_node.env_var_name_value_dict(value, prev_key, key)
          values = transf.two_dict_or_nils.dict_by_take_new(values, subvalues)
        end
      end
      return values
    end,
  },
  url = {

  },
  html_string = {
    html_query_selector_all = function(str, selector)
      return get.fn.rt_or_nil_by_memoized(transf.string.string_or_nil_by_evaled_env_bash_stripped)(
        "htmlq" .. transf.string.single_quoted_escaped(selector) .. transf.string.here_string(str)
      )
    end,
    text_query_selector_all = function(str, selector)
      return get.fn.rt_or_nil_by_memoized(transf.string.string_or_nil_by_evaled_env_bash_stripped)(
        "htmlq --text" .. transf.string.single_quoted_escaped(selector) .. transf.string.here_string(str)
      )
    end,
    attribute_query_selector_all = function(str, selector, attribute)
      return get.fn.rt_or_nil_by_memoized(transf.string.string_or_nil_by_evaled_env_bash_stripped)(
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
  iso_3366_1_alpha_2_code = {
    --- don't use this for english, use transf.iso_3366_1_alpha_2.iso_3336_1_full_name instead
    full_name_in_language_string = function(code, language_identifier_string)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_string({
        query = "Get the short name of a country from its ISO 3366-1 alpha-2 code in the language '" .. language_identifier_string .. "'",
        input = code
      })
    end,
    --- don't use this for english, use transf.iso_3366_1_alpha_2.iso_3336_1_short_name instead
    short_name_in_language_string = function(code, language_identifier_string)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_string({
        query = "Get the short name of a country from its ISO 3366-1 alpha-2 code in the language '" .. language_identifier_string .. "'",
        input = code
      })
    end,
  },
  any = {
    join_if_array = function(arg, separator)
      if is.any.array(arg) then
        return get.string_or_number_array.string_by_joined(arg, separator)
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
      local_thing_name_hierarchy = local_thing_name_hierarchy or get.table.table_by_copy(thing_name_hierarchy, true)
      parent = parent or "any"
      local res = {}
      for thing_name, child_thing_name_hierarchy_or_leaf_indication_string in transf.table.key_value_stateless_iter(thing_name_hierarchy) do
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
      return is.any.table(any) and get.table.bool_by_has_key(any, key)
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
        get.fn.arbitrary_args_bound_or_ignored_fn(get.retriever_specifier.result, {a_use, value})
      )
    end,
    result_joined = function(arr, value)
      return get.string_or_number_array.string_by_joined(
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
    initial_selected_index = function(arr, value)
      return get.retriever_specifier_array.result_highest_precedence(
        transf.thing_name_array.initial_selected_retriever_specifier_array(arr),
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
      local res = get.table.table_by_copy(arr)
      for i, chooser_item_specifier in transf.array.index_value_stateless_iter(res) do
        local text_styledtext_attribute_specifier = transf.two_dict_or_nils.dict_by_take_new( {
          font = {size = 14 },
          color = { red = 0, green = 0, blue = 0, alpha = 0.7 },
        }, chooser_item_specifier_text_key_styledtext_attributes_specifier_dict.styledtext_attribute_specifier.text)
        local subtext_styledtext_attribute_specifier = transf.two_dict_or_nils.dict_by_take_new( {
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
      return get.string.not_userdata_or_function_or_nil_by_evaled_env_bash_parsed_json_in_key(
        "echo '" .. json.encode(request_table) .. "' | /opt/homebrew/bin/socat UNIX-CONNECT:" .. transf.ipc_socket_id.ipc_socket_path(ipc_socket_id) .. " STDIO",
        "data"
      )
    end
  },
  mpv_ipc_socket_id = {
    string = function(id, key)
      return get.ipc_socket_id.response_table_or_nil(id, {
        command = { "get_property", key }
      } )
    end,
    int = function(id, key)
      return get.string_or_number.int_by_rounded_or_nil(
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
        get.fn.arbitrary_args_bound_or_ignored_fn(get.table.bool_by_key_equals_value, {a_use, "creation_specifier", creation_specifier})
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
    comparable_by_clamped = function(comparable, min, max)
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
  stream_creation_specifier = {
  },
  youtube_video_id = {
    get_extracted_attr_dict_via_ai = function(video_id, do_after)
      return get.form_filling_specifier.filled_string_dict({
        in_fields = {
          title = transf.youtube_video_id.title(video_id),
          channel_title = transf.youtube_video_id.channel_title(video_id),
          description = get.string.string_by_shortened_start_ellipsis(transf.youtube_video_id.description(video_id)),
        },
        form_field_specifier_array = {
          {
            alias = "tcrea",
            value = "Artist"
          },
          {
            alias = "title",
            value = "Title"
          },
          {
            alias = "srs",
            value = "Series"
          },
          {
            alias = "srsrel",
            value = "Relation to series",
            explanation = "op, ed, ost, insert song, etc."
          },
          {
            alias = "srsrelindex",
            value = "Index in the relation to series",
            explanation = "positive integer"
          }
        },
      })
    end,
  },
  youtube_video_id_array = {
    youtube_playlist_creation_specifier = function(arr, name, desc, privacy)
      return {
        name = name,
        desc = desc,
        privacy = privacy,
        youtube_video_id_array = arr
      }
    end,
  },
  fn = {
    first_n_args_bound_fn = hs.fnutils.partial,

    --- binds arguments to a function
    --- @param func function
    --- @param arg_spec any | any[] List of arguments to bind. Use a_use to consume an argument passed at runtime.
    --- @param ignore_spec? integer | integer[] List of arguments to ignore (by index).
    --- @return function
    arbitrary_args_bound_or_ignored_fn = function(func, arg_spec, ignore_spec)

      -- handle shorthand
      if not is.any.array(arg_spec) then
        arg_spec = { arg_spec }
      end
      if not is.any.array(ignore_spec) then
        ignore_spec = { ignore_spec }
      end
      
      -- initialize inner_func to the original function
      local inner_func = function(...)
        local args = {...}
        table.sort(ignore_spec, function(a, b) return a > b end)
        for _, index in transf.array.index_value_stateless_iter(ignore_spec) do
          table.remove(args, index)
        end
        local new_args = {}
        for index, arg in transf.array.index_value_stateless_iter(arg_spec) do -- for all arg_lists to bind
          if arg == a_use then
            new_args[index] = table.remove(args, 1)
          else
            new_args[index] = arg
          end
        end
        for _, arg in transf.array.index_value_stateless_iter(args) do -- for all remaining args
          table.insert(new_args, arg)
        end
        return func(table.unpack(new_args))
      end

      return inner_func
    end,
    second_n_args_bound_fn = function(func, ...)
      return get.fn.arbitrary_args_bound_or_ignored_fn(
        func,
        transf.any_and_array.array(
          a_use,
          transf.n_anys.array(...)
        )
      )
    end,
    --- @class memoOpts
    --- @field is_async? boolean whether we are memoizing an async function. Defaults to false
    --- @field invalidation_mode? "invalidate" | "reset" | "none" whether and in what way to invalidate the cache. Defaults to "none"
    --- @field interval? number how often to invalidate the cache, in seconds. Defaults to 0
    --- @field stringify_table_params? boolean whether to stringify table params before using them as keys in the cache. Defaults to false. However, this is ignored if mode = "fs", as we need to stringify the params to use them as a path
    --- @field table_param_subset? "json" | "no-fn-userdata-loops" | "any" whether table params that will be stringified will only contain jsonifiable values, anything that a lua table can contain but functions, userdata, and loops, or anything that a lua table can contain. Speed: "json" > "no-fn-userdata-loops" > "any". Defaults to "json"

    --- memoize a function if it's not already memoized, or return the memoized version if it is
    --- @generic I, O
    --- @param fn fun(...: I): O
    --- @param opts? memoOpts
    --- @param fnname? string the name of the function. Optional, but required for fsmemoization and switches to fsmemoization if provided, since we need to use the function name to create a unique cache path. We can't rely on an automatically generated identifier, since this may change between sessions
    --- @return fun(...: I): O, hs.timer?
    rt_or_nil_by_memoized = function(fn, opts, fnname)
      local fnid = fnname or transf.fn.fnid(fn) -- get a unique id for the function, using lua's tostring function, which uses the memory address of the function and thus is unique for each function
    
      local opts_as_str_or_nil
      if memoized[fnid] then 
        return memoized[fnid]
      elseif opts == nil then
        -- no-op: we only need to make the else block isn't executed if opts is nil, since that will result in an infinite loop
      else
        opts_as_str_or_nil = get.fn.rt_or_nil_by_memoized(json.encode)(opts)
        if memoized_w_opts[fnid] then
          if memoized_w_opts[fnid][opts_as_str_or_nil] then -- if the function is already memoized with the same options, return the memoized version.  This allows us to use memoized functions immediately as `get.fn.rt_or_nil_by_memoized(fn)(...)` without having to assign it to a variable first
            return memoized_w_opts[fnid][opts_as_str_or_nil]
          end
        else
          memoized_w_opts[fnid] = {}
        end
      end
    
      local opts_as_str = opts_as_str_or_nil or "noopts"
    
      --- set default options
      opts = get.table.table_by_copy(opts) or {}
      local mode, fnidentifier_type
      if fnname then
        mode = "fs"
        fnidentifier_type = "fnname"
      else
        mode = "mem"
        fnidentifier_type = "fnid"
      end
      opts.is_async = get.any.default_if_nil(opts.is_async, false)
      opts.invalidation_mode = opts.invalidation_mode or "none"
      opts.interval = opts.interval or 0
      opts.stringify_table_params = get.any.default_if_nil(opts.stringify_table_params, false)
      opts.table_param_subset = opts.table_param_subset or "json"
    
      -- initialize the cache if using memory
      if mode == "mem" then
        memstore[fnid] = memstore[fnid] or {}
      end
      
      -- create some variables that will be used later
    
      local timer
      
      local created_at = get[fnidentifier_type].timestamp_s_by_created_time(fnid, opts_as_str)
    
      -- create a timer to invalidate the cache if needed
      if opts.invalidation_mode == "reset" then
        timer = hs.timer.doEvery(opts.interval, function()
          dothis[fnidentifier_type].reset_by_opts(fnid, opts_as_str)
        end)
      end
    
      -- create the memoized function
      local memoized_func = function(...)
        local params = {...}
        local callback = nil
        if opts.is_async then -- assume that async functions always have a callback as the last argument
          callback = params[#params]
          params[#params] = nil
        end 
    
    
    
        local result 
    
        if opts.invalidation_mode == "invalidate" then
          if created_at + opts.interval < os.time() then -- cache is invalid, so we need to recalculate
            dothis[fnidentifier_type].reset_by_opts(fnid)
            if mode == "fs" then
              dothis[fnidentifier_type].set_timestamp_s_created_time(fnid, opts_as_str, os.time())
            end
            created_at = os.time()
          end
    
        else
    
          -- get the result from the cache
          result = get[fnidentifier_type].rt_by_memo(fnid, opts_as_str, params, opts)
        end
    
        if not opts.is_async then
          if not result then  -- no result yet, so we need to call the original function and store the result in the cache
            -- print("cache miss for", fnid)
            result = { fn(...) }
            dothis[fnidentifier_type].put_memo(fnid, opts_as_str, params, result, opts)
          else
            -- print("cache hit for", fnid)
            -- inspPrint(result)
          end
          return table.unpack(result) -- we're sure to have a result now, so we can return it
        else
          if result then -- if we have a result, we can call the callback immediately
            callback(table.unpack(result))
          else -- else we need to call the original function and wrap the callback to store the result in the cache before calling it
            fn(table.unpack(params), function(...)
              local result = {...}
              dothis[fnidentifier_type].put_memo(fnid, opts_as_str, params, result, opts)
              callback(table.unpack(result))
            end)
          end
        end
      end
      if opts_as_str_or_nil == nil then
        memoized[fnid] = memoized_func
      else
        memoized_w_opts[fnid][opts_as_str] = memoized_func
      end
      return memoized_func, timer
    end,
  },
  n_any_arg_fn = {
    --- basically `decorate`
    n_t_arg_fn_w_n_any_arg_n_t_ret_fn = function(fn, fn2)
      return function(...)
        return fn(fn2(...))
      end
    end,
  },
  fnname = {
    local_absolute_path_by_in_cache_w_string_and_array_or_nil = function(fnname, optsstr, args)
      local path = transf.fnname.local_absolute_path_by_in_cache(fnname)

      if optsstr then
        path = path .. optsstr .. "/"
      end
      if args then 
        -- encode args to json and hash it, to use as the key for the cache
        local hash = transf.not_userdata_or_function.md5_hex_string(args)
        path = path .. hash
      end
      return path
    end,
  },
  form_field_specifier_array = {
    form_filling_specifier = function(specarr, in_fields)
      return {
        form_field_specifier_array = specarr,
        in_fields = in_fields
      }
    end,
    filled_string_dict_from_string = function(specarr, str)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        specarr,
        function (form_field_specifier)
          return 
            form_field_specifier.alias or form_field_specifier.value, 
            string.match(str, form_field_specifier.value .. "[^\n]-: *(.-)\n") or string.match(str, form_field_specifier.value .. "[^\n]-: *(.-)$")
        end
      )
    end,
    filled_string_dict_from_string_array = function(specarr, in_fields)
      return get.form_filling_specifier.filled_string_dict(
        get.form_field_specifier_array.form_filling_specifier(
          specarr,
          in_fields
        )
      )
    end
  },
  form_filling_specifier = {
    --- @class form_field_specifier  
    --- @field value string The field to fill, as we want GPT to see it (i.e. chosing a name that GPT will understand)
    --- @field alias? string The field to fill, as we want the user to see it (i.e. chosing a name that the user will understand). May often be unset, in which case the value field is used.
    --- @field explanation? string The explanation to show to GPT for the field. May be unset if the field is self-explanatory.

    --- @class form_filling_specifier
    --- @field in_fields {[string]: string} The fields to take the data from
    --- @field form_field_specifier_array form_field_specifier[] The fields (i.e. the template) to fill
    --- fills a template using GPT
    --- example use-case: Imagine trying to get the metadata of some song from a youtube video, where the artist name may be in the title, or the channel name, or not present at all, where the title may contain a bunch of other stuff besides the song title
    --- in this case you could call this function as
    --- ```
    --- fillTemplateGPT(
    ---   {
    ---     in_fields = {
    ---       channel_name = "XxAimerLoverxX",
    ---       video_title = "XxAimerLoverxX - Aimer - Last Stardust",
    ---     },
    ---     form_field_specifier_array = {
    ---       {value = "artist"},
    ---       {value = "song_title"},
    ---     }
    ---   }, ...
    --- )
    --- ```

    filled_string_dict = function(spec)
      local query = get.string.evaled_as_template(lemap.gpt.fill_template, spec)
      local res = gpt(query,  { temperature = 0})
      return get.form_field_specifier_array.filled_string_dict_from_string(spec.form_field_specifier_array, res)
    end,
  },
  input_spec = {
    declared_input_spec = function(input_spec, type)
      local cpy = get.table.table_by_copy(input_spec)
      cpy.type = type
      return cpy
    end,
  },
  tree_node_like = {
    tree_node = function(tree_node_like, treeify_spec)
      local raw_children = tree_node_like[treeify_spec.children_key or "children"]
      tree_node_like[treeify_spec.children_key] = nil -- remove children old node
      local label
      if treeify_spec.label_key then
        label = tree_node_like[treeify_spec.label_key]
      else
        label = get.table.table_by_copy(tree_node_like, true)
      end
      if raw_children and #raw_children > 0 and treeify_spec.levels_of_nesting_to_skip then
        for i = 1, treeify_spec.levels_of_nesting_to_skip do -- this is to handle cases in which instead of children being { item, item, ... }, it's {{ item, item, ... }} etc. Really, this shouldn't be necessary, but some of the data I'm working with is like that.
          raw_children = raw_children[1]
        end
      end
      local children = get.tree_node_like_array.tree_node_array(raw_children, treeify_spec)
      return {
        label = label,
        children = children
      }
    end
  },
  tree_node_like_array = {
    tree_node_array = function(tree_node_like_array, treeify_spec)
      return hs.fnutils.imap(
        tree_node_like_array,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.tree_node_like.tree_node, {a_use, treeify_spec})
      )
    end,
  },
  n_any_assoc_arr_array = {
    leaf_label_with_title_path = function(arr, title_key)
      local leaf = get.table.table_by_copy(dothis.array.pop(arr))
      local title_path = get.array_of_tables.array_of_vts_w_kt(arr, title_key)
      leaf.path = title_path
      return leaf
    end
  },
  array_of_n_any_assoc_arr_arrays = {
    array_of_assoc_arr_leaf_labels_with_title_path = function(arr, title_key)
      return hs.fnutils.imap(
        arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.n_any_assoc_arr_array.leaf_label_with_title_path, {a_use, title_key})
      )
    end,
  },
  role_content_message_spec_array = {
    llm_response_string = function(arr, temperature, max_tokens)
      local request = {
        endpoint = "chat/completions",
        api_name = "openai",
        request_table = {
          temperature = temperature or 0,
          max_tokens = max_tokens or 1000,
          model = "gpt-4",
          messages = arr
        }
      }
      local res = rest(request)
      return transf.gpt_response_table.response_text(res)
    end,
  },
  n_shot_role_content_message_spec_array = {
    n_shot_llm_spec = function(arr)


    end,
  },
  n_shot_llm_spec = {
    n_shot_api_query_llm_response_string = function(spec, temperature, max_tokens)
      local res = get.role_content_message_spec_array.llm_response_string(
        transf.n_shot_llm_spec.n_shot_api_query_role_content_message_spec_array(spec),
        temperature,
        max_tokens
      )
      if res == "IMPOSSIBLE" then
        return nil
      else
        return res
      end
    end,
  },
  not_userdata_or_function = {
    md5_base32_crock_string_of_length = function(any, length)
      return transf.not_userdata_or_function.md5_base32_crock_string(any):sub(1, length)
    end,
  }
}