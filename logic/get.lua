get = {
  str_or_number = {
    number_or_nil = function(t, base)
      if is.any.str(t) then
        return get.str.number_or_nil(t, base)
      else
        return t
      end
    end,
    int_by_rounded_or_nil = function(t, base)
      if is.any.str(t) then
        return get.str.int_by_rounded_or_nil(t, base)
      else
        return t
      end
    end,
    pos_int_or_nil = function(t, base)
      return transf.number.pos_int_or_nil(
        get.str_or_number.number_or_nil(t, base)
      )
    end,
  },
  int_or_nil = {
    prompted_once_int_from_default = function(int, message)
      return transf.prompt_spec.any({
        prompter = transf.str_prompt_args_spec.str_or_nil_and_bool,
        transformer = get.str.int_by_rounded_or_nil,
        prompt_args = {
          message = message or "Enter an int...",
          default = transf.number.nonindicated_dec_number_str(int or 0),
        }
      })
    end,
  },
  number_or_nil = {
    prompted_once_number_from_default = function(no, message)
      return transf.prompt_spec.any({
        prompter = transf.str_prompt_args_spec.str_or_nil_and_bool,
        transformer = get.str.number_or_nil,
        prompt_args = {
          message = message or "Enter a number...",
          default = transf.number.nonindicated_dec_number_str(no or 0),
        }
      })
    end,
  },

  package_manager_name_or_nil = {
    package_name_semver_compound_str_arr = function(mgr, arg) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " with-version " .. (arg or ""))) end,
    package_name_semver_package_manager_name_compound_str_arr = function(mgr, arg) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " with-version-package-manager " .. (arg or ""))) end,
    package_name_package_manager_name_compound_str = function(mgr, arg) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " with-package-manager " .. (arg or ""))) end,
    semver_str_arr = function(mgr, arg) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " version " .. (arg or ""))) end,
    absolute_path_arr = function(mgr, arg) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") ..  " which " .. (arg or "")))
    end,
    bool_arr_installed = function(mgr, arg) return transf.str.bool_by_evaled_env_bash_success( "upkg " .. (mgr or "") .. " is-installed " .. (arg or "")) end,
  },
  calendar_name = {
   
  },
  khal = {
    parseable_format_specifier = function()
      return get.str_or_number_arr.str_by_joined(
        get.arr.str_arr_by_mapped_values_w_fmt_str(
          ls.khal.parseable_format_component_arr,
          "{%s}"
        ), fixedstr.unique_field_separator
      ) .. fixedstr.unique_record_separator
    end,
    basic_command_parts = function(include, exclude)
      local command = " --format=" .. transf.str.str_by_single_quoted_escaped(get.khal.parseable_format_specifier())
      if include then command = command .. transf.str_arr.repeated_option_str(include, "--include-calendar") end
      if exclude then command = command .. transf.str_arr.repeated_option_str(exclude, "--exclude-calendar") end
      return command
    end,
       
    search_event_tables = function(searchstr, include, exclude)
      local command = "khal search" .. get.khal.basic_command_parts(include, exclude)
      command = command .. " " .. transf.str.str_by_single_quoted_escaped(searchstr)
      return transf.multirecord_str.event_table_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped(command))
    end,
    list_event_tables = function(specifier, include, exclude)
      local command = {
        'khal list -df ""',
        get.khal.basic_command_parts(include, exclude),
      }
      if specifier.once then
        dothis.arr.push(command, "--once")
      end
      if specifier.notstarted then
        dothis.arr.push(command, "--notstarted")
      end
      specifier.start = specifier.start or "today"
      specifier["end"] = specifier["end"] or date(os.time()):adddays(60):fmt("%Y-%m-%d")
      dothis.arr.push(command, transf.str.str_by_single_quoted_escaped(specifier.start))
      dothis.arr.push(command, transf.str.str_by_single_quoted_escaped(specifier["end"]))
      return transf.multirecord_str.event_table_arr(
        transf.str.str_or_nil_by_evaled_env_bash_stripped(
          get.str_or_number_arr.str_by_joined(command, " ")
        )
      )
    end,
  },
  pass_item_name = {
    str_or_nil_by_fetch_value = function(item, type)
      return get.fn.rt_or_nil_by_memoized_invalidate_1_day(transf.str.str_or_nil_by_evaled_env_bash_stripped)("pass show " .. type .. "/" .. item)
    end,
    local_absolute_path = function(item, type, ext)
      return env.PASSWORD_STORE_DIR .. "/" .. type .. "/" .. item .. "." .. (ext or "gpg")
    end,
    bool_by_exists_as = function(item, type, ext)
      return is.absolute_path.extant_path(get.pass_item_name.local_absolute_path(item, type, ext))
    end,
    not_userdata_or_fn_by_parsed_json = function(item, type)
      return transf.str.not_userdata_or_fn_or_nil_by_evaled_env_bash_parsed_json("pass show " .. type .. "/" .. item)
    end,
    contact_json = function(item, type)
      return get.pass_item_name.not_userdata_or_fn_by_parsed_json(item, "contacts/" .. type)
    end,
    
  },
  ["nil"] = {
    nth_arg_ret_fn = function(_, n)
      return function(...)
        return select(n, ...)
      end
    end,
  },
  audiodevice = {
    is_active_audiodevice = function (device, type)
      return device == transf.audiodevice_type.default_audiodevice(type)
    end,
    audiodevice_specifier = function (device, type)
      return {
        device = device,
        type = type,
      }
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
      return transf.contact_table.vcard_email_type_key_email_value_assoc(contact_table)[type]
    end,
    phone_number = function(contact_table, type)
      return transf.contact_table.vcard_type_phone_assoc(contact_table)[type]
    end,
    address_table = function(contact_table, type)
      return transf.contact_table.vcard_type_address_assoc(contact_table)[type]
    end,
  },
  table = {
    ---@param table table
    ---@param keystop integer
    ---@param valuestop integer
    ---@param depth integer
    ---@return str[]
    yaml_lines_aligned_with_predetermined_stops = function(table, keystop, valuestop, depth)
      local lines = {}
      for value_k, value_v in transf.table.stateless_key_value_iter(table) do
        local pre_padding_length = depth * 2
        local key_length = #value_k
        local key_padding_length = keystop - (key_length + pre_padding_length)
        if is.any.table(value_v) and not (value_v.value or value_v.comment) then 
          dothis.arr.push(lines, get.str.str_by_repeated(" ", depth * 2) .. value_k .. ":" .. get.str.str_by_repeated(" ", key_padding_length) .. " ")
          lines = transf.two_arrs.arr_by_appended(lines, get.table.yaml_lines_aligned_with_predetermined_stops(value_v, keystop, valuestop, depth + 1))
        elseif is.any.table(value_v) and (value_v.value or value_v.comment) then 
          local key_part = get.str.str_by_repeated(" ", pre_padding_length) .. value_k .. ":" .. get.str.str_by_repeated(" ", key_padding_length) .. " "
          local value_length = 0
          local value_part = ""
          if value_v.value then
            value_length = #value_v.value
            value_part = value_v.value
          end
          local comment_part = ""
          if value_v.comment then
            local value_padding_length = valuestop - value_length
            comment_part = get.str.str_by_repeated(" ", value_padding_length) .. " # " .. value_v.comment
          end
          dothis.arr.push(lines, key_part .. value_part .. comment_part)
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
      if is.any.not_table(t) then return t end -- non-tables don't need to be copied
      deep = get.any.default_if_nil(deep, true)
      copied_tables = get.any.default_if_nil(copied_tables, {})
      if not t then return t end
      local new = {}
      copied_tables[transf.any.str(t)] = new
      for k, v in transf.table.stateless_key_value_iter(t) do
        if is.any.table(v) and deep then
          if copied_tables[transf.any.str(v)] then -- we've already copied this table, so just reference it
            new[k] = copied_tables[transf.any.str(v)]
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
    bool_by_all_keys_contained_in_w_arr = function(t, arr)
      return get.arr.bool_by_all_contained_in_w_arr(
        transf.table.kt_arr(t),
        arr
      )
    end,
    bool_by_some_keys_contained_in_w_arr = function(t, arr)
      return get.arr.bool_by_some_contained_in_w_arr(
        transf.table.kt_arr(t),
        arr
      )
    end,
    bool_by_all_keys_contained_in_w_table = function(t, table)
      return get.table.bool_by_all_keys_contained_in_w_arr(
        t,
        transf.table.kt_arr(table)
      )
    end,
    bool_by_all_keys_pass_w_fn = function(t, fn)
      return get.arr.bool_by_all_pass_w_fn(
        transf.table.kt_arr(t),
        fn
      )
    end,
    booL_by_all_values_pass_w_fn = function(t, fn)
      return get.arr.bool_by_all_pass_w_fn(
        transf.table.vt_arr(t),
        fn
      )
    end,
    bool_by_some_keys_pass_w_fn = function(t, fn)
      return get.arr.bool_by_some_pass_w_fn(
        transf.table.kt_arr(t),
        fn
      )
    end,
    bool_by_none_keys_pass_w_fn = function(t, fn)
      return get.arr.bool_by_none_pass_w_fn(
        transf.table.kt_arr(t),
        fn
      )
    end,
    vt_or_err = function(t, key)
      if t[key] then
        return t[key]
      else
        error("Table did not contain key " .. key)
      end
    end,
    arr_arr_by_label_root_to_leaf = function(t, table_arg_bool_by_is_leaf_ret_fn, visited, path)
      visited = get.any.default_if_nil(visited, {})
      local arr_o_arrs = {}
      for k, v in transf.table.stateless_key_value_iter(t) do
        local path = transf.arr_or_nil_and_any.arr(path, k)
        if not is.any.table(v) or table_arg_bool_by_is_leaf_ret_fn(v) then -- this is inherently a leaf, or we've been told to treat it as one
          dothis.arr.push(
            arr_o_arrs, 
            transf.arr_and_any.arr(path, v)
          )
        else -- not a leaf
          if not get.arr.bool_by_contains(visited, v) then -- only if we've not seen this yet, to avoid infinite loops
            arr_o_arrs = transf.two_arrs.arr_by_appended(
              arr_o_arrs,
              get.table.arr_arr_by_label_root_to_leaf(
                v,
                table_arg_bool_by_is_leaf_ret_fn,
                transf.two_arrs.arr_by_appended(visited, v),
                path
              )
            )
          end
        end
      end
      return arr_o_arrs
    end,
    arr_arr_by_key_label = function(t, table_arg_bool_by_is_leaf_ret_fn, visited, path)
      visited = get.any.default_if_nil(visited, {})
      local arr_o_arrs = {}
      for k, v in transf.table.stateless_key_value_iter(t) do
        local path = transf.arr_or_nil_and_any.arr(path, k)
        dothis.arr.push(
          arr_o_arrs, 
          path
        )
        if is.any.table(v) and table_arg_bool_by_is_leaf_ret_fn(v) then -- not a leaf
          if not get.arr.bool_by_contains(visited, v) then -- only if we've not seen this yet, to avoid infinite loops
            arr_o_arrs = transf.two_arrs.arr_by_appended(
              arr_o_arrs,
              get.table.arr_arr_by_key_label(
                v,
                table_arg_bool_by_is_leaf_ret_fn,
                transf.two_arrs.arr_by_appended(visited, v),
                path
              )
            )
          end
        end
      end
      return arr_o_arrs
    end,
    arr_or_nil_by_find_key_path = function(t, key_to_find, visited, path)
      visited = get.any.default_if_nil(visited, {})
      local key_path = nil
      for k, v in pairs(t) do
        local path = transf.arr_or_nil_and_any.arr(path, k)
        if k == key_to_find then
          key_path = path
          break
        end
        if is.any.table(v) then -- if v is a table, recursively search it
          if not get.arr.bool_by_contains(visited, v) then -- only if we've not seen this yet, to avoid infinite loops
            visited = transf.two_arrs.arr_by_appended(visited, v)
            key_path = get.table.arr_or_nil_by_find_key_path(v, key_to_find, visited, path)
            if key_path then
              break
            end
          end
        end
      end
      return key_path
    end,
    any_by_key_path = function(t, key_path)
      local current = t
      for _, key in ipairs(key_path) do
        current = current[key]
      end
      return current
    end,
    arr_or_nil_by_find_path_between_two_keys = function(t, start, stop)
      local start_path = get.table.arr_or_nil_by_find_key_path(t, start)
      local start_tbl = get.table.any_by_key_path(t, start_path)
      if start_tbl then
        return get.table.arr_or_nil_by_find_key_path(start_tbl, stop)
      end
    end,
    str_by_joined_key_any_value_assoc = function(t, table_arg_bool_by_is_leaf_ret_fn, joiner)
      return get.arr_arr.str_by_joined_key_any_value_assoc(
        get.table.arr_arr_by_label_root_to_leaf(t, table_arg_bool_by_is_leaf_ret_fn),
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
    arr_by_mapped_w_kt_vt_arg_vt_ret_fn = function(t, fn)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(t) do
        dothis.arr.push(res, fn(k, v))
      end
      return res
    end,
    arr_by_mapped_w_kt_arg_vt_ret_fn = function(t, fn)
      return get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(t, function(k, v) return fn(k) end)
    end,
    arr_by_mapped_w_vt_arg_vt_ret_fn = function(t, fn)
      return get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(t, function(k, v) return fn(v) end)
    end,
    str_arr_by_mapped_w_fmt_str = function(t, fmt_str)
      return get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
        t,
        function(k,v)
          return get.str.str_by_formatted_w_n_anys(fmt_str, k, v)
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
    kt_arr_by_sorted = function(t, fn)
      local kt_arr = transf.table.kt_arr(t)
      dothis.arr.sort(kt_arr, fn)
      return kt_arr
    end,
    vt_arr_by_sorted = function(t, fn)
      local vt_arr = transf.table.vt_arr(t)
      dothis.arr.sort(vt_arr, fn)
      return vt_arr
    end,
    dot_notation_str_by_path_to_key = pltablex.search,
    table_by_mapped_nested_w_kt_arg_kt_ret_fn = function(t, fn, table_arg_bool_by_is_leaf_ret_fn)
      return get.table.table_by_mapped_w_kt_vt_arg_kt_vt_ret_fn(
        t,
        function(k, v)
          if is.any.table(v) and not table_arg_bool_by_is_leaf_ret_fn(v) then
            return fn(k), get.table.table_by_mapped_nested_w_kt_arg_kt_ret_fn(v, fn, table_arg_bool_by_is_leaf_ret_fn)
          else
            return fn(k), v
          end
        end
      )
    end,
  },
  
  assoc = {
    arr_by_mapped_w_kt_arr = function(assoc, arr)
      return get.arr.arr_by_mapped_w_t_key_assoc(
        arr,
        assoc
      )
    end,
    assoc_by_filtered_w_kt_vt_fn = function(t, fn)
      return transf.pair_arr.assoc(
        get.arr.arr_by_filtered(
          transf.table.two_anys_arr(t),
          function(two_anys_arr)
            return fn(two_anys_arr[1], two_anys_arr[2])
          end
        )
      )
    end,
    assoc_by_filtered_w_vt_fn = function(t, fn)
      return get.assoc.assoc_by_filtered_w_kt_vt_fn(t, function(k, v) return fn(v) end)
    end,
    kt_or_nil_by_first_match_w_kt_vt_arg_fn = function(t, fn)
      local arr = transf.table.two_anys_arr_by_sorted_larger_key_first(t)
      for _, two_anys_arr in transf.arr.pos_int_vt_stateless_iter(arr) do
        if fn(two_anys_arr[1], two_anys_arr[2]) then
          return two_anys_arr[1]
        end
      end
    end,
    kt_or_nil_by_first_match_w_kt_arg_fn = function(t, fn)
      return get.assoc.kt_or_nil_by_first_match_w_kt_vt_arg_fn(t, function(k, v) return fn(k) end)
    end,
    kt_or_nil_by_first_match_w_vt_arg_fn = function(t, fn)
      return get.assoc.kt_or_nil_by_first_match_w_kt_vt_arg_fn(t, function(k, v) return fn(v) end)
    end,
    kt_or_nil_by_first_match_w_vt = function(t, vt)
      return get.assoc.kt_or_nil_by_first_match_w_vt_arg_fn(t, function(v) return v == vt end)
    end,
    kt_by_first_match_w_kt_arr = function(t, keys)
      return get.assoc.kt_or_nil_by_first_match_w_kt_arg_fn(t, function(k) return get.arr.bool_by_contains(keys, k) end)
    end,
    vt_by_first_match_w_kt_arr= function(t, keys)
      local key = get.assoc.kt_or_nil_by_first_match_w_kt_arr(t, keys)
      if key then
        return t[key]
      else
        return nil
      end
    end,

  },
  nonabsolute_path_key_assoc = {
    absolute_path_key_assoc = function(nonabsolute_path_key_assoc, starting_point, extension)
      return get.table.table_by_mapped_w_kt_arg_kt_ret_fn(nonabsolute_path_key_assoc, function(k)
        local ext_part = ""
        if extension then ext_part = "." .. extension end
        return (starting_point or "") .. "/" .. k .. ext_part
      end)
    end,
  },
  table_of_assocs = {
    assoc_arr = function(assoc, key)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(assoc) do
        local copied = get.table.table_by_copy(v, true)
        copied[key] = k
        dothis.arr.push(res, copied)
      end
      return res
    end,
  },
  complete_pos_int_slice_spec = {
    boolen_by_is_hit_w_pos_int = function(spec, i)
      return i >= spec.start and i <= spec.stop and (i - spec.start) % spec.step == 0 
    end,
  },
  arr = {
    two_arrs_of_arrs_by_slice_w_slice_spec = function(arr, spec)
      
      if spec.start and not is.any.number(spec.start) then
        spec.start = get.arr.pos_int_or_nil_by_first_match_w_t(arr, spec.start)
      end

      if spec.stop and  not is.any.number(spec.start) then
        spec.stop = get.arr.pos_int_or_nil_by_first_match_w_t(arr, spec.stop)
      end

      local hits = {}
      local misses = {}

      -- set defaults

      if not spec.step then spec.step = 1 end
      if not spec.start then spec.start = 1 end
      if not spec.stop then spec.stop = transf.arr.pos_int_by_length(arr) end

      -- resolve negative indices

      if spec.start < 0 then
        spec.start = transf.arr.pos_int_by_length(arr) + spec.start + 1
      end
      if spec.stop < 0 then
        spec.stop = transf.arr.pos_int_by_length(arr) + spec.stop + 1
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

      -- I want to return an arr of arrs, with each series of hits or misses being its own arr
      local current = {}
      local current_type = nil

      for i = 1, #arr do
        if get.complete_pos_int_slice_spec.boolen_by_is_hit_w_pos_int(spec, i) then
          if current_type == "misses" then
            dothis.arr.push(hits, current)
            current = {}
          end
          current_type = "hits"
          dothis.arr.push(current, arr[i])
        else
          if current_type == "hits" then
            dothis.arr.push(misses, current)
            current = {}
          end
          current_type = "misses"
          dothis.arr.push(current, arr[i])
        end
        
      end

      if #current > 0 then
        if current_type == "hits" then
          dothis.arr.push(hits, current)
        else
          dothis.arr.push(misses, current)
        end
    end

      return hits, misses


    end,
    two_arrs_by_slice_w_slice_spec = function(arr, spec)
      local hits, misses = get.arr.two_arrs_of_arrs_by_slice_w_slice_spec(arr, spec)
      return get.arr.arr_by_flatten(hits), get.arr.arr_by_flatten(misses)
    end,
    arr_by_slice_w_slice_spec = function(arr, slice_spec)
      return select(
        1,
        get.arr.two_arrs_by_slice_w_slice_spec(arr, slice_spec)
      )
    end,
    two_arrs_of_arrs_by_slice_w_3_int_any_or_nils = function(arr, start, stop, step)
      return get.arr.two_arrs_of_arrs_by_slice_w_slice_spec(
        arr,
        {
          start = start,
          stop = stop,
          step = step,
        }
      )
    end,
    two_arrs_by_slice_w_3_int_any_or_nils = function(arr, start, stop, step)
      return get.arr.two_arrs_by_slice_w_slice_spec(
        arr,
        {
          start = start,
          stop = stop,
          step = step,
        }
      )
    end,
    arr_by_slice_w_3_pos_int_any_or_nils = function(arr, start, stop, step)
      return get.arr.arr_by_slice_w_slice_spec(
        arr,
        {
          start = start,
          stop = stop,
          step = step,
        }
      )
    end,
    two_arrs_of_arrs_by_slice_w_slice_notation = function(arr, notation)
      return get.arr.two_arrs_of_arrs_by_slice_w_3_int_any_or_nils(
        arr,
        transf.slice_notation.three_pos_int_or_nils(notation)
      )
    end,
    two_arrs_by_slice_w_slice_notation = function(arr, notation)
      return get.arr.two_arrs_by_slice_w_3_int_any_or_nils(
        arr,
        transf.slice_notation.three_pos_int_or_nils(notation)
      )
    end,
    arr_by_slice_w_slice_notation = function(arr, notation)
      return get.arr.arr_by_slice_w_3_pos_int_any_or_nils(
        arr,
        transf.slice_notation.three_pos_int_or_nils(notation)
      )
    end,
    two_arrs_of_arrs_by_slice_and_removed_filler_w_slice_spec = function(arr, slice_spec, fill)
      local hits, removed = get.arr.two_arrs_of_arrs_by_slice_w_slice_spec(arr, slice_spec)
      return hits, get.arr_arr.arr_arr_by_mapped(
        removed,
        function(arr)
          return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
            arr,
            function()
              return fill
            end
          )
        end
      )
    end,
    arr_arr_by_slice_and_removed_filler_w_slice_spec = function(arr, slice_spec, fill)
      local hits, fill = get.arr.two_arrs_of_arrs_by_slice_and_removed_filler_w_slice_spec(arr, slice_spec, fill)
      return transf.two_arrs.arr_by_interleaved_stop_longest(hits, fill)
    end,
    arr_by_slice_removed_filler_and_flatten_w_slice_spec = function(arr, slice_spec, fill)
      return transf.arr_arr.arr_by_flatten(
        get.arr.arr_arr_by_slice_and_removed_filler_w_slice_spec(arr, slice_spec, fill)
      )
    end,
    --- the difference between this function and the _removed_filler one is that this will replace an arr of removed elements with a single element (the indicator) unless length zero, whereas the other will replace it with an arr of elements (the fill)
    two_arr_arr_by_slice_and_removed_indicator_w_slice_spec = function(arr, slice_spec, indicator)
      local hits, removed = get.arr.two_arrs_of_arrs_by_slice_w_slice_spec(arr, slice_spec)
      return hits, get.arr_arr.arr_arr_by_mapped_if_not_length_0(
        removed,
        function(arr)
          return {indicator}
        end
      )
    end,
    arr_arr_by_slice_and_removed_indicator_w_slice_spec = function(arr, slice_spec, indicator)
      local hits, indicator = get.arr.two_arr_arr_by_slice_and_removed_indicator_w_slice_spec(arr, slice_spec, indicator)
      return transf.two_arrs.arr_by_interleaved_stop_longest(hits, indicator)
    end,
    arr_by_slice_removed_indicator_and_flatten_w_slice_spec = function(arr, slice_spec, indicator)
      return transf.arr_arr.arr_by_flatten(
        get.arr.arr_arr_by_slice_and_removed_indicator_w_slice_spec(arr, slice_spec, indicator)
      )
    end,
    pos_int_or_nil_by_first_match_w_t = pltablex.find,
    pos_int_or_nil_by_last_match_w_t = pltablex.rfind,
    pos_int_or_nil_by_first_match_w_t_arr = function(arr, t_arr)
      return get.arr.pos_int_or_nil_by_first_match_w_fn(arr, function(t)
        return get.arr.bool_by_first_match_w_t(t_arr, t)
      end)
    end,
    pos_int_or_nil_by_first_match_w_fn = hs.fnutils.find,
    t_or_nil_by_first_match_w_fn = function(arr, fn)
      local index = get.arr.pos_int_or_nil_by_first_match_w_fn(arr, fn)
      if index then
        return arr[index]
      else
        return nil
      end
    end,
    bool_by_first_match_w_t = function(arr, t)
      return get.arr.pos_int_or_nil_by_first_match_w_t(arr, t) ~= nil
    end,
    bool_by_last_match_w_t = function(arr, t)
      return get.arr.pos_int_or_nil_by_last_match_w_t(arr, t) ~= nil
    end,
    bool_by_first_match_w_fn = function(arr, fn)
      return get.arr.pos_int_or_nil_by_first_match_w_fn(arr, fn) ~= nil
    end,
    arr_by_filtered = hs.fnutils.ifilter,
    pos_int_by_last_match_w_fn = function(arr, fn)
      local rev = transf.arr.arr_by_reversed(arr)
      local index = get.arr.pos_int_or_nil_by_first_match_w_fn(rev, fn)
      if index then
        return #arr - index + 1
      else
        return nil
      end
    end,
    two_arrs_by_filtered_nonfiltered = function(arr, fn)
      local passes = {}
      local fails = {}
      for _, v in transf.arr.kt_vt_stateless_iter(arr) do
        if fn(v) then
          dothis.arr.push(passes, v)
        else
          dothis.arr.push(fails, v)
        end
      end
      return passes, fails
    end,
    str_by_joined = function(arr, joiner)
      return get.str_or_number_arr.str_by_joined(
        transf.arr.str_arr(arr),
        joiner
      )
    end,
    str_by_joined_any_pair = function(arr, joiner)
      local any = act.arr.pop(arr)
      local str = get.str_or_number_arr.str_by_joined(arr, joiner)
      return { str, any }
    end,
    bool_by_some_pass_w_fn = function(arr, fn)
      return get.arr.bool_by_first_match_w_fn(arr, fn)
    end,
    bool_by_none_pass_w_fn = function(arr, cond)
      return not get.arr.bool_by_some_pass_w_fn(arr, cond)
    end,
    bool_by_all_pass_w_fn = function(arr, cond)
      return get.arr.bool_by_none_pass_w_fn(arr, function(x) return not cond(x) end)
    end,
    bool_by_some_equals_w_t = function(arr, t)
      return get.arr.some_pass_w_fn(arr, function(x) return x == t end)
    end,
    bool_by_none_equals_w_t = function(arr, t)
      return get.arr.none_pass_w_fn(arr, function(x) return x == t end)
    end,
    bool_by_all_equals_w_t = function(arr, t)
      return get.arr.all_pass_w_fn(arr, function(x) return x == t end)
    end,
    bool_by_some_contained_in_w_arr = function(arr, arr2)
      return get.arr.some_pass_w_fn(arr, function(x) return get.arr.bool_by_contains(arr2, x) end)
    end,
    bool_by_none_contained_in_w_arr = function(arr, arr2)
      return get.arr.none_pass_w_fn(arr, function(x) return get.arr.bool_by_contains(arr2, x) end)
    end,
    bool_by_all_contained_in_w_arr = function(arr, arr2)
      return get.arr.all_pass_w_fn(arr, function(x) return get.arr.bool_by_contains(arr2, x) end)
    end,
    arr_by_head = function(arr, n)
      return get.arr.arr_by_slice_w_3_pos_int_any_or_nils(arr, 1, n or 10)
    end,
    arr_by_tail = function(arr, n)
      return get.arr.arr_by_slice_w_3_pos_int_any_or_nils(arr, -(n or 10))
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
      local index = get.arr.pos_int_or_nil_by_first_match_w_t(arr, item)
      return get.arr.any_by_next_w_index(arr, index)
    end,
    next_by_item_wrapping = function(arr, item)
      local index = get.arr.pos_int_or_nil_by_first_match_w_t(arr, item)
      return get.arr.any_by_next_wrapping_w_index(arr, index)
    end,
    t_by_next_w_fn = function(arr, fn)
      local index = get.arr.pos_int_or_nil_by_first_match_w_fn(arr, fn)
      return get.arr.any_by_next_w_index(arr, index)
    end,
    next_by_fn_wrapping = function(arr, fn)
      local index = get.arr.pos_int_or_nil_by_first_match_w_fn(arr, fn)
      return get.arr.any_by_next_wrapping_w_index(arr, index)
    end,
    t_or_nil_by_previous = function(arr, n)
      return arr[n - 1]
    end,
    t_by_previous_wrapping = function(arr, n)
      return arr[(n - 2) % #arr + 1]
    end,
    arr_by_sorted = function(list, comp)
      local new_list = get.table.table_by_copy(list, false)
      dothis.arr.sort(new_list, comp)
      return new_list
    end,
    bool_by_is_sorted = function(list, comp)
      for i = 1, #list - 1 do
        if not comp(list[i], list[i + 1]) then
          return false
        end
      end
      return true
    end,
    t_by_min = function(list, comp)
      return get.arr.arr_by_sorted(list, comp)[1]
    end,
    t_by_max = function(list, comp)
      return get.arr.arr_by_sorted(list, comp)[#list]
    end,
    arr_by_revsorted = function(arr, comp)
      return transf.arr.arr_by_reversed(get.arr.arr_by_sorted(arr, comp))
    end,
    --- @generic T
    --- @param list T[]
    --- @param comp? fun(a: T, b: T):boolean
    --- @param if_even? "lower" | "higher" | "average" | "both"
    --- @return T
    median = function (list, comp, if_even)
      if_even = if_even or "lower"
      list = get.table.table_by_copy(list, false) -- don't modify the original list
      dothis.arr.sort(list, comp)
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
      for _, v2 in transf.arr.pos_int_vt_stateless_iter(arr) do
        if v2 == v then return true end
      end
      return false
    end,
    t_arr_arr_by_combinations_w_pos_int = function(arr, k)
      k = k or #arr
      if k == 0 or #arr == 0 then
        return {{}}
      else 
        return get.any_stateful_generator.arr(combine.combn, arr, k)
      end
    end,
    raw_item_chooser_item_specifier_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.any.item_chooser_item_specifier
      )
    end,
    item_chooser_item_specifier_arr = function(arr, target_item_chooser_item_specifier_name)
      if target_item_chooser_item_specifier_name then
        return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
          get.arr.raw_item_chooser_item_specifier_arr(arr),
          transf.item_chooser_item_specifier[target_item_chooser_item_specifier_name .. "_item_chooser_item_specifier"]
        )
      else
        return get.arr.raw_item_chooser_item_specifier_arr(arr)
      end
    end,
    item_with_index_chooser_item_specifier_arr = function(arr, target_item_chooser_item_specifier_name)
      return transf.assoc_arr.has_index_key_table_arr(
        get.arr.item_chooser_item_specifier_arr(arr, target_item_chooser_item_specifier_name)
      )
    end,
    hschooser_specifier = function(arr, target_item_chooser_item_specifier_name)
      return {
        chooser_item_specifier_arr = get.arr.item_with_index_chooser_item_specifier_arr(arr, target_item_chooser_item_specifier_name),
        placeholder_text = transf.arr.str_by_summary(arr),
        initial_selected_index = transf.arr.pos_int_by_initial_selected_index(arr),
      }
    end,
    choosing_hschooser_specifier = function(arr, target_item_chooser_item_specifier_name)
      return get.hschooser_specifier.choosing_hschooser_specifier(transf.arr.hschooser_specifier(arr, target_item_chooser_item_specifier_name), "index", arr)
    end,
    arr_by_mapped_w_t_arg_t_ret_fn = hs.fnutils.imap,
    arr_by_mapped_w_pos_int_t_arg_t_ret_fn = function(arr, fn)
      local res = {}
      for i, v in transf.arr.kt_vt_stateless_iter(arr) do
        dothis.arr.push(res, fn(i, v))
      end
    end,
    arr_by_mapped_w_t_key_assoc = function(arr, assoc)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        function(v) return assoc[v] end
      )
    end,
    str_arr_by_mapped_values_w_fmt_str = function(arr, fmt_str)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        get.fn.first_n_args_bound_fn(get.str.str_by_formatted_w_n_anys, fmt_str)
      )
    end,
    arr_by_mapped_w_t_arg_t_ret_fn_and_t_arg_bool_ret_fn = function(arr, mapfn, condfn)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
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
  has_id_key_table_arr = {
    has_id_key_table_by_first_match_w_has_id_key_table = function(arr, assoc)
      return get.arr.t_or_nil_by_first_match_w_fn(
        arr,
        get.fn.first_n_args_bound_fn(
          transf.two_has_id_key_tables.bool_by_equal,
          assoc
        )
      )
    end
  },
  str = {
    pos_int_by_amount_contained_nooverlap = plstringx.count,
    pos_int_by_amount_contained_overlap = function(str, substr)
      return plstringx.count(str, substr, true)
    end,
    str_by_sub_lua = string.sub,
    str_by_sub_eutf8 = get.str.str_by_sub_eutf8,
    str_by_formatted_w_n_anys = string.format,
    str_by_repeated = get.str.str_by_repeated,
    str_arr_by_split_w_ascii_char = stringy.split,
    not_empty_str_arr_by_split_w_ascii_char = function(str, sep)
      return transf.str_arr.noemtpy_str_arr(
        transf.str.str_arr_split_single_char(str, sep)
      )
    end,
    str_arr_split_single_char_stripped = function(str, sep)
      return transf.str_arr.stripped_str_arr(
        transf.str.split_single_char(str, sep)
      )
    end,
    str_arr_by_split_w_str = plstringx.split,
    str_arr_split_noempty = function(str, sep)
      return transf.str_arr.noemtpy_str_arr(
        transf.str.str_arr_split(str, sep)
      )
    end,
    --- don't split on the edge of the str, i.e. don't return empty strs at the start or end
    str_arr_split_noedge = function(str, sep)
      local res = transf.str.str_arr_split(str, sep)
      if res[1] == "" then
        act.arr.shift(res)
      end
      if res[#res] == "" then
        act.arr.pop(res)
      end
      return res
    end,
    n_strs_by_split = function(str, sep, n)
      return transf.arr.n_anys(get.str.str_arr_by_split_w_str(str, sep, n))
    end,
    two_strs_arr_split_or_nil = function(str, sep)
      local arr = get.str.str_arr_by_split_w_str(str, sep, 2)
      if #arr ~= 2 then
        return nil
      else
        return arr
      end
    end,
    two_strs_split_or_nil = function(str, sep)
      local arr = get.str.str_arr_by_split_w_str(str, sep, 2)
      if #arr ~= 2 then
        return nil
      else
        return arr[1], arr[2]
      end
    end,
    line_arr_by_tail = function(path, n)
      return get.arr.arr_by_slice_w_3_pos_int_any_or_nils(transf.str.line_arr(path), -(n or 10))
    end,
    line_arr_by_head = function(path, n)
      return get.arr.arr_by_slice_w_3_pos_int_any_or_nils(transf.str.line_arr(path), 1, n or 10)
    end,
    noempty_line_arr_by_tail = function(path, n)
      return get.arr.arr_by_slice_w_3_pos_int_any_or_nils(transf.str.noempty_line_arr(path), -(n or 10))
    end,
    noempty_line_arr_by_head = function(path, n)
      return get.arr.arr_by_slice_w_3_pos_int_any_or_nils(transf.str.noempty_line_arr(path), 1, n or 10)
    end,
    bool_by_startswith = stringy.startswith,
    bool_by_endswith = stringy.endswith,
    bool_by_not_startswith = function(str, prefix)
      return not transf.str.bool_startswith(str, prefix)
    end,
    bool_by_not_endswith = function(str, suffix)
      return not transf.str.bool_endswith(str, suffix)
    end,
    bool_by_startswith_any_w_ascii_str_arr = function(str, anyof)
      for i = 1, #anyof do
        local res = get.str.bool_by_startswith(str, anyof[i])
        if res then
          return true
        end
      end
      return false
    end,
    bool_by_endswith_any_w_ascii_str_arr = function(str, anyof)
      for i = 1, #anyof do
        local res = get.str.bool_by_endswith(str, anyof[i])
        if res then
          return true
        end
      end
      return false
    end,
    bool_by_contains_w_ascii_str = stringy.find,
    bool_by_not_contains_w_ascii_str = function(str, substr)
      return not transf.str.bool_by_contains_w_ascii_str(str, substr)
    end,
    bool_by_not_contains_w_ascii_str_arr = function(str, substr_arr)
      for k, substr in transf.arr.kt_vt_stateless_iter(substr_arr) do
        if get.str.bool_by_contains_w_str(str, substr) then
          return false
        end
      end
      return true
    end,
    str_arr_arr_by_split = function(str, upper_sep, lower_sep)
      local upper = transf.str.split(str, upper_sep)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(upper, function(v)
        return transf.str.split(v, lower_sep)
      end)
    end,
    search_engine_id_search_url = function(str, search_engine_id)
      return tblmap.search_engine_id.url[search_engine_id]:format(
        get.str.str_by_percent_encoded(str, tblmap.search_engine_id.bool_by_param_is_path[search_engine_id])
      )
    end,
    window_arr_by_pattern = function(str, app_name)
      return get.running_application.window_arr_by_pattern(
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
    bool_by_contains_any_w_ascii_str_arr = function(str, anyof)
      for i = 1, #anyof do
        local res = get.str.bool_by_contains_w_ascii_str(str, anyof[i])
        if res then
          return true
        end
      end
      return false
    end,
    bool_by_contains_all_w_ascii_str_arr = function(str, allof)
      for i = 1, #allof do
        local res = get.str.bool_by_contains_w_ascii_str(str, allof[i])
        if not res then
          return false
        end
      end
      return true
    end,
    bool_by_starts_ends = function(str, start, ends)
      return transf.str.startswith(str, start) and transf.str.endswith(str, ends)
    end,
    bool_by_matches_whole_eutf8 = function(str, regex_str)
      return get.str.bool_by_matches_part_eutf8(str, transf.str.str_by_whole_regex(regex_str))
    end,
    bool_by_matches_whole_onig = function(str, regex_str)
      return get.str.bool_by_matches_part_onig(str, transf.str.str_by_whole_regex(regex_str))
    end,
    bool_by_matches_part_eutf8 = function(str, regex_str)
      return get.str.two_integer_or_nils_by_eutf8_regex_match(str, regex_str) ~= nil
    end,
    bool_by_matches_part_onig = function(str, regex_str)
      return get.str.two_integer_or_nils_by_onig_regex_match(str, regex_str) ~= nil
    end,
    bool_by_not_matches_whole_eutf8 = function(str, regex_str)
      return not transf.str.bool_by_matches_whole_eutf8(str, regex_str)
    end,
    bool_by_not_matches_whole_onig = function(str, regex_str)
      return not transf.str.bool_by_matches_whole_onig(str, regex_str)
    end,
    bool_by_not_matches_part_eutf8 = function(str, regex_str)
      return not transf.str.bool_by_matches_part_eutf8(str, regex_str)
    end,
    bool_by_not_matches_part_onig = function(str, regex_str)
      return not transf.str.bool_by_matches_part_onig(str, regex_str)
    end,
    bool_by_matches_whole_onig_w_regex_quantifiable = function(str, regex_quantifiable)
      return transf.str.bool_by_matches_whole_onig(str, regex_quantifiable .. "*")
    end,
    bool_by_not_matches_part_onig_w_regex_quantifiable = function(str, regex_quantifiable)
      return not transf.str.bool_by_matches_part_onig(str, regex_quantifiable)
    end,
    bool_by_matches_whole_onig_w_regex_character_class_innards = function(str, regex_character_class_innards)
      return transf.str.bool_by_matches_whole_onig_w_regex_quantifiable(str, "[" .. regex_character_class_innards .. "]")
    end,
    bool_by_not_matches_part_onig_w_regex_character_class_innards = function(str, regex_character_class_innards)
      return not transf.str.bool_by_matches_part_onig_w_regex_quantifiable(str, "[" .. regex_character_class_innards .. "]")
    end,
    bool_by_matches_whole_onig_inverted_w_regex_character_class_innards = function(str, regex_character_class_innards)
      return transf.str.bool_by_matches_whole_onig(str, "[^" .. regex_character_class_innards .. "]")
    end,
    str_by_no_prefix = function(str, prefix)
      if get.str.bool_by_startswith(str, prefix) then
        return str:sub(#prefix + 1)
      else
        return str
      end
    end,
    str_by_no_suffix = function(str, suffix)
      if get.str.bool_by_endswith(str, suffix) then
        return str:sub(1, #str - #suffix)
      else
        return str
      end
    end,
    str_by_with_prefix = function(str, prefix)
      if get.str.bool_by_startswith(str, prefix) then
        return str
      else
        return prefix .. str
      end
    end,
    str_by_with_suffix = function(str, suffix)
      if get.str.bool_by_endswith(str, suffix) then
        return str
      else
        return str .. suffix
      end
    end,
    str_by_no_adfix = function(str, adfix)
      return transf.str.str_by_no_prefix(
        transf.str.str_by_no_suffix(str, adfix),
        adfix
      )
    end,
    str_by_with_adfix = function(str, adfix)
      return transf.str.str_by_with_prefix(
        transf.str.str_by_with_suffix(str, adfix),
        adfix
      )
    end,
    str_and_int_by_replaced_eutf8_w_regex_str = get.str.str_and_int_by_replaced_eutf8_w_regex_str,
    str_by_replaced_onig_w_regex_str = onig.gsub,
    str_by_continuous_collapsed_onig_w_regex_quantifiable = function(str, regex_quantifiable)
      return get.str.str_by_replaced_onig_w_regex_str(
        str,
        "(" .. regex_quantifiable .. "){2,}", -- using {2,} instead of + saves us some performance, given a match of length 1 just gets replaced with itself. However, this is not available in eutf8, so we have to use + there
        "%1"
      )
    end,
    str_by_continuous_collapsed_eutf8_w_regex_quantifiable = function(str, regex_quantifiable)
      return get.str.str_and_int_by_replaced_eutf8_w_regex_str(
        str,
        "(" .. regex_quantifiable .. ")+",
        "%1"
      )
    end,
    str_by_final_continuous_collapsed_onig_w_regex_quantifiable = function(str, regex_quantifiable)
      return get.str.str_by_replaced_onig_w_regex_str(
        str,
        "(" .. regex_quantifiable .. ")+$",
        "%1"
      )
    end,
    str_by_final_continuous_collapsed_eutf8_w_regex_quantifiable = function(str, regex_quantifiable)
      return get.str.str_and_int_by_replaced_eutf8_w_regex_str(
        str,
        "(" .. regex_quantifiable .. ")+$",
        "%1"
      )
    end,
    str_by_continuous_replaced_onig_w_regex_quantifiable = function(str, regex_quantifiable, replacement)
      return get.str.str_by_replaced_onig_w_regex_str(
        str,
        regex_quantifiable .. "+",
        replacement
      )
    end,
    str_by_continuous_replaced_eutf8_w_regex_quantifiable = function(str, regex_quantifiable, replacement)
      return get.str.str_and_int_by_replaced_eutf8_w_regex_str(
        str,
        regex_quantifiable .. "+",
        replacement
      )
    end,
    str_by_final_continuous_replaced_onig_w_regex_quantifiable = function(str, regex_quantifiable, replacement)
      return get.str.str_by_replaced_onig_w_regex_str(
        str,
        regex_quantifiable .. "+$",
        replacement
      )
    end,
    str_by_final_continuous_replaced_eutf8_w_regex_quantifiable = function(str, regex_quantifiable, replacement)
      return get.str.str_and_int_by_replaced_eutf8_w_regex_str(
        str,
        regex_quantifiable .. "+$",
        replacement
      )
    end,
    str_by_removed_onig_w_regex_quantifiable = function(str, regex_quantifiable)
      return get.str.str_by_continuous_replaced_onig_w_regex_quantifiable(str, regex_quantifiable, "")
    end,
    str_by_removed_eutf8_w_regex_quantifiable = function(str, regex_quantifiable)
      return get.str.str_by_continuous_replaced_eutf8_w_regex_quantifiable(str, regex_quantifiable, "")
    end,
    str_by_final_removed_onig_w_regex_quantifiable = function(str, regex_quantifiable)
      return get.str.str_by_final_continuous_replaced_onig_w_regex_quantifiable(str, regex_quantifiable, "")
    end,
    str_by_final_removed_eutf8_w_regex_quantifiable = function(str, regex_quantifiable)
      return get.str.str_by_final_continuous_replaced_eutf8_w_regex_quantifiable(str, regex_quantifiable, "")
    end,
    str_by_removed_onig_w_regex_character_class_innards = function(str, regex_character_class_innards)
      return transf.str.str_by_removed_onig_w_regex_quantifiable(str, "[" .. regex_character_class_innards .. "]")
    end,
    str_by_removed_onig_inverted_w_regex_character_class_innards = function(str, regex_character_class_innards)
      return transf.str.str_by_removed_onig_w_regex_quantifiable(str, "[^" .. regex_character_class_innards .. "]")
    end,
    str_by_replaced_all_eutf8_w_regex_str_arr = function(str, regex_str_arr, replacement)
      local res = str
      for _, regex_str in transf.arr.kt_vt_stateless_iter(regex_str_arr) do
        res = get.str.str_and_int_by_replaced_eutf8_w_regex_str(
          res,
          regex_str,
          replacement
        )
      end
      return res
    end,
    str_by_replaced_w_ascii_str = plstringx.replace,
    str_by_replaced_all_w_ascii_str_arr = function(str, ascii_str_arr, replacement)
      local res = str
      for _, ascii_str in transf.arr.kt_vt_stateless_iter(ascii_str_arr) do
        res = get.str.str_by_replaced_w_ascii_str(res, ascii_str, replacement)
      end
      return res
    end,
    str_by_prepended_all_w_ascii_str_arr = function(str, ascii_str_arr, prepend)
      local res = str
      for _, ascii_str in transf.arr.kt_vt_stateless_iter(ascii_str_arr) do
        res = get.str.str_by_replaced_w_ascii_str(res, ascii_str, prepend .. ascii_str)
      end
      return res
    end,
    str_by_appended_all_w_ascii_str_arr = function(str, ascii_str_arr, append)
      local res = str
      for _, ascii_str in transf.arr.kt_vt_stateless_iter(ascii_str_arr) do
        res = get.str.str_by_replaced_w_ascii_str(res, ascii_str, ascii_str .. append)
      end
      return res
    end,
    str_by_replaced_first_eutf8_w_regex_str_arr = function(str, regex_str_arr, replacement)
      for _, regex_str in transf.arr.kt_vt_stateless_iter(regex_str_arr) do
        local res, matches = get.str.str_and_int_by_replaced_eutf8_w_regex_str(
          str,
          regex_str,
          replacement,
          1
        )
        if matches > 0 then
          return res
        end
      end
    end,
    n_strs_by_extracted_onig = onig.match,
    n_strs_by_extracted_eutf8 = eutf8.match,
    n_str_stateful_iter_by_extracted_onig = onig.gmatch,
    n_str_stateful_iter_by_extracted_eutf8 = eutf8.gmatch,
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
      if d then -- add d to global namespace so that it can be accessed in the str
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
    str_by_evaled_as_template = function(str, d)
      local res = get.str.str_and_int_by_replaced_eutf8_w_regex_str(str, "{{%[(.-)%]}}", function(item)
        return get.str.str_by_evaled_as_template(item, d)
      end)
      return res
    end,
    llm_response_str_freeform = function(str, temperature, max_tokens)
      return get.role_content_message_spec_arr.llm_response_str(
        {{
          content = str,
          role = "user"
        }},
        temperature,
        max_tokens
      )
    end,
    llm_response_str_strent = function(str, temperature, max_tokens)
      return get.role_content_message_spec_arr.llm_response_str(
        transf.role_content_message_spec_arr.api_role_content_message_spec_arr({{
          content = str,
          role = "user"
        }}),
        temperature,
        max_tokens
      )
    end,
    str_by_prompted_once_from_default = function(str, message)
      return transf.prompt_spec.any({
        prompter = transf.str_prompt_args_spec.str_or_nil_and_bool,
        prompt_args = {
          message = message,
          default = str,
        }
      })
    end,
    alphanum_minus_underscore_str_by_prompted_once_from_default = function(str, message)
      return transf.prompt_spec.any({
        prompter = transf.str_prompt_args_spec.str_or_nil_and_bool,
        transformed_validator = is.str.alphanum_minus_underscore,
        prompt_args = {
          message = message,
          default = str,
        }
      })
    end,
    str_arr_groups_ascii_fron_start = function(str, n)
      local res = {}
      for i = 1, #str, n do
        dothis.arr.push(res, str:sub(i, i + n - 1))
      end
      return res
    end,
    str_with_separator_grouped_ascii_from_start = function(str, n, sep)
      return get.str_or_number_arr.str_by_joined(get.str.str_arr_groups_ascii_fron_start(str, n), sep)
    end,
    str_arr_groups_ascii_from_end = function(str, n)
      local res = {}
      for i = #str, 1, -n do
        dothis.arr.push(res, str:sub(i - n + 1, i))
      end
      return res
    end,
    str_with_separator_grouped_ascii_from_end = function(str, n, sep)
      return get.str_or_number_arr.str_by_joined(get.str.str_arr_groups_ascii_from_end(str, n), sep)
    end,
    str_arr_groups_utf8_from_start = function(str, n)
      local res = {}
      for i = 1, transf.str.pos_int_by_len_utf8_chars(str), n do
        dothis.arr.push(res, get.str.str_by_sub_eutf8(str, i, i + n - 1))
      end
      return res
    end,
    str_with_separator_grouped_utf8_from_start = function(str, n, sep)
      return get.str_or_number_arr.str_by_joined(get.str.str_arr_groups_utf8_from_start(str, n), sep)
    end,
    str_arr_groups_utf8_from_end = function(str, n)
      local res = {}
      for i = transf.str.pos_int_by_len_utf8_chars(str), 1, -n do
        dothis.arr.push(res, get.str.str_by_sub_eutf8(str, i - n + 1, i))
      end
      return res
    end,
    str_with_separator_grouped_utf8_from_end = function(str, n, sep)
      return get.str_or_number_arr.str_by_joined(get.str.str_arr_groups_utf8_from_end(str, n), sep)
    end,
    number_or_nil = function(str,  base)
      local nonindicated_number_str = transf.str.nonindicated_number_str(str)
      return get.nonindicated_number_str.number(nonindicated_number_str, base)
    end,
    int_by_rounded_or_nil = function(str, base)
      local nonindicated_number_str = transf.str.nonindicated_number_str(str)
      return get.nonindicated_number_str.int_by_rounded_or_nil(nonindicated_number_str, base)
    end,
    two_integer_or_nils_by_onig_regex_match = onig.find,
    two_integer_or_nils_by_eutf8_regex_match = eutf8.find,
    str_arr_by_onig_regex_match = function(str, regex)
      local res = {}
      for match in get.str.n_str_stateful_iter_by_extracted_onig(str, regex) do
        dothis.arr.push(res, match)
      end
      return res
    end,
    two_str_arrs_by_onig_regex_match_nomatch = function(str, regex)
      local matches = {}
      local nomatches = {}
      local prev_index = 1
      while true do
        local start, stop = get.str.two_integer_or_nils_by_onig_regex_match(str, regex, prev_index)
        if start == nil then
          if prev_index <= #str then
            dothis.arr.push(nomatches, str:sub(prev_index))
          end          
          return matches, nomatches
        else
          dothis.arr.push(matches, str:sub(start, stop))
          if start > prev_index then
            dothis.arr.push(nomatches, str:sub(prev_index, start - 1))
          end
          prev_index = stop + 1
        end
      end
    end,
    str_arr_by_eutf8_regex_match = function(str, regex)
      local res = {}
      for match in get.str.n_str_stateful_iter_by_extracted_eutf8(str, regex) do
        dothis.arr.push(res, match)
      end
      return res
    end,
    two_str_arrs_by_eutf8_regex_match_nomatch = function(str, regex)
      local matches = {}
      local nomatches = {}
      local prev_index = 1
      while true do
        local start, stop = get.str.two_integer_or_nils_by_eutf8_regex_match(str, regex, prev_index)
        if start == nil then
          if prev_index <= transf.str.pos_int_by_len_utf8_chars(str) then
            dothis.arr.push(nomatches, get.str.str_by_sub_eutf8(str, prev_index))
          end          
          return matches, nomatches
        else
          dothis.arr.push(matches, get.str.str_by_sub_eutf8(str, start, stop))
          if start > prev_index then
            dothis.arr.push(nomatches, get.str.str_by_sub_eutf8(str, prev_index, start - 1))
          end
          prev_index = stop + 1
        end
      end
    end,
    str_by_shortened_start_ellipsis = function(str, len)
      return plstringx.shorten(str, len)
    end,
    str_by_shortened_end_ellipsis = function(str, len)
      return plstringx.shorten(str, len, true)
    end,
    str_by_with_yaml_metadata = function(str, tbl)
      if not str then return transf.table.yaml_metadata(tbl) end
      if not tbl then return str end
      if transf.table.pos_int_by_num_keys(tbl) == 0 then return str end
      local stripped_str = transf.str.not_starting_o_ending_with_whitespace_str(str)
      local final_metadata, final_contents
      if get.str.bool_by_startswith(stripped_str, "---") then
        -- splice in the metadata
        local parts = get.str.str_arr_split_noempty(str, "---") -- this should now have the existing metadata as [1], and the content as [2] ... [n]
        local extant_metadata = act.arr.shift(parts)
        final_metadata = extant_metadata .. "\n" .. transf.not_userdata_or_str.yaml_str(tbl)
        final_contents = get.str_or_number_arr.str_by_joined(parts)
        final_contents = final_contents .. "---"
      else
        final_metadata = transf.not_userdata_or_str.yaml_str(tbl)
        final_contents = str
      end
      return "---\n" .. final_metadata .. "\n---\n" .. final_contents
    end,
    not_userdata_or_fn_or_err_by_evaled_env_bash_parsed_json_in_key = function(str, key)
      local tbl = transf.str.table_or_err_by_evaled_env_bash_parsed_json(str)
      return get.table.vt_or_err(tbl, key)
    end,
    not_userdata_or_fn_or_nil_by_evaled_env_bash_parsed_json_in_key = function(str, key)
      return transf.n_anys_or_err_ret_fn.n_anys_or_nil_ret_fn_by_pcall(
        get.str.not_userdata_or_fn_or_err_by_evaled_env_bash_parsed_json_in_key
      )(str, key)
    end,
    str_or_err_by_evaled_env_bash_parsed_json_in_key = function(str, key)
      local tbl = transf.str.table_or_err_by_evaled_env_bash_parsed_json(str)
      local res = get.table.vt_or_err(tbl, key)
      if is.any.str(res) then
        return res
      else
        error("Not a str.")
      end
    end,
    str_or_nil_by_evaled_env_bash_parsed_json_in_key = function(str, key)
      return transf.n_anys_or_err_ret_fn.n_anys_or_nil_ret_fn_by_pcall(
        get.str.str_or_err_by_evaled_env_bash_parsed_json_in_key
      )(str, key)
    end,
    str_or_err_by_evaled_env_bash_parsed_json_in_key_stripped = function(str, key)
      return transf.str.not_starting_o_ending_with_whitespace_str(get.str.str_or_err_by_evaled_env_bash_parsed_json_in_key(str, key))
    end,
    str_or_nil_by_evaled_env_bash_parsed_json_in_key_stripped = function(str, key)
      return transf.n_anys_or_err_ret_fn.n_anys_or_nil_ret_fn_by_pcall(
        get.str.str_or_err_by_evaled_env_bash_parsed_json_in_key_stripped
      )(str, key)
    end,
    str_by_percent_encoded = function(str, as_path)
      if as_path then return transf.local_path.local_path_by_percent_encoded(str) 
      else return transf.str.encoded_query_param_value_by_folded(str) end
    end,
    not_starting_o_ending_with_whitespace_str = stringy.strip
  },
  nonindicated_number_str_arr = {
    number_arr = function(arr, base)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(
          get.nonindicated_number_str.number,
          {a_use, base}
        )
      )
    end,
  },
  nonindicated_number_str = {
    number = tonumber,
    int_by_rounded_or_nil = function(num, base)
      return transf.number.int_by_rounded(
        get.nonindicated_number_str.number(num, base)
      )
    end,
  },
  str_or_styledtext = {
    styledtext_ignore_styled = function(str, styledtext_attributes_specifier)
      if is.any.str(str) then
        return hs.styledtext.new(str, styledtext_attributes_specifier)
      else
        return str
      end
    end,
    styledtext_merge = function(str, styledtext_attributes_specifier)
      if is.any.str(str) then
        return hs.styledtext.new(str, styledtext_attributes_specifier)
      else
        return transf.styledtext.styledtext_merge(str, styledtext_attributes_specifier)
      end
    end,
  },
  styledtext = {
    styledtext_merge = function(styledtext, styledtext_attributes_specifier)
      local existing_style = styledtext:asTable()
      local text_str, style = get.arr.two_arrs_by_slice_w_3_pos_int_any_or_nils(existing_style, 1, 1)
      local new_styledtext = hs.styledtext.new(text_str, styledtext_attributes_specifier)
      for _, v in transf.arr.pos_int_vt_stateless_iter(style) do
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
  str_or_styledtext_arr = {
    styledtext_arr_merge = function(arr, styledtext_attributes_specifier)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.str_or_styledtext.styledtext_merge, {a_use, styledtext_attributes_specifier})
      )
    end,
  },
  str_or_number_arr = {
    str_by_joined = table.concat,
  },
  str_arr = {
    resplit_by_oldnew = function(arr, sep)
      return get.str.str_arr_by_split_w_str(
        get.str_arr.str_joined(
          arr,
          sep
        ),
        sep
      )
    end,
    resplit_by_new = function(arr, sep)
      return get.str.str_arr_by_split_w_str(
        get.str_arr.str_joined(
          arr,
          ""
        ),
        sep
      )
    end,
    resplit_by_oldnew_single_char = function(arr, sep)
      return get.str.str_arr_by_split_w_ascii_char(
        get.str_arr.str_joined(
          arr,
          sep
        ),
        sep
      )
    end,
    resplit_by_oldnew_single_char_noempty = function(arr, sep)
      return get.str.not_empty_str_arr_by_split_w_ascii_char(
        get.str_arr.str_joined(
          arr,
          sep
        ),
        sep
      )
    end,
    resplit_by_new_single_char = function(arr, sep)
      return get.str.str_arr_by_split_w_ascii_char(
        get.str_arr.str_joined(
          arr,
          ""
        ),
        sep
      )
    end,
    pos_int_or_nil_by_first_match_nohashcomment_noindent_w_str = function(arr, str)
      return get.arr.pos_int_or_nil_by_first_match_w_t(
        transf.str_arr.nohashcomment_noindent_str_arr(arr),
        str
      )
    end,
    pos_int_or_nil_by_first_match_ending_w_str = function(arr, str)
      return get.arr.pos_int_or_nil_by_first_match_w_fn(
        arr,
        get.fn.first_n_args_bound_fn(
          get.str.bool_by_endswith,
          str
        )
      )
    end,
    str_or_nil_by_first_match_ending_w_str = function(arr, str)
      return arr[
        get.arr.pos_int_or_nil_by_first_match_ending_w_str(arr, str)
      ]
    end,
    pos_int_or_nil_by_first_match_starting_w_str = function(arr, str)
      return get.arr.pos_int_or_nil_by_first_match_w_fn(
        arr,
        get.fn.first_n_args_bound_fn(
          get.str.bool_by_startswith,
          str
        )
      )
    end,
    str_or_nil_by_first_match_starting_w_str = function(arr, str)
      return arr[
        get.arr.pos_int_or_nil_by_first_match_starting_w_str(arr, str)
      ]
    end,

  },
  str_arr_arr = {
    str_record_arr = function(arr, field_sep)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(arr, function(x) return get.str_or_number_arr.str_by_joined(x, field_sep) end)
    end,
    str_table = function(arr, field_sep, record_sep)
      return get.str_or_number_arr.str_by_joined(get.str_arr_arr.str_record_arr(arr, field_sep), record_sep)
    end,
    
  },
  table_arr = {
    vt_arr_w_kt = function(arr, kt)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(arr, function(x) return x[kt] end)
    end,
  },
  path_leaf_specifier = {
    tag_value = function(parts, key)
      return transf.path_leaf_specifier.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc(parts)[key]
    end,
    tag_raw_value = function(parts, key)
      return transf.path_leaf_specifier.lower_alphanum_underscore_key_lower_alphanum_underscore_comma_value_assoc(parts)[key]
    end,
  },
  path = {
    usable_as_filetype = function(path, filetype)
      local extension = transf.path.extension_by_normalized(path)
      if get.arr.contains(ls.filetype[filetype], extension) then
        return true
      else
        return false
      end
    end,
    with_different_extension = function(path, ext)
      return transf.path.path_by_without_extension(path) .. "." .. ext
    end,
    leaf_starts_with = function(path, str)
      return get.str.bool_by_startswith(transf.path.leaflike_by_leaf(path), str)
    end,
    is_extension = function(path, ext)
      return transf.path.extension(path) == ext
    end,
    is_standartized_extension = function(path, ext)
      return transf.path.extension_by_normalized(path) == ext
    end,
    is_extension_in = function(path, exts)
      return get.arr.bool_by_contains(exts, transf.path.extension(path))
    end,
    is_standartized_extension_in = function(path, exts)
      return get.arr.bool_by_contains(exts, transf.path.extension_by_normalized(path))
    end,
    is_filename = function(path, filename)
      return transf.path.leaflike_by_filename(path) == filename
    end,
    is_leaf = function(path, leaf)
      return transf.path.leaflike_by_leaf(path) == leaf
    end,
    window_with_leaf_as_title = function(path, app_name)
      return get.str.window_by_title(
        transf.path.leaflike_by_leaf(path),
        app_name
      )
    end,
    path_component_arr_by_slice_w_slice_spec = function(path, spec)
      local path_component_arr = transf.path.path_component_arr(path)
      return get.arr.arr_by_slice_w_slice_spec(path_component_arr, spec)
    end,
    path_segment_arr_by_slice_w_slice_spec = function(path, spec)
      local path_segment_arr = transf.path.path_segment_arr(path)
      return get.arr.arr_by_slice_w_slice_spec(path_segment_arr, spec)
    end,
    path_from_sliced_path_component_arr = function(path, spec)
      local sliced_path_component_arr = transf.path.sliced_path_component_arr(path, spec)
      dothis.arr.push(sliced_path_component_arr, "")
      return get.str_or_number_arr.str_by_joined(sliced_path_component_arr, "/")
    end,
    path_from_sliced_path_segment_arr = function(path, spec)
      local sliced_path_segment_arr = transf.path.sliced_path_segment_arr(path, spec)
      dothis.arr.push(sliced_path_segment_arr, "")
      local extension = act.arr.pop(sliced_path_segment_arr)
      local filename = act.arr.pop(sliced_path_segment_arr)
      local leaf
      if extension == "" then
        leaf = filename
      else
        leaf = filename .. "." .. extension
      end
      if #sliced_path_segment_arr == 0 then
        return leaf
      else
        return get.str_or_number_arr.str_by_joined(sliced_path_segment_arr, "/") .. "/" .. leaf
      end
    end,
    path_arr_from_sliced_path_component_arr = function(path, spec)
      local sliced_path_component_arr = transf.path.sliced_path_component_arr(path, spec)
      local whole_path_component_arr = transf.path.path_component_arr(path)
      local res = {}
      local started_with_slash = get.str.bool_by_startswith(path, "/")
      
      -- Create a map for quick lookup of the index of each path component
      local path_component_index_map = {}
      for rawi, rawv in transf.arr.pos_int_vt_stateless_iter(whole_path_component_arr) do
        path_component_index_map[rawv] = rawi
      end
      
      for i, v in transf.arr.pos_int_vt_stateless_iter(sliced_path_component_arr) do
        -- Use the map to find the index of the current path component
        local rawi = path_component_index_map[v]
        if rawi then
          local relevant_path_components = get.arr.arr_by_slice_w_slice_spec(whole_path_component_arr, { start = 1, stop = rawi })
          if started_with_slash then
            dothis.arr.insert_at_index(relevant_path_components, 1, "") -- if we started with a slash, we need to reinsert an empty str at the beginning so that it will start with a slash again once we rejoin
          end
          res[i] = get.str_or_number_arr.str_by_joined(relevant_path_components, "/")
        end
      end
      
      return res
    end
  },
  absolute_path = {
    relative_path_from = function(path, starting_point)
      return get.str.str_by_no_prefix(path, get.str.str_by_with_suffix(starting_point, "/"))
    end,
  },
  extant_path = {
    --- @class itemsInPathOpts
    --- @field recursion? boolean | integer Whether to recurse into subdirectories, and how much. Default false (no recursion)
    --- @field include_dirs? boolean Whether to include directories in the returned table. Default true
    --- @field include_files? boolean Whether to include files in the returned table. Default true
    --- @field follow_links? boolean Whether to follow symlinks. Default false

    --- @param path str
    --- @param opts? itemsInPathOpts
    --- @param is_recursive_call? boolean Whether this is a recursive call. Allows us to avoid some duplicate work.
    --- @param depth? integer Internal use only. The current depth of recursion.  
    --- @param seen_paths? str[] Internal use only. A table of paths we have already seen. Used to avoid infinite recursion
    --- @return str[] #A table of all things in the directory
    absolute_path_arr = function(path, opts, is_recursive_call, depth, seen_paths)
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

      --- @cast opts itemsInPathOpts
    
      path = transf.path.path_by_ending_with_slash(path)
    
      if opts.follow_links then
        seen_paths = seen_paths or {}
        local links_resolved_path = hs.fs.pathToAbsolute(path)
        if get.arr.bool_by_contains(seen_paths, links_resolved_path) then
          return {}
        else
          dothis.arr.push(seen_paths, links_resolved_path)
        end
      end
    
      for file_name in transf.dir.absolute_path_stateful_iter_by_children(path) do
        if file_name ~= "." and file_name ~= ".." and file_name ~= ".DS_Store" then
          local file_path = path .. get.str.str_by_no_suffix(file_name, "/")
          if is.extant_path.dir(file_name) then 
            if opts.include_dirs then
              extant_paths[#extant_paths + 1] = file_path
            end
            local shouldRecurse = opts.recursion
            if is.any.number(opts.recursion) then
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
              local sub_files = get.local_extant_path.absolute_path_arr(file_path, opts, true, depth + 1, seen_paths)
              for _, sub_file in transf.arr.pos_int_vt_stateless_iter(sub_files) do
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
    extant_path_by_self_or_ancestor_w_fn = function(path, fn)
      local ancestor = path
      while ancestor ~= "/" or ancestor ~= "" do
        if fn(ancestor) then
          return ancestor
        else
          ancestor = transf.path.trimmed_noweirdwhitespace_line_by_parent_path(ancestor)
        end
      end
    end,
    extant_path_by_ancestor_w_fn = function(path, fn)
      return get.local_extant_path.extant_path_by_self_or_ancestor_w_fn(transf.path.trimmed_noweirdwhitespace_line_by_parent_path(path), fn)
    end,
    extant_path_by_self_or_ancestor_siblings_w_fn = function(path, fn)
      return get.local_extant_path.extant_path_by_self_or_ancestor_w_fn(path, function(x)
        return get.arr.pos_int_or_nil_by_first_match_w_fn(transf.dir.absolute_path_arr_by_children(transf.path.trimmed_noweirdwhitespace_line_by_parent_path(x)), fn)
      end)
    end,
    extant_path_by_self_or_ancestor_sibling_w_leaf = function(path, leaf)
      return get.local_extant_path.extant_path_by_self_or_ancestor_siblings_w_fn(path, function(x)
        return transf.path.leaflike_by_leaf(x) == leaf
      end)
    end,
    extant_path_by_descendant_w_fn = function(path, cond)
      return get.arr.pos_int_or_nil_by_first_match_w_fn(transf.extant_path.absolute_path_arr_by_descendants(path), cond)
    end,
    find_descendant_ending_with = function(path, ending)
      return get.path_arr.path_or_nil_by_first_ending_find_ending_w_str(transf.extant_path.absolute_path_arr_by_descendants(path), ending)
    end,
    find_leaf_of_descendant = function(path, filename)
      return get.path_arr.bool_by_contains_leaf(transf.extant_path.absolute_path_arr_by_descendants(path), filename)
    end,
    bool_by_descendant_with_extnesion = function(path, extension)
      return get.path_arr.bool_by_contains_extension(transf.extant_path.absolute_path_arr_by_descendants(path), extension)
    end,
    absolute_path_by_descendant_with_leaf = function(path, leaf)
      return get.path_arr.path_or_nil_by_first_having_leaf(transf.extant_path.absolute_path_arr_by_descendants(path), leaf)
    end,
    absolute_path_by_descendant_with_extension = function(path, extension)
      return get.path_arr.path_or_nil_by_first_having_extension(transf.extant_path.absolute_path_arr_by_descendants(path), extension)
    end,
    absolute_path_by_descendant_with_leaf_ending = function(path, leaf_ending)
      return get.path_arr.path_or_nil_by_first_having_leaf_ending(transf.extant_path.absolute_path_arr_by_descendants(path), leaf_ending)
    end,
    absolute_path_or_nil_by_descendant_with_filename_ending = function(path, filename_ending)
      return get.path_arr.path_or_nil_by_first_having_filename_ending(transf.extant_path.absolute_path_arr_by_descendants(path), filename_ending)
    end,
    absolute_path_by_descendant_with_filename = function(path, filename)
      return get.path_arr.path_or_nil_by_first_having_filename(transf.extant_path.absolute_path_arr_by_descendants(path), filename)
    end,
    bool_by_some_descendants_pass_w_fn = function(path, fn)
      return get.arr.bool_by_some_pass_w_fn(transf.extant_path.absolute_path_arr_by_descendants(path), fn)
    end,
    stream_creation_specifier = function(path, flag_profile_name)
      return {
        source_path = path,
        urls = transf.extant_path.url_or_local_path_arr_by_descendant_m3u_file_content_lines(path),
        type = "stream",
        flag_profile_name = flag_profile_name,
      }
    end,
    stream_creation_specifier_arr = function(path, flag_profile_name)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        transf.extant_path.m3u_file_arr_by_descendants(path),
        get.fn.arbitrary_args_bound_or_ignored_fn(
          get.m3u_file.stream_creation_specifier,
          {a_use, flag_profile_name} 
        )
      )
    end,
  },
  local_dir = {
    cmd_output_from_path = function(path, cmd)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("cd " .. transf.str.str_by_single_quoted_escaped(path) .. " && " .. cmd)
    end
  },
  local_extant_path = {
    cmd_output_from_path = function(path, cmd)
      if is.local_extant_path.local_dir(path) then
        return get.local_dir.cmd_output_from_path(path, cmd)
      else
        return get.local_dir.cmd_output_from_path(transf.path.trimmed_noweirdwhitespace_line_by_parent_path(path), cmd)
      end
    end,
    str_w_fs_attr_name = function(path, attr)
      return hs.fs.attributes(hs.fs.pathToAbsolute(path), attr)
    end,
    local_absolute_path_by_default_prompted_once = function(path, message)
      return transf.prompt_spec.any({
        prompter = transf.path_prompt_args_spec.local_absolute_path_and_bool,
        prompt_args = {default = path, message = message or "Choose an absolute path..."}
      })
    end,
    local_absolute_path_by_default_prompted_multiple = function(path, message)
      local intermediate_path = get.local_extant_path.local_absolute_path_by_default_prompted_once(path, message)
      return transf.local_absolute_path.local_absolute_path_by_prompted_multiple_from_default(intermediate_path)
    end,
    dir_by_default_prompted_once = function(path, message)
      return transf.prompt_spec.any({
        prompter = transf.path_prompt_args_spec.local_absolute_path_and_bool,
        prompt_args = {
          default = path,
          can_choose_files = false,
          message = message or "Choose a directory..."
        }
      })
    end,
    local_absolute_path_arr_by_default_prompted_once = function(path, message)
      return transf.prompt_spec.any({
        prompter = transf.path_prompt_args_spec.local_absolute_path_arr_and_bool,
        prompt_args = {default = path, message = message or "Choose absolute paths..."}
      })
    end,
  },
  dir = {
    extant_path_by_child_w_fn = function(dir, fn)
      return get.arr.pos_int_or_nil_by_first_match_w_fn(transf.dir.absolute_path_arr_by_children(dir), fn)
    end,
    extant_path_by_child_ending = function(dir, ending)
      return get.path_arr.path_or_nil_by_first_ending_find_ending_w_str(transf.dir.absolute_path_arr_by_children(dir), ending)
    end,
    bool_by_contains_leaf_of_child = function(dir, leaf)
      return get.path_arr.bool_by_contains_leaf(transf.dir.absolute_path_arr_by_children(dir), leaf)
    end,
    bool_by_extension_of_child = function(dir, extension)
      return get.path_arr.bool_by_contains_extension(transf.dir.absolute_path_arr_by_children(dir), extension)
    end,
    extant_path_by_child_having_leaf = function(dir, leaf)
      return get.path_arr.path_or_nil_by_first_having_leaf(transf.dir.absolute_path_arr_by_children(dir), leaf)
    end,
    extant_path_by_child_having_extension = function(dir, extension)
      return get.path_arr.path_or_nil_by_first_having_extension(transf.dir.absolute_path_arr_by_children(dir), extension)
    end,
    extant_path_by_child_having_leaf_ending = function(dir, leaf_ending)
      return get.path_arr.path_or_nil_by_first_having_leaf_ending(transf.dir.absolute_path_arr_by_children(dir), leaf_ending)
    end,
  },
  git_root_dir = {
    hook_path = function(path, hook)
      return transf.git_root_dir.in_git_dir_by_hooks_dir(path) .. "/" .. hook
    end,
    hook_res = function(path, hook)
      local hook_path = get.git_root_dir.hook_path(path, hook)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(hook_path)
    end,
  },
  in_git_dir = {
    remote_blob_url = function(path, branch)
      local git_remote_type = transf.in_git_dir.git_remote_type(path)
      branch = branch or transf.in_git_dir.str_by_current_branch(path)
      local remote_owner_item = transf.in_git_dir.two_strs_arr_or_nil_by_remote_owner_item(path)
      local relative_path = transf.in_git_dir.nonabsolute_path_by_from_git_root_dir(path)
      return get.git_hosting_service.file_url(
        transf.in_git_dir.host_by_remote_blob_host(path),
        tblmap.git_remote_type.printable_ascii_by_blob_indicator_path[git_remote_type],
        remote_owner_item,
        branch,
        relative_path
      )
    end,
    remote_raw_url = function(path, branch)
      local git_remote_type = transf.in_git_dir.git_remote_type(path)
      branch = branch or transf.in_git_dir.str_by_current_branch(path)
      local remote_owner_item = transf.in_git_dir.two_strs_arr_or_nil_by_remote_owner_item(path)
      local relative_path = transf.in_git_dir.nonabsolute_path_by_from_git_root_dir(path)
      return get.git_hosting_service.file_url(
        transf.in_git_dir.host_by_remote_raw_host(path),
        tblmap.git_remote_type.printable_ascii_by_raw_indicator_path[git_remote_type],
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
      return get.str.line_arr_by_tail(transf.plaintext_file.str_by_contents(path), n)
    end,
    lines_head = function(path, n)
      return get.str.line_arr_by_head(transf.plaintext_file.str_by_contents(path), n)
    end,
    nth_line = function(path, n)
      return transf.plaintext_file.line_arr(path)[n]
    end,
    contents_lines_appended = function(path, lines)
      local extlines = transf.plaintext_file.line_arr(path)
      return transf.two_arrs.arr_by_appended(extlines, lines)
    end,
    contents_line_appended = function(path, line)
      return dothis.plaintext_file.contents_lines_appended(path, {line})
    end,
    contents_lines_appended_to_str = function(path, lines)
      return get.str_or_number_arr.str_by_joined(dothis.plaintext_file.contents_lines_appended(path, lines), "\n")
    end,
    contents_line_appended_to_str = function(path, line)
      return dothis.plaintext_file.content_lines_appended_to_str(path, {line})
    end,
  },
  m3u_file = {
    stream_creation_specifier = function(path, flag_profile_name)
      return {
        source_path = path,
        urls = transf.plaintext_file.noempty_line_arr(path),
        type = "stream",
        flag_profile_name = flag_profile_name,
      }
    end
  },
  bib_file = {
    raw_citations = function(path, format)
      get.csl_table_or_csl_table_arr.raw_citations(transf.bib_file.csl_table_arr(path), format)
    end,
  },
  csl_table_or_csl_table_arr = {
    raw_citations = function(csl_table, style)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "pandoc --citeproc -f csljson -t plain --csl=" .. transf.csl_style.path(style) .. transf.not_userdata_or_fn.here_doc_by_json(csl_table)
      )
    end,
    
  },
  whisper_file = {
    table_by_transcribed = function(path, format, prompt, iso639_1)
      return get.fn.rt_or_nil_by_memoized_invalidate_1_year(rest, "rest")({
        api_name = "openai",
        endpoint = "audio/transcriptions",
        request_table_type = "form",
        request_table = {
          model = "whisper-1",
          file = transf.path.atpath(path),
          response_format = format,
          prompt = prompt,
          language = iso639_1,
        }
      })
    end,
    str_by_transcribed = function(path, prompt, iso639_1)
      return get.whisper_file.table_by_transcribed(path, "json", prompt, iso639_1)
    end,
    assoc_by_transcribed_detailed = function(path, prompt, iso639_1)
      return get.whisper_file.table_by_transcribed(path, "verbose_json", prompt, iso639_1)
    end,
  },
  csl_table_arr = {
    
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
    key_prefix_partial_dcmp_spec_force_first = function(csl_table, key)
      return transf.date_parts_single_or_range.prefix_partial_dcmp_spec_force_first(
        transf.csl_table.key_date_parts_single_or_range(csl_table, key)
      )
    end,
    key_year_force_first = function(csl_table, key)
      return transf.csl_table.key_prefix_partial_dcmp_spec_force_first(csl_table, key).year
    end,
  },
  shell_script_file = {
    lint_table = function(path, severity)
      return transf.str.table_or_err_by_evaled_env_bash_parsed_json("shellcheck --format=json --severity=" .. severity .. transf.str.str_by_single_quoted_escaped(path))
    end,
    str_or_nil_by_lint_gcc = function(path, severity)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("shellcheck --format=gcc --severity=" .. severity .. transf.str.str_by_single_quoted_escaped(path))
    end,
  },
  email_file = {
    with_body_quoted = function(path, response)
      return response .. "\n\n" .. transf.email_file.str_by_quoted_body(path)
    end,
    prefixed_header = function(path, header)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "mshow -qh" .. transf.str.str_by_single_quoted_escaped(header) .. transf.str.str_by_single_quoted_escaped(path)
      )
    end,
    str_by_header = function(path, header)
      local prefixed_header = transf.email_file.prefixed_header(path, header)
      return get.str.str_by_sub_eutf8(prefixed_header, #header + 2) -- +2 for the colon and the space
    end,
    addresses = function(path, header, only)
      if not get.arr.bool_by_contains(ls.email_headers_containin_emails, header) then
        error("Header can't contain email addresses")
      end
      only = get.any.default_if_nil(only, true)
      local headerpart
      if header then
        headerpart = "-h" .. transf.str.str_by_single_quoted_escaped(header)
      else
        headerpart = ""
      end
      local res = transf.str.str_or_nil_by_evaled_env_bash_stripped("maddr " .. (only and "-a" or "")  .. headerpart .. transf.str.str_by_single_quoted_escaped(path))
      return transf.arr.set(transf.str.line_arr(res))
    end,
    displayname_addresses_assoc_of_assocs = function(path, header)
      local w_displaynames = transf.email_file.addresses(path, header, false)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(w_displaynames, transf.email_or_displayname_email.displayname_email_assoc)
    end,

  },
  maildir_dir = {
    --- @param path str
    --- @param reverse? boolean
    --- @param magrep? str
    --- @param mpick? str
    --- @return str[]
    sorted_email_paths = function(path, reverse, magrep, mpick)
      local flags = "-d"
      if reverse then
        flags = flags .. "r"
      end
      local cmd = "mlist" .. transf.str.str_by_single_quoted_escaped(path)
      if magrep then
        cmd = cmd .. " | magrep -i" .. transf.str.str_by_single_quoted_escaped(magrep)
      end
      if mpick then
        cmd = cmd .. " | mpick -i" .. transf.str.str_by_single_quoted_escaped(mpick)
      end
      cmd = cmd .. " | msort " .. flags

      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped(cmd))
    end

  },
  alphanum_minus_underscore = {
    
  },
  email_specifier = {
    
  },
  sqlite_file = {
    csv_or_nil_by_query = function(path, query)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("sqlite3 -csv " .. transf.str.str_by_single_quoted_escaped(path) .. " " .. transf.str.str_by_single_quoted_escaped(query))
    end,
    json_or_nil_by_query = function(path, query)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("sqlite3 -json " .. transf.str.str_by_single_quoted_escaped(path) .. " " .. transf.str.str_by_single_quoted_escaped(query))
    end,
  },
  timestamp_ms_key_assoc_value_assoc = {
    timestamp_ms_key_assoc_value_assoc_by_filtered_timestamp = function(timestamp_ms_key_assoc_value_assoc, identifier)
      local timestamp = transf.backuped_thing_identifier.timestamp_ms(identifier)
      return get.assoc.assoc_by_filtered_w_kt_vt_fn(timestamp_ms_key_assoc_value_assoc, function(k, v)
        return k > timestamp
      end)
    end,
  },
  logging_dir = {
    log_path_for_date = function(path, date)
      return hs.fs.pathToAbsolute(path) .. "/" .. transf.date.triplex_local_nonabsolute_path_by_y_ym_ymd(date) .. ".csv"
    end,
  },
  path_arr = {
    path_arr_by_filter_to_same_filename = function(path_arr, filename)
      return get.arr.arr_by_filtered(path_arr, function(path)
        return get.path.is_filename(path, filename)
      end)
    end,
    path_arr_by_filter_to_different_filename = function(path_arr, filename)
      return get.arr.arr_by_filtered(path_arr, function(path)
        return not get.path.is_filename(path, filename)
      end)
    end,
    path_arr_by_filter_to_same_extension = function(path_arr, extension)
      return get.arr.arr_by_filtered(path_arr, function(path)
        return get.path.is_extension(path, extension)
      end)
    end,
    path_arr_by_filter_to_different_extension = function(path_arr, extension)
      return get.arr.arr_by_filtered(path_arr, function(path)
        return not get.path.is_extension(path, extension)
      end)
    end,
    path_arr_by_filter_to_filename_ending = function(path_arr, leaf_ending)
      return get.arr.arr_by_filtered(path_arr, function(path)
        return get.str.bool_by_endswith(transf.path.leaflike_by_filename(path), leaf_ending)
      end)
    end,
    path_arr_by_filter_to_filename_starting = function(path_arr, leaf_starting)
      return get.arr.arr_by_filtered(path_arr, function(path)
        return get.str.bool_by_startswith(transf.path.leaflike_by_filename(path), leaf_starting)
      end)
    end,

    path_or_nil_by_first_ending_find_ending_w_str = function(path_arr, ending)
      return get.str_arr.str_or_nil_by_first_match_ending_w_str(path_arr, ending)
    end,
    bool_by_contains_leaf = function(path_arr, leaf)
      return get.arr.bool_by_contains(transf.path_arr.leaflike_arr_by_leaves(path_arr), leaf)
    end,
    bool_by_contains_extension = function(path_arr, extension)
      return get.arr.bool_by_contains(transf.path_arr.extensions_arr(path_arr), extension)
    end,
    path_or_nil_by_first_having_leaf = function(path_arr, leaf)
      return get.arr.t_or_nil_by_first_match_w_fn(path_arr, function(path)
        return get.path.leaf(path) == leaf
      end)
    end,
    path_or_nil_by_first_having_extension = function(path_arr, extension)
      return get.arr.t_or_nil_by_first_match_w_fn(path_arr, function(path)
        return get.path.extension(path) == extension
      end)
    end,
    path_or_nil_by_first_having_leaf_ending = function(path_arr, leaf_ending)
      return get.arr.t_or_nil_by_first_match_w_fn(path_arr, function(path)
        return get.str.bool_by_endswith(get.path.leaf(path), leaf_ending)
      end)
    end,
    path_or_nil_by_first_having_filename = function(path_arr, filename)
      return get.arr.t_or_nil_by_first_match_w_fn(path_arr, function(path)
        return get.path.filename(path) == filename
      end)
    end,
    path_or_nil_by_first_having_filename_ending = function(path_arr, filename_ending)
      return get.arr.t_or_nil_by_first_match_w_fn(path_arr, function(path)
        return get.str.bool_by_endswith(get.path.filename(path), filename_ending)
      end)
    end,
  },
  extant_path_arr = {
    extant_path_arr_by_sorted_via_attr = function(arr, attr)
      return dothis.arr.sort(arr, function(a, b)
        return get.local_extant_path.attr(a, attr) < get.local_extant_path.attr(b, attr)
      end)
    end,
    extant_path_by_largest_of_attr = function(arr, attr)
      return get.extant_path_arr.extant_path_arr_by_sorted_via_attr(arr, attr)[1]
    end,
  },
  git_hosting_service = {
    file_url = function(host, indicator, owner_item, branch, relative_path)
      return "https://" .. host .. "/" .. owner_item .. "/" .. indicator .. branch .. "/" .. relative_path
    end,
  },
  dcmp_name = {
    dcmp_name_by_next = function(component, n)
      n = n or 0
      return get.arr.any_by_next_w_index(ls.date.dcmp_names, transf.dcmp_name.date_component_index(component) + n)
    end,
    dcmp_name_by_previous = function(component, n)
      n = n or 0
      return get.arr.t_or_nil_by_previous(ls.date.dcmp_names, transf.dcmp_name.date_component_index(component) - n)
    end,
  },
  date = {
    with_date_component_value_added = function(date, date_component_value, dcmp_name)
      local dtcp = date:copy()
      return dtcp["add" .. tblmap.dcmp_name.dcmp_name_long[dcmp_name] .. "s"](dtcp, date_component_value)
    end,
    with_date_component_value_subtracted = function(date, date_component_value, dcmp_name)
      return get.date.with_date_component_value_added(date, -date_component_value, dcmp_name)
    end,
    date_component_value = function(date, dcmp_name)
      return date["get" .. tblmap.dcmp_name.dcmp_name_long[dcmp_name]](date)
    end,
    surrounding_date_sequence_specifier = function(date, date_component_value, step, unit)
      return {
        start = get.date.with_date_component_value_subtracted(date, date_component_value, step),
        stop = get.date.with_date_component_value_added(date, date_component_value, step),
        step = step,
        unit = unit,
      }
    end,
    date_sequence_specifier_of_lower_component = function(date, step, dcmp_name)
      return get.full_dcmp_spec.date_sequence_specifier_of_lower_component(
        transf.date.full_dcmp_spec(date),
        step,
        dcmp_name
      )
    end,
    hours_date_sequence_specifier = function(date, date_component_value)
      return get.date.date_sequence_specifier_of_lower_component(date, date_component_value, "day")
    end,
    precision_date = function(date, dcmp_name)
      return get.full_dcmp_spec.precision_date(
        transf.date.full_dcmp_spec(date),
        dcmp_name
      )
    end,
    --- date_format_indicator = date_format or date_format_name
    str_w_date_format_indicator = function(date, format)
      local retrieved_format = tblmap.date_format_name.date_format[format]
      return date:fmt(retrieved_format or format)
    end,
    rfc3339like_dt_of_precision = function(date, precision)
      return get.date.str_w_date_format_indicator(date, tblmap.dcmp_name.rfc3339like_dt_format_str[precision])
    end,

  },
  timestamp_s = {
    str_w_date_format_indicator = function(timestamp_s, format)
      return get.date.str_w_date_format_indicator(
        transf.timestamp_s.date(timestamp_s),
        format
      )
    end,
  },
  timestamp_ms = {
    str_w_date_format_indicator = function(timestamp_s, format)
      return get.date.str_w_date_format_indicator(
        transf.timestamp_s.date(timestamp_s),
        format
      )
    end,
  },
  dcmp_name_list = {
    date_component_value_list = function(dcmp_name_list, dcmp_spec)
      return get.arr.arr_by_mapped_w_t_key_assoc(
        dcmp_name_list,
        dcmp_spec
      )
    end,
    date_component_value_ordered_list = function(dcmp_name_list, dcmp_spec)
      return get.arr.arr_by_mapped_w_t_key_assoc(
        transf.dcmp_name_arr.dcmp_name_seq(dcmp_name_list),
        dcmp_spec
      )
    end,
  },
  dcmp_spec = {
    date_sequence_specifier = function(dcmp_spec, step, unit)
      return {
        start = date(transf.dcmp_spec.full_dcmp_spec_by_min(dcmp_spec)),
        stop = date(transf.dcmp_spec.full_dcmp_spec_by_max(dcmp_spec)),
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
    arr = function(interval_specifier, step, unit)
      return transf.sequence_specifier.arr(
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
      specifier = transf.two_tables.table_by_take_new(transf.date_interval_specifier.event_table(date_interval_specifier), specifier)
      return get.khal.list_event_tables(
        specifier,
        include,
        exclude
      )
    end,
  },
  full_dcmp_spec = {
    prefix_partial_dcmp_spec = function(full_dcmp_spec, dcmp_name)
      return get.arr.arr_by_mapped_w_t_key_assoc(
        transf.dcmp_name.dcmp_spec_larger_or_same(dcmp_name),
        full_dcmp_spec
      )
    end,
    date_sequence_specifier_of_lower_component = function (full_dcmp_spec, step, dcmp_name, additional_steps_down)
      return get.dcmp_spec.date_sequence_specifier(
        get.full_dcmp_spec.prefix_partial_dcmp_spec(full_dcmp_spec, dcmp_name),
        step,
        get.dcmp_name.dcmp_name_by_next(dcmp_name, additional_steps_down)
      )      
    end,
    precision_full_dcmp_spec = function(full_dcmp_spec, dcmp_name)
      return transf.full_dcmp_spec.min_full_dcmp_spec(
        get.full_dcmp_spec.prefix_partial_dcmp_spec(full_dcmp_spec, dcmp_name)
      )
    end,
    precision_date = function(full_dcmp_spec, dcmp_name)
      return date(get.full_dcmp_spec.precision_full_dcmp_spec(full_dcmp_spec, dcmp_name))
    end,
  },
  rfc3339like_dt = {
    min_date_formatted = function(str, format)
      return transf.date.formatted(
        transf.rfc3339like_dt.date_by_min(str),
        format
      )
    end,
    max_date_formatted = function(str, format)
      return transf.date.formatted(
        transf.rfc3339like_dt.date_by_max(str),
        format
      )
    end,
  },
  arr_arr = {
    arr_by_column = plarray2d.column,
    arr_by_row = plarray2d.row,
    arr_arr_by_mapped_if_not_length_0 = function(arr_arr, fn)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr_arr,
        function(arr)
          if #arr == 0 then
            return arr
          else
            return fn(arr)
          end
        end
      )
    end,
    str_by_joined_any_pair_arr = function(arr, joiner)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.n_str_or_number_any_arr.str_by_joined_any_pair, {a_use, joiner})
      )
    end,
    str_by_joined_key_any_value_assoc = function(arr, joiner)
      return transf.pair_arr.assoc(
        get.n_str_or_number_any_arr_arr.str_by_joined_any_pair_arr(arr, joiner)
      )
    end,
    assoc_arr_by_arr = function(arr_arr, arr2)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr_arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(transf.two_arrs.assoc_by_zip_stop_shortest, {arr2, a_use})
      )
    end,
    assoc_of_arrs_by_first_element = function(arr_arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        arr_arr,
        transf.arr.t_and_arr_by_first_rest
      )
    end,
    assoc_of_assocs_by_first_element_and_arr = function(arr_arr, arr2)
      return get.assoc_of_arrs.assoc_of_assocs_by_arr(
        get.arr_arr.assoc_of_arrs_by_first_element(arr_arr),
        arr2
      )
    end,
    arr_arr_by_mapped = function(arr_arr, fn)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr_arr,
        get.fn.second_n_args_bound_fn(get.arr.arr_by_mapped, fn)
      )
    end,
    --- essentially flatMap
    arr_by_mapped_w_t_arg_t_ret_fn_and_flatten = function(arr, fn)
      return transf.arr.arr_by_flatten(
        get.arr.arr_by_mapped_w_t_arg_t_ret_fn(arr, fn)
      )
    end,
    arr_by_mapped_w_n_t_arg_t_ret_fn = function(arr, fn)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        function(nested_arr) return fn(transf.arr.n_anys(nested_arr)) end
      )
    end,

  },
  assoc_of_arrs = {
    assoc_of_assocs_by_arr = function(assoc_of_arr, arr2)
      return hs.fnutils.map(
        assoc_of_arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(transf.two_arrs.assoc_by_zip_stop_shortest, {arr2, a_use})
      )
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
    window_arr_by_pattern = function(app, pattern)
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
      return get.str.evaled_js_osa( ("Application('%s').windows()[%d].%s()"):format(
        window_specifier.application_name,
        window_specifier.window_index,
        property
      ))
    end,
  },
  jxa_tab_specifier = {
    property = function(tab_specifier, property)
      return get.str.evaled_js_osa( ("Application('%s').windows()[%d].tabs()[%d].%s()"):format(
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
    self_env_var_name_value_assoc = function(node, prev_key, key)
      prev_key = prev_key or ""
      if node.value then
        local value = node.value
        if type(node.value) == 'table' then -- list value
          value = get.str_or_number_arr.str_by_joined(
            get.arr.str_arr_by_mapped_values_w_fmt_str(node.value,  prev_key .. "%s"), -- todo: currently refactoring and I'm not sure that node.value is an arr, but I can't check rn. potentially needs replacing with a get.table call
            ":"
          )
        else
          value = prev_key .. value
        end
        local values = {
          [key] = value
        }
        if node.aliases then
          for _, alias in transf.arr.pos_int_vt_stateless_iter(node.aliases) do
            values[alias] = value
          end
        end
        return values
      else
        return {}
      end
    end,
    shell_var_name_key_str_value_assoc = function(node, prev_key, key)
      local self_assoc = get.detailed_env_node.self_env_var_name_value_assoc(node, prev_key, key)
      local dependent_assoc
      if node.dependents then
        dependent_assoc = get.detailed_env_node.shell_var_name_key_str_value_assoc(node.dependents, key)
      else
        dependent_assoc = {}
      end
      return transf.two_table_or_nils.table_by_take_new(self_assoc, dependent_assoc)
    end,
  },
  env_var_name_env_node_assoc = {
    shell_var_name_key_str_value_assoc = function(assoc, prev_key)
      if prev_key then prev_key = prev_key .. "/" else prev_key = "" end
      local values = {}
      for key, value in transf.table.kt_vt_stateless_iter(assoc) do
        if is.any.str(value) then
          values[key] = prev_key .. value
        else
          local subvalues = get.detailed_env_node.shell_var_name_key_str_value_assoc(value, prev_key, key)
          values = transf.two_table_or_nils.table_by_take_new(values, subvalues)
        end
      end
      return values
    end,
  },
  url = {

  },
  sgml_str = {
    sgml_str_or_nil_by_query_selector_all = function(str, selector)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)(
        "htmlq" .. transf.str.str_by_single_quoted_escaped(selector) .. transf.str.here_doc(str)
      )
    end,
    str_or_nil_by_query_selector_all = function(str, selector)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)(
        "htmlq --text" .. transf.str.str_by_single_quoted_escaped(selector) .. transf.str.here_doc(str)
      )
    end,
    str_or_nil_by_attribute_query_selector_all = function(str, selector, attribute)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)(
        "htmlq --attribute " .. transf.str.str_by_single_quoted_escaped(attribute) .. transf.str.str_by_single_quoted_escaped(selector) .. transf.str.here_doc(str)
      )
    end,
    -- non-all seems to not be possible with htmlq. At least for html_, it would be possible if we parsed the html, but for text_, there seems to be no indication of when each result ends.
  },
  sgml_url = {
    sgml_str_or_nil_by_query_selector_all = function(url, selector)
      return get.sgml_str.sgml_str_or_nil_by_query_selector_all(
        transf.sgml_url.sgml_str(url),
        selector
      )
    end,
    str_or_nil_by_query_selector_all = function(url, selector)
      return get.sgml_str.str_or_nil_by_query_selector_all(
        transf.sgml_url.sgml_str(url),
        selector
      )
    end,
    str_or_nil_by_attribute_query_selector_all = function(url, selector, attribute)
      return get.sgml_str.str_or_nil_by_attribute_query_selector_all(
        transf.sgml_url.sgml_str(url),
        selector,
        attribute
      )
    end,
  },
  url_arr = {
    absolute_path_key_assoc_of_url_files = function(arr, root)
      return get.nonabsolute_path_key_assoc.absolute_path_key_assoc(
        transf.url_arr.nonabsolute_path_key_assoc_of_url_files(arr),
        root
      )
    end,
    stream_creation_specifier = function(arr, flag_profile_name)
      return {
        urls = arr,
        type = "stream",
        flag_profile_name = flag_profile_name
      }
    end,
  },
  omegat_project_dir = {
    source_files_extension = function(dir, ext)
      return get.path_arr.path_arr_by_filter_to_same_extension(
        transf.omegat_project_dir.source_files(dir),
        ext
      )
    end,
    target_files_extension = function(dir, ext)
      return get.path_arr.path_arr_by_filter_to_same_extension(
        transf.omegat_project_dir.source_files(dir),
        ext
      )
    end,
  },
  project_dir = {
    local_project_material_path = function(dir, type)
      return transf.path.path_by_ending_with_slash(dir) .. type .. "/"
    end,
    local_subtype_project_material_path = function(dir, type, subtype)
      return get.project_dir.local_project_material_path(dir, type) .. subtype .. "/"
    end,
    local_universal_project_material_path = function(dir, type)
      return get.project_dir.local_subtype_project_material_path(dir, type, "universal")
    end,
    global_project_material_path = function(dir, type)
      return transf.path.path_by_ending_with_slash(env.MPROJECT_MATERIALS) .. type .. "/"
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
    full_name_in_language_str = function(code, language_identifier_str)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_str({
        query = "Get the short name of a country from its ISO 3366-1 alpha-2 code in the language '" .. language_identifier_str .. "'",
        input = code
      })
    end,
    --- don't use this for english, use transf.iso_3366_1_alpha_2.iso_3336_1_short_name instead
    short_name_in_language_str = function(code, language_identifier_str)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_str({
        query = "Get the short name of a country from its ISO 3366-1 alpha-2 code in the language '" .. language_identifier_str .. "'",
        input = code
      })
    end,
  },
  any = {
    join_if_arr = function(arg, separator)
      if is.any.arr(arg) then
        return get.str_or_number_arr.str_by_joined(arg, separator)
      else
        return arg
      end
    end,
    arr_repeated = function(arg, times)
      local result = {}
      for i = 1, times do
        dothis.arr.insert_at_index(result, arg)
      end
      return result
    end,
    repeated = function(arr, times)
      return transf.arr.n_anys(get.any.arr_repeated(arr, times))
    end,
    applicable_thing_name_hierarchy = function(any, local_thing_name_hierarchy, parent)
      local_thing_name_hierarchy = local_thing_name_hierarchy or get.table.table_by_copy(thing_name_hierarchy, true)
      parent = parent or "any"
      local res = {}
      for thing_name, child_thing_name_hierarchy_or_leaf_indication_str in transf.table.kt_vt_stateless_iter(thing_name_hierarchy) do
        local passes = is[parent][thing_name](any)
        if passes then
          if is.any.table(child_thing_name_hierarchy_or_leaf_indication_str) then
            res[thing_name] = get.any.applicable_thing_name_hierarchy(any, child_thing_name_hierarchy_or_leaf_indication_str, thing_name)
          else
            res[thing_name] = child_thing_name_hierarchy_or_leaf_indication_str
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
        retriever_specifier.target
      ][
        retriever_specifier.thing_name
      ](value)
    end,
  },
  retriever_specifier_arr = {
    result_highest_precedence = function(arr, value)
      return get.retriever_specifier.result(
        transf.retriever_specifier_arr.highest_precedence_retriever_specifier(arr),
        value
      )
    end,
    result_arr = function(arr, value)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr, 
        get.fn.arbitrary_args_bound_or_ignored_fn(get.retriever_specifier.result, {a_use, value})
      )
    end,
    result_joined = function(arr, value)
      return get.str_or_number_arr.str_by_joined(
        get.retriever_specifier.result_arr(arr, value),
        " | "
      )
    end,
  },
  thing_name_arr = {
    bool_by_chained_and = function(arr, value)
      local previous_thing_name = nil
      for _, thing_name in transf.arr.pos_int_vt_stateless_iter(arr) do
        if previous_thing_name then
          local fn = rawget(rawget(is, previous_thing_name), thing_name)
          if fn then
            if not fn(value) then
              return false
            end
          else
            error("No such function: is." .. previous_thing_name .. "." .. thing_name)
          end
        end
        previous_thing_name = thing_name
      end
      return true
    end,
    chooser_text = function(arr, value)
      return get.retriever_specifier_arr.result_highest_precedence(
        transf.thing_name_arr.chooser_text_retriever_specifier_arr(arr),
        value
      )
    end,
    placeholder_text = function(arr, value)
      return get.retriever_specifier_arr.result_highest_precedence(
        transf.thing_name_arr.placeholder_text_retriever_specifier_arr(arr),
        value
      )
    end,
    chooser_image = function(arr, value)
      return get.retriever_specifier_arr.result_highest_precedence(
        transf.thing_name_arr.chooser_image_retriever_specifier_arr(arr),
        value
      )
    end,
    chooser_subtext = function(arr, value)
      return get.retriever_specifier_arr.result_joined(
        transf.thing_name_arr.chooser_subtext_retriever_specifier_arr(arr),
        value
      )
    end,
    pos_int_by_initial_selected_index = function(arr, value)
      return get.retriever_specifier_arr.result_highest_precedence(
        transf.thing_name_arr.initial_selected_retriever_specifier_arr(arr),
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
  chooser_item_specifier_arr = {
    styled_chooser_item_specifier_arr = function(arr, chooser_item_specifier_text_key_styledtext_attributes_specifier_assoc)
      local res = get.table.table_by_copy(arr)
      for i, chooser_item_specifier in transf.arr.pos_int_vt_stateless_iter(res) do
        local text_styledtext_attribute_specifier = transf.two_table_or_nils.table_by_take_new( {
          font = {size = 14 },
          color = { red = 0, green = 0, blue = 0, alpha = 0.7 },
        }, chooser_item_specifier_text_key_styledtext_attributes_specifier_assoc.styledtext_attribute_specifier.text)
        local subtext_styledtext_attribute_specifier = transf.two_table_or_nils.table_by_take_new( {
          font = {size = 12 },
          color = { red = 0, green = 0, blue = 0, alpha = 0.5 },
        }, chooser_item_specifier_text_key_styledtext_attributes_specifier_assoc.styledtext_attribute_specifier.subtext)
        res[i].text = get.str_or_styledtext.styledtext_merge(
          chooser_item_specifier.text,
          text_styledtext_attribute_specifier
        )
        res[i].subText = get.str_or_styledtext.styledtext_merge(
          chooser_item_specifier.subText,
          subtext_styledtext_attribute_specifier
        )
      end
    end
  },
  ipc_socket_id = {
    response_table_or_nil = function(ipc_socket_id, request_table)
      return get.str.not_userdata_or_fn_or_nil_by_evaled_env_bash_parsed_json_in_key(
        "echo '" .. json.encode(request_table) .. "' | /opt/homebrew/bin/socat UNIX-CONNECT:" .. transf.ipc_socket_id.ipc_socket_path(ipc_socket_id) .. " STDIO",
        "data"
      )
    end
  },
  mpv_ipc_socket_id = {
    str = function(id, key)
      return get.ipc_socket_id.response_table_or_nil(id, {
        command = { "get_property", key }
      } )
    end,
    int = function(id, key)
      return get.str_or_number.int_by_rounded_or_nil(
        get.mpv_ipc_socket_id.str(id, key)
      )
    end,
    bool_emoji = function(id, key)
      local res = get.mpv_ipc_socket_id.str(id, key)
      if res then return tblmap.stream_attribute.true_emoji[key]
      else return tblmap.stream_attribute.false_emoji[key] end
    end,
  },
  created_item_specifier_arr = {
    created_item_specifier_w_creation_specifier = function(arr, creation_specifier)
      return get.arr.t_or_nil_by_first_match_w_fn(
        arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.table.bool_by_key_equals_value, {a_use, "creation_specifier", creation_specifier})
      )
    end,
    pos_int_w_creation_specifier = function(arr, creation_specifier)
      return get.arr.pos_int_or_nil_by_first_match_w_fn(
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
            return transf.arr.n_anys(res, start_res_at, end_res_at)
          end
        end
      end
    end
  },
  two_anys_stateful_generator = {
    assoc = function(gen, ...)
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
    arr = function(gen, ...)
      local res = {}
      local iter = gen(...)
      while true do
        local val = {iter()}
        if #val == 0 then
          break
        end
        dothis.arr.insert_at_index(res, val)
      end
      return res
    end
  },
  bin_specifier = {
    str = function(bin_specifier, bool)
      if bool then
        return bin_specifier.vt
      else
        return bin_specifier.vf
      end
    end,
    bool = function(bin_specifier, str)
      if str == bin_specifier.vt then
        return true
      elseif str == bin_specifier.vf then
        return false
      else
        error("invalid argument")
      end
    end,
    str_by_inverted = function(bin_specifier, bool)
      return get.bin_specifier.str(bin_specifier, not bool)
    end,
    bool_by_inverted = function(bin_specifier, str)
      if str == bin_specifier.vt then
        return false
      elseif str == bin_specifier.vf then
        return true
      else
        error("invalid argument")
      end
    end,
    str_or_bool_by_inverted = function(bin_specifier, str_or_bool)
      if is.any.str(str_or_bool) then
        return get.bin_specifier.str_by_inverted(bin_specifier, str_or_bool)
      else
        return get.bin_specifier.bool_by_inverted(bin_specifier, str_or_bool)
      end
    end
  },
  two_numbers = {
    number_by_sum_modulo_n = function(a, b, n)
      return (a + b) % n
    end,
    number_by_difference_modulo_n = function(a, b, n)
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
    get_extracted_attr_assoc_via_ai = function(video_id, do_after)
      return get.form_filling_specifier.filled_str_assoc({
        in_fields = {
          title = transf.youtube_video_id.line_by_title(video_id),
          channel_title = transf.youtube_video_id.line_by_channel_title(video_id),
          description = get.str.str_by_shortened_start_ellipsis(transf.youtube_video_id.str_by_description(video_id)),
        },
        form_field_specifier_arr = {
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
  youtube_video_id_arr = {
    youtube_playlist_creation_specifier = function(arr, name, desc, privacy)
      return {
        name = name,
        desc = desc,
        privacy = privacy,
        youtube_video_id_arr = arr
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
      if not is.any.arr(arg_spec) then
        arg_spec = { arg_spec }
      end
      if not is.any.arr(ignore_spec) then
        ignore_spec = { ignore_spec }
      end
      
      -- initialize inner_func to the original function
      local inner_func = function(...)
        local args = {...}
        dothis.arr.sort(ignore_spec, function(a, b) return a > b end)
        for _, index in transf.arr.pos_int_vt_stateless_iter(ignore_spec) do
          dothis.arr.remove_by_index(args, index)
        end
        local new_args = {}
        for index, arg in transf.arr.pos_int_vt_stateless_iter(arg_spec) do -- for all arg_lists to bind
          if arg == a_use then
            new_args[index] = act.arr.shift(args)
          else
            new_args[index] = arg
          end
        end
        for _, arg in transf.arr.pos_int_vt_stateless_iter(args) do -- for all remaining args
          dothis.arr.insert_at_index(new_args, arg)
        end
        return func(transf.arr.n_anys(new_args))
      end

      return inner_func
    end,
    second_n_args_bound_fn = function(func, ...)
      return get.fn.arbitrary_args_bound_or_ignored_fn(
        func,
        transf.any_and_arr.arr(
          a_use,
          transf.n_anys.arr(...)
        )
      )
    end,
    --- @class memoOpts
    --- @field is_async? boolean whether we are memoizing an async function. Defaults to false
    --- @field invalidation_mode? "invalidate" | "reset" | "none" whether and in what way to invalidate the cache. Defaults to "none"
    --- @field interval? number how often to invalidate the cache, in seconds. Defaults to 0
    --- @field strify_table_params? boolean whether to strify table params before using them as keys in the cache. Defaults to false. However, this is ignored if mode = "fs", as we need to strify the params to use them as a path
    --- @field table_param_subset? "json" | "no-fn-userdata-loops" | "any" whether table params that will be strified will only contain jsonifiable values, anything that a lua table can contain but functions, userdata, and loops, or anything that a lua table can contain. Speed: "json" > "no-fn-userdata-loops" > "any". Defaults to "json"

    --- memoize a function if it's not already memoized, or return the memoized version if it is
    --- @generic I, O
    --- @param fn fun(...: I): O
    --- @param opts? memoOpts
    --- @param fnname? str the name of the function. Optional, but required for fsmemoization and switches to fsmemoization if provided, since we need to use the function name to create a unique cache path. We can't rely on an automatically generated identifier, since this may change between sessions
    --- @return fun(...: I): (O), hs.timer?
    rt_or_nil_by_memoized = function(fn, opts, fnname)
      local fnid = fnname or transf.fn.fnid(fn) -- get a unique id for the function, using lua's tostr function, which uses the memory address of the function and thus is unique for each function
    
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
      opts.strify_table_params = get.any.default_if_nil(opts.strify_table_params, false)
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
          return transf.arr.n_anys(result) -- we're sure to have a result now, so we can return it
        else
          --- @cast callback fun(...: any)
          if result then -- if we have a result, we can call the callback immediately
            callback(transf.arr.n_anys(result))
          else -- else we need to call the original function and wrap the callback to store the result in the cache before calling it
            fn(transf.arr.n_anys(params), function(...)
              local result = {...}
              dothis[fnidentifier_type].put_memo(fnid, opts_as_str, params, result, opts)
              callback(transf.arr.n_anys(result))
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
    rt_or_nil_by_memoized_invalidate = function(fn, interval, fnname)
      return get.fn.rt_or_nil_by_memoized(fn, {
        invalidation_mode = "invalidate",
        interval = interval
      }, fnname)
    end,
    rt_or_nil_by_memoized_invalidate_1_day = function(fn, fnname)
      return get.fn.rt_or_nil_by_memoized_invalidate(fn, 60 * 60 * 24, fnname)
    end,
    rt_or_nil_by_memoized_invalidate_1_week = function(fn, fnname)
      return get.fn.rt_or_nil_by_memoized_invalidate(fn, 60 * 60 * 24 * 7, fnname)
    end,
    rt_or_nil_by_memoized_invalidate_1_month = function(fn, fnname)
      return get.fn.rt_or_nil_by_memoized_invalidate(fn, 60 * 60 * 24 * 30, fnname)
    end,
    rt_or_nil_by_memoized_invalidate_1_year = function(fn, fnname)
      return get.fn.rt_or_nil_by_memoized_invalidate(fn, 60 * 60 * 24 * 365, fnname)
    end,
    rt_or_nil_by_memoized_invalidate_5_minutes = function(fn, fnname)
      return get.fn.rt_or_nil_by_memoized_invalidate(fn, 60 * 5, fnname)
    end,
    rt_or_nil_by_memoized_invalidate_strify_json = function(fn, interval, fnname)
      return get.fn.rt_or_nil_by_memoized(fn, {
        invalidation_mode = "invalidate",
        interval = interval,
        strify_table_params = true,
        table_param_subset = "json"
      }, fnname)
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
    local_absolute_path_by_in_cache_w_str_and_arr_or_nil = function(fnname, optsstr, args)
      local path = transf.fnname.local_absolute_path_by_in_cache(fnname)

      if optsstr then
        path = path .. optsstr .. "/"
      end
      if args then 
        -- encode args to json and hash it, to use as the key for the cache
        local hash = transf.not_userdata_or_fn.hex_str_by_md5(args)
        path = path .. hash
      end
      return path
    end,
    rt_by_memo = function(fnid, opts_as_str, params, opts)
      local cache_path = get.fnname.local_absolute_path_by_in_cache_w_str_and_arr_or_nil(fnid, opts_as_str, params)
      local raw_cnt = transf.file.str_by_contents(cache_path)
      if not raw_cnt then return nil end
      return json.decode(raw_cnt)
    end,
    timestamp_s_by_created_time = function(fnid, opts_as_str)
      local cache_path = get.fnname.local_absolute_path_by_in_cache_w_str_and_arr_or_nil(fnid, opts_as_str, "~~~created~~~") -- this is a special path that is used to store the time the cache was created
      return get.str_or_number.number_or_nil(transf.file.str_by_contents(cache_path)) or os.time() -- if the file doesn't exist, return the current time
    end,
  },
  fnid = {
    rt_by_memo = function(fnid, opts_as_str, params, opts)
      memstore[fnid] = memstore[fnid] or {}
      memstore[fnid][opts_as_str] = memstore[fnid][opts_as_str] or {}
      local node = memstore[fnid][opts_as_str]
      for i=1, #params do
        local param = params[i]
        if param == nil then param = nil_singleton 
        elseif opts.strify_table_params and is.any.table(param) then
          if opts.table_param_subset == "json" then
            param = json.encode(param)
          elseif opts.table_param_subset == "no-fn-userdata-loops" then
            param = shelve.marshal(param)
          elseif opts.table_param_subset == "any" then
            param = hs.inspect(param, { depth = 4 })
          end
        end
        node = node.children and node.children[param]
        if not node then return nil end
      end
      return get.table.table_by_copy(node.results, true)
    end,
    timestamp_s_by_created_time = function() -- no special functionality here, just needs to exist for polymorphic implementation with fscache
      return os.time()
    end
  },
  form_field_specifier_arr = {
    form_filling_specifier = function(specarr, in_fields)
      return {
        form_field_specifier_arr = specarr,
        in_fields = in_fields
      }
    end,
    filled_str_assoc_from_str = function(specarr, str)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        specarr,
        function (form_field_specifier)
          return 
            form_field_specifier.alias or form_field_specifier.value, 
            get.str.n_strs_by_extracted_eutf8(str, form_field_specifier.value .. "[^\n]-: *(.-)\n") or get.str.n_strs_by_extracted_eutf8(str, form_field_specifier.value .. "[^\n]-: *(.-)$")
        end
      )
    end,
    filled_str_assoc_from_str_arr = function(specarr, in_fields)
      return get.form_filling_specifier.filled_str_assoc(
        get.form_field_specifier_arr.form_filling_specifier(
          specarr,
          in_fields
        )
      )
    end
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
      local children = get.tree_node_like_arr.tree_node_arr(raw_children, treeify_spec)
      return {
        label = label,
        children = children
      }
    end
  },
  tree_node_like_arr = {
    tree_node_arr = function(tree_node_like_arr, treeify_spec)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        tree_node_like_arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.tree_node_like.tree_node, {a_use, treeify_spec})
      )
    end,
  },
  tree_node = {
    arr_arr_by_root_path = function(node, path, include_inner)
      path = get.table.table_by_copy(path) or {}
      dothis.arr.push(path, node.label)
      local res = {}
      if not node.children or include_inner then
        res = {path}
      end
      if node.children then
        res = transf.two_arrs.arr_by_appended(
          res, 
          get.tree_node_arr.arr_arr_by_label(
            node.children, 
            path, 
            include_inner
          )
        )
      end
      return res
    end
  },
  tree_node_arr = {
    arr_arr_by_root_path = function(arr, path, include_inner)
      local res = {}
      for _, node in transf.arr.pos_int_vt_stateless_iter(arr) do
        res = transf.two_arrs.arr_by_appended(
          res, 
          get.tree_node.arr_arr_by_label(node, path, include_inner)
        )
      end
      return res
    end,
  },
  n_any_assoc_arr = {
    leaf_label_with_title_path = function(arr, title_key)
      local leaf = get.table.table_by_copy(act.arr.pop(arr))
      local title_path = get.table_arr.vt_arr_w_kt(arr, title_key)
      leaf.path = title_path
      return leaf
    end
  },
  n_any_assoc_arr_arr = {
    assoc_leaf_labels_with_title_path_arr = function(arr, title_key)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.n_any_assoc_arr.leaf_label_with_title_path, {a_use, title_key})
      )
    end,
  },
  role_content_message_spec_arr = {
    llm_response_str = function(arr, temperature, max_tokens)
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
  n_shot_role_content_message_spec_arr = {
    n_shot_llm_spec = function(arr)


    end,
  },
  n_shot_llm_spec = {
    n_shot_api_query_llm_response_str = function(spec, temperature, max_tokens)
      local res = get.role_content_message_spec_arr.llm_response_str(
        transf.n_shot_llm_spec.n_shot_api_query_role_content_message_spec_arr(spec),
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
  not_userdata_or_fn = {
    md5_base32_crock_str_of_length = function(any, length)
      return transf.not_userdata_or_fn.base32_crock_str_by_md5(any):sub(1, length)
    end,
  },
  export_chat_main_object = {
    backuped_thing_identifier = function(obj, typ)
      return typ .. "/" .. transf[typ .. "_export_chat_main_object"].str_by_id(obj)
    end,
    timestamp_ms_last_backup = function(obj, typ)
      return transf.backuped_thing_identifier.timestamp_ms(
        transf.export_chat_main_object.backuped_thing_identifier(obj, typ)
      )
    end,
    id_key_timestamp_ms_value_assoc = function(main_object, typ)
      local res = {}
      for _, msg in ipairs(main_object.messages) do
        res[msg.id] = get.export_chat_message.timestamp_ms(msg, typ)
      end
      return res
    end,
    dir_by_target_backup_location = function(obj, typ)
      return env.MCHATS .. "/" .. transf.export_chat_main_object.backuped_thing_identifier(obj, typ)
    end,
    logging_dir = function(obj, typ)
      return transf.export_chat_main_object.dir_by_target_backup_location(obj, typ) .. "/_logs"
    end,
    media_dir = function(obj, typ)
      return transf.export_chat_main_object.dir_by_target_backup_location(obj, typ) .. "/media"
    end,
    timestamp_ms_key_msg_spec_value_assoc_by_filtered = function(obj, typ)
      return get.export_chat_message_arr.timestamp_ms_key_msg_spec_value_assoc_by_filtered(
        obj.messages,
        typ,
        transf.export_chat_main_object.timestamp_ms_last_backup(obj, typ)
      )
    end,
  },
  export_chat_message = {
    msg_spec = function(msg, typ, obj)
      local export_chat_message_type = typ .. "_export_chat_message"
      return {
        author = transf[export_chat_message_type].str_by_author(msg),
        content = transf[export_chat_message_type].str_by_content(msg),
        attachments = transf[export_chat_message_type].absolute_path_arr_by_attachments(msg),
        reactions = transf[export_chat_message_type].reaction_spec_arr(msg),
        call_duration = transf[export_chat_message_type].int_or_nil_by_call_duration(msg),
        sticker_emoji = transf[export_chat_message_type].str_or_nil_by_sticker_emoji(msg),
        replying_to_timestamp = get[export_chat_message_type].timestamp_ms_or_nil_by_replying_to(msg, obj),
      }
    end,
    timestamp_ms = function(msg, typ)
      return transf[
        typ .. "_export_chat_message"
      ].timestamp_ms(msg)
    end,

  },
  export_chat_message_arr = {
    timestamp_ms_key_msg_spec_value_assoc_by_filtered = function(arr, typ, timestamp_ms)
      local res = {}
      for _, msg in transf.arr.pos_int_vt_stateless_iter(arr) do
        local msg_timestamp_ms = get.export_chat_message.timestamp_ms(msg, typ)
        if msg_timestamp_ms >= timestamp_ms then
          res[msg_timestamp_ms] = get.export_chat_message.msg_spec(msg, typ)
        end
      end
      return res
    end
  },
  discord_export_chat_message = {
    timestamp_ms_or_nil_by_replying_to = function(msg, obj)
      return get.fn.rt_or_nil_by_memoized(
        get.export_chat_main_object.id_key_timestamp_ms_value_assoc
      )(obj, "discord")[msg.reference.messageId]
    end,
    absolute_path_arr_by_attachments = function(msg, obj)
      local media_dir = get.export_chat_main_object.media_dir(obj, "discord")
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        msg.attachments or {},
        function(att)
          return media_dir .. "/" .. transf.path.leaflike_by_leaf(att.uri)
        end
      )
    end
  },
  facebook_export_chat_message = {
    timestamp_ms_or_nil_by_replying_to = function(msg)
      return nil -- facebook doesn't have replies in its export
    end,
    absolute_path_arr_by_attachments = function(msg, obj)
      local media_dir = get.export_chat_main_object.media_dir(obj, "facebook")
      local res = {}

      for _, attachment_type in transf.arr.pos_int_vt_stateless_iter({"photos", "videos", "files", "audio_files", "gifs", "share", "sticker", "animated_image_attachments"}) do
        if msg[attachment_type] then
          for _, attachment in transf.arr.pos_int_vt_stateless_iter(msg[attachment_type]) do
            local attachment_path = media_dir .. "/" .. transf.path.leaflike_by_leaf(attachment.uri)
            dothis.res.push(res, attachment_path)
          end
        end
      end

      return res
    end
  },
  signal_export_chat_message = {
    timestamp_ms_or_nil_by_replying_to = function(msg)
      if msg.quote then
        return msg.quote.id -- despite the name, this is actually the timestamp
      end
    end,
    absolute_path_arr_by_attachments = function(msg, obj)
      if msg.attachments then
        local media_dir = get.export_chat_main_object.media_dir(obj, "signal")
        return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
          msg.attachments,
          function(att)
            return media_dir .. "/" .. att.fileName
          end
        )
      else
        return {}
      end
    end,

  },
  telegram_export_chat_message = {
    timestamp_ms_or_nil_by_replying_to = function(msg, obj)
      return get.fn.rt_or_nil_by_memoized(
        get.export_chat_main_object.id_key_timestamp_ms_value_assoc
      )(obj, "telegram")[msg.reply_to_message_id]
    end,
    absolute_path_arr_by_attachments = function(msg, obj)
      if msg.file then
        local media_dir = get.export_chat_main_object.media_dir(obj, "telegram")
        return {media_dir .. "/" .. transf.path.leaflike_by_leaf(msg.file)}
      else
        return {}
      end
    end
  },
}