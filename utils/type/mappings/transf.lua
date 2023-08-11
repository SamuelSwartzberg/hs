--- maps one thing_name to another thing_name
--- so transf.<thing_name1>.<thing_name2>(<thing1>) -> <thing2>
transf = {
  nonindicated_number_string_array = {
    number_base_2_array = function(hex_array)
      return get.nonindicated_number_string_array.number_array(hex_array, 2)
    end,
    number_base_8_array = function(hex_array)
      return get.nonindicated_number_string_array.number_array(hex_array, 8)
    end,
    number_base_10_array = function(hex_array)
      return get.nonindicated_number_string_array.number_array(hex_array, 10)
    end,
    number_base_16_array = function(hex_array)
      return get.nonindicated_number_string_array.number_array(hex_array, 16)
    end,
  },
  nonindicated_number_string = {
    number_base_2 = function(num)
      return get.nonindicated_number_string.number_or_nil(num, 2)
    end,
    number_base_8 = function(num)
      return get.nonindicated_number_string.number_or_nil(num, 8)
    end,
    number_base_10 = function(num)
      return get.nonindicated_number_string.number_or_nil(num, 10)
    end,
    number_base_16 = function(num)
      return get.nonindicated_number_string.number_or_nil(num, 16)
    end,
  },
  indicated_number_string = {
    number_string = function(indicated_number)
      return indicated_number:sub(3)
    end,
    base_letter = function(indicated_number)
      return indicated_number:sub(2, 2)
    end,
    base = function(indicated_number)
      return tblmap.base_letter.base[
        transf.indicated_number_string.base_letter(indicated_number)
        ]
    end,
    number = function(indicated_number)
      return get.nonindicated_number_string.number_or_nil(
        indicated_number:sub(3),
        transf.indicated_number_string.base(indicated_number)
      )
    end,
  },
  percent_encoded_octet = {
    char = function(percent)
      local num = percent:sub(2, 3)
      return string.char(get.string_or_number.number_or_nil(num, 16))
    end,
  },
  unicode_codepoint_string = { -- U+X...`
    number = function(codepoint)
      return get.nonindicated_number_string.number_or_nil(transf.unicode_codepoint_string.nonindicated_hex_number_string(codepoint), 16)
    end,
    nonindicated_hex_number_string = function(codepoint)
      return codepoint:sub(3)
    end,
    unicode_prop_table = function(codepoint)
      return get.fn.rt_or_nil_by_memoized(transf.string.not_userdata_or_function_or_err_by_evaled_env_bash_parsed_json)(
        "uni print -compact -format=all -as=json" 
        .. transf.string.single_quoted_escaped(
          codepoint
        )
      )[1]
    end
  },
  indicated_utf8_hex_string = {
    unicode_prop_table = function(str)
      return get.fn.rt_or_nil_by_memoized(transf.string.not_userdata_or_function_or_err_by_evaled_env_bash_parsed_json)(
        "uni print -compact -format=all -as=json" 
        .. transf.string.single_quoted_escaped(
          str
        )
      )[1]
    end
  },
  unicode_prop_table = {
    unicode_codepoint_binary_string = function(unicode_prop_table)
      return unicode_prop_table.bin
    end,
    unicode_block_name = function(unicode_prop_table)
      return unicode_prop_table.block
    end,
    unicode_category_name = function(unicode_prop_table)
      return unicode_prop_table.cat
    end,
    char = function(unicode_prop_table)
      return unicode_prop_table.char
    end,
    unicode_codepoint = function(unicode_prop_table)
      return unicode_prop_table.cpoint
    end,
    unicode_codepoint_decimal_string = function(unicode_prop_table)
      return unicode_prop_table.dec
    end,
    unicode_codepoint_hex_string = function(unicode_prop_table)
      return unicode_prop_table.hex
    end,
    unicode_codepoint_octal_string = function(unicode_prop_table)
      return unicode_prop_table.oct
    end,
    html_entity = function(unicode_prop_table)
      return unicode_prop_table.html
    end,
    unicode_character_name = function(unicode_prop_table)
      return unicode_prop_table.name
    end,
    unicode_plane = function(unicode_prop_table)
      return unicode_prop_table.plane
    end,
    utf8_hex_string = function(unicode_prop_table)
      return transf.string.nowhitespace_string(unicode_prop_table.utf8)
    end,
    summary = function(unicode_prop_table)
      return transf.unicode_prop_table.char(unicode_prop_table) .. ": "
        .. transf.unicode_prop_table.unicode_codepoint(unicode_prop_table) .. " "
        .. transf.unicode_prop_table.unicode_character_name(unicode_prop_table)
    end,
  },
  unicode_prop_table_array = {
    unicode_prop_table_item_array = function(unicode_prop_table_array)
      return hs.fnutils.imap(
        unicode_prop_table_array,
        CreateUnicodePropTable
      )
    end,
  },
  number = {
    sign_indicator = function(num)
      if num < 0 then
        return "-"
      else
        return ""
      end
    end,
    
    nonindicated_decimal_number_string = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.nonindicated_decimal_number_string(transf.number.pos_number(num))
    end,
    separated_nonindicated_decimal_number_string = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.separated_nonindicated_decimal_number_string(transf.number.pos_number(num))
    end,
    indicated_decimal_number_string = function(num)
      return transf.number.sign_indicator(num) .. "0d" .. transf.pos_number.nonindicated_decimal_number_string(transf.number.pos_number(num))
    end,
    nonindicated_hex_number_string = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.nonindicated_hex_number_string(transf.number.pos_number(num))
    end,
    separated_nonindicated_hex_number_string = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.separated_nonindicated_hex_number_string(transf.number.pos_number(num))
    end,
    indicated_hex_number_string = function(num)
      return transf.number.sign_indicator(num) .. "0x" .. transf.pos_number.nonindicated_hex_number_string(transf.number.pos_number(num))
    end,
    byte_hex_number_string_array = function(num)
      return  get.string.string_array_groups_ascii_from_end(
        transf.number.nonindicated_hex_number_string(num),
        2
      )
    end,
    two_byte_hex_number_string_array = function(num)
      return  get.string.string_array_groups_ascii_from_end(
        transf.number.nonindicated_hex_number_string(num),
        4
      )
    end,
    
    noninciated_octal_number_string = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.noninciated_octal_number_string(transf.number.pos_number(num))
    end,

    separated_nonindicated_octal_number_string = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.separated_nonindicated_octal_number_string(transf.number.pos_number(num))
    end,
    indicated_octal_number_string = function(num)
      return transf.number.sign_indicator(num) .. "0o" .. transf.pos_number.noninciated_octal_number_string(transf.number.pos_number(num))
    end,

    nonindicated_binary_number_string = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.nonindicated_binary_number_string(transf.number.pos_number(num))
    end,
    separated_nonindicated_binary_number_string = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.separated_nonindicated_binary_number_string(transf.number.pos_number(num))
    end,
    indicated_binary_number_string = function(num)
      return transf.number.sign_indicator(num) .. "0b" .. transf.pos_number.nonindicated_binary_number_string(transf.number.pos_number(num))
    end,
    int_by_rounded = function(num)
      return math.floor(num + 0.5)
    end,
    int_or_nil = function(num)
      if is.number.int(num) then
        return num
      else
        return nil
      end
    end,
    pos_int_or_nil = function(num)
      if is.number.int(num) and num > 0 then
        return num
      else
        return nil
      end
    end,
    neg_int_or_nil = function(num)
      if is.number.int(num) and num < 0 then
        return num
      else
        return nil
      end
    end,
    pos_number = function(num)
      return math.abs(num)
    end,
    neg_number = function(num)
      return -math.abs(num)
    end,
    pos_int = function(num)
      return transf.number.pos_number(transf.number.int_by_rounded(num))
    end,
    neg_int = function(num)
      return transf.number.pos_numbert(transf.number.int_by_rounded(num))
    end,
    floor_int = math.floor,
    ceil_int = math.ceil,
    pos_int_part = function(num)
      return transf.number.floor_int(
        transf.number.pos_number(num)
      )
    end,
    pos_float_part = function(num)
      return transf.number.pos_number(num) - transf.number.pos_int_part(num)
    end,
    pos_int_float_part = function(num)
      return transf.nonindicated_number_string.number_base_10(
        tostring(
          transf.number.pos_float_part(num)
        ):sub(3)
      )
    end,
    with_1_added = function(num)
      return num + 1
    end,
    with_1_subtracted = function(num)
      return num - 1
    end,
  },
  pos_number = { 
    nonindicated_decimal_number_string = function(num)
      return 
        transf.pos_int.nonindicated_decimal_number_string(
          transf.number.pos_int_part(num)
        ) .. 
        (
          transf.number.pos_float_part(num) == 0 and "" or 
          (
            "." .. transf.pos_int.nonindicated_decimal_number_string(
              transf.number.pos_int_float_part(num)
            )
          )
        )
      end,
    separated_nonindicated_decimal_number_string = function(num)
      return 
        transf.pos_int.separated_nonindicated_decimal_number_string(
          transf.number.pos_int_part(num)
        ) .. 
        (
          transf.number.pos_float_part(num) == 0 and "" or 
          (
            "." .. transf.pos_int.separated_nonindicated_decimal_number_string(
              transf.number.pos_int_float_part(num)
            )
          )
        )
      end,
    nonindicated_hex_number_string = function(num)
      return transf.pos_int.nonindicated_hex_number_string(
        transf.number.pos_int_part(num)
      ) .. 
      (
        transf.number.pos_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.nonindicated_hex_number_string(
            transf.number.pos_int_float_part(num)
          )
        )
      )
    end,
    separated_nonindicated_hex_number_string = function(num)
      return transf.pos_int.separated_nonindicated_hex_number_string(
        transf.number.pos_int_part(num)
      ) .. 
      (
        transf.number.pos_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.separated_nonindicated_hex_number_string(
            transf.number.pos_int_float_part(num)
          )
        )
      )
    end,
    noninciated_octal_number_string = function(num)
      return transf.pos_int.noninciated_octal_number_string(
        transf.number.pos_int_part(num)
      ) .. 
      (
        transf.number.pos_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.noninciated_octal_number_string(
            transf.number.pos_int_float_part(num)
          )
        )
      )
    end,
    separated_nonindicated_octal_number_string = function(num)
      return transf.pos_int.separated_nonindicated_octal_number_string(
        transf.number.pos_int_part(num)
      ) .. 
      (
        transf.number.pos_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.separated_nonindicated_octal_number_string(
            transf.number.pos_int_float_part(num)
          )
        )
      )
    end,
    nonindicated_binary_number_string = function(num)
      return transf.pos_int.nonindicated_binary_number_string(
        transf.number.pos_int_part(num)
      ) .. 
      (
        transf.number.pos_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.nonindicated_binary_number_string(
            transf.number.pos_int_float_part(num)
          )
        )
      )
    end,
    separated_nonindicated_binary_number_string = function(num)
      return transf.pos_int.separated_nonindicated_binary_number_string(
        transf.number.pos_int_part(num)
      ) .. 
      (
        transf.number.pos_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.separated_nonindicated_binary_number_string(
            transf.number.pos_int_float_part(num)
          )
        )
      )
    end,
  },
  neg_number = {

  },
  num_chars = {
    normzeilen = function(num_chars)
      return transf.number.int_by_rounded(
        num_chars / 55
      )
    end,
  },
  
  int = {
    length = function(int)
      return #tostring(int)
    end,
    pos_int_or_nil = function(int)
      if int > 0 then
        return int
      else
        return nil
      end
    end,
    neg_int_or_nil = function(int)
      if int < 0 then
        return int
      else
        return nil
      end
    end,
    random_int_of_length = function(int)
      return math.random(
        transf.pos_int.smallest_int_of_length(int),
        transf.pos_int.largest_int_of_length(int)
      )
    end,
  },
  pos_int = {
    random_base64_gen_string_of_length = function(int)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("openssl rand -base64 " .. tostring(transf.number.int_by_rounded(int * 3/4))) -- 3/4 because base64 takes the int to be the input length, but we want to specify the output length (which is 4/3 the input length in case of base64)
    end,
    nonindicated_decimal_number_string = function(num)
      return tostring(num)
    end,
    separated_nonindicated_decimal_number_string = function(num)
      return get.string.string_with_separator_grouped_ascii_from_end(
        transf.pos_int.nonindicated_decimal_number_string(num),
        3,
        " "
      )
    end,
    nonindicated_hex_number_string = function(num)
      return string.format("%X", num)
    end,
    separated_nonindicated_hex_number_string = function(num)
      return get.string.string_with_separator_grouped_ascii_from_end(
        transf.pos_int.nonindicated_hex_number_string(num),
        2,
        " "
      )
    end,
    noninciated_octal_number_string = function(num)
      return string.format("%o", num)
    end,
    separated_nonindicated_octal_number_string = function(num)
      return get.string.string_with_separator_grouped_ascii_from_end(
        transf.pos_int.noninciated_octal_number_string(num),
        3,
        " "
      )
    end,
    nonindicated_binary_number_string = function(num)
      return string.format("%b", num)
    end,
    separated_nonindicated_binary_number_string = function(num)
      return get.string.string_with_separator_grouped_ascii_from_end(
        transf.pos_int.nonindicated_binary_number_string(num),
        4,
        " "
      )
    end,
    indicated_utf8_hex_string = function(int)
      return "utf8:" .. transf.pos_int.nonindicated_hex_number_string(int)
    end,
    largest_int_of_length = function(int)
      return 10^int - 1
    end,
    smallest_int_of_length = function(int)
      return (transf.pos_int.largest_int_of_length(int)+1) / 10
    end,
    center_int_of_length = function(int)
      return (transf.pos_int.largest_int_of_length(int)+1) / 2
    end,
    unicode_codepoint_string = function(num)
      return "U+" .. transf.pos_int.nonindicated_hex_number_string(num)
    end,
    unicode_prop_table_from_unicde_codepoint = function(num)
      return transf.unicode_codepoint_string.unicode_prop_table(transf.pos_int.unicode_codepoint_string(num))
    end,
    unicode_prop_table_from_utf8 = function(num)
      return  transf.indicated_utf8_hex_string.unicode_prop_table(transf.pos_int.indicated_utf8_hex_string(num))
    end,
    ascii_char = function(num)
      return string.char(num)
    end,
    gelbooru_post_url = function(pos_int)
      return "https://gelbooru.com/index.php?page=post&s=view&id=" .. pos_int
    end,
    danbooru_post_url = function(pos_int)
      return "https://danbooru.donmai.us/posts/" .. pos_int
    end,
  },
  pos_int_array = {
    unicode_codepoint_string_array = function(arr)
      return hs.fnutils.imap(
        arr,
        transf.pos_int.unicode_codepoint_string
      )
    end,
    ascii_char_array = function(arr)
      return hs.fnutils.imap(
        arr,
        transf.pos_int.ascii_char
      )
    end,
    string_from_ascii_char_array = function(arr)
      return get.string_or_number_array.string_by_joined(
        transf.pos_int.ascii_char_array(arr)
      )
    end,
    unicode_prop_table_array_from_unicode_codepoint_array = function(arr)
      return get.fn.rt_or_nil_by_memoized(transf.string.table_or_err_by_evaled_env_bash_parsed_json)(
        "uni print -compact -format=all -as=json" 
        .. transf.string.single_quoted_escaped(
          get.string_or_number_array.string_by_joined(
            transf.pos_int.unicode_codepoint_string_array(arr),
            " "
          )
        )
      )
    end,
    indicated_utf8_hex_string_array = function(arr)
      return hs.fnutils.imap(
        arr,
        transf.pos_int.indicated_utf8_hex_string
      )
    end,
    unicode_prop_table_array_from_utf8_array = function(arr)
      return get.fn.rt_or_nil_by_memoized(transf.string.table_or_err_by_evaled_env_bash_parsed_json)(
        "uni print -compact -format=all -as=json" 
        .. transf.string.single_quoted_escaped(
          get.string_or_number_array.string_by_joined(
            transf.pos_int.indicated_utf8_hex_string_array(arr),
            " "
          )
        )
      )
    end,
  },
  not_nil = {
    string = function(arg)
      if arg == nil then
        return nil
      else
        return transf.any.string(arg)
      end
    end,
  },
  array = {
    array_by_reversed = function(arr)
      local res = {}
      for i = #arr, 1, -1 do
        dothis.array.push(res, arr[i])
      end
      return res
    end,
    t_by_first = function(arr)
      return arr[1]
    end,
    t_by_last = function(arr)
      return arr[#arr]
    end,
    pos_int_by_length = function(arr)
      return #arr
    end,
    t_and_array_by_first_rest = function(arr)
      return arr[1], get.array.array_by_slice_w_3_pos_int_any_or_nils(arr, 2)
    end,
    array_by_nofirst = function(arr)
      return get.array.array_by_slice_w_3_pos_int_any_or_nils(arr, 2)
    end,
    array_by_nolast = function(arr)
      return get.array.array_by_slice_w_3_pos_int_any_or_nils(arr, 1, -2)
    end,
    empty_string_value_dict = function(arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        arr,
        transf.any.self_and_empty_string
      )
    end,
    string_array = function(arr)
      return hs.fnutils.imap(
        arr,
        transf.any.string
      )
    end,
    contents_summary = function(arr)
      return transf.string_array.contents_summary(
        transf.array.string_array(arr)
      )
    end,
    summary = function(arr)
      return "array ("..#arr.."):" .. transf.array.contents_summary(arr)
    end,
    multiline_string = function(arr)
      return transf.string_array.multiline_string(transf.array.string_array(arr))
    end,
    
    index_value_stateless_iter = ipairs,
    index_value_stateful_iter = get.stateless_generator.stateful_generator(transf.array.index_value_stateless_iter),
    index_stateful_iter = get.stateless_generator.stateful_generator(transf.array.index_value_stateless_iter, 1, 1),
    value_boolean_dict = function(arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(arr, function(v) return v, true end)
    end,
    set = function(arr)
      return transf.table_or_nil.kt_array(
        transf.array.value_boolean_dict(arr)
      )
    end,
    permutation_array = function(arr)
      if #arr == 0 then
        return {{}}
      else
        return get.any_stateful_generator.array(combine.permute, arr)
      end
    end,
    powerset = function(arr)
      if #arr == 0 then
        return {{}}
      else
        local output = transf.array_and_any.array( get.any_stateful_generator.array(combine.powerset, arr), {} )
        return output
      end
    end,
    n_anys = function(t)
      return table.unpack(t)
    end,
    initial_selected_index = function(arr)
      return get.thing_name_array.initial_selected_index(
        transf.any.applicable_thing_name_array(arr)
      ) or 1 
    end,
  },
  hole_y_arraylike = {
    array = function(tbl)
      local new_tbl = transf.table.determined_array_table({})
      for i = 1, #tbl do
        if tbl[i] ~= nil then
          new_tbl[#new_tbl + 1] = tbl[i]
        end
      end
      return new_tbl
    end
  },
  two_id_assocs = {
    bool_by_equal = function(t1, t2)
      return t1.id == t2.id
    end,
  },
  assoc_array = {
    assoc_with_index_as_key_array = function(arr)
      local res = get.table.table_by_copy(arr, true)
      for i, v in transf.array.index_value_stateless_iter(arr) do
        v.index = i
      end
      return res
    end,
  },
  char = {
    hex = function(char)
      return string.format("%02X", string.byte(char))
    end,
    percent = function(char)
      return string.format("%%%02X", string.byte(char))
    end,
    unicode_prop_table = function(char)
      return get.fn.rt_or_nil_by_memoized(transf.string.table_or_err_by_evaled_env_bash_parsed_json)("uni identify -compact -format=all -as=json".. transf.string.single_quoted_escaped(char))[1]
    end
  },
  leaf = {
    rf3339like_dt_or_interval_general_name_fs_tag_string = function(leaf)
      return onig.match(
        leaf,
        ("^(%s(?:_to_%s)?--)?([^%%]*)(%%.*)?$"):format(
          mt._r.date.rfc3339like_dt,
          mt._r.date.rfc3339like_dt
        )
      )
    end,
  },
  path = {
    form_path = function(path)
      return "@" .. path
    end,
    path_component_array = function(path)
      if path == "" then
        return {""}
      elseif path == "/" then
        return {"/"}
      else
        -- remove leading and trailing slashes
        if eutf8.sub(path, 1, 1) == "/" then
          path = eutf8.sub(path, 2)
        end
        if eutf8.sub(path, -1) == "/" then
          path = eutf8.sub(path, 1, -2)
        end

        -- split into components
        return get.string.string_array_split_single_char(path, "/")
      end
    end,
    pos_int_by_path_component_array_length = function(path)
      return #transf.path.path_component_array(path)
    end,
    path_array_of_path_component_array = function(path)
      return get.path.path_array_from_sliced_path_component_array(
        get.path.path_component_array(path),
        {start = 1, stop = -1}
      )
    end,
    path_segments = function(path)
      local path_components = transf.path.path_component_array(path)
      local leaf = dothis.array.pop(path_components)
      local without_extension = ""
      local extension = ""
      if leaf == "" then
        -- already both empty, nothing to do
      elseif stringy.startswith(leaf, ".") then -- dotfile
        without_extension = leaf
      elseif stringy.endswith(leaf, ".") then -- file that ends with a dot, does not count as having an extension
        without_extension = leaf
      elseif not stringy.find(leaf, ".") then
        without_extension = leaf
      else -- in case of multiple dots, everything after the last dot is considered the extension
        without_extension, extension = eutf8.match(leaf, transf.string.whole_regex(mt._r_lua.without_extension_and_extension))
      end
      dothis.array.push(path_components, without_extension)
      dothis.array.push(path_components, extension)
    end,
    extension = function(path)
      local psegments = transf.path.path_segments(path)
     ---@diagnostic disable-next-line: need-check-nil -- path_segments always returns a table with at least two elements for any valid path
      return psegments[#psegments]
    end,
    normalized_extension = function(path)
      return normalize.extension[
        transf.path.extension(path)
      ]
    end,
    path_without_extension = function(path)
      return get.path.path_from_sliced_path_segment_array(
        get.path.path_segments(path),
        {start = 1, stop = -2}
      )
    end,
    filename = function(path)
      local psegments = transf.path.path_segments(path)
      dothis.array.pop(psegments)
      ---@diagnostic disable-next-line: need-check-nil -- path_segments always returns a table with at least two elements for any valid path
      return psegments[#psegments]
    end,
    ending_with_slash = function(path)
      return get.string.string_by_with_suffix(path or "", "/")
    end,
    initial_path_component = function(path)
      return transf.path.path_component_array(path)[1]
    end,
    leaf = function(path)
      local pcomponents = transf.path.path_component_array(path)
      return pcomponents[#pcomponents]
    end,
    parent_path = function(path)
      return get.path.path_from_sliced_path_component_array(
        get.path.path_component_array(path),
        {start = 1, stop = -2}
      )
    end,
    parent_leaf = function(path)
      local pcomponents = transf.path.path_component_array(path)
      dothis.array.pop(pcomponents)
      return pcomponents[#pcomponents]
    end,
    parent_path_component_array = function(path)
      return transf.path.path_component_array(
        transf.path.parent_path(path)
      )
    end,
    parent_path_array_of_path_component_array = function(path)
      return transf.path.path_array_of_path_component_array(
        transf.path.parent_path(path)
      )
    end,
    path_leaf_specifier = function(path)
      local rf3339like_dt_or_interval, general_name, fs_tag_string = transf.leaf.rf3339like_dt_or_interval_general_name_fs_tag_string(transf.path.leaf(path))
      return {
        extension = transf.path.extension(path),
        path = transf.path.parent_path(path),
        rfc3339like_dt_or_range = rf3339like_dt_or_interval,
        general_name = general_name,
        fs_tag_assoc = transf.fs_tag_string.fs_tag_assoc(fs_tag_string),
      }
    end,
    window_array_with_leaf_as_title = function(path)
      return transf.string.window_array_by_title(transf.path.leaf(path))
    end,
    local_or_remote_string = function(path)
      if is.path.remote_path(path) then
        return "remote"
      else
        return "local"
      end
    end,
    parent_path_with_extension_if_any = function(path)
      local extension = transf.path.extension(path)
      local parent_path = transf.path.parent_path(path)
      local new_path = parent_path .. extension
      return new_path
    end,

  },
  path_with_intra_file_locator = {
    path_with_intra_file_locator_specifier = function(path)
      local parts = stringy.split(path, ":")
      local final_part = dothis.array.pop(parts)
      local specifier = {}
      if is.string.number_string(parts[#parts]) then
        specifier = {
          column = final_part,
          line = dothis.array.pop(parts),
          path = get.string_or_number_array.string_by_joined(parts, ":")
        }
      else
        specifier = {
          line = final_part,
          path = get.string_or_number_array.string_by_joined(parts, ":")
        }
      end
      return specifier
    end,
  },
  path_with_intra_file_locator_specifier = {
    line = function(specifier)
      return specifier.line
    end,
    column = function(specifier)
      return specifier.column
    end,
    path = function(specifier)
      return specifier.path
    end,
    intra_file_locator = function(specifier)
      if specifier.column then
        return ":" .. specifier.line .. ":" .. specifier.column
      else
        return ":" .. specifier.line
      end
    end,
    input_spec_array = function(specifier)
      return ":ctrl+g,:+" .. transf.path_with_intra_file_locator_specifier.intra_file_locator(specifier) .. ",:+return"
    end,
     
  },
  local_path = {
    local_absolute_path = hs.fs.pathToAbsolute, -- resolves ~, ., .., and symlinks
    local_path_by_percent_encoded = function(path)
      return plurl.quote(path)
    end,
  },
  remote_path = {

  },
  absolute_path = {
    file_url = function(path)
      return transf.local_absolute_path.file_url(transf.absolute_path.local_absolute_path(path))
    end,
  },
  local_absolute_path = {
    file_url = function(path)
      return "file://" .. path
    end,
    prompted_multiple_local_absolute_path_from_default = function(path)
      return transf.prompt_spec.any_array({
        prompter = transf.prompt_args_string.string_or_nil_and_boolean,
        prompt_args = {
          message =  "Enter a subdirectory (or file, if last) (started with: " .. path .. ")",
        }
      })
    end,
    prompted_once_local_absolute_path_from_default = function(path)
      return transf.prompt_spec.any({
        prompter = transf.prompt_args_string.string_or_nil_and_boolean,
        prompt_args = {
          message =  "Enter a directory or file as a child of " .. path,
        }
      })
    end,

  },
  extant_volume_local_extant_path = {

  },
  extant_path = {
    sibling_absolute_path_array = function(path)
      return transf.dir.absolute_path_array_by_children(transf.path.parent_path(path))
    end,
    descendants_absolute_path_array = function(path)
      return get.extant_path.absolute_path_array(
        path,
        {recursion = true}
      )
    end,
    file_array_by_descendants = function(path)
      return get.extant_path.absolute_path_array(
        path,
        {recursion = true, include_dirs = false}
      )
    end,
    plaintext_file_array_by_descendants = function(path)
      return transf.file_array.plaintext_file_array(
        transf.extant_path.file_array_by_descendants(path)
      )
    end,
    m3u_file_array_by_descendants = function(path)
      return transf.plaintext_file_array.m3u_file_array(
        transf.extant_path.plaintext_file_array_by_descendants(path)
      )
    end,
    url_or_local_path_array_by_descendant_m3u_file_content_lines = function(path)
      return transf.file_array.url_or_local_path_array_by_m3u_file_content_lines(
        transf.extant_path.file_array_by_descendants(path)
      )
    end,
    
    descendant_dir_array = function(path)
      return get.extant_path.absolute_path_array(
        path,
        {recursion = true, include_files = false}
      )
    end,
    descendants_leaves_array = function(path)
      return transf.path_array.leaves_array(transf.extant_path.descendants_absolute_path_array(path))
    end,
    descendants_filenames_array = function(path)
      return transf.path_array.filenames_array(transf.extant_path.descendants_absolute_path_array(path))
    end,
    descendants_extensions_array = function(path)
      return transf.path_array.extensions_array(transf.extant_path.descendants_absolute_path_array(path))
    end,
  },
  local_extant_path = {
    size = function(path)
      return get.extant_path.attr(path, "size")
    end,
    m_timestamp_s = function(path)
      return get.extant_path.attr(path, "modification")
    end,
    m_date = function(path)
      return transf.timestamp_s.date(transf.extant_path.m_timestamp_s(path))
    end,
    cr_timestamp_s = function(path)
      return get.extant_path.attr(path, "creation")
    end,
    
    cr_date = function(path)
      return transf.timestamp_s.date(transf.extant_path.cr_timestamp_s(path))
    end,
    
    c_timestamp_s = function(path)
      return get.extant_path.attr(path, "change")
    end,
    
    c_date = function(path)
      return transf.timestamp_s.date(transf.extant_path.c_timestamp_s(path))
    end,
    
    a_timestamp_s = function(path)
      return get.extant_path.attr(path, "access")
    end,
    
    a_date = function(path)
      return transf.timestamp_s.date(transf.extant_path.a_timestamp_s(path))
    end,

    
  },
  local_dir = {
    children_absolute_path_value_stateful_iter = hs.fs.dir
  },
  local_absolute_path_in_home = {
    local_http_server_url = function(path)
      return env.FS_HTTP_SERVER .. path
    end,
    local_nonabsolute_path_relative_to_home = function(path)
      return get.absolute_path.relative_path_from(path, env.HOME)
    end,
    labelled_remote_path = function(path)
      return transf.local_nonabsolute_path_relative_to_home.labelled_remote_absolute_path(transf.local_absolute_path_in_home.local_nonabsolute_path_relative_to_home(path))
    end
  },
  local_nonabsolute_path_relative_to_home = {
    labelled_remote_absolute_path = function(path)
      return "hsftp:/home/" .. path
    end,
    local_absolute_path = function(path)
      return env.HOME .. "/" .. path
    end,
  },
  path_array = {
    leaves_array = function(path_array)
      return hs.fnutils.imap(path_array, transf.path.leaf)
    end,
    filenames_array = function(path_array)
      local filenames = hs.fnutils.imap(path_array, transf.path.filename)
      return transf.array.set(filenames)
    end,
    extensions_array = function(path_array)
      local extensions = hs.fnutils.imap(path_array, transf.path.extension)
      return transf.array.set(extensions)
    end,
    extant_path_array = function(path_array)
      return hs.fnutils.ifilter(path_array, is.path.extant_path)
    end,
    useless_file_leaf_filtered_path_array = function(path_array)
      return hs.fnutils.ifilter(path_array, is.path.not_useless_file_leaf)
    end,
  },
  extant_path_array = {
    newest = function(path_array)
      return get.extant_path_array.largest_by_attr(path_array, "creation")
    end,
    filter_dir_array = function(path_array)
      return hs.fnutils.ifilter(path_array, is.path.dir)
    end,
    filter_file_array = function(path_array)
      return hs.fnutils.ifilter(path_array, is.path.file)
    end,
    filter_git_root_dir_array = function(path_array)
      return transf.dir_array.filter_git_root_dir_array(transf.extant_path_array.filter_dir_array(path_array))
    end,
    descendant_file_array = function(path_array)
      return get.array_of_arrays.array_by_mapped_w_vt_arg_vt_ret_fn_and_flatten(
        path_array,
        transf.extant_path.file_array_by_descendants
      )
    end,
  },
  dir_array = {
    filter_git_root_dir_array = function(path_array)
      return hs.fnutils.ifilter(path_array, is.dir.git_root_dir)
    end,
    children_absolute_path_array = function(path_array)
      return get.array_of_arrays.array_by_mapped_w_vt_arg_vt_ret_fn_and_flatten(
        path_array,
        transf.dir.absolute_path_array_by_children
      )
    end,
  },
  file_array = {
    plaintext_file_array = function(path_array)
      return hs.fnutils.ifilter(path_array, is.file.plaintext_file)
    end,
    url_or_local_path_array_by_m3u_file_content_lines = function(path_array)
      return transf.plaintext_file_array.url_or_local_path_array_by_m3u_file_content_lines(
        transf.file_array.plaintext_file_array(path_array)
      )
    end
  },
  labelled_remote_dir = {
    children_absolute_path_array = function(remote_extant_path)
      local output = transf.string.string_or_nil_by_evaled_env_bash_stripped("rclone lsf" .. transf.string.single_quoted_escaped(remote_extant_path))
      if output then
        items = transf.string.noempty_line_string_array(output)
        items = transf.string_array.stripped_string_array(items)
      else
        items = {}
      end
      return items
    end,
    children_absolute_path_value_stateful_iter = function(remote_extant_path)
      return transf.table.value_stateful_iter(
        transf.remote_dir.children_absolute_path_array(remote_extant_path)
      )
    end,
  },
  remote_dir = {
    children_absolute_path_array = function(remote_extant_path)
      return transf.labelled_remote_dir.children_absolute_path_array(remote_extant_path)
    end,
    children_absolute_path_value_stateful_iter = function(remote_extant_path)
      return transf.labelled_remote_dir.children_absolute_path_value_stateful_iter(remote_extant_path)
    end,
  },
  local_file = {
    contents = function(path)
      local file = io.open(path, "r")
      if file ~= nil then
        local contents = file:read("*a")
        io.close(file)
        return contents
      else
        error("Couldn't read file at " .. path .. "!")
      end
    end,
    attachment_string = function(path)
      local mimetype = mimetypes.guess(path) or "text/plain"
      return "#" .. mimetype .. " " .. path
    end,
    email_specifier = function(path)
      return {
        non_inline_attachment_local_file_array = {path}
      }
    end,
  },
  local_file_array = {
    attachment_array = function(path_array)
      return hs.fnutils.imap(path_array, transf.local_file.attachment_string)
    end,
    attachment_string = function(path_array)
      return get.string_or_number_array.string_by_joined(transf.path_array.attachment_array(path_array), "\n")
    end,
    email_specifier = function(path_array)
      return {
        non_inline_attachment_local_file_array = path_array
      }
    end,
  },
  labelled_remote_file = {
    contents = function(path)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("rclone cat" .. transf.string.single_quoted_escaped(path))
    end,
  },
  remote_file = {
    contents = function(path)
      return transf.labelled_remote_file.contents(path)
    end,
  },
  file = {
    contents = function(path)
      if is.path.remote_path(path) then
        return transf.remote_file.contents(path)
      else
        return transf.local_file.contents(path)
      end
    end,
  },
  dir = {
    absolute_path_array_by_children = function(dir)
      return get.extant_path.absolute_path_array(dir)
    end,
    absolute_path_array_by_children_or_self = function(dir)
      return transf.array_and_any.array(
        transf.dir.absolute_path_array_by_children(dir),
        dir
      )
    end,
    file_array_by_children = function(dir)
      return get.extant_path.absolute_path_array(dir, {include_dirs = false})
    end,
    absolute_path_array_by_file_children_or_self = function(dir)
      return transf.array_and_any.array(
        transf.dir.file_array_by_children(dir),
        dir
      )
    end,
    dir_array_by_children = function(dir)
      return get.extant_path.absolute_path_array(dir, {include_files = false})
    end,
    dir_array_by_children_or_self = function(dir)
      return transf.array_and_any.array(
        transf.dir.dir_array_by_children(dir),
        dir
      )
    end,
    children_absolute_path_value_stateful_iter = function(dir)
      if is.path.remote_path(dir) then
        return transf.remote_dir.children_absolute_path_value_stateful_iter(dir)
      else
        return transf.local_dir.children_absolute_path_value_stateful_iter(dir)
      end
    end,
    children_leaves_array = function(dir)
      return transf.path_array.leaves_array(transf.dir.absolute_path_array_by_children(dir))
    end,
    children_filename_array = function(dir)
      return transf.path_array.filenames_array(transf.dir.absolute_path_array_by_children(dir))
    end,
    children_extensions_array = function(dir)
      return transf.path_array.extensions_array(transf.dir.absolute_path_array_by_children(dir))
    end,
    newest_child = function(dir)
      return transf.extant_path_array.newest(transf.dir.absolute_path_array_by_children(dir))
    end,
    grandchildren_absolute_path_array = function(dir)
      return get.array_of_arrays.array_by_mapped_w_vt_arg_vt_ret_fn_and_flatten(transf.dir.absolute_path_array_by_children(dir), transf.dir.absolute_path_array_by_children)
    end,
    git_root_dir_descendants = function(dir)
      return transf.dir_array.filter_git_root_dir_array(transf.extant_path.descendants_absolute_path_array(dir))
    end,
    absolute_path_key_leaf_string_or_nested_value_dict = function(path)
      local res = {}
      path = get.string.string_by_with_suffix(path, "/")
      for child_path in transf.dir.children_absolute_path_value_stateful_iter(path) do
        if is.absolute_path.dir(child_path) then
          res[child_path] = transf.dir.absolute_path_key_leaf_string_or_nested_value_dict(child_path)
        else
          res[child_path] = "leaf"
        end
      end
      return res
    end,
    plaintext_dictonary_read_assoc = function(path)
      transf.absolute_path_key_leaf_string_or_nested_value_dict.plaintext_dictonary_read_assoc(
        transf.dir.absolute_path_key_leaf_string_or_nested_value_dict(path)
      )
    end,
    string_by_ls = function(path)
      transf.string.string_or_nil_by_evaled_env_bash_stripped("ls -F -1" .. transf.string.single_quoted_escaped(path))
    end,
    string_by_tree = function(path)
      transf.string.string_or_nil_by_evaled_env_bash_stripped("tree -F --noreport" .. transf.string.single_quoted_escaped(path))
    end,
  },
  absolute_path_key_leaf_string_or_nested_value_dict = {
    leaf_key_leaf_string_or_nested_value_dict = function(dict)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(dict) do
        local leaf = transf.path.leaf(k)
        if is.any.table(v) then
          res[leaf] = transf.absolute_path_key_leaf_string_or_nested_value_dict.leaf_key_leaf_string_or_nested_value_dict(v)
        else
          res[leaf] = v
        end
      end
      return res
    end,
    plaintext_dictonary_read_assoc = function(dict)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(dict) do
        local filename = transf.path.filename(k)
        if is.any.table(v) then
          res[filename] = transf.absolute_path_key_leaf_string_or_nested_value_dict.plaintext_dictonary_read_assoc(v)
        else
          if is.file.plaintext_dictionary_file(k) then
            res[filename] = transf.plaintext_dictionary_file.table(k)
          end
        end
      end
      return res
    end,
  },

  in_git_dir = {
    git_root_dir = function(path)
      return get.extant_path.extant_path_by_self_or_ancestor_w_fn(
        path,
        is.dir.git_root_dir
      )
    end,
    relative_path_from_git_root_dir = function(path)
      return transf.path.relative_path(
        path,
        transf.in_git_dir.git_root_dir(path)
      )
    end,
    gitignore_path = function(path)
      return transf.path.ending_with_slash(transf.in_git_dir.gitignore_path(path)) .. ".gitignore"
    end,
    current_branch = function(path)
      return get.extant_path.cmd_output_from_path(
        path,
        "git rev-parse --abbrev-ref HEAD"
      )
    end,
    remote_url = function(path)
      local raw= get.extant_path.cmd_output_from_path(
        path,
        "git config --get remote.origin.url"
      )
      raw = get.string.string_by_no_suffix(raw, ".git")
      raw = get.string.string_by_no_suffix(raw, "/")
      return raw
    end,
    remote_owner_item = function(path)
      return transf.owner_item_url.owner_item(transf.in_git_dir.remote_url(path))
    end,
    remote_host = function(path)
      return transf.url.host(transf.in_git_dir.remote_url(path))
    end,
    remote_sld = function(path)
      return transf.url.sld(transf.in_git_dir.remote_url(path))
    end,
    remote_type = function(path)
      if get.array.bool_by_contains(mt._list.remote_types, transf.in_git_dir.remote_sld(path)) then
        return transf.in_git_dir.remote_sld(path)
      else
        return tblmap.host.remote_type[transf.in_git_dir.remote_host(path)] -- we'll hardcode known hosts there
      end
    end,
    remote_blob_host = function(path)
      local remote_type = transf.in_git_dir.remote_type(path)
      local remote_host = transf.in_git_dir.remote_host(path)
      return tblmap.host.blob_host[remote_host] or tblmap.remote_type.blob_default_host[remote_type]
    end,
    remote_raw_host = function(path)
      local remote_type = transf.in_git_dir.remote_type(path)
      local remote_host = transf.in_git_dir.remote_host(path)
      return tblmap.host.raw_host[remote_host] or tblmap.remote_type.raw_default_host[remote_type]
    end,
    status = function(path)
      return get.extant_path.cmd_output_from_path(
        path,
        "git status"
      )
    end,
    unpushed_commit_hash_list = function(path)
      local raw_hashes = get.extant_path.cmd_output_from_path(
        path,
        "git log --branches --not --remotes --pretty=format:'%h'"
      )
      return transf.string.noempty_line_string_array(raw_hashes)
    end


  },

  git_root_dir = {
    dotgit_dir = function(git_root_dir)
      return transf.path.ending_with_slash(git_root_dir) .. ".git"
    end,
    hooks_dir = function(git_root_dir)
      return transf.path.ending_with_slash(git_root_dir) .. ".git/hooks"
    end,
    hooks_absolute_path_array = function(git_root_dir)
      return transf.dir.absolute_path_array_by_children(transf.git_root_dir.hooks_dir(git_root_dir))
    end,
  },

  github_username = {
    github_url = function(github_username)
      return "https://github.com/" .. github_username
    end,
  },
  
  path_leaf_specifier = {
    general_name_part = function(path_leaf_specifier)
      if path_leaf_specifier.general_name then 
        return "--" .. path_leaf_specifier.general_name
      else
        return ""
      end
    end,
    extension_part = function(path_leaf_specifier)
      if path_leaf_specifier.extension then 
        return "." .. path_leaf_specifier.extension
      else
        return ""
      end
    end,
    rf3339like_dt_or_interval_part = function(path_leaf_specifier)
      return path_leaf_specifier.rf3339like_dt_or_interval or ""
    end,
    date_interval_specifier = function(path_leaf_specifier)
      return transf.rf3339like_dt_or_interval.date_interval_specifier(path_leaf_specifier.rf3339like_dt_or_interval)
    end,
    path_part = function(path_leaf_specifier)
      return transf.path.ending_with_slash(path_leaf_specifier.path) 
    end,
    fs_tag_assoc = function(path_leaf_specifier)
      return path_leaf_specifier.fs_tag_assoc
    end,
    fs_tag_string_dict = function(path_leaf_specifier)
      return transf.fs_tag_assoc.fs_tag_string_dict(path_leaf_specifier.fs_tag_assoc)
    end,
    fs_tag_string_part_array = function(path_leaf_specifier)
      return transf.fs_tag_assoc.fs_tag_string_part_array(path_leaf_specifier.fs_tag_assoc)
    end,
    fs_tag_string = function(path_leaf_specifier)
      return transf.fs_tag_assoc.fs_tag_string(path_leaf_specifier.fs_tag_assoc)
    end,
    fs_tag_keys = function(path_leaf_specifier)
      return transf.table_or_nil.kt_array(path_leaf_specifier.fs_tag_assoc)
    end,
    path = function(path_leaf_specifier)
      return transf.path.ending_with_slash(path_leaf_specifier.path) 
      .. transf.path_leaf_specifier.rf3339like_dt_or_interval_part(path_leaf_specifier)
      .. transf.path_leaf_specifier.general_name_part(path_leaf_specifier)
      .. transf.path_leaf_specifier.fs_tag_string(path_leaf_specifier)
      .. transf.path_leaf_specifier.extension_part(path_leaf_specifier)
    end
  },
  fs_tag_string = {
    fs_tag_string_part_array = function(fs_tag_string)
      return stringy.split(
        fs_tag_string:sub(2),
        "%"
      )
    end,
    fs_tag_string_dict = function(fs_tag_string)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        transf.fs_tag_string.fs_tag_string_part_array(fs_tag_string),
        get.fn.arbitrary_args_bound_or_ignored_fn(get.string.n_strings_split, {a_use, "-", 2})
      )
    end,
    fs_tag_assoc = function(fs_tag_string)
      transf.fs_tag_string_dict.fs_tag_assoc(
        transf.fs_tag_string.fs_tag_string_dict(fs_tag_string)
      )
    end,
  },
  fs_tag_string_part_array = {
    fs_tag_string_dict = function(fs_tag_string_part_array)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        fs_tag_string_part_array,
        get.fn.second_n_args_bound_fn(get.string.two_strings_split_or_nil, "-")
      )
    end,
    fs_tag_assoc = function(fs_tag_string_part_array)
      transf.fs_tag_string_dict.fs_tag_assoc(
        transf.fs_tag_string_part_array.fs_tag_string_dict(fs_tag_string_part_array)
      )
    end,
    fs_tag_string = function(fs_tag_string_part_array)
      return "%" .. get.string_or_number_array.string_by_joined(fs_tag_string_part_array, "%")
    end,
  },
  fs_tag_string_dict = {
    fs_tag_assoc = function(dict)
      return hs.fnutils.map(
        dict,
        get.fn.arbitrary_args_bound_or_ignored_fn(stringy.split, {a_use, ","})
      )
    end,
    fs_tag_string_part_array = function(dict)
      return get.table.string_array_by_mapped_w_fmt_string(
        dict,
        "%s-%s"
      )
    end,
    fs_tag_string = function(dict)
      return transf.fs_tag_string_part_array.fs_tag_string(
        transf.fs_tag_string_dict.fs_tag_string_part_array(dict)
      )
    end,
  },
  fs_tag_assoc = {
    fs_tag_string_dict = function(fs_tag_assoc)
      return hs.fnutils.map(
        fs_tag_assoc,
        transf.any.join_if_array
      )
    end,
    fs_tag_string_part_array = function(fs_tag_assoc)
      return transf.fs_tag_string_dict.fs_tag_string_part_array(
        transf.fs_tag_assoc.fs_tag_string_dict(fs_tag_assoc)
      )
    end,
    fs_tag_string = function(fs_tag_assoc)
      return transf.fs_tag_string_part_array.fs_tag_string(
        transf.fs_tag_assoc.fs_tag_string_part_array(fs_tag_assoc)
      )
    end,
  },
  path_leaf_specifier_array = {
    path_leaf_specifier_date_interval_specifier_dict = function(arr)
      return get.table.table_by_mapped_w_kt_arg_kt_vt_ret_fn(
        arr,
        function(path_leaf_specifier)
          return 
            path_leaf_specifier,
            transf.path_leaf_specifier.date_interval_specifier(
              path_leaf_specifier
            )
        end
      )
    end,
    date_interval_specifier_array = function(arr)
      return hs.fnutils.imap(
        arr,
        transf.path_leaf_specifier.date_interval_specifier
      )
    end,
    interval_specifier_with_earliest_start = function(arr)
      return transf.interval_specifier_array.interval_specifier_with_earliest_start(
        transf.path_leaf_specifier_array.date_interval_specifier_array(arr)
      )
    end,
    path_leaf_specifier_with_earliest_start = function(arr)
      return get.dict.kt_or_nil_by_first_match_w_vt(
        transf.path_leaf_specifier_array.path_leaf_specifier_date_interval_specifier_dict(arr),
        transf.path_leaf_specifier_array.interval_specifier_with_earliest_start(arr)
      )
    end,
  },
  whisper_file = {
    transcribed = function(path)
      return get.fn.rt_or_nil_by_memoized(rest, refstore.params.memoize.opts.invalidate_1_year_fs, "rest")({
        api_name = "openai",
        endpoint = "audio/transcriptions",
        request_table_type = "form",
        request_table = {
          model = "whisper-1",
          file = transf.path.form_path(path),
        }
      }).text
    end
  },
  local_image_file = {
    qr_data = function(path)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("zbarimg -q --raw " .. transf.string.single_quoted_escaped(path))
    end,
    hs_image = function(path)
      return get.fn.rt_or_nil_by_memoized(hs.image.imageFromPath, refstore.params.memoize.opts.invalidate_1_week_fs, "hs.image.imageFromPath")(path)
    end,
    booru_post_url = function(path)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(
        "saucenao --file" ..
        transf.string.single_quoted_escaped(path)
        .. "--output-properties booru-url"
      )
    end,
    data_url = function(path)
      local ext = transf.path.extension(path)
      return get.fn.rt_or_nil_by_memoized(hs.image.encodeAsURLString)(transf.local_image_file.hs_image(path), ext)
    end,
  },
  email_file = {
    all_headers_raw = function(path)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(
        "mshow -L" .. transf.string.single_quoted_escaped(path)
      )
    end,
    all_useful_headers_raw = function(path)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(
        "mshow -q" .. transf.string.single_quoted_escaped(path)
      )
    end,
    useful_header_dict = function(path)
      error("TODO: currently the way the headers are rendered contains a bunch of stuff we wouldn't want in the dict. In particular, emails without a name are rendered as <email>, which may not be what we want.")
      return transf.header_string.dict(transf.email_file.all_useful_headers_raw(path))
    end,
    rendered_body = function(path)
      return get.fn.rt_or_nil_by_memoized(transf.string.string_or_nil_by_evaled_env_bash_stripped)(
        "mshow -R" .. transf.string.single_quoted_escaped(path)
      )
    end,
    simple_view = function(path)
      return transf.email_file.all_useful_headers_raw(path) .. "\n\n" .. transf.email_file.rendered_body(path)
    end,
    email_specifier = function(path)
      local specifier = transf.email_file.useful_header_dict(path)
      specifier.body = transf.email_file.rendered_body(path)
      return specifier
    end,
    reply_email_specifier = function(path)
      return transf.email_specifier.reply_email_specifier(transf.email_file.email_specifier(path))
    end,
    forward_email_specifier = function(path)
      return transf.email_specifier.forward_email_specifier(transf.email_file.email_specifier(path))
    end,
    quoted_body = function(path)
      transf.string.email_quoted(transf.email_file.rendered_body(path))
    end,
    from = function(path)
      return get.email_file.header(path, "from")
    end,
    to = function(path)
      return get.email_file.header(path, "to")
    end,
    subject = function(path)
      return get.email_file.header(path, "subject")
    end,
    mime_parts_raw = function(path)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(
        "mshow -t" .. transf.string.single_quoted_escaped(path)
      )
    end,
    attachments = function(path)
      return transf.mime_parts_raw.attachments(transf.email_file.mime_parts_raw(path))
    end,
    summary = function(path)
      return get.fn.rt_or_nil_by_memoized(transf.string.string_or_nil_by_evaled_env_bash_stripped)("mscan -f %D **%f** %200s" .. transf.string.single_quoted_escaped(path))
    end,
    email_file_summary_key_value = function(path)
      return path, transf.email_file.summary(path)
    end,
    email_file_simple_view_key_value = function(path)
      return path, transf.email_file.simple_view(path)
    end,

  },
  email_specifier = {
    reply_email_specifier = function(specifier)
      return {
        to = specifier.from,
        subject = "Re: " .. specifier.subject,
        body = "\n\n" .. transf.string.email_quoted(specifier.body)
      }
    end,
    forward_email_specifier = function(specifier)
      return {
        subject = "Fwd: " .. specifier.subject,
        body = "\n\n" .. transf.string.email_quoted(specifier.body)
      }
    end,
    email_string = function(specifier)
      specifier = get.table.table_by_copy(specifier)
      local body = specifier.body or ""
      specifier.body = nil
      local non_inline_attachment_local_file_array = specifier.non_inline_attachment_local_file_array
      specifier.non_inline_attachment_local_file_array = nil
      local header = transf.dict.email_header(specifier)
      local mail = string.format("%s\n\n%s", header, body)
      if non_inline_attachment_local_file_array then
        mail = mail .. "\n" .. transf.path_array.attachment_string(non_inline_attachment_local_file_array)
      end
      return mail
    end,

    draft_email_file = function(specifier)
      

      local mail = join.string.table.email(body, specifier)
      local evaled_mail = get.string.evaled_as_template(mail)
      local temppath = transf.not_userdata_or_function.in_tmp_dir(evaled_mail)
      local outpath = temppath .. "_out"
      transf.string.string_or_nil_by_evaled_env_bash_stripped("mmime < " .. transf.string.single_quoted_escaped(temppath) .. " > " .. transf.string.single_quoted_escaped(outpath))
      dothis.absolute_path.delete(temppath)
      return outpath
    end
  },
  mime_parts_raw = {
    attachments = function(mime_parts_raw)
      local attachments = {}
      for line in transf.string.lines(mime_parts_raw) do
        local name = line:match("name=\"(.-)\"")
        if name then
          table.insert(attachments, name)
        end
      end
      return attachments
    end,
  },
  bib_file = {
    array_of_csl_tables = function(path)
      return transf.string.table_or_err_by_evaled_env_bash_parsed_json({
        "citation-js --input" .. transf.string.single_quoted_escaped(path) ..
        "--output-language json"
      })
    end,

  },

  ics_file = {
    array_of_assocs = function(path)
      local temppath = transf.string.in_tmp_dir(transf.path.filename(path) .. ".ics")
      dothis.extant_path.copy_to_absolute_path(path, temppath)
      dothis.ics_file.generate_json_file(temppath)
      local jsonpath = transf.file.contents(get.path.with_different_extension(temppath, "json"))
      local res = json.decode(transf.file.contents(jsonpath))
      dothis.absolute_path.delete(temppath)
      dothis.absolute_path.delete(jsonpath)
      return res
    end,
  },
  json_file = {
    not_userdata_or_function = function(path)
      return transf.json_string.not_userdata_or_function(transf.file.contents(path))
    end,
    table_or_nil = function(path)
      return transf.json_string.table_or_nil(transf.file.contents(path))
    end,
  },
  ini_file = {
    assoc = function(path)
      return transf.ini_string.assoc(transf.file.contents(path))
    end,
  },
  toml_file = {
    assoc = function(path)
      return transf.toml_string.assoc(transf.file.contents(path))
    end,
  },
  xml_local_file = {
    tree = xml.parseFile
  },
  -- a tree_node_like is a table with a key <ckey> which at some depth contains a tree_node_like_array, and a key <lkey> which contains a thing of any type that can be seen as the label of the node (or use self), such the tree_node_like it can be transformed to a tree_node
  tree_node_like = {

  },
  tree_node_like_array = {

  },
  tree_node = {
    array_of_arrays_by_label = function(node, path, include_inner)
      path = get.table.table_by_copy(path) or {}
      dothis.array.push(path, node.label)
      local res = {}
      if not node.children or include_inner then
        res = {path}
      end
      if node.children then
        res = transf.two_arrays.array_by_appended(res, transf.tree_node_array.array_of_arrays_by_label(node.children, path, include_inner))
      end
      return res
    end
  },
  tree_node_array = {
    array_of_arrays_by_label = function(arr, path, include_inner)
      local res = {}
      for _, node in transf.array.index_value_stateless_iter(arr) do
        res = transf.two_arrays.array_by_appended(res, transf.tree_node.array_of_arrays_by_label(node, path, include_inner))
      end
      return res
    end,
  },

  env_var_name_value_dict = {
    key_value_and_dependency_dict = function(dict)
      return hs.fnutils.imap(dict, function(value)
        return {
          value = value,
          dependencies = get.stateless_iter.table(
            eutf8.gmatch(value, "%$([A-Z0-9_]+)")), {tolist=true, ret="v"}
        }
      end)
    end,
    dependency_ordered_key_value_array = function(dict)
      return transf.key_value_and_dependency_dict.dependency_ordered_key_value_array(
        transf.key_value_and_dependency_dict.key_value_and_dependency_dict(dict)
      )
    end,
    env_string = function(dict)
      transf.env_line_array.env_string(
        transf.string_pair_array.env_line_array(
          transf.env_var_name_value_dict.dependency_ordered_key_value_array(dict)
        )
      )
    end

  },
  key_value_and_dependency_dict = {
    dependency_ordered_key_value_array = function(dict)local result = {}  -- Table to store the sorted keys
      local visited = {}  -- Table to keep track of visited keys
      local temp_stack = {}  -- Table to detect cyclic dependencies
  
      -- Helper function for DFS traversal
      local function dfs(key)
          if temp_stack[key] then
              error("Cyclic dependency detected")
          end
  
          if not visited[key] then
              temp_stack[key] = true  -- Add key to temporary stack to detect cyclic dependencies
  
              -- Traverse dependencies recursively
              for _, dep in transf.array.index_value_stateless_iter(dict[key]['dependencies']) do
                  dfs(dep)
              end
  
              temp_stack[key] = nil  -- Remove key from temporary stack
              visited[key] = true  -- Mark key as visited
              table.insert(result, { key, dict[key]['value'] })  -- Append {key, value} pair to result
          end
      end
  
      -- Perform DFS traversal for each key in the graph
      for key, _ in transf.table.key_value_stateless_iter(dict) do
          dfs(key)
      end
  
      return result
    end
  },

  shellscript_file = {
    gcc_string_errors = function(path)
      return get.shellscript_file.lint_gcc_string(path, "errors")
    end,
    gcc_string_warnings = function(path)
      return get.shellscript_file.lint_gcc_string(path, "warnings")
    end,
  },

  plaintext_file = {
    string_by_contents = function(path)
      return transf.file.contents(path)
    end,
    string_array_by_lines = function(path)
      return transf.string.lines(transf.plaintext_file.string_by_contents(path))
    end,
    string_array_by_content_lines = function(path)
      return transf.string.noempty_line_string_array(transf.plaintext_file.string_by_contents(path))
    end,
    noindent_content_lines = function(path)
      return transf.string.noindent_content_lines(transf.plaintext_file.string_by_contents(path))
    end,
    nocomment_noindent_content_lines = function(path)
      return transf.string.nocomment_noindent_content_lines(transf.plaintext_file.string_by_contents(path))
    end,
    first_line = function(path)
      return transf.string.first_line(transf.plaintext_file.string_by_contents(path))
    end,
    last_line = function(path)
      return transf.string.last_line(transf.plaintext_file.string_by_contents(path))
    end,
    bytechars = function(path)
      return transf.string.bytechar_array(transf.plaintext_file.string_by_contents(path))
    end,
    chars = function(path)
      return transf.string.char_array(transf.plaintext_file.string_by_contents(path))
    end,
    no_final_newlines = function(path)
      return transf.string.no_final_newlines(transf.plaintext_file.string_by_contents(path))
    end,
    one_final_newline = function(path)
      return transf.string.one_final_newline(transf.plaintext_file.string_by_contents(path))
    end,
    len_lines = function(path)
      return transf.string.len_lines(transf.plaintext_file.string_by_contents(path))
    end,
    len_chars = function(path)
      return transf.string.len_chars(transf.plaintext_file.string_by_contents(path))
    end,
    len_bytechars = function(path)
      return transf.string.len_bytechars(transf.plaintext_file.string_by_contents(path))
    end,

    
  },

  plaintext_table_file = {
    field_separator = function(path)
      return tblmap.extension.likely_field_separator[transf.path.extension(path)]
    end,
    record_separator = function(path)
      return tblmap.extension.likely_record_separator[transf.path.extension(path)]
    end,
    array_of_array_of_fields = function(path)
      return ftcsv.parse(path, transf.plaintext_table_file.field_separator(path), refstore.params.ftcsv_parse.opts.noheaders)
    end,
    iter_of_array_of_fields = function(path)
      local iter = ftcsv.parseLine(path, transf.plaintext_table_file.field_separator(path), refstore.params.ftcsv_parse.opts.noheaders)
      iter() -- skip header, seems to be a bug in ftcsv
      return iter
    end,
    dict_array = function(path)
      return select(1, ftcsv.parse(path, transf.plaintext_table_file.field_separator(path)))
    end,
    iter_of_dicts = function(path)
      return ftcsv.parseLine(path, transf.plaintext_table_file.field_separator(path))
    end,
  },
  timestamp_s_key_dict_value_dict_json_file = {

  },
  dated_children_dir = {

  },
  dated_named_item_dir = {

  },
  logging_dir = {
   
  },
  dated_named_item = {

  },
  dated_grouping_dir = {

  },
  newsboat_url_specifier = {
    newsboat_url_line = function(specifier)
      return ('%s\t"~%s"\t"_%s"'):format(
        specifier.url,
        specifier.title,
        ((specifier.category and #specifier.category > 0) and specifier.category) or "edu"
      )
    end
  },
  semver_string = {
    semver_component_specifier = function(str)
      local major, minor, patch, prerelease, build = onig.match(str, mt._r.version.semver)
      return {
        major = get.string_or_number.number_or_nil(major),
        minor = get.string_or_number.number_or_nil(minor),
        patch = get.string_or_number.number_or_nil(patch),
        prerelease = prerelease,
        build = build
      }
    end,
  },
  package_name_semver_compound_string = {
    package_name_semver_string_array = function(str)
      return get.string.string_array_split_noedge(str, "@")
    end,
    package_name = function(str)
      return transf.package_name_semver_compound_string.package_name_semver_string_array(str)[1]
    end,
    semver_string = function(str)
      return transf.package_name_semver_compound_string.package_name_semver_string_array(str)[2]
    end,
  },
  package_name_semver_package_manager_name_compound_string = {
    package_name_semver_compound_string = function(str)
      return get.string.string_array_split_noedge(str, ":")[1]
    end,
    package_name = function(str)
      return transf.package_name_semver_compound_string.package_name(
        transf.package_name_semver_package_manager_name_compound_string.package_name_semver_compound_string(str)
      )
    end,
    semver_string = function(str)
      return transf.package_name_semver_compound_string.semver_string(
        transf.package_name_semver_package_manager_name_compound_string.package_name_semver_compound_string(str)
      )
    end,
    package_manager_name = function(str)
      return get.string.string_array_split_noedge(str, ":")[2]
    end,
  },
  package_name_package_manager_name_compound_string = {
    package_name = function(str)
      return get.string.string_array_split_noedge(str, ":")[1]
    end,
    package_manager_name = function(str)
      return get.string.string_array_split_noedge(str, ":")[2]
    end,
  },
  dice_notation = {
    nonindicated_decimal_number_string_result = function(dice_notation)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("roll" .. transf.string.single_quoted_escaped(dice_notation))
    end,
    int_result = function(dice_notation)
      return transf.nonindicated_number_string.number_base_10(
        transf.dice_notation.nonindicated_decimal_number_string_result(dice_notation)
      )
    end,
  },
  date = {
    y_ym_ymd_table = function(date)
      return  {
        date:fmt("%Y"),
        date:fmt("%Y-%m"),
        date:fmt("%Y-%m-%d"),
      }
    end,
    y_ym_ymd_path = function(date)
      return get.string_or_number_array.string_by_joined(transf.date.y_ym_ymd_table(date), "/")
    end,
    weekday_number_start_1 = function(date)
      return date:getisoweekday()
    end,
    weekday_number_start_0 = function(date)
      return date:getisoweekday() - 1
    end,
    weeknumber = function(date)
      return date:getisoweeknumber()
    end,
    full_date_component_name_value_dict = function(date)
      local tbl = transf.two_tables.table_by_take_new(
        date:getdate(),
        date:gettime()
      )
      tbl.ticks = nil
      return tbl
    end,
    quarter_hours_date_sequence_specifier = function(date)
      return get.date.date_sequence_specifier_of_lower_component(date, 15, "hour")
    end,
    quarter_hours_of_day_date_sequence_specifier = function(date)
      return get.date.date_sequence_specifier_of_lower_component(date, 15, "day")
    end,
    full_rfc3339like_dt = function(date)
      return get.date.string_w_date_format_indicator(date, tblmap.date_format_name.date_format["rfc3339-datetime"])
    end,
    full_rfc3339like_time = function(date)
      return get.date.string_w_date_format_indicator(date, tblmap.date_format_name.date_format["rfc3339-time"])
    end,
    timestamp_s = function(date)
      return transf.full_date_component_name_value_dict.timestamp_s(
        transf.date.full_date_component_name_value_dict(date)
      )
    end,
    timestamp_ms = function(date)
      return transf.date.timestamp_s(date) * 1000
    end,
    event_table_with_start = function(date)
      return {
        start = transf.date.full_rfc3339like_dt(date)
      }
    end,
    summary = function(date)
      return get.date.string_w_date_format_indicator(date, "detailed")
    end

  },
  timestamp_s = {
    timestamp_ms = function(timestamp)
      return timestamp * 1000
    end,
    date = function(timestamp)
      return date(timestamp)
    end
  },
  timestamp_ms = {
    timestamp_s = function(timestamp)
      return timestamp / 1000
    end,
    date = function(timestamp)
      return date(timestamp / 1000)
    end
  },
  date_component_name = {
    date_component_name_array_larger_or_same = function(date_component_name)
      return get.array.array_by_slice_w_3_pos_int_any_or_nils(mt._list.date.date_component_names, 1, date_component_name)
    end,
    date_component_name_array_same_or_smaller = function(date_component_name)
      return get.array.array_by_slice_w_3_pos_int_any_or_nils(mt._list.date.date_component_names, date_component_name)
    end,
    date_component_index = function(date_component_name)
      return tblmap.date_component_name.date_component_index[date_component_name]
    end,
    
  },
  date_component_name_array = {
    min_date_component_name_value_dict = function(arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        arr,
        function(component)
          return component, tblmap.date_component_name.min_date_component_value[component]
        end
      )
    end,
    max_date_component_name_value_dict = function(arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        arr,
        function(component)
          return component, tblmap.date_component_name.max_date_component_value[component]
        end
      )
    end,
    date_component_name_ordered_array = function(arr)
      return get.array.array_by_sorted(arr, transf.two_date_component_names.larger)
    end,
    largest_date_component_name = function(arr)
      return transf.date_component_name_array.date_component_name_ordered_array(
        arr
      )[1]
    end,
    smallest_date_component_name = function(arr)
      return transf.date_component_name_array.date_component_name_ordered_array(
        arr
      )[#arr]
    end,
    date_component_name_array_inverse = function(arr)
      return transf.two_arrays.set_by_difference(mt._list.date.date_component_names, arr)
    end,
    rfc3339like_dt_separator_array  = function(arr)
      return get.array.array_by_mapped_w_t_key_dict(
        arr,
        tblmap.date_component_name.rfc3339like_dt_separator
      )
    end,
    rfc3339like_dt_string_format_part_array = function(arr)
      return get.array.array_by_mapped_w_t_key_dict(
        arr,
        tblmap.date_component_name.rfc3339like_dt_string_format_part
      )
    end,
  },
  date_component_name_ordered_list = {
    largest_date_component_name = function(list)
      return list[1]
    end,
    smallest_date_component_name = function(list)
      return list[#list]
    end,
  },
  rfc3339like_dt = {
    date_component_name_value_dict = function(str)
      local comps = {onig.match(str, mt._r.date.rfc3339like_dt)}
      return get.table.table_by_mapped_w_kt_vt_arg_kt_vt_ret_fn(mt._list.date.date_component_names, function(k, v)
        return v and get.string_or_number.number_or_nil(comps[k]) or nil
      end)
    end,
    date_interval_specifier = function(str)
      return transf.date_component_name_value_dict.date_interval_specifier(transf.rfc3339like_dt.date_component_name_value_dict(str))
    end,
    min_full_date_component_name_value_dict = function(str)
      return transf.date_component_name_value_dict.min_full_date_component_name_value_dict(
        transf.rfc3339like_dt.date_component_name_value_dict(str)
      )
    end,
    max_full_date_component_name_value_dict = function(str)
      return transf.date_component_name_value_dict.max_full_date_component_name_value_dict(
        transf.rfc3339like_dt.date_component_name_value_dict(str)
      )
    end,
    min_date = function(str)
      return transf.full_date_component_name_value_dict.date(
        transf.rfc3339like_dt.min_full_date_component_name_value_dict(str)
      )
    end,
    max_date = function(str)
      return transf.full_date_component_name_value_dict.date(
        transf.rfc3339like_dt.max_full_date_component_name_value_dict(str)
      )
    end,
    min_timestamp_s = function(str)
      return transf.date.timestamp_s(
        transf.rfc3339like_dt.min_date(str)
      )
    end,
    max_timestamp_s = function(str)
      return transf.date.timestamp_s(
        transf.rfc3339like_dt.max_date(str)
      )
    end,
    

  },
  full_rfc3339like_dt = {
    date = function(str)
      transf.full_date_component_name_value_dict.date(
        transf.rfc3339like_dt.date_component_name_value_dict(str)
      )
    end,
    timestamp_s = function(str)
      return transf.date.timestamp_s(
        transf.full_rfc3339like_dt.date(str)
      )
    end,
    timestamp_ms = function(str)
      return transf.date.timestamp_ms(
        transf.full_rfc3339like_dt.date(str)
      )
    end,
  },
  rfc3339like_interval = {
    start_rfc3339like_dt = function(str)
      return plstringx.split(str, "_to_")[1]
    end,
    start_date_component_name_value_dict = function(str)
      return transf.rfc3339like_dt.date_component_name_value_dict(
        transf.rfc3339like_interval.start_rfc3339like_dt(str)
      )
    end,
    start_min_full_date_component_name_value_dict = function(str)
      return transf.date_component_name_value_dict.min_full_date_component_name_value_dict(
        transf.rfc3339like_interval.start_date_component_name_value_dict(str)
      )
    end,
    start_min_date = function(str)
      return transf.full_date_component_name_value_dict.date(
        transf.rfc3339like_interval.start_min_full_date_component_name_value_dict(str)
      )
    end,
    end_rfc3339like_dt = function(str)
      return plstringx.split(str, "_to_")[2]
    end,
    end_date_component_name_value_dict = function(str)
      return transf.rfc3339like_dt.date_component_name_value_dict(
        transf.rfc3339like_interval.end_rfc3339like_dt(str)
      )
    end,
    end_max_full_date_component_name_value_dict = function(str)
      return transf.date_component_name_value_dict.max_full_date_component_name_value_dict(
        transf.rfc3339like_interval.end_date_component_name_value_dict(str)
      )
    end,
    end_min_full_date_component_name_value_dict = function(str)
      return transf.date_component_name_value_dict.min_full_date_component_name_value_dict(
        transf.rfc3339like_interval.end_date_component_name_value_dict(str)
      )
    end,
    end_max_date = function(str)
      return transf.full_date_component_name_value_dict.date(
        transf.rfc3339like_interval.end_max_full_date_component_name_value_dict(str)
      )
    end,
    end_min_date = function(str)
      return transf.full_date_component_name_value_dict.date(
        transf.rfc3339like_interval.end_min_full_date_component_name_value_dict(str)
      )
    end,
    start_smallest_date_component_set = function(str)
      return transf.date_component_name_value_dict.smallest_date_component_set(
        transf.rfc3339like_interval.start_date_component_name_value_dict(str)
      )
    end,
    end_smallest_date_component_set = function(str)
      return transf.date_component_name_value_dict.smallest_date_component_set(
        transf.rfc3339like_interval.end_date_component_name_value_dict(str)
      )
    end,
    smallest_date_component_both_set = function(str)
      return transf.two_date_component_names.larger_date_component_name(
        transf.rfc3339like_interval.start_smallest_date_component_set(str),
        transf.rfc3339like_interval.end_smallest_date_component_set(str)
      )
    end,
    date_interval_specifier = function(str)
      return {
        start = transf.rfc3339like_interval.start_min_date(str),
        stop = transf.rfc3339like_interval.end_max_date(str),
      }
    end,
    date_sequence_specifier = function(str)
      return {
        start = transf.rfc3339like_interval.start_min_date(str),
        stop = transf.rfc3339like_interval.end_max_date(str),
        step = 1,
        unit = transf.rfc3339like_interval.smallest_date_component_both_set(str)
      }
    end,
    min_date = function(str)
      return transf.rfc3339like_interval.start_min_date(str)
    end,
    max_date = function(str)
      return transf.rfc3339like_interval.end_max_date(str)
    end,
  },
  rf3339like_dt_or_interval = {
    dt_or_interval = function(str)
      if stringy.find(str, "_to_") then
        return "rfc3339like_interval"
      else
        return "rfc3339like_dt"
      end
    end,
    max_date = function(str)
      return transf[
        transf.rf3339like_dt_or_interval.dt_or_interval(str)
      ].max_date(str)
    end,
    min_date = function(str)
      return transf[
        transf.rf3339like_dt_or_interval.dt_or_interval(str)
      ].min_date(str)
    end,
    date_interval_specifier = function(str)
      return transf[
        transf.rf3339like_dt_or_interval.dt_or_interval(str)
      ].date_interval_specifier(str)
    end,
  },
  rf3339like_dt_or_interval_array = {
    date_interval_specifier_array = function(rf3339like_dt_or_interval_array)
      return hs.fnutils.imap(rf3339like_dt_or_interval_array, transf.rf3339like_dt_or_interval.date_interval_specifier)
    end,
  },
  basic_interval_string = {
    start_stop = function(str)
      return stringy.split(str, "-")
    end,
    interval_specifier = function(str)
      local start, stop = transf.basic_interval_string.start_stop(str)
      return {
        start = start,
        stop = stop,
      }
    end,
  },
  single_value_or_basic_interval_string = {
    interval_specifier = function(str)
      if stringy.find(str, "-") then
        return transf.basic_interval_string.interval_specifier(str)
      else
        return {
          start = str,
          stop = str,
        }
      end
    end,
  },
  --- interval specifier: table of start, stop
  --- both inclusive
  interval_specifier = {
    diff = function(interval)
      return interval.stop - interval.start
    end,
  },
  int_interval_specifier = {
    random = function(interval)
      return math.random(interval.start, interval.stop)
    end,
  },
  float_interval_specifier = {
    random = function(interval)
      return math.random() * (interval.stop - interval.start) + interval.start
    end,
  },
  --- sequence specifier: table of start, stop, step, unit?
  --- sequence specifiers can use all methods of interval specifiers 
  sequence_specifier = {
    array = function(sequence)
      return transf.start_stop_step_unit.array(sequence.start, sequence.stop, sequence.step, sequence.unit)
    end,
    interval_specifier = function(sequence)
      return {
        start = sequence.start,
        stop = sequence.stop,
      }
    end,
  },
  interval_specifier_array = {
    interval_specifier_with_earliest_start = function(interval_specifier_array)
      return hs.fnutils.reduce(
        interval_specifier_array,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.table_and_table.smaller_table_by_key, {a_use, a_use, "start"})
      )
    end,
    earliest_start = function(interval_specifier_array)
      return transf.interval_specifier_array.interval_specifier_with_earliest_start(
          interval_specifier_array
        ).start
    end,
    interval_specifier_with_latest_start = function(interval_specifier_array)
      return hs.fnutils.reduce(
        interval_specifier_array,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.table_and_table.larger_table_by_key, {a_use, a_use, "start"})
      )
    end,
    latest_start = function(interval_specifier_array)
      return transf.interval_specifier_array.interval_specifier_with_latest_start(
          interval_specifier_array
        ).start
    end,
    interval_specifier_with_latest_stop = function(interval_specifier_array)
      return hs.fnutils.reduce(
        interval_specifier_array,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.table_and_table.larger_table_by_key, {a_use, a_use, "stop"})
      )
    end,
    latest_stop = function(interval_specifier_array)
      return transf.interval_specifier_array.interval_specifier_with_latest_stop(
          interval_specifier_array
        ).stop
    end,
    interval_specifier_with_earliest_stop = function(interval_specifier_array)
      return hs.fnutils.reduce(
        interval_specifier_array,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.table_and_table.smaller_table_by_key, {a_use, a_use, "stop"})
      )
    end,
    earliest_stop = function(interval_specifier_array)
      return transf.interval_specifier_array.interval_specifier_with_earliest_stop(
          interval_specifier_array
        ).stop
    end,
    intersection_interval_specifier = function(interval_specifier_array)
      return {
        start = transf.interval_specifier_array.latest_start(interval_specifier_array),
        stop = transf.interval_specifier_array.earliest_stop(interval_specifier_array),
      }
    end,
    union_interval_specifier = function(interval_specifier_array)
      return {
        start = transf.interval_specifier_array.earliest_start(interval_specifier_array),
        stop = transf.interval_specifier_array.latest_stop(interval_specifier_array),
      }
    end,
  },
  date_sequence_specifier = {
    start_rfc3339like_dt_of_unit_precision = function(date_sequence_specifier)
      return get.date.rfc3339like_dt_of_precision(
        date_sequence_specifier.start,
        date_sequence_specifier.unit
      )
    end,
    end_rfc3339like_dt_of_unit_precision = function(date_sequence_specifier)
      return get.date.rfc3339like_dt_of_precision(
        date_sequence_specifier.stop,
        date_sequence_specifier.unit
      )
    end,
    rfc3339like_interval_of_unit_precision = function(date_sequence_specifier)
      return 
        transf.date_sequence_specifier.start_rfc3339like_dt_of_unit_precision(date_sequence_specifier) .. 
        "_to_" ..
        transf.date_sequence_specifier.end_rfc3339like_dt_of_unit_precision(date_sequence_specifier)
    end,
  },
  date_interval_specifier = {
    start_full_rfc3339like_dt = function(date_interval_specifier)
      return transf.date.full_rfc3339like_dt(date_interval_specifier.start)
    end,
    end_full_rfc3339like_dt = function(date_interval_specifier)
      return transf.date.full_rfc3339like_dt(date_interval_specifier.stop)
    end,
    start_full_date_component_name_value_dict = function(date_interval_specifier)
      return transf.date.full_date_component_name_value_dict(date_interval_specifier.start)
    end,
    end_full_date_component_name_value_dict = function(date_interval_specifier)
      return transf.date.full_date_component_name_value_dict(date_interval_specifier.stop)
    end,
    start_prefix_date_component_name_value_dict_where_date_component_value_is_not_min_date_component_value = function(date_interval_specifier)
      return transf.date_component_name_value_dict.prefix_date_component_name_value_dict_where_date_component_value_is_not_min_date_component_value(
        transf.date_interval_specifier.start_full_date_component_name_value_dict(date_interval_specifier)
      )
    end,
    end_prefix_date_component_name_value_dict_where_date_component_value_is_not_max_date_component_value = function(date_interval_specifier)
      return transf.date_component_name_value_dict.prefix_date_component_name_value_dict_where_date_component_value_is_not_max_date_component_value(
        transf.date_interval_specifier.end_full_date_component_name_value_dict(date_interval_specifier)
      )
    end,
    start_rfc3339like_dt_where_date_component_value_is_not_min_date_component_value = function(date_interval_specifier)
      return transf.date_component_name_value_dict.rfc3339like_dt(
        transf.date_interval_specifier.start_prefix_date_component_name_value_dict_where_date_component_value_is_not_min_date_component_value(date_interval_specifier)
      )
    end,
    end_rfc3339like_dt_where_date_component_value_is_not_max_date_component_value = function(date_interval_specifier)
      return transf.date_component_name_value_dict.rfc3339like_dt(
        transf.date_interval_specifier.end_prefix_date_component_name_value_dict_where_date_component_value_is_not_max_date_component_value(date_interval_specifier)
      )
    end,
    rfc3339like_dt = function(date_interval_specifier)
      local start_rfc3339like_dt = transf.date_interval_specifier.start_rfc3339like_dt_where_date_component_value_is_not_min_date_component_value(date_interval_specifier)
      local end_rfc3339like_dt = transf.date_interval_specifier.end_rfc3339like_dt_where_date_component_value_is_not_max_date_component_value(date_interval_specifier)
      if start_rfc3339like_dt == end_rfc3339like_dt then
        return start_rfc3339like_dt
      end
    end,
    rfc3339like_interval_where_date_component_value_is_not_max_date_component_value = function(date_interval_specifier)
      local start_rfc3339like_dt = transf.date_interval_specifier.start_rfc3339like_dt_where_date_component_value_is_not_min_date_component_value(date_interval_specifier)
      local end_rfc3339like_dt = transf.date_interval_specifier.end_rfc3339like_dt_where_date_component_value_is_not_max_date_component_value(date_interval_specifier)
      return start_rfc3339like_dt .. "_to_" .. end_rfc3339like_dt
    end,
    rf3339like_dt_or_interval = function(date_interval_specifier)
      local rfc3339like_dt = transf.date_interval_specifier.rfc3339like_dt(date_interval_specifier)
      return rfc3339like_dt or transf.date_interval_specifier.rfc3339like_interval_where_date_component_value_is_not_max_date_component_value(date_interval_specifier)
    end,
    event_table = function(date_interval_specifier)
      return {
        start = transf.date.full_rfc3339like_dt(date_interval_specifier.start),
        ["end"] = transf.date.full_rfc3339like_dt(date_interval_specifier.stop),
      }
    end,
  },
  date_component_name_value_dict = {
    date_component_name_list_set = function(date_component_name_value_dict)
      return transf.table_or_nil.kt_array(date_component_name_value_dict)
    end,
    date_component_value_list_set = function(date_component_name_value_dict)
      return transf.table_or_nil.vt_array(date_component_name_value_dict)
    end,
    date_component_name_list_not_set = function(date_component_name_value_dict)
      return transf.date_component_name_array.date_component_name_array_inverse(transf.date_component_name_value_dict.date_component_name_list_set(date_component_name_value_dict))
    end,
    date_component_value_list_not_set = function(date_component_name_value_dict)
      return get.date_component_name_list.date_component_value_list(
        transf.date_component_name_value_dict.date_component_name_list_not_set(date_component_name_value_dict),
        date_component_name_value_dict
      )
    end,
    date_component_name_ordered_list_set = function(date_component_name_value_dict)
      return transf.date_component_name_array.date_component_name_ordered_array(transf.date_component_name_value_dict.date_component_name_list_set(date_component_name_value_dict))
    end,
    date_component_value_ordered_list_set = function(date_component_name_value_dict)
      return get.date_component_name_list.date_component_value_ordered_list(
        transf.date_component_name_value_dict.date_component_name_list_set(date_component_name_value_dict),
        date_component_name_value_dict
      )
    end,
    date_component_name_ordered_list_not_set = function(date_component_name_value_dict)
      return transf.date_component_name_array.date_component_name_ordered_array(transf.date_component_name_value_dict.date_component_name_list_not_set(date_component_name_value_dict))
    end,
    largest_date_component_name_set = function(date_component_name_value_dict)
      return transf.date_component_name_array.largest_date_component_name(transf.date_component_name_value_dict.date_component_name_list_set(date_component_name_value_dict))
    end,
    smallest_date_component_name_set = function(date_component_name_value_dict)
      return transf.date_component_name_array.smallest_date_component_name(transf.date_component_name_value_dict.date_component_name_list_set(date_component_name_value_dict))
    end,
    largest_date_component_name_not_set = function(date_component_name_value_dict)
      return transf.date_component_name_array.largest_date_component_name(transf.date_component_name_value_dict.date_component_name_list_not_set(date_component_name_value_dict))
    end,
    smallest_date_component_name_not_set = function(date_component_name_value_dict)
      return transf.date_component_name_array.smallest_date_component_name(transf.date_component_name_value_dict.date_component_name_list_not_set(date_component_name_value_dict))
    end,
    min_date_component_name_value_dict_not_set = function(date_component_name_value_dict)
      return transf.date_component_name_array.min_date_component_name_value_dict(transf.date_component_name_value_dict.date_component_name_list_not_set(date_component_name_value_dict))
    end,
    max_date_component_name_value_dict_not_set = function(date_component_name_value_dict)
      return transf.date_component_name_array.max_date_component_name_value_dict(transf.date_component_name_value_dict.date_component_name_list_not_set(date_component_name_value_dict))
    end,
    min_full_date_component_name_value_dict = function(date_component_name_value_dict)
      return transf.two_tables.table_by_take_new(
        date_component_name_value_dict,
        transf.date_component_name_value_dict.min_date_component_name_value_dict_not_set(date_component_name_value_dict)
      )
    end,
    max_full_date_component_name_value_dict = function(date_component_name_value_dict)
      return transf.two_tables.table_by_take_new(
        date_component_name_value_dict,
        transf.date_component_name_value_dict.max_date_component_name_value_dict_not_set(date_component_name_value_dict)
      )
    end,
    date_interval_specifier = function(date_component_name_value_dict)
      return {
        start = date(transf.date_component_name_value_dict.min_full_date_component_name_value_dict(date_component_name_value_dict)),
        stop = date(transf.date_component_name_value_dict.max_full_date_component_name_value_dict(date_component_name_value_dict))
      }
    end, 
    prefix_date_component_name_value_dict = function(date_component_name_value_dict)
      local res = {}
      for _, date_component_name in transf.array.index_value_stateless_iter(mt._list.date.date_component_names) do
        if date_component_name_value_dict[date_component_name] == nil then
          return res
        end
        res[date_component_name] = date_component_name_value_dict[date_component_name]
      end
    end,
    prefix_date_component_name_list_set = function(date_component_name_value_dict)
      return transf.date_component_name_value_dict.date_component_name_list_set(
        transf.date_component_name_value_dict.prefix_date_component_name_value_dict(date_component_name_value_dict)
      )
    end,
    prefix_date_component_name_ordered_list_set = function(date_component_name_value_dict)
      return transf.date_component_name_array.date_component_name_ordered_list_set(
        transf.date_component_name_value_dict.prefix_date_component_name_value_dict(date_component_name_value_dict)
      )
    end,
    --- gets a date_component_names_ordered_list which has all date_component_names where there is a date_component_name within the date_component_name_value_dict that is smaller and equal that is not nil
    --- i.e. { month = 02, hour = 12 } will return { "year", "month", "day", "hour" }
    --- this should be equal to prefix_date_component_name_ordered_list_set if date_component_name_value_dict is a prefix_date_component_name_value_dict since prefix_ is defined as having no nil values before potential trailing nil values
    prefix_date_component_name_ordered_list_no_trailing_nil = function(date_component_name_value_dict)
      local ol = get.table.table_by_copy(mt._list.date.date_component_names)
      while(date_component_name_value_dict[
        ol[#ol]
      ] == nil) do
        ol[#ol] = nil
      end
      return ol
    end,
    rfc3339like_dt_string_format_part_specifier_array = function(date_component_name_value_dict)
      return hs.fnutils.imap(
        transf.date_component_name_value_dict.prefix_date_component_name_ordered_list_no_trailing_nil(date_component_name_value_dict),
        function(date_component_name)
          return {
            fallback = tblmap.date_component_name.rfc3339like_dt_string_format_part_fallback[date_component_name],
            value = date_component_name_value_dict[date_component_name],
            string_format_part = tblmap.date_component_name.rfc3339like_dt_string_format_part[date_component_name]
          }
        end
      )
    end,
    rfc3339like_dt = function(date_component_name_value_dict)
      local res = transf.string_format_part_specifier_array.string(
        transf.date_component_name_value_dict.rfc3339like_dt_string_format_part_specifier_array(date_component_name_value_dict)
      )
      if res:sub(-1) == "Z" then
        return res
      else
        return res:sub(1, -2) -- not full rfc3339like_dt, thus the trailing sep will be something like - or : and must be removed
      end
    end,
    date_component_name_value_dict_where_date_component_value_is_max_date_component_value = function(date_component_name_value_dict)
      return get.dict.key_value_fn_filtered_dict(
        date_component_name_value_dict,
        function(k, v) return v == tblmap.date_component_name.max_date_component_value[k] end
      )
    end,
    date_component_name_value_dict_where_date_component_value_is_min_date_component_value = function(date_component_name_value_dict)
      return get.dict.key_value_fn_filtered_dict(
        date_component_name_value_dict,
        function(k, v) return v == tblmap.date_component_name.min_date_component_value[k] end
      )
    end,
    date_component_name_value_dict_where_date_component_value_is_not_max_date_component_value = function(date_component_name_value_dict)
      return get.dict.key_value_fn_filtered_dict(
        date_component_name_value_dict,
        function(k, v) return v ~= tblmap.date_component_name.max_date_component_value[k] end
      )
    end,
    date_component_name_value_dict_where_date_component_value_is_not_min_date_component_value = function(date_component_name_value_dict)
      return get.dict.key_value_fn_filtered_dict(
        date_component_name_value_dict,
        function(k, v) return v ~= tblmap.date_component_name.min_date_component_value[k] end
      )
    end,
    prefix_date_component_name_value_dict_where_date_component_value_is_not_max_date_component_value = function(date_component_name_value_dict)
      local date_component_name_value_dict_where_date_component_value_is_not_max_date_component_value = transf.date_component_name_value_dict.date_component_name_value_dict_where_date_component_value_is_not_max_date_component_value(date_component_name_value_dict)
      return transf.date_component_name_value_dict.prefix_date_component_name_value_dict(date_component_name_value_dict_where_date_component_value_is_not_max_date_component_value)
    end,
    prefix_date_component_name_value_dict_where_date_component_value_is_not_min_date_component_value = function(date_component_name_value_dict)
      local date_component_name_value_dict_where_date_component_value_is_not_min_date_component_value = transf.date_component_name_value_dict.date_component_name_value_dict_where_date_component_value_is_not_min_date_component_value(date_component_name_value_dict)
      return transf.date_component_name_value_dict.prefix_date_component_name_value_dict(date_component_name_value_dict_where_date_component_value_is_not_min_date_component_value)
    end,
    

  },
  string_format_part_specifier = {
    string = function(string_format_part_specifier)
      local succ, res = pcall(string_format_part_specifier.string_format_part, string_format_part_specifier.value)
      local finalres 
      if succ then
        finalres = res
      else
        finalres = string_format_part_specifier.fallback
      end
      if finalres then
        return finalres .. (string_format_part_specifier.suffix or "")
      else
        return ""
      end
    end
  },
  string_format_part_specifier_array = {
    string = function(string_format_part_specifier_array)
      return get.string_or_number_array.string_by_joined(
        hs.fnutils.imap(
          string_format_part_specifier_array,
          transf.string_format_part_specifier.string
        ),
        ""
      )
    end
  },
  prefix_date_component_name_value_dict = {
    
    
  },
  suffix_date_component_name_value_dict = {

  },
  partial_date_component_name_value_dict = {

  },
  -- date components are full if all components are set
  full_date_component_name_value_dict = {
    date = function(full_date_component_name_value_dict)
      return date(full_date_component_name_value_dict)
    end,
    timestamp_s = function(full_date_component_name_value_dict)
      return os.time(full_date_component_name_value_dict)
    end,
    timestamp_ms = function(full_date_component_name_value_dict)
      return transf.date.timestamp_s(full_date_component_name_value_dict) * 1000
    end,
    full_rfc3339like_dt = function(full_date_component_name_value_dict)
      return transf.date.full_rfc3339like_dt(
        transf.full_date_component_name_value_dict.date(full_date_component_name_value_dict)
      )
    end,
  },
  iban = {
    cleaned_iban = function(iban)
      return select(1, string.gsub(iban, "[ %-_]", ""))
    end,
    bic = function(iban)
      return transf.cleaned_iban.bic(transf.iban.cleaned_iban(iban))
    end,
    bank_name = function(iban)
      return transf.cleaned_iban.bank_name(transf.iban.cleaned_iban(iban))
    end,
    iban_bic_bank_name_array = function(iban)
      return {iban, transf.iban.bic(iban), transf.iban.bank_name(iban)}
    end,
    bank_details_string = function(iban)
      return get.string_or_number_array.string_by_joined(
        transf.iban.iban_bic_bank_name_array(iban),
        "\n"
      )
    end,
    separated_iban = function(iban)
      return transf.cleaned_iban.separated_iban(transf.iban.cleaned_iban(iban))
    end,
  },
  cleaned_iban = {
    data = function(iban)
      local res = get.fn.rt_or_nil_by_memoized(rest, refstore.params.memoize.opts.invalidate_1_month_fs, "rest")({
        host = "openiban.com/",
        endpoint = "validate/" .. iban,
        params = { getBIC = "true" },
      })
      local data = res.bankData
      data.valid = res.valid
    end,
    bic = function(iban)
      return transf.cleaned_iban.data(iban).bic
    end,
    bank_name = function(iban)
      return transf.cleaned_iban.data(iban).bankName
    end,
    separated_iban = function(iban)
      return get.string_or_number_array.string_by_joined(
        get.string.string_array_groups_utf8_from_end(
          transf.iban.cleaned_iban(iban),
          4
        ),
        " "
      )
    end,
  },
  raw_contact = {
    -- Function for transforming a raw contact data into a structured table
    contact_table = function(raw_contact)

      -- The raw contact data, which is in yaml string format, is transformed into a table. 
      -- This is done because table format is easier to handle and manipulate in Lua.
      local contact_table = transf.yaml_string.not_userdata_or_function(raw_contact)

      -- In the vCard standard, some properties can have vcard_types. 
      -- For example, a phone number can be 'work' or 'home'. 
      -- Here, we're iterating over the keys in the contact data that have associated vcard_types.
      for _, vcard_key in transf.array.index_value_stateless_iter(mt._list.vcard.keys_with_vcard_type) do
      
          -- We iterate over each of these keys. Each key can have multiple vcard_types, 
          -- which we get as a comma-separated string (type_list). 
          -- We also get the corresponding value for these vcard_types.
          for type_list, value in transf.array.index_value_stateless_iter(contact_table[vcard_key]) do
          
              -- We split the type_list into individual vcard_types. This is done because 
              -- each vcard_type might need to be processed independently in the future. 
              -- It also makes the data more structured and easier to handle.
              local vcard_types = plstringx.split(type_list, ", ")
        
              -- For each vcard_type, we create a new key-value pair in the contact_table. 
              -- This way, we can access the value directly by vcard_type, 
              -- without needing to parse the type_list each time.
              for _, vcard_type in transf.array.index_value_stateless_iter(vcard_types) do
                  contact_table[vcard_key][vcard_type] = value
              end
          end
      end

      -- Here, we're handling the 'Addresses' key separately. Each address is a table itself,
      -- and we're adding a 'contact' field to each of these tables. 
      -- This 'contact' field holds the complete contact information.
      -- This could be useful in scenarios where address tables are processed individually,
      -- and there's a need to reference back to the full contact details.
      for _, address_table in transf.array.index_value_stateless_iter(contact_table["Addresses"]) do
          address_table.contact = contact_table
      end
      
      -- Finally, we return the contact_table, which now has a more structured and accessible format.
      return contact_table
    end

  },
  uuid = {
    raw_contact = function(uuid)
      return get.fn.rt_or_nil_by_memoized(transf.string.string_or_nil_by_evaled_env_bash_stripped)( "khard show --format=yaml uid:" .. uuid)
    end,
    contact_table = function(uuid)
      local raw_contact = transf.uuid.raw_contact(uuid)
      local contact_table = transf.raw_contact.contact_table(raw_contact)
      contact_table.uid = uuid
      return contact_table
    end,
  },
  contact_table = {
    uid = function (contact_table)
      return contact_table.uid
    end,
    pref_name = function(contact_table) return contact_table["Formatted name"] end,
    name_pre = function(contact_table) return contact_table["Prefix"] end,
    first_name = function(contact_table) return contact_table["First name"] end,
    middle_name = function(contact_table) return contact_table["Additional"] end,
    last_name = function(contact_table) return contact_table["Last name"] end,
    name_suf = function(contact_table) return contact_table["Suffix"] end,
    nickname = function(contact_table) return contact_table["Nickname"] end,
    anniversary = function(contact_table) return contact_table["Anniversary"] end,
    birthday = function(contact_table) return contact_table["Birthday"] end,
    organization = function(contact_table) return contact_table["Organization"] end,
    title = function(contact_table) return contact_table["Title"] end,
    role = function(contact_table) return contact_table["Role"] end,
    homepage_raw = function(contact_table) return contact_table["Webpage"] end,
    homepages = function(contact_table) 
      if type(contact_table.homepage_raw) == "table" then
        return contact_table.homepage_raw
      else
        return {contact_table.homepage_raw}
      end
    end,
    github_username = function(contact_table)
      return contact_table.Private["github-username"]
    end,
    github_url = function(contact_table)
      return transf.github_username.github_url(
        transf.contact_table.github_username(contact_table)
      )
    end,
    translation_rate = function(contact_table)
      return get.string_or_number.number_or_nil(contact_table.Private["translation-rate"])
    end,
    iban = function (contact_table)
      return get.contact_table.encrypted_data(contact_table, "iban")
    end,
    bic = function (contact_table)
      return transf.iban.bic(transf.contact_table.iban(contact_table))
    end,
    bank_name = function (contact_table)
      return transf.iban.bank_name(transf.contact_table.iban(contact_table))
    end,
    bank_details_string = function (contact_table)
      return transf.iban.bank_details_string(transf.contact_table.iban(contact_table))
    end,
    personal_tax_number = function (contact_table)
      return get.contact_table.tax_number(contact_table, "personal")
    end,
    full_name_western_array = function(contact_table)
      return transf.hole_y_arraylike.array({ 
        transf.contact_table.name_pref(contact_table),
        transf.contact_table.first_name(contact_table),
        transf.contact_table.middle_name(contact_table),
        transf.contact_table.last_name(contact_table),
        transf.contact_table.name_suf(contact_table)
      })
    end,
    full_name_western = function(contact_table)
      return get.string_or_number_array.string_by_joined(
        transf.contact_table.full_name_western_array(contact_table),
        " "
      )
    end,
    normal_name_western_array = function(contact_table)
      return transf.hole_y_arraylike.array({ 
        transf.contact_table.first_name(contact_table),
        transf.contact_table.last_name(contact_table),
      })
    end,
    normal_name_western = function(contact_table)
      return get.string_or_number_array.string_by_joined(
        transf.contact_table.normal_name_western_array(contact_table),
        " "
      )
    end,
    main_name = function(contact_table)
      return transf.contact_table.pref_name(contact_table) or transf.contact_table.normal_name_western(contact_table)
    end,
    full_name_eastern_array = function(contact_table)
      return transf.hole_y_arraylike.array({ 
        transf.contact_table.name_pref(contact_table),
        transf.contact_table.last_name(contact_table),
        transf.contact_table.first_name(contact_table),
        transf.contact_table.name_suf(contact_table)
      })
    end,
    full_name_eastern = function(contact_table)
      return get.string_or_number_array.string_by_joined(
        transf.contact_table.full_name_eastern_array(contact_table),
        " "
      )
    end,
    normal_name_eastern_array = function(contact_table)
      return transf.hole_y_arraylike.array({ 
        transf.contact_table.last_name(contact_table),
        transf.contact_table.first_name(contact_table),
      })
    end,
    normal_name_eastern = function(contact_table)
      return get.string_or_number_array.string_by_joined(
        transf.contact_table.normal_name_eastern_array(contact_table),
        " "
      )
    end,
    name_additions_array = function(contact_table)
      return transf.hole_y_arraylike.array({ 
        transf.contact_table.title(contact_table),
        transf.contact_table.role(contact_table),
        transf.contact_table.organization(contact_table),
      })
    end,
    name_additions = function(contact_table)
      return get.string_or_number_array.string_by_joined(
        transf.contact_table.name_additions_array(contact_table),
        ", "
      )
    end,
    indicated_nickname = function(contact_table)
      return '"' .. transf.contact_table.nickname(contact_table) .. '"'
    end,
    main_name_iban_bic_bank_name_array = function(contact_table)
      return {
        transf.contact_table.main_name(contact_table),
        transf.contact_table.iban(contact_table),
        transf.contact_table.bic(contact_table),
        transf.contact_table.bank_name(contact_table),
      }
    end,
    name_bank_details_string = function(contact_table)
      return get.string_or_number_array.string_by_joined(
        transf.contact_table.main_name_iban_bic_bank_name_array(contact_table),
        "\n"
      )
    end,
    vcard_type_phone_number_dict = function (contact_table)
      return contact_table.Phone
    end,
    phone_number_array = function (contact_table)
      return transf.table.value_set(transf.contact_table.vcard_type_phone_number_dict(contact_table))
    end,
    phone_number_string = function (contact_table)
      return get.string_or_number_array.string_by_joined(transf.contact_table.phone_number_array(contact_table), ", ")
    end,
    vcard_type_email_dict = function (contact_table)
      return contact_table.Email
    end,
    email_array = function (contact_table)
      return transf.table.value_set(transf.contact_table.vcard_type_email_dict(contact_table))
    end,
    email_string = function (contact_table)
      return get.string_or_number_array.string_by_joined(transf.contact_table.email_array(contact_table), ", ")
    end,
    vcard_type_address_table_dict = function (contact_table)
      return contact_table.Addresses
    end,
    address_table_array = function (contact_table)
      return transf.table.value_set(transf.contact_table.vcard_type_address_table_dict(contact_table))
    end,
    summary = function (contact_table)
      local sumstr = transf.contact_table.full_name_western(contact_table)
      if transf.contact_table.nickname(contact_table) then
        sumstr = sumstr .. " " .. transf.contact_table.indicated_nickname(contact_table)
      end
      if transf.contact_table.name_additions(contact_table) then
        sumstr = sumstr .. " (" .. transf.contact_table.name_additions(contact_table) .. ")"
      end
      if transf.contact_table.phone_number_string(contact_table) ~= "" then
        sumstr = sumstr .. " [" .. transf.contact_table.phone_number_string(contact_table) .. "]"
      end
      if transf.contact_table.email_string(contact_table) ~= "" then
        sumstr = sumstr .. " <" .. transf.contact_table.email_string(contact_table) .. ">"
      end
    end,
    main_email = function (contact_table)
      return get.contact_table.email(contact_table, "pref") or transf.contact_table.email_array(contact_table)[1]
    end,
    main_phone_number = function (contact_table)
      return get.contact_table.phone_number(contact_table, "pref") or transf.contact_table.phone_number_array(contact_table)[1]
    end,
    main_address_table = function (contact_table)
      return get.contact_table.address_table(contact_table, "pref") or transf.contact_table.address_table_array(contact_table)[1]
    end,
    main_relevant_address_label = function (contact_table)
      return transf.address_table.relevant_address_label(
        transf.contact_table.main_address_table(contact_table)
      )
    end

  },
  vcard_type_dict = {
    vcard_types = function (vcard_type_dict)
      return transf.table_or_nil.kt_array(vcard_type_dict)
    end
  },
  vcard_type_address_table_dict = {

  },
  address_table = {
    contact = function(single_address_table)
      return single_address_table.contact
    end,
    extended = function(single_address_table)
      return single_address_table.Extended
    end,
    postal_code = function(single_address_table)
      return single_address_table.Code
    end,
    region = function(single_address_table)
      return single_address_table.Region
    end,
    country_identifier_string = function(single_address_table)
      return single_address_table.Country
    end,
    iso_3366_1_alpha_2_country_code = function(single_address_table)
      return transf.country_identifier_string.iso_3366_1_alpha_2_country_code(
        transf.address_table.country_identifier_string(single_address_table)
      )
    end,
    street = function(single_address_table)
      return single_address_table.Street
    end,
    city = function(single_address_table)
      return single_address_table.City
    end,
    postal_code_city_line = function(single_address_table)
      return 
        transf.address_table.postal_code(single_address_table) .. " " ..
        transf.address_table.city(single_address_table)
    end,
    region_country_line = function(single_address_table)
      return 
        transf.address_table.region(single_address_table) .. ", " ..
        transf.address_table.country_identifier(single_address_table)
    end,
    addressee_array = function(single_address_table)
      return transf.hole_y_arraylike.array({
        transf.contact_table.main_name(single_address_table.contact),
        transf.address_table.extended(single_address_table)
      })
    end,
    in_country_location_array = function(single_address_table)
      return transf.hole_y_arraylike.array({
        transf.address_table.street(single_address_table),
        transf.address_table.postal_code(single_address_table),
        transf.address_table.city(single_address_table),
      })
    end,
    international_location_array = function(single_address_table)
      return transf.hole_y_arraylike.array({
        transf.address_table.street(single_address_table),
        transf.address_table.postal_code(single_address_table),
        transf.address_table.city(single_address_table),
        transf.address_table.region(single_address_table),
        transf.address_table.country_identifier(single_address_table),
      })
    end,
    relevant_location_array = function(single_address_table)
      if transf.address_table.iso_3366_1_alpha_2_country_code(single_address_table) == "de" then
        return transf.address_table.in_country_location_array(single_address_table)
      else
        return transf.address_table.international_location_array(single_address_table)
      end
    end,
    in_country_address_array = function(single_address_table)
      return transf.two_arrays.array_by_appended(
        transf.address_table.addressee_array(single_address_table),
        transf.address_table.in_country_location_array(single_address_table)
      )
    end,
    international_address_array = function(single_address_table)
      return transf.two_arrays.array_by_appended(
        transf.address_table.addressee_array(single_address_table),
        transf.address_table.international_location_array(single_address_table)
      )
    end,
    relevant_address_array = function(single_address_table)
      if transf.address_table.iso_3366_1_alpha_2_country_code(single_address_table) == "de" then
        return transf.address_table.in_country_address_array(single_address_table)
      else
        return transf.address_table.international_address_array(single_address_table)
      end
    end,
    in_country_address_label = function(single_address_table)
      return 
        get.string_or_number_array.string_by_joined(transf.address_table.addressee_array(single_address_table), "\n") .. "\n" ..
        transf.address_table.street(single_address_table) .. "\n" ..
        transf.address_table.postal_code_city_line(single_address_table)
    end,
    international_address_label = function(single_address_table)
      return 
        get.string_or_number_array.string_by_joined(transf.address_table.addressee_array(single_address_table), "\n") .. "\n" ..
        transf.address_table.street(single_address_table) .. "\n" ..
        transf.address_table.postal_code_city_line(single_address_table) .. "\n" ..
        transf.address_table.region_country_line(single_address_table)
    end,
    relevant_address_label = function(single_address_table)
      if transf.address_table.iso_3366_1_alpha_2_country_code(single_address_table) == "de" then
        return transf.address_table.in_country_address_label(single_address_table)
      else
        return transf.address_table.international_address_label(single_address_table)
      end
    end,

  },
  youtube_video_id = {
    youtube_video_item = function(id)
      return get.fn.rt_or_nil_by_memoized(rest, refstore.params.memoize.opts.invalidate_1_month_fs)({
        api_name = "youtube",
        endpoint = "videos",
        params = {
          id = id,
          part = "snippet,status",
        },
      }).items[1]
    end,
    title = function(id)
      return transf.youtube_video_id.youtube_video_item(id).snippet.title
    end,
    channel_title = function(id)
      return transf.youtube_video_id.youtube_video_item(id).snippet.channelTitle
    end,
    youtube_channel_id = function(id)
      return transf.youtube_video_id.youtube_video_item(id).snippet.channelId
    end,
    description = function(id)
      return transf.youtube_video_id.youtube_video_item(id).snippet.description
    end,
    upload_status = function(id)
      return transf.youtube_video_id.youtube_video_item(id).status.uploadStatus
    end,
    privacy_status = function(id)
      return transf.youtube_video_id.youtube_video_item(id).status.privacyStatus
    end,
    youtube_video_url = function(id)
      return "https://www.youtube.com/watch?v=" .. id
    end,
    captions_list = function(id)
      return get.fn.rt_or_nil_by_memoized(rest, refstore.params.memoize.opts.invalidate_1_month_fs)({
        api_name = "youtube",
        endpoint = "captions",
        params = {
          videoId = id,
          part = "snippet",
        },
      }).items
    end,
  },
  youtube_playlist_id = {
    youtube_playlist_item = function(id)
      return rest({
        api_name = "youtube",
        endpoint = "playlists",
        params = {
          id = id,
          part = "snippet,status",
        }
      }).items[1]
    end,
    title = function(id)
      return transf.youtube_playlist_id.youtube_playlist_item(id).snippet.title
    end,
    uploader = function(id)
      return transf.youtube_playlist_id.youtube_playlist_item(id).snippet.channelTitle
    end,
    youtube_playlist_url = function(id)
      return "https://www.youtube.com/playlist?list=" .. id
    end,
  },
  youtube_playlist_url = {
    youtube_playlist_id = function(url)
      return transf.url.param_table(url).list
    end,
    title = function(url)
      return transf.youtube_playlist_id.title(transf.youtube_playlist_url.youtube_playlist_id(url))
    end,
    uploader = function(url)
      return transf.youtube_playlist_id.uploader(transf.youtube_playlist_url.youtube_playlist_id(url))
    end,
  },
  youtube_video_url = {
    youtube_video_id = function(url)
      return transf.url.param_table(url).v
    end,
    title = function(url)
      return transf.youtube_video_id.title(transf.youtube_video_url.youtube_video_id(url))
    end,
    channel_title = function(url)
      return transf.youtube_video_id.channel_title(transf.youtube_video_url.youtube_video_id(url))
    end,
  },
  youtube_channel_id = {
    feed_url = function(id)
      return "https://www.youtube.com/feeds/videos.xml?channel_id=" .. id
    end,
    channel_url = function(id)
      return "https://www.youtube.com/channel/" .. id
    end,
    youtube_channel_item = function(id)
      return get.fn.rt_or_nil_by_memoized(rest, refstore.params.memoize.opts.invalidate_1_month_fs, "rest")({
        api_name = "youtube",
        endpoint = "channels",
        params = {
          id = id,
          part = "snippet,status",
        }
      }).items[1]
    end,
    channel_title = function(id)
      return transf.youtube_channel_id.youtube_channel_item(id).snippet.title
    end,
  },
  youtube_video_title = {
    cleaned = function(title)
      title = replace(title, {
        { cond = {_r = mt._r.text_bloat.youtube.video, _ignore_case = true}, mode="remove" },
        { cond = {_r = mt._r.text_bloat.youtube.misc, _ignore_case = true}, mode="remove" },
      })
      return title
    end,
  },
  youtube_channel_title = {
    cleaned = function(channel)
      channel = replace(channel, {
        { cond = {_r = mt._r.text_bloat.youtube.channel_topic_producer, _ignore_case = true}, mode="remove" },
        { value = {_r = mt._r.text_bloat.youtube.slash_suffix, _ignore_case = true}, mode="remove" },
      })
      return channel
    end,
  },
  handle = {
    youtube_channel_item = function(handle)
      return get.fn.rt_or_nil_by_memoized(rest, refstore.params.memoize.opts.invalidate_1_month_fs, "rest")({
        api_name = "youtube",
        endpoint = "channels",
        params = { handle = handle}
      }).items[1]
    end,
    youtube_channel_id = function(handle)
      return transf.handle.youtube_channel_item(handle).id
    end,
    channel_title = function(handle)
      return transf.handle.youtube_channel_item(handle).snippet.title
    end,
    feed_url = function(handle)
      return transf.youtube_channel_id.feed_url(transf.handle.youtube_channel_id(handle))
    end,
    raw_handle = function(handle)
      return eutf8.sub(handle, 2)
    end,
  },
  youtube_channel_url = {
    handle = function(url)
      return get.string.string_by_no_adfix(
        transf.url.path(url),
        "/"
      )
    end,
    youtube_channel_id = function(url)
      return transf.handle.youtube_channel_id(transf.youtube_channel_url.handle(url))
    end,
  },
  string = {
    consonants = function(str)
      error("todo")
    end,
    string_by_env_getter_comamnds_prepended = function(str)
      return string.format(
        "base64 -d <<< '%s' | /opt/homebrew/bin/bash -s",
        transf.string.base64_gen_string(
          "cd && source \"$HOME/.target/envfile\" && " ..  str
        )
      )
    end,
    string_by_minimal_locale_setter_commands_prepended = function(str)
      return "LC_ALL=en_US.UTF-8 && LANG=en_US.UTF-8 && LANGUAGE=en_US.UTF-8 && " .. str
    end,
    string_or_string_and_8_bit_pos_int_by_evaled_raw_bash = function(str)
      local command = transf.string.string_by_minimal_locale_setter_commands_prepended(str)
      local output, status, reason, code = hs.execute(command)
      if status then
        return output -- stdout
      else
        return output, code -- stderr, exit code
      end
    end,
    string_or_string_and_8_bit_pos_int_by_evaled_raw_bash_stripped = function(str)
      local res, code = transf.string.string_or_string_and_8_bit_pos_int_by_evaled_raw_bash(str)
      res = stringy.strip(res)
      return res, code
    end,
    string_or_nil_by_evaled_raw_bash_stripped = function(str)
      local res, code = transf.string.string_or_string_and_8_bit_pos_int_by_evaled_raw_bash_stripped(str)
      if code == 0 then
        return res
      else
        return nil
      end
    end,
    string_or_err_by_evaled_raw_bash_stripped = function(str)
      local res, code = transf.string.string_or_string_and_8_bit_pos_int_by_evaled_raw_bash_stripped(str)
      if code == 0 then
        return res
      else
        error("Exit code " .. code .. " for command " .. str ". Stderr:\n\n" .. res)
      end
    end,
    string_or_string_and_8_bit_pos_int_by_evaled_env_bash = function(str)
      local command = transf.string.string_by_env_getter_comamnds_prepended(str)
      local output, status, reason, code = hs.execute(command)
      if status then
        return output -- stdout
      else
        return output, code -- stderr, exit code
      end
    end,
    bool_by_evaled_env_bash_success = function(str)
      local res, code = transf.string.string_or_string_and_8_bit_pos_int_by_evaled_env_bash(str)
      return code == 0
    end,
    string_or_string_and_8_bit_pos_int_by_evaled_env_bash_stripped = function(str)
      local res, code = transf.string.string_or_string_and_8_bit_pos_int_by_evaled_env_bash(str)
      res = stringy.strip(res)
      return res, code
    end,
    string_or_nil_by_evaled_env_bash_stripped = function(str)
      local res, code = transf.string.string_or_string_and_8_bit_pos_int_by_evaled_env_bash_stripped(str)
      if code == 0 then
        return res
      else
        return nil
      end
    end,
    string_or_err_by_evaled_env_bash_stripped = function(str)
      local res, code = transf.string.string_or_string_and_8_bit_pos_int_by_evaled_env_bash_stripped(str)
      if code == 0 then
        return res
      else
        error("Exit code " .. code .. " for command " .. str ". Stderr:\n\n" .. res)
      end
    end,
    string_or_err_by_evaled_env_bash = function(str)
      local res, code = transf.string.string_or_string_and_8_bit_pos_int_by_evaled_env_bash(str)
      if code == 0 then
        return res
      else
        error("Exit code " .. code .. " for command " .. str ". Stderr:\n\n" .. res)
      end
    end,
    string_or_err_by_evaled_env_bash_stripped_noempty = function(str)
      local res = transf.string.string_or_err_by_evaled_env_bash_stripped(str)
      if res == "" then
        error("Empty result for command " .. str)
      else
        return res
      end
    end,
    not_userdata_or_function_or_err_by_evaled_env_bash_parsed_json = function(str)
      local res = transf.string.string_or_err_by_evaled_env_bash_stripped_noempty(str)
      return transf.json_string.not_userdata_or_function(res)
    end,
    table_or_err_by_evaled_env_bash_parsed_json = function(str)
      local res = transf.string.not_userdata_or_function_or_err_by_evaled_env_bash_parsed_json(str)
      if type(res) == "table" then
        return res
      else
        error("Result for command " .. str .. " is not a table")
      end
    end,
    table_or_nil_by_evaled_env_bash_parsed_json = function(str)
      return transf.n_anys_or_err_ret_fn.n_anys_or_nil_ret_fn_by_pcall(
        transf.string.table_or_err_by_evaled_env_bash_parsed_json
      )(str)
    end,
    table_or_err_by_evaled_env_bash_parsed_json_err_error_key = function(str)
      local res = transf.string.table_or_err_by_evaled_env_bash_parsed_json(str)
      if res.error then
        error("Error for command " .. str .. ":\n\n" .. transf.not_userdata_or_function.json_string_pretty(res.error))
      else
        return res
      end
    end,
    table_or_nil_by_evaled_env_bash_parsed_json_nil_error_key = function(str)
      return transf.n_anys_or_err_ret_fn.n_anys_or_nil_ret_fn_by_pcall(
        transf.string.table_or_err_by_evaled_env_bash_parsed_json_err_error_key
      )(str)
    end,
    escaped_lua_regex = function(str)
      return replace(str, to.regex.escaped_lua_regex)
    end,
    escaped_general_regex = function(str)
      return replace(str, to.regex.escaped_general_regex)
    end,
    window_array_by_pattern = function(str)
      local res = hs.window.find(str)
      if type(res) == "table" then return res 
      else return {res} end
    end,
    window_array_by_title = function(str)
      local res = hs.window.get(str)
      if type(res) == "table" then return res 
      else return {res} end
    end,
    in_cache_dir = function(data, type)
      return env.XDG_CACHE_HOME .. "/hs/" .. (type or "default") .. "/" .. transf.string.safe_filename(data)
    end,
    in_tmp_dir = function(data, type) -- in contrast to the above method, we also ensure that it's unique by using a timestamp
      return env.TMPDIR .. "/hs/" .. (type or "default") .. "/" .. os.time() .. "-" .. transf.string.safe_filename(data)
    end,
    qr_utf8_image_bow = function(data)
      return get.fn.rt_or_nil_by_memoized(transf.string.string_or_nil_by_evaled_env_bash_stripped)("qrencode -l M -m 2 -t UTF8 " .. transf.string.single_quoted_escaped(data))
    end,
    qr_utf8_image_wob = function(data)
      return get.fn.rt_or_nil_by_memoized(transf.string.string_or_err_by_evaled_env_bash, refstore.params.memoize.opts.stringify_json)("qrencode -l M -m 2 -t UTF8i " .. transf.string.single_quoted_escaped(data))
    end,
    qr_png_in_cache = function(data)
      local path = transf.string.in_cache_dir(data, "qr")
      dothis.string.generate_qr_png(data, path)
      return path
    end,
    --- does the minimum to make a string safe for use as a filename, but doesn't impose any policy
    safe_filename = function(filename)
      -- Replace forward slash ("/") with underscore
      filename = eutf8.gsub(filename, "/", "_")

      -- Replace control characters (ASCII values 0 - 31 and 127)
      for i = 0, 31 do
        filename = eutf8.gsub(filename, string.char(i), "_")
      end
      filename = eutf8.gsub(filename, string.char(127), "_")

      -- Replace sequences of whitespace characters with a single underscore
      filename = eutf8.gsub(filename, "%s+", "_")

      if filename == "." then
        filename = "_"
      elseif filename == ".." then
        filename = "__"
      end

      if #filename > 255 then
        filename = eutf8.sub(filename, 1, 255)
      elseif #filename == 0 then
        filename = "_"
      end
      
      return filename
    end,
    snake_case = function(str)
      local naive_snake_case = get.string.string_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "[^%w%d]+", "_")
      local multi_cleaned_snake_case = get.string.string_by_continuous_collapsed_eutf8_w_regex_quantifiable(naive_snake_case, "_")
      return get.string.string_by_no_adfix(multi_cleaned_snake_case, "_")
    end,
    lower_snake_case = function(str)
      return eutf8.lower(transf.string.snake_case(str))
    end,
    upper_snake_case = function(str)
      return eutf8.upper(transf.string.snake_case(str))
    end,
    snake_case_parts = function(str) -- word separation is notoriously tricky. For now, we'll just use the same logic as in the snake_case function
      return stringy.split(transf.string.snake_case(str), "_")
    end,
    upper_camel_snake_case = function(str)
      local parts = transf.string.snake_case_parts(str)
      local upper_parts = hs.fnutils.imap(parts, transf.string.string_by_first_eutf8_upper)
      return get.string_or_number_array.string_by_joined(upper_parts, "_")
    end,
    lower_camel_snake_case = function(str)
      return eutf8.lower(transf.string.upper_camel_snake_case(str))
    end,
    upper_camel_case = function(str)
      local parts = transf.string.snake_case_parts(str)
      local upper_parts = hs.fnutils.imap(parts, transf.string.string_by_first_eutf8_upper)
      return get.string_or_number_array.string_by_joined(upper_parts, "")
    end,
    lower_camel_case = function(str)
      return eutf8.lower(transf.string.upper_camel_case(str))
    end,
    kebap_case = function(str)
      local naive_kebap_case = get.string.string_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "[^%w%d]+", "-")
      local multi_cleaned_kebap_case = get.string.string_by_continuous_collapsed_eutf8_w_regex_quantifiable(naive_kebap_case, "-")
      return get.string.string_by_no_adfix(multi_cleaned_kebap_case, "-")
    end,
    lower_kebap_case = function(str)
      return eutf8.lower(transf.string.kebap_case(str))
    end,
    upper_kebap_case = function(str)
      return eutf8.upper(transf.string.kebap_case(str))
    end,
    string_by_all_eutf8_lower = eutf8.lower,
    string_by_all_eutf8_upper = eutf8.upper,
    string_by_first_eutf8_upper = function(str)
      return eutf8.upper(eutf8.sub(str, 1, 1)) .. eutf8.sub(str, 2)
    end,
    string_by_first_eutf8_lower = function(str)
      return eutf8.lower(eutf8.sub(str, 1, 1)) .. eutf8.sub(str, 2)
    end,
    alphanum = function(str)
      return get.string.string_by_removed_eutf8_w_regex_quantifiable(str, "[^%w%d]")
    end,
    encoded_query_param_value = function(str)
      return plurl.quote(str, true)
    end,
    encoded_query_param_value_by_folded = function(str)
      local folded = transf.string.singleline_string_by_folded(str)
      return transf.string.encoded_query_param_value(folded)
    end,
    string_by_percent_decoded_also_plus = plurl.unquote,
    string_by_percent_decoded_no_plus = function(str)
      return transf.string.string_by_percent_decoded_also_plus(
        eutf8.gsub(str, "%+", "%%2B") -- encode plus sign as %2B, so that it then gets decoded as a plus sign
      )
    end,
    escaped_csv_field = function(field)
      local escaped = eutf8.gsub(field, '"', '""')
      return '"' .. escaped  .. '"'
    end,
    unicode_prop_table_array = function(str)
      return get.fn.rt_or_nil_by_memoized(transf.string.table_or_err_by_evaled_env_bash_parsed_json)("uni identify -compact -format=all -as=json".. transf.string.single_quoted_escaped(str))
    end,
    unicode_prop_table_item_array = function(str)
      return transf.unicode_prop_table_array.unicode_prop_table_item_array(
        transf.string.unicode_prop_table_array(str)
      )
    end,
    single_quoted_escaped = function(str)
      return " '" .. eutf8.gsub(str, "'", "\\'") .. "'"
    end,
    double_quoted_escaped = function(str)
      return ' "' .. eutf8.gsub(str, '"', '\\"') .. '"'
    end,
    string_by_envsubsted = function(str)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("echo " .. transf.string.single_quoted_escaped(str) .. " | envsubst")
    end,
    binary_string = basexx.to_bit,
    hex_string = basexx.to_hex,
    base64_gen_string = basexx.to_base64,
    base64_url_string = basexx.to_url64,
    base32_gen_string = basexx.to_base32,
    base32_crock_string = basexx.to_crockford,
    html_entitiy_encoded_string = htmlEntities.encode,
    html_entitiy_decoded_string = htmlEntities.decode,
    two_strings_by_split_header = function(str)
      local k, v = eutf8.match(str, "^([^:]+):%s*(.+)$")
      return transf.string.string_by_initial_lower(k), v
    end,
    two_string_or_nils_by_split_envlike = function(str)
      return get.string.two_strings_split_or_nil(str, "=")
    end,
    two_string_or_nils_by_split_ini = function(str)
      return get.string.two_strings_split_or_nil(str, " = ")
    end,
    title_case = function(str)
      local words, removed = get.string.two_string_arrays_by_onig_regex_match_nomatch(str, "[ :–\\—\\-\\t\\n]")
      local title_cased_words = hs.fnutils.imap(words, transf.word.title_case_policy)
      title_cased_words[1] = transf.string.string_by_first_eutf8_upper(title_cased_words[1])
      title_cased_words[#title_cased_words] = transf.string.string_by_first_eutf8_upper(title_cased_words[#title_cased_words])
      local arr = transf.two_arrays.array_by_interleaved_stop_a1(title_cased_words, removed)
      return get.string_or_number_array.string_by_joined(arr, "")
    end, 
    romanized_deterministic = function(str)
      local raw_romanized = transf.string.string_or_nil_by_evaled_env_bash_stripped(
         "echo -n" .. transf.string.single_quoted_escaped(str) .. "| kakasi -iutf8 -outf8 -ka -Ea -Ka -Ha -Ja -s -ga" 
      )
      local is_ok, romanized = pcall(eutf8.gsub, raw_romanized, "(%w)%^", "%1%1")
      if not is_ok then
        return str -- if there's an error, just return the original string
      end
      replace(romanized, {{"(kigou)", "'"}, {}}, {
        mode = "remove",
      })
      return romanized
    end,
    lower_snake_case_string_by_romanized = function(str)
      str = eutf8.gsub(str, "[%^']", "")
      str = transf.string.romanized_deterministic(str)
      str = eutf8.lower(str)
      str = transf.string.snake_case(str)
      return str
    end,
    romanized_gpt = function(str)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_string({input = str, query =  "Please romanize the following text with wapuro-like romanization, where:\n\nっ -> duplicated letter (e.g. っち -> cchi)\nlong vowel mark -> duplicated letter (e.g. ローマ -> roomaji)\nづ -> du\nんま -> nma\nじ -> ji\nを -> wo\nち -> chi\nparticles are separated by spaces (e.g. これに -> kore ni)\nbut morphemes aren't (真っ赤 -> makka)", shots = {
        {"こっち", "kocchi"}
      }})
    end,
    singleline_string_by_folded = function(str)
      return get.string.string_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "[\n\r\v\f]", " ")
    end,
    whitespace_collapsed_string = function(str)
      return get.string.string_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "%s", " ")
    end,
    nowhitespace_string = function(str)
      return get.string.string_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "%s", "")
    end,
    --- @param str string
    --- @return string[]
    bytechar_array = function(str)
      local t = {}
      for i = 1, #str do
        t[i] = str:sub(i, i)
      end
      return t
    end,

    len_bytechars = function(str)
      return #transf.string.bytechar_array(str)
    end,


    --- @param str string
    --- @return string[]
    char_array = function(str)
      local t = {}
      for i = 1, eutf8.len(str) do
        t[i] = eutf8.sub(str, i, i)
      end
      return t
    end,

    len_chars = function(str)
      return #transf.string.char_array(str)
    end,

    --- @param str string
    --- @return string[]
    lines = function(str)
      return stringy.split(
        stringy.strip(str),
        "\n"
      )
    end,

    len_lines = function(str)
      return #transf.string.lines(str)
    end,


    noempty_line_string_array = function(str)
      return transf.string_array.noemtpy_string_array(
        transf.string.lines(str)
      )
    end,
    noindent_content_lines = function(str)
      return transf.string_array.noindent_string_array(transf.string.noempty_line_string_array(str))
    end,
    nocomment_noindent_content_lines = function(str)
      return transf.string_array.nocomment_noindent_string_array(transf.string.noempty_line_string_array(str))
    end,

    first_line = function(str)
      return transf.string.lines(str)[1]
    end,
    first_content_line = function(str)
      return transf.string.noempty_line_string_array(str)[1]
    end,
    last_line = function(str)
      local lines = transf.string.lines(str)
      return lines[#lines]
    end,
    last_content_line = function(str)
      local lines = transf.string.noempty_line_string_array(str)
      return lines[#lines]
    end,
    first_char = function(str)
      return eutf8.sub(str, 1, 1)
    end,
    last_char = function(str)
      return eutf8.sub(str, -1)
    end,
    no_final_newlines = function(str)
      return eutf8.gsub(str, "\n+$", "")
    end,
    one_final_newline = function(str)
      return eutf8.gsub(str, "\n+$", "\n")
    end,
    here_string = function(str)
      return " <<EOF\n" .. str .. "\nEOF"
    end,
    rfc3339like_dt = function(str)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_string({input = str, query = "Please transform the following thing indicating a date(time) into the corresponding RFC3339-like date(time) (UTC). Leave out elements that are not specified."})
    end,
    raw_contact = function(searchstr)
      return get.fn.rt_or_nil_by_memoized(transf.string.string_or_nil_by_evaled_env_bash_stripped)("khard show --format=yaml " .. searchstr )
    end,
    contact_table = function(searchstr)
      local raw_contact = transf.string.raw_contact(searchstr)
      local contact = transf.raw_contact.contact_table(raw_contact)
      return contact
    end,
    event_table = function(str)
      local components = plstringx.split(str, mt._contains.unique_field_separator)
      local parsed = ovtable.new()
      for i, component in transf.array.index_value_stateless_iter(components) do
        local key = mt._list.khal.parseable_format_components[i]
        if key == "alarms" then
          parsed[key] = stringy.split(component, ",")
        elseif key == "description" then
          parsed[key] = component
        else
          parsed[key] = plstringx.replace(component, "\n", "")
        end
      end
      return parsed
    end,
    kana_inner = function(argstr)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("kana --vowel-shortener x " .. argstr )
    end,
    kana_inner_nospaces = function(argstr)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("kana --vowel-shortener x " .. argstr .. "| tr -d ' '")
    end,
    hiragana_only = function(str)
      return transf.string.kana_inner(transf.string.single_quoted_escaped(str))
    end,
    katakana_only = function(str)
      return transf.string.kana_inner("--katakana --extended" .. transf.string.single_quoted_escaped(str))
    end,
    hiragana_punct = function(str)
      return transf.string.kana_inner_nospaces("--punctuation" .. transf.string.single_quoted_escaped(str))
    end,
    katakana_punct = function(str)
      return transf.string.kana_inner_nospaces("--katakana --extended --punctuation" .. transf.string.single_quoted_escaped(str))
    end,
    kana_mixed = function(str)
      return transf.string.kana_inner("--extended --punctuation --kana-toggle 'Δ' --raw-toggle '†'" .. transf.string.single_quoted_escaped(str))
    end,
    japanese_writing = function(str)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_string({input = str, query =  "You're a dropin IME for already written text. Please transform the following into its Japanese writing system equivalent:"})
    end,
    kana_readings = function(str)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_string({input = str, query =  "Provide kana readings for:"})
    end,
    ruby_annotated_kana = function(str)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_string({input = str, query =  "Add kana readings to this text as <ruby> annotations, including <rp> fallback:"})
    end,
    --- @param str string
    --- @return hs.styledtext
    with_styled_start_end_markers = function(str)
      local res =  hs.styledtext.new("^" .. str .. "$")
      res = get.styledtext.styledtext_with_slice_styled(res, "light", 1, 1)
      res = get.styledtext.styledtext_with_slice_styled(res, "light", #res, #res)
      return res
    end,
    email_quoted = function(str)
      return plstringx.join(
        "\n",
        hs.fnutils.imap(
          plstringx.splitlines(
            stringy.strip(str)
          ),
          function(v)
            if stringy.startswith(v, ">") then
              return ">" .. v
            else
              return ">" .. " " .. v
            end
          end
        )
      )
    end,
    url_array = function(str)
      return transf.string_array.filter_nocomment_noindent_to_url_array(
        transf.string.lines(str)
      )
    end,
    whole_regex = function(str)
      return "^" .. str .. "$"
    end,
    string_pair_split_by_minus_or_nil = function(str)
      return get.string.string_pair_split_or_nil(str, "-")
    end,
    prompted_once_string_pair_for = function(str)
      return transf.prompt_spec.any({
        prompter = transf.prompt_args_string.string_or_nil_and_boolean,
        transformer = transf.string.string_pair_split_by_minus_or_nil,
        prompt_args = {
          message = "Please enter a string pair for " .. str .. " (e.g. 'foo-bar')",
        }
      })
    end,
    prompted_multiple_string_pair_array_for = function(str)
      return transf.prompt_spec.any_array({
        prompter = transf.prompt_args_string.string_or_nil_and_boolean,
        transformer = transf.string.string_pair_split_by_minus_or_nil,
        prompt_args = {
          message = "Please enter a string pair for " .. str .. " (e.g. 'foo-bar')",
        }
      })
    end,
    prompted_once_string_from_default = function(str)
      return get.string.string_by_prompted_once_from_default(str, "Enter a string...")
    end,
    prompted_once_alphanum_minus_underscore_string_from_default = function(str)
      return get.string.alphanum_minus_underscore_string_by_prompted_once_from_default(str, "Enter a string (alphanum, minus, underscore)...")
    end,
    nowhitespace_string_array = function(str)
      return get.string.string_array_split_single_char_stripped(
        transf.string.whitespace_collapsed_string(str),
        " "
      )
    end,
    nonindicated_number_string = function(str)
      local res = str
      res = eutf8.gsub(res, ",", ".")
      res = eutf8.gsub(str, "^[0-9a-zA-Z]+", "")
      return res
    end,
  },
  line = {
    noindent = function(str)
      return eutf8.match(str, "^%s*(.*)$")
    end,
    nocomment = function(str)
      return plstringx.split(str, " # ")[1]
    end,
    nocomment_noindent = function(str)
      return transf.line.noindent(transf.line.nocomment(str))
    end,
    comment = function(str)
      return plstringx.split(str, " # ")[2]
    end,
  },
  potentially_atpath = {
    potentially_atpath_resolved = function(str)
      if stringy.startswith(str, "@") then
        local valpath = eutf8.sub(str, 2)
        valpath = hs.fs.pathToAbsolute(valpath, true)
        str = "@" .. valpath
      end
      return str
    end,
  },
  alphanum_minus = {
    alphanum = function(str)
      return eutf8.gsub(str, "-", "")
    end,
  },
  alphanum_underscore = {
    evaled_shell_var = function(str)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("echo $" .. str)
    end,
  },
  alphanum_minus_underscore = {
    
  },
  pass_item_name = {
    password = function(pass_item_name)
      return get.pass_item_name.value(pass_item_name, "passw")
    end,
    password_absolute_path = function(pass_item_name)
      return get.pass_item_name.path(pass_item_name, "passw")
    end,
    recovery_key = function(pass_item_name)
      return get.pass_item_name.value(pass_item_name, "recovery")
    end,
    recovery_key_absolute_path = function(pass_item_name)
      return get.pass_item_name.path(pass_item_name, "recovery")
    end,
    security_question = function(pass_item_name)
      return get.pass_item_name.value(pass_item_name, "security_question")
    end,
    security_question_absolute_path = function(pass_item_name)
      return get.pass_item_name.path(pass_item_name, "security_question")
    end,
    username_or_default = function(pass_item_name)
      return transf.pass_item_name.username(pass_item_name) or env.MAIN_EMAIL
    end,
    username = function(pass_item_name)
      return transf.plaintext_file.no_final_newlines(
        transf.pass_item_name.username_absolute_path(pass_item_name)
      )
    end,
    username_absolute_path = function(pass_item_name)
      return get.pass_item_name.path(pass_item_name, "username")
    end,
    otp = function(item)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("pass otp otp/" .. item)
    end,
    otp_absolute_path = function(item)
      return "otp/" .. item
    end,
  },
  cc_name = {
    cc_number = function(cc_name)
      return get.pass_item_name.value(cc_name, "cc/nr")
    end,
    cc_expiry = function(cc_name)
      return get.pass_item_name.value(cc_name, "cc/exp")
    end,
  },
  styledtext = {
    string = function(st)
      return st:getString()
    end,
  },
  styledtext_or_string = {
    string = function(st_or_str)
      if type(st_or_str) == "string" then
        return st_or_str
      else
        return transf.styledtext.string(st_or_str)
      end
    end,
  },
  yaml_string = {
    not_userdata_or_function = function(str)
      local res = yaml.load(str)
      null2nil(res)
      return res
    end,
    json_string = function(str)
      return transf.not_userdata_or_function.json_string(
        transf.yaml_string.not_userdata_or_function(str)
      )
    end,
  },
  json_string = {
    not_userdata_or_function = function(str)
      return transf.fn.rt_or_nil_fn_by_pcall(json.decode)(str)
    end,
    table_or_nil = function(str)
      local res =  transf.not_userdata_or_function.json_string(str)
      if type(res) == "table" then
        return res
      else
        return nil
      end
    end,
    yaml_string = function(str)
      return transf.not_userdata_or_function.yaml_string(
        transf.json_string.not_userdata_or_function(str)
      )
    end,
  },
  toml_string = {
    assoc = toml.decode
  },
  yaml_file = {
    not_userdata_or_function = function(path)
      return transf.yaml_string.not_userdata_or_function(transf.plaintext_file.string_by_contents(path))
    end
  },
  
  ini_string = {
    assoc = function(str)
      return transf.string.table_or_err_by_evaled_env_bash_parsed_json(
        "jc --ini <<EOF " .. str .. "EOF"
      )
    end,
  },
  plaintext_dictionary_file = {
    table = function(file)
      if is.plaintext_dictionary_file.yaml_file(file) then
        return transf.yaml_file.not_userdata_or_function(file)
      elseif is.plaintext_dictionary_file.json_file(file) then
        return transf.json_file.not_userdata_or_function(file)
      elseif is.plaintext_dictionary_file.ini_file(file) then
        return transf.ini_file.assoc(file)
      elseif is.plaintext_dictionary_file.toml_file(file) then
        return transf.toml_file.assoc(file)
      elseif is.plaintext_dictionary_file.ics_file(file) then
        return transf.ics_file.array_of_assocs(file) 
      end
    end
  },
  header_string = {
    dict = function(str)
      local lines = transf.string.noempty_line_string_array(str)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        lines,
        transf.string.two_strings_by_split_header
      )
    end
  },
  base64_gen_string = {
    decoded_string = basexx.from_base64,
  },
  base64_url_string = {
    decoded_string = basexx.from_url64,
  },
  base32_gen_string = {
    decoded_string = basexx.from_base32,
  },
  base32_crock_string = {
    decoded_string = basexx.from_crockford,
  },
  base64 = {
    decoded_string = function(b64)
      if is.printable_ascii_string.base64_gen_string(b64) then
        return transf.base64_gen_string.decoded_string(b64)
      else
        return transf.base64_url_string.decoded_string(b64)
      end
    end
  },
  base32 = {
    decoded_string = function(b32)
      if is.printable_ascii_string.base32_gen_string(b32) then
        return transf.base32_gen_string.decoded_string(b32)
      else
        return transf.base32_crock_string.decoded_string(b32)
      end
    end
  },
  event_table = {
    calendar_template = function(event_table)
      local template = transf["nil"].calendar_template_empty()
      for key, value in transf.table.stateless_key_value_iter(event_table) do
        if template[key] then
          if key == "repeat" then
            for subkey, subvalue in transf.table.stateless_key_value_iter(value) do
              template[key][subkey].value = subvalue
            end
          else
            template[key].value = value
          end
        end
      end
      if template.alarms.value then 
        template.alarms.value = get.string_or_number_array.string_by_joined(template.alarms.value, ",")
      end
      return transf.table.yaml_aligned(template)

    end,
    event_tagline = function(event_table)
      local str = event_table.start
      if event_table["end"] then
        str = str .. " - " .. event_table["end"]
      end
      str = str .. " " .. event_table.calendar .. ":"
      if event_table.title then
        str = str .. " " .. event_table.title
      end
      if event_table.location then
        str = str .. " @ " .. event_table.location
      end
      if event_table.description then
        str = str .. " :: " .. event_table.description
      end
      if event_table.url then
        str = str .. " Link: " .. event_table.url
      end
      return str
    end,
    calendar = function(event_table)
      return event_table.calendar
    end,
    title = function(event_table)
      return event_table.title
    end,
    location = function(event_table)
      return event_table.location
    end,
    description = function(event_table)
      return event_table.description
    end,
    url = function(event_table)
      return event_table.url
    end,

    start_rfc3339like_dt = function(event_table)
      return event_table.start
    end,
    end_rfc3339like_dt = function(event_table)
      return event_table["end"]
    end,
    start_date = function(event_table)
      return transf.rfc3339like_dt.min_date(event_table.start)
    end,
    end_date = function(event_table)
      return transf.rfc3339like_dt.min_date(event_table["end"])
    end,
    date_interval_specifier = function(event_table)
      return {
        start = transf.event_table.start_date(event_table),
        ["end"] = transf.event_table.end_date(event_table),
      }
    end,
  },
  search_engine = {
    action_table_item = function(search_engine)
      return {
        i = emj.search .. emj[search_engine],
        d = dsc.search .. dsc[search_engine],
        dothis = get.fn.arbitrary_args_bound_or_ignored_fn(
          dothis.string.search,
          {a_use, search_engine}
        )
      }
    end,
  },
  multiline_string = {
    trimmed_lines_multiline_string = function(str)
      local lines = get.string.string_array_split(str, "\n")
      local trimmed_lines = hs.fnutils.imap(lines, stringy.strip)
      return get.string_or_number_array.string_by_joined(trimmed_lines, "\n")
    end,
    iso_3366_1_alpha_2_country_code_key_mullvad_city_code_key_mullvad_relay_identifier_string_array_value_dict_value_dict = function(raw)
      local raw_countries = get.string.string_array_split_noempty(raw, "\n\n")
      local countries = {}
      for _, raw_country in transf.array.index_value_stateless_iter(raw_countries) do
        local raw_country_lines = get.string.string_array_split_single_char_noempty(raw_country, "\n")
        local country_header = raw_country_lines[1]
        local country_code = onig.match(country_header, "\\(([^\\)]+\\)")
        if country_code == nil then error("could not find country code in header. header was " .. country_header) end
        local payload_lines = transf.array.array_by_nofirst(raw_country_lines)
        countries[country_code] = {}
        local city_code
        for _, payload_line in transf.array.index_value_stateless_iter(payload_lines) do
          if stringy.startswith(payload_line, "\t\t") then -- line specifying a single relay
            local relay_code = payload_line:match("^\t\t([%w%-]+) ") -- lines look like this: \t\tfi-hel-001 (185.204.1.171) - OpenVPN, hosted by Creanova (Mullvad-owned)
            dothis.array.push(countries[country_code][city_code], relay_code)
          elseif stringy.startswith(payload_line, "\t") then -- line specifying an entire city
            city_code = onig.match(payload_line," \\(([^\\)]+\\) " ) -- lines look like this: \tHelsinki (hel) @ 60.19206°N, 24.94583°W
            countries[country_code][city_code] = {}
          end
        end

      end
    
      return countries
    end,
    
  },
  multirecord_string = {
    array_of_record_strings = function(str)
      return get.string.string_array_split_noempty(
        str,
        mt._contains.unique_record_separator
      )
    end,
    array_of_event_tables = function(str)
      return hs.fnutils.imap(
        transf.multirecord_string.array_of_record_strings(str),
        transf.string.event_table
      )
    end,
  },
  word = {
    title_case_policy = function(word)
      if get.array.bool_by_contains(mt._contains.small_words, word) then
        return word
      elseif eutf8.find(word, "%u") then -- words with uppercase letters are presumed to already be correctly title cased (acronyms, brands, the like)
        return word
      else
        return transf.string.string_by_first_eutf8_upper(word)
      end
    end,
    raw_syn_output = function(str)
      return get.fn.rt_or_nil_by_memoized(transf.string.string_or_nil_by_evaled_env_bash_stripped)( "syn -p" .. transf.string.single_quoted_escaped(str) )
    end,
    term_syn_specifier_dict = function(str)
      local synonym_parts = plstringx.split(transf.word.raw_syn_output(str), "\n\n")
      local synonym_tables = get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        synonym_parts,
        function (synonym_part)
          local synonym_part_lines = stringy.split(synonym_part, "\n")
          local synonym_term = eutf8.sub(synonym_part_lines[1], 2) -- syntax: ❯<term>
          local synonyms_raw = eutf8.sub(synonym_part_lines[2], 12) -- syntax:  ⬤synonyms: <term>{, <term>}
          local antonyms_raw = eutf8.sub(synonym_part_lines[3], 12) -- syntax:  ⬤antonyms: <term>{, <term>}
          local synonyms = hs.fnutils.imap(stringy.split(synonyms_raw, ", "), stringy.strip)
          local antonyms = hs.fnutils.imap(stringy.split(antonyms_raw, ", "), stringy.strip)
          return synonym_term, {
            synonyms = synonyms,
            antonyms = antonyms,
          }
        end
      )
      return synonym_tables
    end,
    raw_av_output = function (str)
      get.fn.rt_or_nil_by_memoized(transf.string.string_or_nil_by_evaled_env_bash_stripped)(
        "synonym" .. transf.string.single_quoted_escaped(str)
      )
    end,
    synonym_string_array = function(str)
      local items = stringy.split(transf.word.raw_av_output(str), "\t")
      items = hs.fnutils.ifilter(items, function(itm)
        if itm == nil then
          return false
        end
        itm = stringy.strip(itm)
        return #itm > 0
      end)
      return items
    end,
    long_flag = function(word)
      return "--" .. word
    end,
    determinant_metatable_creator_fn = function(word)
      return function(tbl)
        tbl = get.table.table_by_copy(tbl, true)
        local metatbl = {
            __index = {
            }
        }
        metatbl.__index["is" .. word] = true
        setmetatable(tbl, metatbl)
        return tbl
      end
    end
  },
  syn_specifier = {
    synoynms_array = function (syn_specifier)
      return syn_specifier.synonyms
    end,
    antonyms_array = function (syn_specifier)
      return syn_specifier.antonyms
    end,
    synonyms_string = function (syn_specifier)
      return get.string_or_number_array.string_by_joined(syn_specifier.synonyms, ", ")
    end,
    antonyms_string = function (syn_specifier)
      return get.string_or_number_array.string_by_joined(syn_specifier.antonyms, ", ")
    end,
    summary = function (syn_specifier)
      return 
        "synonyms: " ..
        get.array.array_by_slice_removed_indicator_and_flatten_w_slice_spec(syn_specifier.synonyms, { stop = 2}, "...") ..
        "\n" ..
        "antonyms: " ..
        get.array.array_by_slice_removed_indicator_and_flatten_w_slice_spec(syn_specifier.antonyms, { stop = 2}, "...")
    end,
  },
  pair = {
    key_value = function(pair)
      return pair[1], pair[2]
    end,
    key = function(pair)
      return pair[1]
    end,
    value = function(pair)
      return pair[2]
    end,
    header = function(pair)
      return transf.key_value.header(pair[1], pair[2])
    end,
    email_header = function(pair)
      return transf.key_value.email_header(pair[1], pair[2])
    end,
    url_param = function(pair)
      return transf.key_value.url_param(pair[1], pair[2])
    end,
    ini_line = function(pair)
      return transf.key_value.ini_line(pair[1], pair[2])
    end,
    envlike_line = function(pair)
      return transf.key_value.envlike_line(pair[1], pair[2])
    end,
    curl_form_field_args = function(pair)
      return transf.key_value.curl_form_field_args(pair[1], pair[2])
    end,
    dict_entry_string = function(pair)
      return transf.key_value.dict_entry_string(pair[1], pair[2])
    end,
    larger = function(pair)
      return transf.two_comparables.comparable_by_larger(pair[1], pair[2])
    end,
  },
  two_anys = {
    boolean_and = function(a, b)
      return a and b
    end,
    boolean_or = function(a, b)
      return a or b
    end,
    string_two_anys = function(a, b)
      return transf.any.string(a), transf.any.string(b)
    end,
  },
  two_comparables = {
    comparable_by_larger = function(a, b)
      if a > b then
        return a
      else
        return b
      end
    end,
    comparable_by_smaller = function(a, b)
      if a < b then
        return a
      else
        return b
      end
    end,
    bool_by_equal = function(a, b)
      return a == b
    end,
    bool_by_larger = function(a, b)
      return a > b
    end,
    bool_by_smaller = function(a, b)
      return a < b
    end,
  },
  two_numbers ={
    sum = function(a, b)
      return a + b
    end,
  },
  two_date_component_names = {
    larger = function(a, b)
      return tblmap.date_component_name.date_component_index[a] > tblmap.ddate_component_name.date_component_index[b]
    end,
    larger_date_component_name = function(a, b)
      if tblmap.date_component_name.date_component_index[a] > tblmap.date_component_name.date_component_index[b] then
        return a
      else
        return b
      end
    end,
  },
  -- TODO: many things in key_value should be in two_anys, since key_value is a special case of two_anys where they are semantically keys and values of a table
  key_value = {
    pair = function(key, value)
      return {key, value}
    end,
    key = function(key, value)
      return key
    end,
    value = function(key, value)
      return value
    end,
    header = function(k, v)
      return transf.string.string_by_first_eutf8_upper(transf.any.string(k)) .. ": " .. transf.any.string(v)
    end,
    email_header = function(key, value)
      return transf.string.string_by_first_eutf8_upper(transf.any.string(key)) .. ": " .. get.string.evaled_as_template(transf.any.string(value))
    end,
    url_param = function(key, value)
      return transf.any.string(key) .. "=" .. transf.string.encoded_query_param_value(transf.any.string(value))
    end,
    ini_line = function(key, value)
      return transf.any.string(key) .. " = " .. transf.any.string(value)
    end,
    envlike_line = function(key, value)
      return transf.any.string(key) .. "=" .. transf.any.string(value)
    end,
    curl_form_field_args = function(key, value)
      return {
        "-F",
        transf.any.string(key) .. "=" .. transf.potentially_atpath.potentially_atpath_resolved(transf.any.string(value)),
      }
    end,
    dict_entry_string = function(key, value)
      return "[" .. transf.any.string(key) .. "] = " .. transf.any.string(value)
    end,
    
    
  },
  email = {
    mailto_url = function(str)
      return "mailto:" .. str
    end,
  },
  displayname_email = {
    email = function(str)
      return eutf8.match(str, " <(.*)> *$")
    end,
    displayname = function(str)
      return eutf8.match(str, "^(.*) <")
    end,
    displayname_email_dict = function(str)
      local displayname = transf.displayname_email.displayname(str)
      local email = transf.displayname_email.email(str)
      return {
        displayname = displayname,
        email = email,
      }
    end,
    mailto_url = function(str)
      local email = transf.displayname_email.email(str)
      return transf.email.mailto_url(email)
    end,
  },
  email_or_displayname_email = {
    email = function(str)
      return transf.displayname_email.email(str) or str
    end,
    displayname = function(str)
      return transf.displayname_email.displayname(str) or nil
    end,
    displayname_email_dict = function(str)
      local displayname = transf.email_or_displayname_email.displayname(str)
      local email = transf.email_or_displayname_email.email(str)
      return {
        displayname = displayname,
        email = email,
      }
    end,
  },
  phone_number = {

  },
  string_array = {
    repeated_option_string = function(arr, opt)
      return get.string_or_number_array.string_by_joined(
        hs.fnutils.imap(
          arr,
          function (itm)
            return " " .. opt .. " " .. itm
          end
        ),
        ""
      )
    end,
    single_quoted_escaped_string_array = function(arr)
      return hs.fnutils.imap(
        arr,
        transf.string.single_quoted_escaped
      )
    end,
    single_quoted_escaped_string = function(arr)
      return get.string_or_number_array.string_by_joined(
        transf.string_array.single_quoted_escaped_string_array(arr),
        " "
      )
    end,
    action_path_string = function(arr)
      return get.string_or_number_array.string_by_joined(arr, " > ")
    end,
    path = function(arr)
      return get.string_or_number_array.string_by_joined(
        hs.fnutils.imap(arr, transf.string.safe_filename), 
        "/"
      )
    end,
    noemtpy_string_array = function(arr)
      return hs.fnutils.ifilter(arr, is.string.noempty_string)
    end,
    noindent_string_array = function(arr)
      return hs.fnutils.imap(arr, transf.line.noindent)
    end,
    nocomment_line_filtered_string_array = function(arr)
      return hs.fnutils.ifilter(
        arr,
        is.string.nocomment_line
      )
    end,
    nocomment_string_array = function(arr)
      return hs.fnutils.imap(
        transf.string_array.nocomment_line_filtered_string_array(arr),
        transf.line.nocomment
      )
    end,
    nocomment_line_filtered_noindent_string_array = function(arr)
      return transf.string_array.noindent_string_array(
        transf.string_array.nocomment_line_filtered_string_array(arr)
      )
    end,
    nocomment_noindent_string_array = function(arr)
      return transf.string_array.noindent_string_array(
        transf.string_array.nocomment_string_array(arr)
      )
    end,
    filter_to_url_array = function(arr)
      return hs.fnutils.ifilter(arr, is.string.url)
    end,
    filter_nocomment_noindent_to_url_array = function(arr)
      return transf.string_array.filter_to_url_array(
        transf.string_array.nocomment_noindent_string_array(arr)
      )
    end,
    stripped_string_array = function(arr)
      return hs.fnutils.imap(arr, stringy.strip)
    end,
    multiline_string = function(arr)
      return get.string_or_number_array.string_by_joined(arr, "\n")
    end,
    contents_summary = function(arr)
      return get.string_or_number_array.string_by_joined(
        get.array.array_by_slice_removed_indicator_and_flatten_w_slice_spec(arr, {
          start = 1,
          stop = 10,
        }, "..."),
        ", "
      )
    end,
    
  },
  env_line_array = {
    env_string = function(arr)
      local env_string_inner = get.string_or_number_array.string_by_joined(arr, "\n")
      return "#!/usr/bin/env bash\n\n" ..
          "set -u\n\n" .. 
          env_string_inner .. 
          "\n\nset +u\n"
    end,
  },
  slice_notation = {
    three_pos_int_or_nils = function(notation)
      local stripped_str = stringy.strip(notation)
      local start_str, stop_str, step_str = onig.match(
        stripped_str, 
        "^\\[?(-?\\d*):(-?\\d*)(?::(-?\\d+))?\\]?$"
      )
      return
        start_str == "" and nil or get.string.number_or_nil(start_str),
        stop_str == "" and nil or get.string.number_or_nil(stop_str),
        step_str == "" and nil or get.string.number_or_nil(step_str)
    end,
  },
  two_arrays = {
    two_anys_by_first = function(arr1, arr2)
      return arr1[1], arr2[1]
    end,
    bool_by_larger_first_item = function(arr1, arr2)
      return transf.two_comparables.boolean_by_larger(arr1[1], arr2[1])
    end,
    bool_by_smaller_first_item = function(arr1, arr2)
      return transf.two_comparables.boolean_by_smaller(arr1[1], arr2[1])
    end,
    array_by_appended = function(arr1, arr2)
      local res = get.table.table_by_copy(arr1)
      for _, v in transf.array.index_value_stateless_iter(arr2) do
        res[#res + 1] = v
      end
      return res
    end,
    pair_array_by_zip_stop_a1 = function(arr1, arr2)
      local res = {}
      for i = 1, #arr1 do
        res[#res + 1] = {arr1[i], arr2[i]}
      end
      return res
    end,
    pair_array_by_zip_stop_a2 = function(arr1, arr2)
      local res = {}
      for i = 1, #arr2 do
        res[#res + 1] = {arr1[i], arr2[i]}
      end
      return res
    end,
    pair_array_by_zip_stop_shortest = function(arr1, arr2)
      local res = {}
      local shortest = transf.two_comparables.comparable_by_smaller(#arr1, #arr2)
      for i = 1, shortest do
        res[#res + 1] = {arr1[i], arr2[i]}
      end
      return res
    end,
    dict_by_zip_stop_shortest = function(arr1, arr2)
      return transf.pair_array.dict(
        transf.two_arrays.pair_array_by_zip_stop_shortest(arr1, arr2)
      )
    end,
    pair_array_by_zip_stop_longest = function(arr1, arr2)
      local res = {}
      local longest = transf.two_comparables.comparable_by_larger(#arr1, #arr2)
      for i = 1, longest do
        res[#res + 1] = {arr1[i], arr2[i]}
      end
      return res
    end,
    array_by_interleaved_stop_a1 = function(arr1, arr2)
      local res = {}
      for i, v in transf.array.index_value_stateless_iter(arr1) do
        res[#res + 1] = v
        res[#res + 1] = arr2[i]
      end
      return res
    end,
    array_by_interleaved_stop_a2 = function(arr1, arr2)
      local res = {}
      for i, v in transf.array.index_value_stateless_iter(arr2) do
        res[#res + 1] = arr1[i]
        res[#res + 1] = v
      end
      return res
    end,
    array_by_interleaved_stop_shortest = function(arr1, arr2)
      local res = {}
      local shortest = transf.two_comparables.comparable_by_smaller(#arr1, #arr2)
      for i = 1, shortest do
        res[#res + 1] = arr1[i]
        res[#res + 1] = arr2[i]
      end
      return res
    end,
    array_by_interleaved_stop_longest = function(arr1, arr2)
      local res = {}
      local longest = transf.two_comparables.comparable_by_larger(#arr1, #arr2)
      for i = 1, longest do
        res[#res + 1] = arr1[i]
        res[#res + 1] = arr2[i]
      end
      return res
    end,

    set_by_union = function(arr1, arr2)
      local new_arr = transf.two_arrays.array_by_appended(arr1, arr2)
      return transf.array.set(new_arr)
    end,
    set_by_intersection = function(arr1, arr2)
      local new_arr = {}
      for _, v in transf.array.index_value_stateless_iter(arr1) do
        if get.array.bool_by_contains(arr2, v) then
          new_arr[#new_arr + 1] = v
        end
      end
      return transf.array.set(new_arr)
    end,
    set_by_difference = function(arr1, arr2)
      local new_arr = {}
      for _, v in transf.array.index_value_stateless_iter(arr1) do
        if not get.array.bool_by_contains(arr2, v) then
          new_arr[#new_arr + 1] = v
        end
      end
      return transf.array.set(new_arr)
    end,
    set_by_symmetric_difference = function(arr1, arr2)
      local new_arr = {}
      for _, v in transf.array.index_value_stateless_iter(arr1) do
        if not get.array.bool_by_contains(arr2, v) then
          new_arr[#new_arr + 1] = v
        end
      end
      for _, v in transf.array.index_value_stateless_iter(arr2) do
        if not get.array.bool_by_contains(arr1, v) then
          new_arr[#new_arr + 1] = v
        end
      end
      return transf.array.set(new_arr)
    end,
  },
  two_array_or_nils = {
    array = function(arr1, arr2)
      if arr1 == nil then arr1 = {} end
      if arr2 == nil then arr2 = {} end
      return transf.two_arrays.array_by_appended(arr1, arr2)
    end,
  },
  any_and_array = {
    array = function(any, arr)
      local res = get.table.table_by_copy(arr)
      dothis.array.unshift(res, any)
      return res
    end,
  },
  array_and_any = {
    array = function(arr, any)
      local res = get.table.table_by_copy(arr)
      dothis.array.push(res, any)
      return res
    end,
  },
  array_of_string_arrays = {

  },
  url_array = {
    url_potentially_with_title_comment_array = function(sgml_url_array)
      return hs.fnutils.imap(
        sgml_url_array,
        transf.url.url_potentially_with_title_comment
      )
    end,
    session_string = function(sgml_url_array)
      return get.string_or_number_array.string_by_joined(
        transf.url.url_potentially_with_title_comment_array(sgml_url_array),
        "\n"
      )
    end,
    nonabsolute_path_key_dict_of_url_files = function(url_array)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        url_array,
        function(url)
          return 
            transf.url.title_or_url_as_filename(url),
            url
        end
      )
    end,
  },
  sgml_url_array = {
    sgml_url_with_title_comment_array = function(sgml_url_array)
      return hs.fnutils.imap(
        sgml_url_array,
        transf.sgml_url.sgml_url_with_title_comment
      )
    end,
    
  },
  plaintext_url_or_local_path_file = {

  },
  plaintext_file_array = {
    string_array_by_contents = function(arr)
      return hs.fnutils.imap(arr, transf.plaintext_file.string_by_contents)
    end,
    string_array_by_lines = function(arr)
      return get.array_of_arrays.array_by_mapped_w_vt_arg_vt_ret_fn_and_flatten(arr, transf.plaintext_file.string_array_by_lines)
    end,
    string_array_by_content_lines = function(arr)
      return get.array_of_arrays.array_by_mapped_w_vt_arg_vt_ret_fn_and_flatten(arr, transf.plaintext_file.string_array_by_content_lines)
    end,
    m3u_file_array = function(path_array)
      return hs.fnutils.ifilter(path_array, is.plaintext_file.m3u_file)
    end,
    url_or_local_path_array_by_m3u_file_content_lines = function(arr)
      return transf.plaintext_file_array.string_array_by_content_lines(
        transf.plaintext_file_array.m3u_file_array(arr)
      )
    end,
    
  },
  array_of_event_tables = {
  },
  email_file_array = {
    email_file_summary_dict = function(email_file_array)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        email_file_array,
        transf.email_file.email_file_summary_key_value
      )
    end,
    email_file_simple_view_dict = function(email_file_array)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        email_file_array,
        transf.email_file.email_file_simple_view_key_value
      )
    end,
  },
  stateless_iter = {
    array = function(...)
      local res = {}
      for a1, a2, a3, a4, a5, a6, a7, a8, a9 in ... do
        dothis.array.push(
          res,
          {a1, a2, a3, a4, a5, a6, a7, a8, a9}
        )
      end
      return res
    end,
  },
  table_or_nil = {
    key_value_stateless_iter = function(t)
      if t == nil then t = {} end
      return transf.table.stateless_key_value_iter(t)
    end,
    kt_array = function(t)
      if t == nil then return {} end
      return transf.table.kt_array(t)
    end,
    vt_array = function(t)
      if t == nil then return {} end
      return transf.table.vt_array(t)
    end,
  },
  table = {
    pair_array = function(t)
      return get.table.array_by_mapped_w_kt_vt_arg_vt_ret_fn(
        t,
        transf.key_value.pair
      )
    end,
    pair_array_by_sorted_larger_key_first = function(t)
      return transf.array_of_arrays.array_of_arrays_by_sorted_larger_first_item(
        transf.table.pair_array(t)
      )
    end,
    pair_array_by_sorted_smaller_key_first = function(t)
      return transf.array_of_arrays.array_of_arrays_by_sorted_smaller_first_item(
        transf.table.pair_array(t)
      )
    end,
    kt_array = function(t)
      local res = {}
      for k, _ in transf.table.key_value_stateless_iter(t) do
        res[#res + 1] = k
      end
      return res
    end,
    pos_int_by_num_keys = function(t)
      return #transf.table.kt_array(t)
    end,
    vt_array = function(t)
      local res = {}
      for _, v in transf.table.key_value_stateless_iter(t) do
        res[#res + 1] = v
      end
      return res
    end,
    kt_array_by_sorted_smaller_first = function(t)
      return get.table.kt_array_by_sorted(t, transf.two_comparables.bool_by_smaller)
    end,
    kt_array_by_sorted_larger_first = function(t)
      return get.table.kt_array_by_sorted(t, transf.two_comparables.bool_by_larger)
    end,
    vt_array_by_sorted_smaller_first = function(t)
      return get.table.vt_array_by_sorted(t, transf.two_comparables.bool_by_smaller)
    end,
    vt_array_by_sorted_larger_first = function(t)
      return get.table.vt_array_by_sorted(t, transf.two_comparables.bool_by_larger)
    end,
    key_value_stateless_iter = pairs,
    key_value_stateful_iter = get.stateless_generator.stateful_generator(transf.table.key_value_stateless_iter),
    key_stateful_iter = get.stateless_generator.stateful_generator(transf.table.key_value_stateful_iter, 1, 1),
    value_stateful_iter = get.stateless_generator.stateful_generator(transf.table.key_value_stateful_iter, 2, 2),
    toml_string = toml.encode,
    yaml_aligned = function(tbl)
      local tmp = transf.string.in_tmp_dir(
        transf.not_userdata_or_function.yaml_string(tbl),
        "shell-input"
      )
      transf.string.string_or_nil_by_evaled_env_bash_stripped("align " .. transf.string.single_quoted_escaped(tmp))
      local res = transf.yaml_file.not_userdata_or_function(tmp)
      dothis.local_extant_path.delete(tmp)
      return res
    end,
    yaml_metadata = function(t)
      local string_contents = transf.not_userdata_or_string.yaml_string(t)
      return "---\n" .. string_contents .. "\n---\n"
    end,
    
    ics_string = function(t)
      local tmpdir_ics_path = transf.not_userdata_or_function.in_tmp_dir(t) .. ".ics"
      dothis.table.write_ics_file(t, tmpdir_ics_path)
      local contents = transf.file.contents(tmpdir_ics_path)
      dothis.absolute_path.delete(tmpdir_ics_path)
      return contents
    end,
    value_set = function(t)
      return transf.array.set(transf.table_or_nil.vt_array(t))
    end,
    determined_array_table = function(t)
      return transf.word.determinant_metatable_creator_fn("arr")(t)
    end,
    determined_assoc_table = function(t)
      return transf.word.determinant_metatable_creator_fn("assoc")(t)
    end,
    json_string_pretty = function(t)
      return hs.json.encode(t, true)
    end,
    array_of_arrays_by_label_root_to_leaf_only_primitive_is_leaf = function(t)
      return get.table.array_of_arrays_by_label_root_to_leaf(
        t,
        transf["nil"]["false"]()
      )
    end,
    array_of_arrays_by_label_root_to_leaf_primitive_and_arraylike_is_leaf = function(t)
      return get.table.array_of_arrays_by_label_root_to_leaf(
        t,
        is.table.arraylike
      )
    end,
    array_of_arrays_by_key_label_only_primitive_is_leaf = function(t)
      return get.table.array_of_arrays_by_key_label(
        t,
        transf["nil"]["false"]()
      )
    end,
    array_of_arrays_by_key_label_primitive_and_arraylike_is_leaf = function(t)
      return get.table.array_of_arrays_by_key_label(
        t,
        is.table.arraylike
      )
    end,
    relative_path_key_dict_by_primitive_and_arraylike_is_leaf = function(t)
      return get.table.string_by_joined_key_any_value_dict(
        t,
        is.table.arraylike,
        "/"
      )
    end,
    dot_notation_key_dict_by_primitive_and_arraylike_is_leaf = function(t)
      return get.table.string_by_joined_key_any_value_dict(
        t,
        is.table.arraylike,
        "."
      )
    end,
    array_by_nested_final_key_label_by_primitive_and_arraylike_is_leaf = function(t)
      return transf.array_of_arrays.array_by_map_to_last(
        get.table.array_of_arrays_by_key_label(
          t,
          is.table.arraylike
        )
      )
    end,
    array_by_nested_value_primitive_and_arraylike_is_leaf = function(t)
      return transf.array.array_by_map_to_last(
        get.table.array_of_arrays_by_label_root_to_leaf(
          t,
          is.table.arraylike
        )
      )
    end,
  },
  dict = {
    length = function(t)
      return #transf.table.pair_array(t)
    end,
    url_param_array = function(t)
      return hs.fnutils.imap(transf.table.pair_array(t), transf.pair.url_param)
    end,
    url_params = function(t)
      return get.string_or_number_array.string_by_joined(transf.dict.url_param_array(t), "&")
    end,
    --- @param t { [string]: string }
    --- @return string
    email_header = function(t)
      local header_lines = {}
      local initial_headers = mt._list.initial_headers
      for _, header_name in transf.array.index_value_stateless_iter(initial_headers) do
        local header_value = t[header_name]
        if header_value then
          table.insert(header_lines, transf.pair.email_header({header_name, header_value}))
          t[header_name] = nil
        end
      end
      header_lines = transf.two_arrays.array_by_appended(
        header_lines,
        hs.fnutils.imap(
          transf.table.pair_array_by_sorted_larger_key_first(t),
          transf.pair.email_header
        )
      )
      return get.string_or_number_array.string_by_joined(header_lines, "\n")
    end,
    curl_form_field_array = function(t)
      return transf.array_of_arrays.array_by_flatten(
        hs.fnutils.imap(transf.table.pair_array(t), transf.pair.curl_form_field_args)
      )
    end,
    ini_line_array = function(t)
      return hs.fnutils.imap(transf.table.pair_array(t), transf.pair.ini_line)
    end,
    ini_string = function(t)
      return get.string_or_number_array.string_by_joined(transf.dict.ini_line_array(t), "\n")
    end,
    envlike_line_array = function(t)
      return hs.fnutils.imap(transf.table.pair_array(t), transf.pair.envlike_line)
    end,
    dict_entry_string_array = function(t)
      return hs.fnutils.imap(transf.table.pair_array(t), transf.pair.dict_entry_string)
    end,
    contents_summary = function(t)
      return transf.string_array.contents_summary(
        transf.dict.dict_entry_string_array(t)
      )
    end,
    summary = function(t)
      return "dict (" .. transf.dict.length(t) .. "): " .. transf.dict.contents_summary(t)
    end,
    dict_entry_multiline_string = function(t)
      return get.string_or_number_array.string_by_joined(transf.dict.dict_entry_string_array(t), "\n")
    end,
    envlike_string = function(t)
      return get.string_or_number_array.string_by_joined(transf.dict.envlike_line_array(t), "\n")
    end,
    truthy_value_dict = function(t)
      return hs.fnutils.ifilter(
        t,
        transf.any.boolean
      )
    end,
    truthy_value_key_array = function(t)
      return transf.table_or_nil.kt_array(transf.dict.truthy_value_dict(t))
    end,
  },
  table_array = {
    table_by_take_new = function(t)
      local res = {}
      for _, dict in transf.array.index_value_stateless_iter(t) do
        for k, v in transf.table.stateless_key_value_iter(dict) do
          res[k] = v
        end
      end
      return res
    end,
    table_by_take_old = function(t)
      local res = {}
      for _, dict in transf.array.index_value_stateless_iter(t) do
        for k, v in transf.table.stateless_key_value_iter(dict) do
          if not res[k] then
            res[k] = v
          end
        end
      end
      return res
    end,
  },
  two_tables = {
    table_by_take_new = function(t1, t2)
      return transf.table_array.table_by_take_new({t1, t2})
    end,
    table_by_take_old = function(t1, t2)
      return transf.table_array.table_by_take_old({t1, t2})
    end,
  },
  two_table_or_nils = {
    table_by_take_new = function(t1, t2)
      if t1 == nil then t1 = {} end
      if t2 == nil then t2 = {} end
      return transf.two_tables.table_by_take_new(t1, t2)
    end,
    table_by_take_old = function(t1, t2)
      if t1 == nil then t1 = {} end
      if t2 == nil then t2 = {} end
      return transf.two_tables.table_by_take_old(t1, t2)
    end,
  },
  string_value_dict = {
    string_value_dict_by_prompted_once_from_default = function(dict)
      return get.table.array_by_mapped_w_kt_vt_arg_vt_ret_fn(dict, function(k, v)
        return get.string.string_by_prompted_once_from_default(
          v,
          "Enter a new value for '" .. k .. "'"
        )
      end)
    end,
  },
  string_key_dict = {
    string_key_dict_of_string_key_dicts_or_prev_values_by_space = function(tbl)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(tbl) do
        local key_parts = stringy.split(k, " ")
        local label = key_parts[1]
        local key = key_parts[2]
        if not key then
          res[label] = v
        else
          res[label] = res[label] or {}
          res[label][key] = v
        end
      end
      return res
    end,
  },
  string_key_value_dict = {

  },
  string_boolean_dict = {
    truthy_long_flag_array = function(dict)
      return hs.fnutils.imap(
        transf.dict.truthy_value_key_array(dict),
        transf.word.long_flag
      )
    end,
    truthy_long_flag_string = function(dict)
      return get.string_or_number_array.string_by_joined(transf.dict.truthy_long_flag_array(dict), " ")
    end,
  },
  array_of_arrays = {
    array_of_arrays_by_sorted_larger_first_item = function(arr)
      return get.array.array_by_sorted(
        arr,
        transf.two_arrays.bool_by_larger_first_item
      )
    end,
    array_of_arrays_by_sorted_smaller_first_item = function(arr)
      return get.array.array_by_sorted(
        arr,
        transf.two_arrays.bool_by_smaller_first_item
      )
    end,

    array_by_flatten = plarray2d.flatten,
    array_by_map_to_last = function(arr)
      return hs.fnutils.imap(arr, transf.array.t_by_last)
    end,
    array_by_map_to_first = function(arr)
      return hs.fnutils.imap(arr, transf.array.t_by_first)
    end,
    array_by_longest_common_prefix = function(a_o_a)
      local last_matching_index = 0
      hs.fnutils.reduce(a_o_a, function(acc, arr)
        for i = 1, #arr do
          if arr[i] == acc[i] then
            last_matching_index = i
          else
            break
          end
        end
    
        return arr
      end)
      return get.array.array_by_slice_w_3_pos_int_any_or_nils(a_o_a[1], 1, last_matching_index)
    end,
    array_of_arrays_by_reverse = function(arr)
      return hs.fnutils.imap(arr, transf.array.array_by_reverse)
    end,
    array_by_longest_common_suffix = function(arr)
      local reversed_res = transf.array.array_by_longest_common_prefix(
        transf.array.reverse_mapped(arr)
      )
      return transf.array_by_reversed.array(reversed_res)
    end,
  },
  pair_array = {
    dict = function(arr)
      local res = {}
      for _, pair in transf.array.index_value_stateless_iter(arr) do
        res[pair[1]] = pair[2]
      end
      return res
    end,
  },
  string_pair_array = {
    env_line_array = function (arr)
      return hs.fnutils.imap(
        arr,
        function(pair)
          return "export " .. pair[1] .. "=" .. transf.string.double_quoted_escaped(pair[2])
        end
      )
    end,
    n_shot_role_content_message_spec_array = function(arr)
      local res = {}
      for _, pair in transf.array.index_value_stateless_iter(arr) do
        dothis.array.push(res, {
          role = "user",
          content = pair[1],
        })
        dothis.array.push(res, {
          role = "assistant",
          content = pair[2],
        })
      end
      return res
    end
  },
  dict_of_string_value_dicts = {
    ini_string = function(t)
      return get.string_or_number_array.string_by_joined(hs.fnutils.imap(
        t,
        function(k,v)
          return "[" .. k .. "]\n" .. transf.dict.ini_string(v)
        end
      ), "\n\n")
    end,
  },
  dict_of_dicts = {
    dict_by_space = function(dict_of_dicts)
      local res = {}
      for label, dict in transf.table.stateless_key_value_iter(dict_of_dicts) do
        for k, v in transf.table.stateless_key_value_iter(dict) do
          res[label .. " " .. k] = v
        end
      end
      return res
    end,

  },
  array_value_dict = {
    array_of_arrays = function(arr)
      return transf.table.vt_array(arr)
    end,
    array_by_flatten = function(arr)
      return transf.array_of_arrays.array_by_flatten(transf.table.vt_array(arr))
    end,
        
  },
  timestamp_ms_key_dict_value_dict = {
    nonabsolute_path_key_timestamp_ms_key_dict_value_dict_by_ymd = function(timestamp_key_table)
      local tbl = {}
      for timestamp_ms, dict in transf.table.key_value_stateless_iter(timestamp_key_table) do
        local ymd = os.date("%Y/%Y-%m/%Y-%m-%d", timestamp_ms/1000)
        if not tbl[ymd] then tbl[ymd] = {} end
        local found_unoccupied = false
        -- we don't want to overwrite any existing entries, so we will increment the timestamp_ms until we find an unoccupied slot
        -- this is acceptable as none of our use-cases require sub-second precision, and neither do I expect there to be many entries per second
        -- ergo our drift will be limited to a few ms at most, and the loop will terminate
        while not found_unoccupied do
          if not tbl[ymd][timestamp_ms] then
            tbl[ymd][timestamp_ms] = dict
            found_unoccupied = true
          else
            timestamp_ms = timestamp_ms + 1
          end
        end
      end
      return tbl
    end
  },
  tachiyomi_json_table = {
    timestamp_key_dict_value_dict = function(raw_backup)
      -- data we care about is in the backupManga array in the json file
      -- each array element is a manga which has general metadata keys such as title, author, url, etc
      -- and a chapters array which has chapter metadata keys such as name, chapterNumber, url, etc
      -- and a history array which has the keys url and lastRead (unix timestamp in ms)
      -- we want to transform this into a table of our own design, where the key is a timestamp (but in seconds) and the value is a dict consisting of some of the metadata of the manga and some of the metadata of the chapter
      -- specifically: url (of the manga), title, chapterNumber, name (of the chapter)
      -- for that, we need to match the key url in the history array with the key url in the chapters array, for which we will create a temporary table with the urls as keys and the chapter metadata we will use as values

      local manga = raw_backup.backupManga
      local manga_url, manga_title = manga.url, manga.title
      local chapter_map = {}
      for _, chapter in transf.array.index_value_stateless_iter(manga.chapters) do
        chapter_map[chapter.url] = {
          chapterNumber = chapter.chapterNumber,
          name = chapter.name
        }
      end
      local history_dict = {}
      for _, hist_item in transf.array.index_value_stateless_iter(manga.history) do
        local chapter = chapter_map[hist_item.url]
        history_dict[hist_item.lastRead] = {
          url = manga_url,
          title = manga_title,
          chapter_number = chapter.chapterNumber,
          chapter_name = chapter.name
        }
      end
      return history_dict
    end,
  },
  vdirsyncer_pair_specifier = {
    dict_of_dicts = function(specifier)
      local local_name = specifier.name .. "_local"
      local remote_name = specifier.name .. "_remote"
      return {
        pair = {
          [specifier.name] = {
            a = local_name,
            b = remote_name,
            collections = specifier.collections,
            conflict_resolution = specifier.conflict_resolution,
          }
        },
        storage = {
          [local_name] = {
            type = specifier.local_storage_type,
            path = specifier.local_storage_path,
            fileext = specifier.local_storage_fileext,
          },
          [remote_name] = {
            type = specifier.remote_storage_type,
            url = specifier.remote_storage_url,
            username = specifier.remote_storage_username,
            password = specifier.remote_storage_password,
          }
        }
      }         
    end,
    ini_string = function(specifier)
      return transf.dict_of_string_value_dicts.ini_string(
        transf.dict_of_dicts.dict_by_space(
          transf.vdirsyncer_pair_specifier.dict_of_dicts(specifier)
        )
      )
    end
  },
  url_components = {
    url = function(comps)
      local url
      if comps.url then
        url = comps.url
      elseif comps.host then
        if comps.scheme then
          url = comps.scheme
        else
          url = "https://"
        end
        url = url .. get.string.string_by_with_suffix(comps.host, "/")
        if comps.endpoint then
          url = url .. (get.string.no_prefix_string(comps.endpoint, "/") or "/")
        end   
      end     
      if comps.params then
        if type(comps.params) == "table" then
          url = url .. "?" .. transf.dict.url_params(comps.params)
        else
          url = url .. get.string.with_prefix_string(comps.params, "?")
        end
      end
      return url
    end,
  },
  doi = {
    pure_doi = function(doilike)
      local doi = transf.doi_urnlike.pure_doi(doilike)
      doi = transf.doi_url.pure_doi(doi)
      return doi
    end,
    doi_url = function(doilike)
      local doi = transf.doi_urnlike.pure_doi(doilike)
      doi = transf.pure_doi.doi_url(doi)
      return doi
    end,
    doi_urnlike = function(doilike)
      local doi = transf.doi_url.pure_doi(doilike)
      doi = transf.pure_doi.doi_urnlike(doi)
      return doi
    end,
    online_csl_table = function(doilike)
      local doi = transf.doi_url.pure_doi(doilike)
      return transf.pure_doi.online_csl_table(doi)
    end,
  },
  doi_url = {
    pure_doi = function(url)
      return onig.match(url, mt._r.id.doi_prefix .. "(.+)/?$")
    end,
    doi_urnlike = function(url)
      return transf.pure_doi.doi_urnlike(transf.doi_url.pure_doi(url))
    end,
  },
  doi_urnlike = {
    pure_doi = function(urnlike)
      doi = urnlike:lower()
      doi = get.string.no_prefix_string(urnlike, "urn:")
      doi = get.string.no_prefix_string(urnlike, "doi:")
      return doi
    end,
    doi_url = function(urnlike)
      return transf.pure_doi.doi_url(transf.doi_urnlike.pure_doi(urnlike))
    end,
  },
  pure_doi = {
    doi_url = function(doi)
      return "https://doi.org/" .. doi
    end,
    doi_urnlike = function(doi)
      return "doi:" .. doi
    end,
    online_bib = function(doi)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(
        "curl -LH Accept: application/x-bibtex" .. transf.string.single_quoted_escaped(
          transf.pure_doi.doi_url(doi)
        )
      )
    end,
    online_csl_table = function(doi)
      return rest({
        url = transf.pure_doi.doi_url(doi),
        accept_json_different_header = "application/vnd.citationstyles.csl+json",
      })
    end,
    indicated_citable_object_id = function(doi)
      return "doi:" .. doi
    end,
  },
  isbn = {
    online_bib = function(isbn)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(
        "isbn_meta" .. transf.string.single_quoted_escaped(isbn) .. " bibtex"
      )
    end,
    online_csl_table = function(isbn)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(
        "isbn_meta" .. transf.string.single_quoted_escaped(isbn) .. " csl"
      )
    end,
    indicated_citable_object_id = function(isbn)
      return "isbn:" .. isbn
    end,
  },
  isbn10 = {
    isbn13 = function(isbn10)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(
        "to_isbn13" .. transf.string.single_quoted_escaped(isbn10)
      )
    end,
  },
  isbn13 = {
    isbn10 = function(isbn13)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(
        "to_isbn10" .. transf.string.single_quoted_escaped(isbn13)
      )
    end,
  },
  indicated_citable_object_id = {
    local_csl_file = function(id)
      return transf.filename_safe_indicated_citable_object_id.local_csl_file(
        transf.string.urlencoded(id)
      )
    end,
    local_csl_table = function(id)
      return transf.filename_safe_indicated_citable_object_id.csl_table(
        transf.string.urlencoded(id)
      )
    end,
    citable_object_id = function(id)
      return onig.match(id, "^[^:]+:(.*)$")
    end,
    citable_object_indicator = function(id)
      return stringy.split(id, ":")[1]
    end,
    online_csl_table = function(id)
      return transf[
        transf.indicated_citable_object_id.citable_object_indicator(id)
      ].online_csl_table(
        transf.indicated_citable_object_id.citable_object_id(id)
      )
    end,
    local_citable_object_file = function(id)
      return transf.filename_safe_indicated_citable_object_id.local_citable_object_file(
        transf.string.urlencoded(id)
      )
    end,
    local_citable_object_notes_file = function(id)
      return transf.filename_safe_indicated_citable_object_id.local_citable_object_notes_file(
        transf.string.urlencoded(id)
      )
    end,
    citations_file_line = function(id)
      return transf.csl_table.citations_file_line(
        transf.indicated_citable_object_id.local_csl_table(id)
      )
    end

  },
  filename_safe_indicated_citable_object_id = {
    local_csl_file = function(id)
      return get.extant_path.absolute_path_by_descendant_with_leaf_ending(env.MCITATIONS, id)
    end,
    csl_table = function(id)
      return transf.json_file.not_userdata_or_function(
        transf.filename_safe_indicated_citable_object_id.local_csl_file(id)
      )
    end,
    local_citable_object_file = function(id)
      return get.extant_path.absolute_path_by_descendant_with_leaf_ending(env.MPAPERS, id)
    end,
    local_citable_object_notes_file = function(id)
      return get.extant_path.absolute_path_by_descendant_with_leaf_ending(env.MPAPERNOTES, id)
    end,
  },
  citable_filename = {
    filename_safe_indicated_citable_object_id = function(filename)
      return plstringx.split(filename, "!citid:")[2]
    end,
    indicated_citable_object_id = function(filename)
      return transf.string.string_by_percent_decoded_also_plus(transf.citable_filename.filename_safe_indicated_citable_object_id(filename))
    end,
  },
  citable_path = {
    filename_safe_indicated_citable_object_id = function(path)
      return transf.citable_filename.filename_safe_indicated_citable_object_id(
        transf.path.filename(path)
      )
    end,
    indicated_citable_object_id = function(path)
      return transf.citable_filename.indicated_citable_object_id(
        transf.path.filename(path)
      )
    end,
  },
  citable_object_file ={ -- file with a citable_filename containing the data (e.g. pdf) of a citable object

  },
  citations_file = { -- plaintext file containing one indicated_citable_object_id per line
    indicated_citable_object_id_array = function(file)
      return transf.plaintext_file.nocomment_noindent_content_lines(file)
    end,
    local_csl_table_array = function(file)
      return transf.indicated_citable_object_id_array.local_csl_table_array(
        transf.citations_file.indicated_citable_object_id_array(file)
      )
    end,
    bib_string = function(file)
      return transf.indicated_citable_object_id_array.bib_string(
        transf.citations_file.local_csl_table_array(file)
      )
    end,
    json_string = function(file)
      return transf.indicated_citable_object_id_array.json_string(
        transf.citations_file.local_csl_table_array(file)
      )
    end,
  },
  indicated_citable_object_id_array = {
    local_csl_table_array = function(arr)
      return hs.fnutils.imap(
        arr,
        transf.indicated_citable_object_id.local_csl_table
      )
    end,
    bib_string = function(arr)
      return transf.csl_table_array.bib_string(
        transf.indicated_citable_object_id.local_csl_table_array(
          arr
        )
      )
    end,
    json_string = function(arr)
      return transf.csl_table_array.json_string(
        transf.indicated_citable_object_id.local_csl_table_array(
          arr
        )
      )
    end,
    citations_file_line_array = function(arr)
      return hs.fnutils.imap(
        transf.indicated_citable_object_id_array.local_csl_table_array(arr),
        transf.csl_table.citations_file_line
      )
    end,
    citations_file_string = function(arr)
      return get.string_or_number_array.string_by_joined(
        transf.indicated_citable_object_id_array.citations_file_line_array(arr), 
        "\n"
      )
    end
  },
  latex_project_dir = {
    citations_file = function(dir)
      return transf.path.ending_with_slash(dir) .. "citations"
    end,
    main_tex_file = function(dir)
      return transf.path.ending_with_slash(dir) .. "main.tex"
    end,
    main_pdf_file = function(dir)
      return transf.path.ending_with_slash(dir) .. "main.pdf"
    end,
    main_bib_file = function(dir)
      return transf.path.ending_with_slash(dir) .. "main.bib"
    end,
    citable_object_files = function(dir)
      return transf.path.ending_with_slash(dir) .. "citable_objects"
    end,
    citable_object_notes = function(dir)
      return transf.path.ending_with_slash(dir) .. "citable_objects_notes"
    end,
    indicated_citable_object_id_array_from_citations = function(dir)
      return transf.citations_file.indicated_citable_object_id_array(
        transf.latex_project_dir.citations_file(dir)
      )
    end,
    local_csl_table_array_from_citations = function(dir)
      return transf.citations_file.local_csl_table_array(
        transf.latex_project_dir.citations_file(dir)
      )
    end,
    bib_string_from_citations = function(dir)
      return transf.citations_file.bib_string(
        transf.latex_project_dir.citations_file(dir)
      )
    end,
  },
  omegat_project_dir = {
    metadata_file = function(dir)
      return transf.path.ending_with_slash(dir) .. "data.yaml"
    end,
    metadata = function(dir)
      return transf.yaml_file.not_userdata_or_function(
        transf.omegat_project_dir.metadata_file(dir)
      )
    end,
    client_name = function(dir)
      return transf.omegat_project_dir.metadata(dir).client
    end,
    client_contact_uuid = function(dir)
      return fstblmap.client_name.contact_uuid(
        transf.omegat_project_dir.client_name(dir)
      )
    end,
    client_contact_table = function(dir)
      return transf.uuid.contact_table(
        transf.omegat_project_dir.client_contact_uuid(dir)
      )
    end,
    -- this will often be unset, since I'll default to my uuid within creator_contact_uuid
    creator_name = function(dir)
      return transf.omegat_project_dir.metadata(dir).creator
    end,
    creator_contact_uuid = function(dir)
      if transf.omegat_project_dir.creator_name(dir) then
        return fstblmap.client_name.contact_uuid(
          transf.omegat_project_dir.creator_name(dir)
        )
      else
        return env.SELF_UUID
      end
    end,
    client_main_name = function(dir)
      return transf.contact_table.main_name(
        transf.omegat_project_dir.client_contact_table(dir)
      )
    end,
    client_main_relevant_address_label = function(dir)
      return transf.contact_table.main_relevant_address_label(
        transf.omegat_project_dir.client_contact_table(dir)
      )
    end,
    client_translation_rate = function(dir)
      return transf.contact_table.translation_rate(
        transf.omegat_project_dir.client_contact_table(dir)
      )
    end,
    creator_main_name = function(dir)
      return transf.contact_table.main_name(
        transf.omegat_project_dir.creator_contact_table(dir)
      )
    end,
    creator_main_relevant_address_label = function(dir)
      return transf.contact_table.main_relevant_address_label(
        transf.omegat_project_dir.creator_contact_table(dir)
      )
    end,
    creator_translation_tax_number = function(dir)
      return get.contact_table.tax_number(
        transf.omegat_project_dir.creator_contact_table(dir),
        "translation"
      )
    end,
    creator_bank_details_string = function(dir)
      return get.contact_table.bank_details_string(
        transf.omegat_project_dir.creator_contact_table(dir)
      )
    end,
    creator_translation_rate = function(dir)
      return transf.contact_table.translation_rate(
        transf.omegat_project_dir.creator_contact_table(dir)
      )
    end,
    translation_rate = function(dir)
      return 
        transf.omegat_project_dir.metadata(dir).translation_rate 
        or transf.omegat_project_dir.client_translation_rate(dir)
        or transf.omegat_project_dir.creator_translation_rate(dir)
    end,
    rechnung = function(dir)
      return transf.omegat_project_dir.metadata(dir).rechnung
    end,
    rechnung_id = function(dir)
      return
        date():fmt("%Y") .. "-" ..
        transf.omegat_project_dir.client_name(dir):upper() .. "-" ..
        transf.omegat_project_dir.rechnung_number(dir)
    end,
    rechnung_number = function(dir)
      return transf.omegat_project_dir.rechnung(dir).nr
    end,
    delivery_date = function(dir)
      return transf.omegat_project_dir.rechnung(dir).delivery_date
    end,
    dictionary_dir = function(dir)
      return transf.path.ending_with_slash(dir) .. "dictionary"
    end,
    glossary_dir = function(dir)
      return transf.path.ending_with_slash(dir) .. "glossary"
    end,
    omegat_dir = function(dir)
      return transf.path.ending_with_slash(dir) .. "omegat"
    end,
    source_dir = function(dir)
      return transf.path.ending_with_slash(dir) .. "source"
    end,
    target_dir = function(dir)
      return transf.path.ending_with_slash(dir) .. "target"
    end,
    target_txt_dir = function(dir)
      return transf.path.ending_with_slash(dir) .. "target_txt"
    end,
    tm_dir = function(dir)
      return transf.path.ending_with_slash(dir) .. "tm"
    end,
    source_files = function(dir)
      return transf.dir.absolute_path_array_by_children(
        transf.omegat_project_dir.source_dir(dir)
      )
    end,
    target_files = function(dir)
      return transf.dir.absolute_path_array_by_children(
        transf.omegat_project_dir.target_dir(dir)
      )
    end,
    local_resultant_tm = function(dir)
      return transf.omegat_project_dir.tm_dir(dir) .. "/" .. transf.path.leaf(dir) .. "-omegat.tmx"
    end,
    rechnung_filename = function(dir)
      return get.timestamp_s.string_by_date_format_indicator(
        os.time(),
        tblmap.date_component_name.rfc3339like_dt_format_string["day"]
      ) .. "--" .. transf.omegat_project_dir.client_name(dir) .. "_" .. transf.omegat_project_dir.rechnung_number(dir)
    end,
    rechnung_pdf_path = function(dir)
      return transf.path.ending_with_slash(dir) .. transf.omegat_project_dir.rechnung_filename(dir) .. ".pdf"
    end,
    rechnung_md_path = function(dir)
      return transf.path.ending_with_slash(dir) .. transf.omegat_project_dir.rechnung_filename(dir) .. ".md"
    end,
    target_file_num_chars_array = function(dir)
      return hs.fnutils.imap(
        transf.dir.absolute_path_array_by_children(
          transf.omegat_project_dir.target_txt_dir(dir)
        ),
        transf.plaintext_file.chars
      )
    end,
    translation_price_specifier_array = function(dir)
      local num_chars_array = transf.omegat_project_dir.target_file_num_char_array(dir)
      return hs.fnutils.imap(
        num_chars_array,
        function(num_chars)
          local normzeilen = transf.num_chars.normzeilen(num_chars)
          local rate = transf.omegat_project_dir.translation_rate(dir)
          return {
            price = rate *  normzeilen,
            rate = rate,
            normzeilen = normzeilen
          }
        end
      )
    end,
    translation_price_specifier = function(dir)
      return transf.translation_price_specifier_array.translation_price_specifier(
        transf.omegat_project_dir.translation_price_specifier_array(dir)
      )
    end,
    translation_price_block_german = function(dir)
      return transf.translation_price_specifier.translation_price_block_german(
        transf.omegat_project_dir.translation_price_specifier(dir)
      )
    end,
    rechnung_email_specifier = function(dir)
      return {
        body = get.string.evaled_as_template(comp.documents.translation.rechnung_email_de, dir),
        non_inline_attachment_local_file_array = {
          transf.omegat_project_dir.rechnung_pdf_path(dir)
        }
      }
    end,
    raw_rechnung = function(dir)
      return get.string.evaled_as_template(comp.documents.translation.rechnung_de, dir)
    end,

  },
  translation_price_specifier_array = {
    translation_price_specifier = function(arr)
      return {
        translation_price_specifier_array = arr,
        total = hs.fnutils.reduce(
          arr,
          function(acc, v) return acc + v.price end,
          0
        )
      }
    end
  },
  translation_price_specifier = {
    translation_price_block_german = function(spec)
      return 
        get.string_or_number_array.string_by_joined(
          hs.fnutils.imap(
            spec.translation_price_specifier_array,
            function(v)
              return ("%d Zeilen @ %.2f€ = %d€"):format(
                v.normzeilen,
                v.rate,
                v.price
              )
            end
          ),
          "\n"
        ) .. "\n" ..
        ("Gesamt: %d€"):format(spec.total) .. "\n" ..
        ("Rechnungsbetrag: %d€"):format(spec.total) 
      end,
  },
  number_array = {

  },
  project_dir = {
    
  },

  running_application = {
    main_window = function(app)
      return app:mainWindow()
    end,
    focused_window = function(app)
      return app:focusedWindow()
    end,
    focused_window_jxa_window_specifier = function(app)
      return transf.window.jxa_window_specifier(
        transf.running_application.focused_window(app)
      )
    end,
    window_array = function(app)
      return app:allWindows()
    end,
    window_filter = function(app)
      return hs.window.filter.new(nil):setAppFilter(app)
    end,
    window_array_via_window_filter = function(app)
      return transf.running_application.window_filter(app):getWindows()
    end,
    mac_application_name = function(app)
      return app:name()
    end,
    bundle_id = function(app)
      return app:bundleID()
    end,
    menu_item_table_array = function(app)
      local arr = get.array_of_n_any_assoc_arrays.array_of_assoc_leaf_labels_with_title_path(
        get.tree_node_like_array.tree_node_array(
          app:getMenuItems(),
          { levels_of_nesting_to_skip = 1}
        ),
        "AXTitle"
      )
      local filtered = hs.fnutils.ifilter(arr, function (v) return v.AXTitle ~= "" end)
      for k, v in transf.table.key_value_stateless_iter(filtered) do
        v.application = app
      end
      return filtered
    end,
    icon_hs_image = function(app)
      return transf.bundle_id.icon_hs_image(
        transf.running_application.bundle_id(app)
      )
    end
  },
  window = {
    running_application = function(window)
      return window:application()
    end,
    title = function(window)
      return window:title()
    end,
    filtered_title = function(window)
      return transf.window.title(window):gsub(" - " .. transf.window.mac_application_name(window), "")
    end,
    mac_application_name = function(window)
      return transf.running_application.mac_application_name(
        transf.window.running_application(window)
      )
    end,
    screenshot_hs_image = function(window)
      return window:snapshot()
    end,
    ax_uielement = function(window)
      return hs.axuielement.windowElement(window)
    end,
    hs_geometry_rect = function(window)
      return window:frame()
    end,
    hs_geometry_point_tl = function(window)
      return window:topLeft()
    end,
    hs_geometry_point_tr = function(window)
      local rect = transf.window.hs_geometry_rect(window)
      rect.x = rect.x + rect.w -- move by width
      return rect.topleft -- new top left is old top right
    end,
    hs_geometry_point_bl = function(window)
      local rect = transf.window.hs_geometry_rect(window)
      rect.y = rect.y + rect.h -- move by height
      return rect.topleft -- new top left is old bottom left
    end,
    hs_geometry_point_br = function(window)
      return transf.window.hs_geometry_rect(window).bottomright
    end,
    hs_geometry_size = function(window)
      return window:size()
    end,
    hs_geometry_point_relative_center = function(window)
      return transf.window.hs_geometry_size(window).center
    end,
    hs_geometry_point_c = function(window)
      return transf.window.hs_geometry_rect(window).center
    end,
    summary = function(window)
      return eutf8.format(
        "%s (%s)",
        transf.window.title(window),
        transf.window.mac_application_name(window)
      )
    end,
    hs_screen = function(window)
      return window:screen()
    end,
    app_icon_hs_image = function(window)
      return transf.running_application.icon_hs_image(
        transf.window.running_application(window)
      )
    end,
    native_window_index = function(window)
      local running_application = transf.window.running_application(window)
      local window_array = transf.running_application.window_array(running_application)
      return hs.fnutils.find(
        window_array,
        function(v)
          return v:id() == window:id()
        end
      )
    end,
    jxa_window_index = function(window)
      return get.string.evaled_js_osa(
        "Application('" .. transf.window.mac_application_name(window) .. "')" ..
          ".windows().findIndex(" ..
            "window => window.title() == '" .. transf.window.filtered_title(window) .. "'" ..
          ")"
      )
    end,
    jxa_window_specifier = function(window)
      return {
        application_name = transf.window.mac_application_name(window),
        window_index = transf.window.jxa_window_index(window)
      }
    end,
  },
  window_filter = {
    window_array = function(window_filter)
      return window_filter:getWindows()
    end,
  },
  jxa_window_specifier = {
    title = function(window_spec)
      return get.jxa_window_specifier.property(window_spec, "title")
    end,
    window = function(window_spec)
      return get.running_application.window_by_title(
        transf.jxa_window_specifier.title(window_spec) .. " - " .. 
        window_spec.application_name
      )
    end,
    filtered_title = function(window_spec)
      return transf.window.filtered_title(
        transf.jxa_window_specifier.window(window_spec)
      )
    end,
  },
  tabbable_jxa_window_specifier = {
    amount_of_tabs = function(window_spec)
      return get.string.evaled_js_osa( 
        "Application('" .. window_spec.application_name .. "')" ..
          ".windows().[" ..
            window_spec.window_index ..
          "].tabs().length"
      )
    end,
    jxa_tab_specifier_array = function(window_spec)
      local tab_spec_array = {}
      for i = 0, transf.tabbable_jxa_window_specifier.amount_of_tabs(window_spec) - 1 do
        table.insert(tab_spec_array, {
          application_name = window_spec.application_name,
          window_index = window_spec.window_index,
          tab_index = i
        })
      end
      return tab_spec_array
    end,
    active_tab_index = function(window_spec)
      return get.string.evaled_js_osa( 
        "Application('" .. window_spec.application_name .. "')" ..
          ".windows().[" ..
            window_spec.window_index ..
          "].activeTabIndex()"
      )
    end,
    active_jxa_tab_specifier = function(window_spec)
      return get.jxa_window_specifier.jxa_tab_specifier(
        window_spec,
        transf.tabbable_jxa_window_specifier.active_tab_index(window_spec)
      )
    end,
  },
  browser_tabbable_jxa_window_specifier = {
    url = function(window_spec)
      return transf.browser_jxa_tab_specifier.url(
        transf.tabbable_jxa_window_specifier.active_jxa_tab_specifier(window_spec)
      )
    end
  },
  jxa_tab_specifier = {
    application_name = function(tab_spec)
      return tab_spec.application_name
    end,
    running_application = function(tab_spec)
      return transf.mac_application_name.running_application(
        tab_spec.application_name
      )
    end,
    window_index = function(tab_spec)
      return tab_spec.window_index
    end,
    tab_index = function(tab_spec)
      return tab_spec.tab_index
    end,
    title = function(tab_spec)
      return get.jxa_tab_specifier.property(tab_spec, "title")
    end,
    jxa_window_specifier = function(tab_spec)
      return {
        application_name = tab_spec.application_name,
        window_index = tab_spec.window_index
      }
    end,
  },
  browser_jxa_tab_specifier = {
    url = function(tab_spec)
      return get.jxa_tab_specifier.property(tab_spec, "url")
    end,
  },
  bundle_id = {
    icon_hs_image = function(bundle_id)
      return hs.image.imageFromAppBundle(bundle_id)
    end,
  },
  dotapp_path = {
    mac_application_name = function(dotapp_path)
      return transf.path.filename(dotapp_path)
    end
  },
  jxa_browser_tabbable_running_application = {
    url = function(app)
      return transf.browser_tabbable_jxa_window_specifier.url(
        transf.running_application.focused_window_jxa_window_specifier(app)
      )
    end,
  },
  mac_application_name = {
    application_support_dir_path = function(app_name)
      return env.MAC_APPLICATION_SUPPORT .. "/" .. app_name
    end,
    app_dir = function(app_name)
      return "/Applications/" .. app_name .. ".app"
    end,
    running_application = function(app_name)
      return hs.application.get(app_name)
    end,
    ensure_running_application = function(app_name)
      local app = transf.mac_application_name.running_application(app_name)
      if app == nil then
        return hs.application.open(app_name, 5)
      end
      return app
    end,
    menu_item_table_array = function(app_name)
      return transf.running_application.menu_item_table_array(transf.mac_application_name.running_application(app_name))
    end,
    
  },
  chat_mac_application_name = {
    chat_storage_dir = function(app_name)
      return env.MCHATS .. "/" .. transf.string.string_by_all_eutf8_lower(app_name)
    end,
    chat_media_dir = function(app_name)
      return transf.chat_mac_application_name.chat_storage_dir(app_name) .. "/media"
    end,
    chat_chats_dir = function(app_name)
      return transf.chat_mac_application_name.chat_storage_dir(app_name) .. "/chats"
    end,
  },
  bib_string = {
    csl_table_array = function(str)
      return transf.string.table_or_err_by_evaled_env_bash_parsed_json("pandoc -f biblatex -t csljson" .. transf.string.here_string(str))
    end,
    urls = function(str)
      return transf.csl_table_array.url_array(
        transf.bib_string.csl_table_array(str)
      )
    end
  },
  csl_table_array = {
    bib_string_array = function(arr)
      return hs.fnutils.imap(
        arr,
        transf.csl_table.bib_string
      )
    end,
    bib_string = function(arr)
      return get.string_or_number_array.string_by_joined(
        transf.csl_table_array.bib_string_array(arr),
        "\n"
      )
    end,
    json_string = transf.not_userdata_or_function.json_string,
    indicated_citable_object_id_array = function(arr)
      return hs.fnutils.imap(
        arr,
        transf.csl_table.indicated_citable_object_id
      )
    end,
    citations_file_string = function(arr)
      return transf.indicated_citable_object_id_array.citations_file_string(
        transf.csl_table_array.indicated_citable_object_id_array(arr)
      )
    end,
    url_array = function(csl_table_array)
      return hs.fnutils.imap(csl_table_array, transf.csl_table.url)
    end,

  },
  csl_table_or_csl_table_array = {
    url_array = function(csl_table_or_csl_table_array)
      if is.any.array(csl_table_or_csl_table_array) then
        return transf.csl_table_array.url_array(csl_table_or_csl_table_array)
      else
        return {transf.csl_table.url(csl_table_or_csl_table_array)}
      end
    end,
  },
  csl_table = {
    main_title = function(csl_table)
      return get.assoc.vt_by_first_match_w_kv_arr(csl_table, mt._list.csl_title_keys)
    end,
    issued_date_parts_single_or_range = function(csl_table)
      return csl_table.issued
    end,
    issued_rf3339like_dt_or_interval = function(csl_table)
      return transf.date_parts_single_or_range.rf3339like_dt_or_interval(
        transf.csl_table.issued_date_parts_single_or_range(csl_table)
      )
    end,
    issued_rfc3339like_dt_force_first = function(csl_table)
      return transf.date_parts_single_or_range.rfc3339like_dt_force_first(
        transf.csl_table.issued_date_parts_single_or_range(csl_table)
      )
    end,
    issued_date_force_first = function(csl_table)
      return transf.date_parts_single_or_range.date_force_first(
        transf.csl_table.issued_date_parts_single_or_range(csl_table)
      )
    end,
    issued_prefix_partial_date_component_name_value_dict_force_first = function(csl_table)
      return transf.date_parts_single_or_range.prefix_partial_date_component_name_value_dict_force_first(
        transf.csl_table.issued_date_parts_single_or_range(csl_table)
      )
    end,
    issued_year_force_first = function(csl_table)
      return transf.csl_table.issued_prefix_partial_date_component_name_value_dict_force_first(csl_table).year
    end,
    author_array = function(csl_table)
      return csl_table.author
    end,
    naive_author_summary = function(csl_table)
      return get.string_or_number_array.string_by_joined(
        hs.fnutils.imap(
          transf.csl_table.author_array(csl_table),
          transf.csl_person.naive_name
        ),
        ", "
      )
    end,
    author_last_name_array = function(csl_table)
      return hs.fnutils.imap(
        transf.csl_table.author_array(csl_table),
        transf.csl_person.family
      )
    end,
    authors_et_al_array = function(csl_table)
      return get.array.array_by_slice_removed_indicator_and_flatten_w_slice_spec(
        transf.csl_table.author_last_name_array(csl_table),
        { stop = 5 },
        "et_al"
      )
    end,
    authors_et_al_string = function(csl_table)
      return get.string_or_number_array.string_by_joined(
        transf.csl_table.authors_et_al_array(csl_table),
        ", "
      )
    end,
    main_title_filenamized = function(csl_table)
      return transf.string.upper_camel_snake_case(
        transf.csl_table.main_title(csl_table)
      )
    end,
    filename = function(csl_table)
      return string.sub(
        get.string_or_number_array.string_by_joined(
          {
            transf.csl_table.authors_et_al_string(csl_table),
            get.csl_table.key_year_force_first(csl_table, "issued"),
            transf.csl_table.main_title_filenamized(csl_table)
          },
          "__"
        ),
        1,
        200 -- max filename length, with some space for other stuff
      )
    end,
    volume = function(csl_table)
      return csl_table.volume
    end,
    indicated_volume_string = function(csl_table)
      local volume = transf.csl_table.volume(csl_table)
      if volume then
        return "vol. " .. volume
      end
    end,
    jssue = function(csl_table)
      return csl_table.issue
    end,
    indicated_issue_string = function(csl_table)
      local issue = transf.csl_table.issue(csl_table)
      if issue then
        return "no. " .. issue
      end
    end,
    page = function(csl_table)
      return csl_table.page
    end,
    page_interal_specifier = function(csl_table)
      return transf.single_value_or_basic_interval_string.interval_specifier(
        transf.csl_table.page(csl_table)
      )
    end,
    page_sequence_specifier = function(csl_table)
      return get.interval_specifier.sequence_specifier(
        transf.csl_table.page_interal_specifier(csl_table),
        1 -- afaik there is never a case where pages don't increase by 1 (there is no notation that says 'every other page', for example)
      )
    end,
    indicated_page_string = function(csl_table)
      local page = transf.csl_table.page(csl_table)
      if page then
        if stringy.find(page, "-") then
          return "pp. " .. page
        else
          return "p. " .. page
        end
      end
    end,
    title = function(csl_table)
      return csl_table.title
    end,
    author = function(csl_table)
      return csl_table.author
    end,
    type = function(csl_table)
      return csl_table.type
    end,
    doi = function(csl_table)
      return csl_table.doi
    end,
    isbn = function(csl_table)
      return csl_table.isbn
    end,
    chapter = function(csl_table)
      return csl_table.chapter
    end,
    publisher = function(csl_table)
      return csl_table.publisher
    end,
    publisher_place = function(csl_table)
      return csl_table["publisher-place"]
    end,
    isbn_part_identifier = function(csl_table)
      local isbn_part_identifier = transf.csl_table.isbn(csl_table)
      if csl_table.chapter then
        isbn_part_identifier = isbn_part_identifier .. "::c=" .. csl_table.chapter
      elseif csl_table.page then
        isbn_part_identifier = isbn_part_identifier .. "::p=" .. csl_table.page
      else
        return nil
      end
      return isbn_part_identifier
    end,
    issn = function(csl_table)
      return csl_table.ISSN
    end,
    issn_full_identifier = function(csl_table)
      local issn_full_identifier = transf.csl_table.issn(csl_table)
      if csl_table.volumen and csl_table.issue then
        return issn_full_identifier .. "::" .. csl_table.volume .. "::" .. csl_table.issue
      else
        return nil
      end
    end,
    pmid = function(csl_table)
      return csl_table.pmid
    end,
    pmcid = function(csl_table)
      return csl_table.pmcid
    end,
    url = function(csl_table)
      return csl_table.URL
    end,
    urlmd5 = function(csl_table)
      return transf.not_userdata_or_function.md5_hex_string(transf.csl_table.url(csl_table))
    end,
    accession = function(csl_table)
      return csl_table.accession
    end,
    citable_object_id = function(csl_table)
      if csl_table.doi then
        return csl_table.doi
      elseif csl_table.isbn and is.csl_table.whole_book(csl_table) then
        return csl_table.isbn
      elseif csl_table.isbn and not is.csl_table.whole_book(csl_table) then
        return transf.csl_table.isbn_part_identifier(csl_table)
      elseif csl_table.pmid then
        return csl_table.pmid
      elseif csl_table.pmcid then
        return csl_table.pmcid
      elseif csl_table.accession then
        return csl_table.accession
      elseif transf.csl_table.issn_full_identifier(csl_table) then
        return transf.csl_table.issn_full_identifier(csl_table)
      elseif csl_table.url then
        return transf.csl_table.urlmd5(csl_table)
      else
        return nil
      end
    end,
    indicated_citable_object_id = function(csl_table)
      if csl_table.doi then
        return "doi:" .. csl_table.doi
      elseif csl_table.isbn and is.csl_table.whole_book(csl_table) then
        return "isbn:" .. csl_table.isbn
      elseif csl_table.isbn and not is.csl_table.whole_book(csl_table) then
        return "isbn_part:" .. transf.csl_table.isbn_part_identifier(csl_table)
      elseif csl_table.pmid then
        return "pmid:" .. csl_table.pmid
      elseif csl_table.pmcid then
        return "pmcid:" .. csl_table.pmcid
      elseif csl_table.accession then
        return "accession:" .. csl_table.accession
      elseif transf.csl_table.issn_full_identifier(csl_table) then
        return "issn_full:" .. transf.csl_table.issn_full_identifier(csl_table)
      elseif csl_table.url then
        return "urlmd5:" .. transf.csl_table.urlmd5(csl_table)
      else
        return nil
      end
    end,
    citations_file_line = function(csl_table)
      return transf.csl_table.indicated_citable_object_id(csl_table) 
      .. " # " .. transf.csl_table.apa_string(csl_table)
    end,
    filename_safe_citable_object_id = function(csl_table)
      return transf.string.encoded_query_param_value(transf.csl_table.citable_object_id(csl_table))
    end,
    filename_safe_indicated_citable_object_id = function(csl_table)
      return transf.string.encoded_query_param_value(transf.csl_table.indicated_citable_object_id(csl_table))
    end,
    citable_filename = function(csl_table)
      return 
        transf.csl_table.filename(csl_table) ..
        "!citid:" .. transf.csl_table.filename_safe_indicated_citable_object_id(csl_table)
    end,
    bib_string = function(csl_table)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(
        "pandoc -f csljson -t biblatex" .. transf.string.here_string(transf.not_userdata_or_function.json_string(csl_table))
      )
    end,
    apa_string = function(csl_table)
      return get.csl_table_or_csl_table_array.raw_citations(csl_table, "apa-6th-edition")
    end,
  },
  csl_person = {
    family = function(csl_person)
      return csl_person.family
    end,
    given = function(csl_person)
      return csl_person.given
    end,
    dropping_particle = function(csl_person)
      return csl_person["dropping-particle"]
    end,
    non_dropping_particle = function(csl_person)
      return csl_person["non-dropping-particle"]
    end,
    suffix = function(csl_person)
      return csl_person.suffix
    end,
    literal = function(csl_person)
      return csl_person.literal
    end,
    naive_name = function(csl_person)
      return get.string_or_number_array.string_by_joined(
        transf.hole_y_arraylike.array({
          transf.csl_person.given(csl_person),
          transf.csl_person.dropping_particle(csl_person),
          transf.csl_person.non_dropping_particle(csl_person),
          transf.csl_person.family(csl_person),
          transf.csl_person.suffix(csl_person),
          transf.csl_person.literal(csl_person) and '"' .. transf.csl_person.literal(csl_person) .. '"' or nil,
        }),
        " "
      )
    end,
  },
  csl_style = {
    path = function(style)
      return env.GIT_PACKAGES .. "/citation-style-language/styles/" .. style .. ".csl"
    end,
  },
  date_parts_single = {
    rfc3339like_dt = function(date_parts)
      return get.string_or_number_array.string_by_joined(date_parts, "-")
    end,
    prefix_partial_date_component_name_value_dict = function(date_parts)
      return { year = date_parts[1], month = date_parts[2], day = date_parts[3] }
    end,
    full_full_date_component_name_value_dict = function(date_parts)
      return transf.date_component_name_value_dict.min_full_date_component_name_value_dict(
        transf.date_parts_single.prefix_partial_date_component_name_value_dict(date_parts)
      )
    end,
    date = function(date_parts)
      return transf.full_date_component_name_value_dict.date(
        transf.date_parts_single.full_full_date_component_name_value_dict(date_parts)
      )
    end,
  },
  date_parts_range = {
    rfc3339like_interval = function(date_parts_range)
      return transf.date_parts.rfc3339like_dt(date_parts_range[1]) .. "_to_" .. transf.date_parts.rfc3339like_dt(date_parts_range[2])
    end,
    date_interval_specifier = function(date_parts_range)
      return {
        start = transf.date_parts_single.full_full_date_component_name_value_dict(date_parts_range[1]),
        stop = transf.date_parts_single.full_full_date_component_name_value_dict(date_parts_range[2])
      }
    end
  },
  date_parts_single_or_range = {
    rf3339like_dt_or_interval = function(date_parts)
      if #date_parts == 1 then
        return transf.date_parts_single.rfc3339like_dt(date_parts[1])
      else
        return transf.date_parts_range.rfc3339like_interval(date_parts)
      end
    end,
    --- will pick the first date if there is a range
    rf3339like_dt_force_first = function(date_parts)
      return transf.date_parts_single.rfc3339like_dt(date_parts[1])
    end,
    prefix_partial_date_component_name_value_dict_force_first = function(date_parts)
      return transf.date_parts_single.prefix_partial_date_component_name_value_dict(date_parts[1])
    end,
    full_full_date_component_name_value_dict_force_first = function(date_parts)
      return transf.date_parts_single.full_full_date_component_name_value_dict(date_parts[1])
    end,
    date_force_first = function(date_parts)
      return transf.date_parts_single.date(date_parts[1])
    end,
  },
  url = {
    url_by_ensure_scheme = function(url)
      if is.url.scheme_url(url) then
        return url
      else
        return "https://" .. url
      end
    end,
    in_wayback_machine = function(url)
      return "https://web.archive.org/web/*/" .. transf.url.url_by_ensure_scheme(url)
    end,
    default_negotiation_url_contents = function(url)
      return get.fn.rt_or_nil_by_memoized(transf.string.string_or_nil_by_evaled_env_bash_stripped, refstore.params.memoize.opts.invalidate_1_day_fs, "run")
          "curl -L" .. transf.string.single_quoted_escaped(url)
    end,
    in_cache_dir = function(url)
      return transf.not_userdata_or_function.in_cache_dir(transf.url.url_by_ensure_scheme(url), "url")
    end,
    url_table = function(url)
      return get.fn.rt_or_nil_by_memoized(urlparse)(transf.url.url_by_ensure_scheme(url))
    end,
    scheme = function(url)
      return transf.url.url_table(url).scheme
    end,
    host = function(url)
      return transf.url.url_table(url).host
    end,
    sld_and_tld = function(url)
      return eutf8.match(transf.url.host(url), "(%w+%.%w+)$")
    end,
    sld = function(url)
      return eutf8.match(transf.url.host(url), "(%w+)%.%w+$") 
    end,
    tld = function(url)
      return eutf8.match(transf.url.host(url), "%w+%.(%w+)$")
    end,
    path = function(url)
      return transf.url.url_table(url).path
    end,
    query = function(url)
      return transf.url.url_table(url).query
    end,
    fragment = function(url)
      return transf.url.url_table(url).fragment
    end,
    port = function(url)
      return transf.url.url_table(url).port
    end,
    user = function(url)
      return transf.url.url_table(url).user
    end,
    password = function(url)
      return transf.url.url_table(url).password
    end,
    param_table = function(url)
      local params = {}
      local url_parts = stringy.split(url, "?")
      if #url_parts > 1 then
        local param_parts = stringy.split(url_parts[2], "&")
        for _, param_part in transf.array.index_value_stateless_iter(param_parts) do
          local param_parts = stringy.split(param_part, "=")
          local key = param_parts[1]
          local value = param_parts[2]
          params[key] = transf.string.string_by_percent_decoded_also_plus(value)
        end
      end
      return params
    end,
    no_scheme = function(url)
      local parts = stringy.split(url, ":")
      table.remove(parts, 1)
      local rejoined = get.string_or_number_array.string_by_joined(parts, ":")
      return get.string.no_prefix_string(rejoined, "//")
    end,
    string_by_webcal_name = function(url)
      return "webcal_readonly_" .. transf.not_userdata_or_function.md5_hex_string(url)
    end,
    vdirsyncer_pair_specifier = function(url)
      local name = transf.url.string_by_webcal_name(url)
      local local_storage_path =  env.XDG_STATE_HOME .. "/vdirsyncer/" .. name
      return  {
        name = name,
        collections = "noquote:null",
        conflict_resolution = "b wins",
        local_storage_type = "filesystem",
        local_storage_path = local_storage_path,
        local_storage_fileext = ".ics",
        remote_storage_type = "http",
        remote_storage_url = url,
      }
    end,
    absolute_path_by_webcal_storage_location = function(url)
      return env.XDG_STATE_HOME .. "/vdirsyncer/" .. transf.url.string_by_webcal_name(url)
    end,
    ini_string_by_khal_config_section = function(url)
      return transf.dict_of_string_value_dicts.ini_string({
        ["[ro:".. transf.url.sld(url) .. "]"] = {
          path = transf.url.absolute_path_by_webcal_storage_location(url),
          priority = 0,
        }
      })
    end,
    url_potentially_with_title_comment = function(url)
      local title = transf.sgml_url.string_or_nil_by_title(url)
      if title and title ~= "" then
        return url .. " # " .. title
      else
        return url
      end
    end,
    title_or_url_as_filename = function(url)
      local title = transf.sgml_url.string_or_nil_by_title(url)
      if title and title ~= "" then
        return transf.string.safe_filename(title) .. ".url2"
      else
        return transf.string.safe_filename(url) .. ".url2"
      end
    end,

  },
  path_url = {
    initial_path_component = function(url)
      return transf.path.initial_path_component(transf.url.path(url))
    end,
    leaf = function(url)
      return transf.path.leaf(transf.url.path(url))
    end,
  },
  sgml_url = {
    sgml_string = transf.url.default_negotiation_url_contents, -- ideally we would reject non-html responses, but currently, that's too much work
    string_or_nil_by_title = function(url)
      return get.sgml_url.string_or_nil_by_query_selector_all(url, "title")
    end,
    string_or_nil_by_description = function(url)
      return get.sgml_url.string_or_nil_by_query_selector_all(url, "meta[name=description]")
    end,
    sgml_url_with_title_comment = function(url)
      return url .. " # " .. transf.sgml_url.string_or_nil_by_title(url)
    end
  },
  owner_item_url = {
    owner_item = function(url)
      return get.path.path_component_array_by_slice_w_slice_spec(transf.url.path(url), "1:2")
    end,
  },
  github_url = {

  },
  whisper_url = {
    transcribed = function(url)
      local path = transf.url.in_cache_dir(url)
      dothis.url.download_to(url, path)
      return transf.whisper_file.transcribed(path)

    end
  },
  image_url = {
    booru_post_url = function(url)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(
        "saucenao --url" ..
        transf.string.single_quoted_escaped(url)
        .. "--output-properties booru-url"
      )
    end,
    hs_image = function(url)
      return get.fn.rt_or_nil_by_memoized(hs.image.imageFromURL, refstore.params.memoize.opts.invalidate_1_week_fs, "hs.image.imageFromURL")(url)
    end,
    qr_data = function(url)
      local path = transf.url.in_cache_dir(url)
      dothis.url.download_to(url, path)
      return transf.local_image_file.qr_data(path)
    end,
    data_url = function(url)
      local ext = transf.path.extension(url)
      return get.fn.rt_or_nil_by_memoized(hs.image.encodeAsURLString)(transf.image_url.hs_image(url), ext)
    end,
  },
  gelbooru_style_post_url = {
    nonindicated_number_string_by_booru_post_id = function(url)
      return transf.url.param_table(url).id
    end,
    pos_int_by_booru_post_id = function(url)
      return transf.nonindicated_number_string.number_base_10(transf.gelbooru_style_post_url.nonindicated_number_string_by_booru_post_id(url))
    end,
  },
  yandere_style_post_url = {
    nonindicated_number_string_by_booru_post_id = function(url)
      return eutf8.match(transf.url.path(url), "/post/show/(%d+)")
    end
  },
  danbooru_style_post_url = {
    nonindicated_number_string_by_booru_post_id = function(url)
      return eutf8.match(transf.url.path(url), "/posts/(%d+)")
    end
  },
  gpt_response_table = {
    response_text = function(result)
      local first_choice = result.choices[1]
      local response = first_choice.text or first_choice.message.content
      return stringy.strip(response)
    end
  },
  not_userdata_or_function = {
    md5_hex_string = function(thing)
      if type(thing) ~= "string" then 
        thing = json.encode(thing) 
      end
      local md5 = hashings("md5")
      md5:update(thing)
      return md5:hexdigest()
    end,
    md5_base32_crock_string = function(thing)
      if type(thing) ~= "string" then 
        thing = json.encode(thing) 
      end
      local md5 = hashings("md5")
      md5:update(thing)
      return transf.string.base32_crock_string(md5:digest())
    end,
    in_cache_dir = function(data, type)
      return transf.string.in_cache_dir(
        transf.not_userdata_or_function.md5_hex_string(data),
        type
      )
    end,
    in_tmp_dir = function(data, type)
      return transf.string.in_tmp_dir(
        transf.not_userdata_or_function.md5_hex_string(data),
        type
      )
    end,
    single_quoted_escaped_json = function(t)
      return transf.string.single_quoted_escaped(json.encode(t))
    end,
    json_string = json.encode,
    json_string_pretty = function(t)
      if is.any.table(t) then
        return transf.table.json_string_pretty(t)
      else
        return transf.not_userdata_or_function.json_string(t)
      end
    end,
    --- wraps yaml.dump into a more intuitive form which always encodes a single document
    --- @param tbl any
    --- @return string
    yaml_string = function(tbl)
      local raw_yaml = yaml.dump({tbl})
      local lines = stringy.split(raw_yaml, "\n")
      return get.string_or_number_array.string_by_joined(lines, "\n", 2, #lines - 2)
    end,
    json_here_string = function(t)
      return transf.string.here_string(json.encode(t))
    end,
  },
  any = {
    inspect_string = function(thing)
      return hs.inspect(thing, {depth = 5})
    end,
    string = function(stringable)
      if type(stringable) == "string" then
        return stringable
      elseif type(stringable) ~= "table" then
        return tostring(stringable)
      else
        if stringable.get then
          local got_tostring = stringable:get("to-string")
          if got_tostring then
            return got_tostring
          end
        end
        local succ, json = pcall(transf.not_userdata_or_function.json_string, stringable)
        if succ then
          return json
        else
          return transf.any.inspect_string(stringable)
        end
      end
    end,
    self_and_empty_string = function(any)
      return any, ""
    end,
    t_by_self = function(any)
      return any
    end,
    boolean = function(any)
      return not not any
    end,
    n_anys_if_table = function(any)
      if type(any) == "table" then
        return table.unpack(any)
      else
        return any
      end
    end,
    applicable_thing_name_hierarchy = function(any)
      return get.any.applicable_thing_name_hierarchy(any)
    end,
    applicable_thing_name_array = function(any)
      return transf.thing_name_hierarchy.thing_name_array(transf.any.applicable_thing_name_hierarchy(any))
    end,
    applicable_action_specifier_array = function(any)
      return transf.thing_name_array.action_specifier_array(transf.any.applicable_thing_name_array(any))
    end,
    applicable_action_chooser_item_specifier_array = function(any)
      return transf.action_specifier_array.action_chooser_item_specifier_array(transf.any.applicable_action_specifier_array(any))
    end,
    applicable_action_with_index_chooser_item_specifier_array = function(any)
      return transf.assoc_array.assoc_with_index_as_key_array(transf.any.applicable_action_chooser_item_specifier_array(any))
    end,
    placeholder_text = function(any)
      return "Choose action on: " .. (
        get.thing_name_array.placeholder_text(transf.any.applicable_thing_name_array(any), any) or
        get.thing_name_array.chooser_text(transf.any.applicable_thing_name_array(any), any)
      )
    end,
    hschooser_specifier = function(any)
      return {
        chooser_item_specifier_array = transf.any.applicable_action_with_index_chooser_item_specifier_array(any),
        placeholder_text = transf.any.placeholder_text(any),
      }
    end,
    choosing_hschooser_specifier = function(any)
      return get.hschooser_specifier.choosing_hschooser_specifier(transf.any.hschooser_specifier(any), "index", any)
    end,
    any_and_applicable_thing_name_array_specifier = function(any)
      return {
        any = any,
        applicable_thing_name_array = transf.any.applicable_thing_name_array(any)
      }
    end,
    item_chooser_item_specifier = function(any)
      local applicable_thing_name_array = transf.any.applicable_thing_name_array(any)
      return {
        text = transf.string.with_styled_start_end_markers(get.thing_name_array.chooser_text(applicable_thing_name_array, any)),
        subText = get.thing_name_array.chooser_subtext(applicable_thing_name_array, any),
        image = get.thing_name_array.chooser_image(applicable_thing_name_array, any),
      }
    end,
    with_1_added_if_number = function(any)
      if type(any) == "number" then
        return any + 1
      else
        return any
      end
    end,
    with_1_subtracted_if_number = function(any)
      if type(any) == "number" then
        return any - 1
      else
        return any
      end
    end
  },
  item_chooser_item_specifier = {
    truncated_text_item_chooser_item_specifier = function(item_chooser_item_specifier)
      local copied_spec = get.table.table_by_copy(item_chooser_item_specifier)
      local rawstr =  transf.styledtext.string(
        copied_spec.text
      )
      local truncated = get.string.string_by_shortened_start_ellipsis(rawstr, 250)
      copied_spec.text = transf.string.with_styled_start_end_markers(truncated)
      return copied_spec
    end
  },
  n_anys = {
    array = function(...)
      return {...}
    end,
    n_anys = function(...)
      return ...
    end,
    amount = function(...)
      return #{...}
    end,
  },
  string_and_n_anys = {
    string_and_n_anys_by_stripped = function(...)
      local arg1 = select(1, ...)
      return stringy.strip(arg1), select(2, ...)
    end
  },
  n_boolean_functions = {
    and_boolean_function = function(...)
      local functions = {...}
      return function(arg)
        for _, fn in transf.array.index_value_stateless_iter(functions) do
          if not fn(arg) then
            return false
          end
        end
        return true
      end
    end,
    or_boolean_function = function(...)
      local functions = {...}
      return function(arg)
        for _, fn in transf.array.index_value_stateless_iter(functions) do
          if fn(arg) then
            return true
          end
        end
        return false
      end
    end,
  },
  mailto_url = {
   
    emails = function(mailto_url)
      local no_scheme = transf.url.no_scheme(mailto_url)
      local emails_part = stringy.split(no_scheme, "?")[1]
      local emails = stringy.split(emails_part, ",")
      return hs.fnutils.imap(emails, stringy.strip)
    end,
    first_email = function(mailto_url)
      return transf.mailto_url.emails(mailto_url)[1]
    end,
    subject = function(mailto_url)
      return transf.url.param_table(mailto_url).subject 
    end,
    body = function(mailto_url)
      return transf.url.param_table(mailto_url).body 
    end,
    cc = function(mailto_url)
      return transf.url.param_table(mailto_url).cc 
    end,

  },
  tel_url = {
    phone_number = function(tel_url)
      return transf.url.no_scheme(tel_url)
    end,
    
  },
  otpauth_url = {
    type = function(otpauth_url)
      return stringy.split(transf.url.no_scheme(otpauth_url), "/")[1]
    end,
    label = function(otpauth_url)
      local part = stringy.split(transf.url.no_scheme(otpauth_url), "/")[2]
      return stringy.split(part, "?")[1]
    end,
    
  },
  data_url = {
    raw_type = function(data_url)
      return stringy.split(transf.url.no_scheme(data_url), ";")[1]
    end,
    header_part = function(data_url) -- the non-data part will either be separated from the rest of the url by `;,` or `;base64,`, so we need to split on `,`, then find the first part that ends `;` or `base64;`, and then join and return all parts before that part
      local parts = stringy.split(transf.url.no_scheme(data_url), ",")
      local non_data_part = ""
      for _, part in transf.array.index_value_stateless_iter(parts) do
        non_data_part = non_data_part .. part
        if stringy.endswith(part, ";") or stringy.endswith(part, "base64;") then
          break
        else
          non_data_part = non_data_part .. ","
        end
      end
      return non_data_part
    end,
    payload_part = function(data_url)
      return get.string.no_prefix_string(transf.url.no_scheme(data_url), transf.data_url.header_part(data_url))
    end,
      
    raw_type_param_table = function(data_url)
      local parts = stringy.split(transf.data_url.header_part(data_url), ";")
      table.remove(parts, 1) -- this is the content type
      table.remove(parts, #parts) -- this is the base64, or ""
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(parts, function(part)
        local kv = stringy.split(part, "=")
        return kv[1], kv[2]
      end)
    end
  },
  image_data_url = {
    hs_image = function(data_url)
      return transf.image_url.hs_image(data_url)
    end,
  },
  source_id = {
    language = function(source_id)
      return get.array.array_by_slice_w_3_pos_int_any_or_nils(stringy.split(source_id, "."), -1, -1)[1]
    end,
  },
  source_id_array = {
    next_to_be_activated = function(source_id_array)
      return get.array.next_by_fn_wrapping(source_id_array, is.source_id.active_source_id)
    end,
  },
  -- for future reference, since I'll forget: mod is a hypernym of mod_name, mod_symbol, and mod_char. Via the implementation in `normalize` we can be sure that no matter what we provide when we use tblmap, we will get the desired thing back.
  menu_item_table = {
    mod_name_array = function(menu_item_table)
      return menu_item_table.AXMenuItemCmdModifiers
    end,
    mod_symbol_array = function(menu_item_table)
      return transf.mod_array.mod_symbol_array(transf.menu_item_table.mod_name_array(menu_item_table))
    end,
    hotkey = function(menu_item_table)
      return menu_item_table.AXMenuItemCmdChar
    end,
    shortcut_string = function(menu_item_table)
      return transf.shortcut_specifier.shortcut_string({
        mod_array = transf.menu_item_table.mod_name_array(menu_item_table),
        key = transf.menu_item_table.hotkey(menu_item_table)
      } )
    end,
    title = function(menu_item_table)
      return menu_item_table.AXTitle
    end,
    full_action_path = function(menu_item_table)
      return transf.array_and_any.array(menu_item_table.path, menu_item_table.AXTitle)
    end,
    full_action_path_string = function(menu_item_table)
      return transf.string_array.action_path_string(transf.menu_item_table.full_action_path(menu_item_table))
    end,
    running_application = function(menu_item_table)
      return menu_item_table.application
    end,
    summary = function(menu_item_table)
      if transf.menu_item_table.hotkey(menu_item_table) then
        return transf.menu_item_table.full_action_path_string(menu_item_table) .. " (" .. transf.menu_item_table.shortcut_string(menu_item_table) .. ")"
      else
        return transf.menu_item_table.full_action_path_string(menu_item_table)
      end
    end
  },
  mod_array = {
    mod_symbol_array = function(mod_array)
      return get.array.array_by_mapped_w_t_key_dict(mod_array, transf.mod.mod_symbol)
    end,
    mod_char_array = function(mod_array)
      return get.array.array_by_mapped_w_t_key_dict(mod_array, transf.mod.mod_char)
    end,
    mod_name_array = function(mod_array)
      return get.array.array_by_mapped_w_t_key_dict(mod_array, transf.mod.mod_name)
    end,
  },
  shortcut_specifier = {
    mod_array = function(shortcut_specifier)
      return shortcut_specifier.mod_array
    end,
    key = function(shortcut_specifier)
      return shortcut_specifier.key
    end,
    shortcut_array = function(shortcut_specifier)
      return transf.array_and_any.array(
        shortcut_specifier.mod_array,
        shortcut_specifier.key
      )
    end,
    shortcut_string = function(shortcut_specifier)
      local modstr = plstringx.join("", get.array.array_by_mapped_w_t_key_dict(shortcut_specifier.mod_array, tblmap.mod.mod_symbol))
      if modstr == "" then
        return shortcut_specifier.key
      else
        return modstr .. " " .. shortcut_specifier.key
      end
    end,

  },
  audiodevice_specifier = {
    audiodevice = function(audiodevice_specifier)
      return audiodevice_specifier.device
    end,
    subtype = function(audiodevice_specifier)
      return audiodevice_specifier.subtype
    end,
    name = function(audiodevice_specifier)
      return transf.audiodevice.name(transf.audiodevice_specifier.audiodevice(audiodevice_specifier))
    end

  },
  audiodevice_specifier_array = {
    active_audiodevice_specifier_index = function(arr)
      return hs.fnutils.find(arr, is.audiodevice_specifier.active_audiodevice_specifier)
    end,
  },
  audiodevice = {
    name = function(audiodevice)
      return audiodevice:name()
    end,
  },
  env_var_name_env_node_dict = {
    env_string = function(env_var_name_env_node_dict)
      return transf.env_var_name_value_dict.env_string(
        get.env_var_name_env_node_dict.env_var_name_value_dict(env_var_name_env_node_dict)
      )
    end

  },
  env_yaml_file_container = {
    env_string = function(env_yaml_file_container)
      local files = transf.extant_path.file_array_by_descendants(env_yaml_file_container)
      local yaml_files = get.path_array.filter_to_same_extension(files, "yaml")
      local env_var_name_env_node_dict_array = hs.fnutils.imap(
        yaml_files,
        transf.yaml_file.not_userdata_or_function
      )
      local env_var_name_env_node_dict = transf.table_array.table_by_take_new(env_var_name_env_node_dict_array)
      return transf.env_var_name_env_node_dict.env_string(env_var_name_env_node_dict)
    end,
  },
  country_identifier_string = {
    iso_3366_1_alpha_2_country_code = function(country_identifier)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_string({
        input = country_identifier, 
        query = "Suppose the following identifies a country. Return its ISO 3166-1 Alpha-2 country code."
      }):lower()
    end,
  },
  language_identifier_string = {
    bcp_47_language_tag = function(country_identifier)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_string({
        input = country_identifier, 
        query = "Suppose the following identifies a language or variety. Return its BCP 47 language tag. Be conservative and only add information that is present in the input, or is necessary to make it into a valid BCP 47 language tag."
      })
    end,
  },
  bcp_47_language_tag = {
    summary = function(bcp_47_language_tag)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_string({
        input = bcp_47_language_tag, 
        query = "Suppose the following is a BCP 47 language tag. Return a natural language description of it."
      })
    end,
  },
  iso_3366_1_alpha_2_country_code = {
    iso_3366_1_full_name = function(iso_3366_1_alpha_2)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_string({
        input = iso_3366_1_alpha_2, 
        query = "Get the ISO 3366-1 full name of the country identified by the following ISO 3366-1 Alpha-2 country code."
      })
    end,
    iso_3366_1_short_name = function(iso_3366_1_alpha_2)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_string({
        input = iso_3366_1_alpha_2, 
        query = "Get the ISO 3366-1 short name of the country identified by the following ISO 3366-1 Alpha-2 country code."
      })
    end,
  },
  boolean = {
    negated = function(boolean)
      return not boolean
    end
  },
  ["nil"] = {
    ["true"] = function()
      return true
    end,
    ["false"] = function()
      return false
    end,
    ["nil"] = function()
      return nil
    end,
    empty_string = function()
      return ""
    end,
    empty_table = function()
      return {}
    end,
    zero = function()
      return 0
    end,
    one = function()
      return 1
    end,
    second_arg_ret_fn = function()
      return get["nil"].nth_arg_ret_fn(nil, 2)
    end,
    poisonable = function()
      local dirty = false
      local returnfn
      returnfn = function(...)
        if dirty then
          error("poisoned " .. tostring(returnfn))
        end
        dirty = true
        return {...}
      end
      return returnfn
    end,
    --- Create a function that returns a unique identifier for a given object.
    --- @return fun(any): number
    any_arg_pos_int_ret_fn_by_unique_id_primitives_equal = function()
      local fn_id_map = setmetatable({}, {__mode = "k"}) -- weak keys to allow garbage collection
      local next_id = 0

      local function getIdentifier(thing)
        local id = fn_id_map[thing]
        if id == nil then
          next_id = next_id + 1
          id = "thing " .. next_id
          fn_id_map[thing] = id
        end
        return id
      end

      return getIdentifier
    end,
    random_boolean = function()
      return math.random() < 0.5
    end,
    all_applications = function()
      return transf.dir.children_filename_array("/Applications")
    end,
    sox_is_recording = function()
      return transf.string.bool_by_evaled_env_bash_success("pgrep -x rec")
    end,
    pandoc_full_md_extension_set = function()
      return transf.array_value_dict.array_by_flatten(
        mt._list.markdown_extensions
      )
    end,
    passw_pass_item_name_array = function()
      return transf.dir.children_filename_array(env.MPASSPASSW)
    end,
    timestamp_s_last_midnight = function()
      return transf.date.timestamp_s(
        get.date.precision_date(
          date(),
          "day"
        )
      )
    end,
    package_manager_name_array = function()
      return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg list-package-managers"))
    end,
    package_manager_name_array_with_missing_packages = function()
      return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg missing-package-manager"))
    end,
    semver_string_array_of_installed_package_managers = function ()
      return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg package-manager-version"))
    end,
    absolute_path_array_of_installed_package_managers = function()
      return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg which-package-maanger"))
    end,
    mullvad_status_string = function()
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("mullvad status")
    end,
    mullvad_boolean_connected = function()
      return stringy.startswith(transf["nil"].mullvad_status_string(),"Connected")
    end,
    mullvad_relay_list_string = function()
      return get.fn.rt_or_nil_by_memoized(transf.string.string_or_nil_by_evaled_env_bash_stripped)("mullvad relay list")
    end,
    mullvad_relay_identifier_array = function()
      return 
        transf.table.array_by_nested_value_primitive_and_arraylike_is_leaf(
          transf.multiline_string.iso_3366_1_alpha_2_country_code_key_mullvad_city_code_key_mullvad_relay_identifier_string_array_value_dict_value_dict(
            transf["nil"].mullvad_relay_list_string()
          )
      )
    end,
    active_mullvad_relay_identifier = function()
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("mullvad relay get"):match("hostname ([^ ]+)")
    end,
    non_root_volume_absolute_path_array = function()
      return hs.fnutils.ifilter(
        transf.table_or_nil.kt_array(hs.fs.volume.allVolumes()),
        is.local_absolute_path.root_local_absolute_path
      )
    end,
    calendar_name_array = function()
      return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("khal printcalendars"))
    end,
    writeable_calendar_name_array = function()
      return hs.fnutils.ifilter(
        transf["nil"].calendar_name_array(),
        is.calendar_name.writeable_calendar_name
      )
    end,
    string_by_khard_list_output = function()
      return get.fn.rt_or_nil_by_memoized(transf.string.string_or_nil_by_evaled_env_bash_stripped)(
        "khard list --parsable"
      )
    end,
    contact_uid_array = function()
      return hs.fnutils.imap(
        stringy.split(transf["nil"].string_by_khard_list_output(), "\n"), 
        function (line)
          return stringy.split(line, "\t")[1]
        end
      )
    end,
    contact_table_array = function()
      return hs.fnutils.imap(
        transf["nil"].contact_uid_array(),
        function(uid)
          return transf.uuid.contact_table(uid)
        end
      )
    end

  },
  package_manager_name = {
    semver_string = function(mgr)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. mgr .. " package-manager-version")
    end,
    absolute_path = function(mgr)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. mgr .. " which-package-manager")
    end,
  },
  package_manager_name_or_nil = {
    backed_up_package_name_array = function(mgr)
      return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " read-backup"))
    end,
    missing_package_name_array = function(mgr)
      return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " missing"))
    end,
    added_package_name_array = function(mgr)
      return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " added"))
    end,
    difference_package_name_array = function(mgr)
      return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " difference"))
    end,
    package_name_or_package_name_semver_compound_string_array = function(mgr) return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list ")) end,
    package_name_semver_compound_string_array = function(mgr) return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list-version ")) end,
    package_name_array = function(mgr) return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list-no-version ")) end,
    package_name_semver_package_manager_name_compound_string_array = function(mgr) return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list-version-package-manager ")) end,
    package_name_package_manager_name_compound_string = function(mgr) return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list-with-package-manager ")) end,
    nonindicated_decimal_string_array_installed = function(mgr) return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " count ")) end,
  },
  package_name = {
    installed_package_manager = function(pkg) return transf.string.lines(transf.string.string_or_nil_by_evaled_env_bash_stripped("upkg installed_package_manager " .. pkg)) end,
  },
  action_specifier = {
    action_chooser_item_specifier = function(action_specifier)
      if action_specifier.text then error("old action_specifier format, contains action_specifier.text") end
      local str = get.string.string_by_with_suffix(action_specifier.d, ".")
      str = str .. " #" .. get.not_userdata_or_function.md5_base32_crock_string_of_length(action_specifier.d, 3) -- shortcode for easy use
      return {text = str}
    end
  },
  action_specifier_array = {
    action_chooser_item_specifier_array = function(action_specifier_array)
      return hs.fnutils.imap(
        action_specifier_array,
        transf.action_specifier.action_chooser_item_specifier
      )
    end,
    action_with_index_choose_item_specifier_array = function(action_specifier_array)
      return transf.assoc_array.assoc_with_index_as_key_array(
        transf.action_specifier.action_chooser_item_specifier_array(action_specifier_array)
      )
    end,
  },
  hschooser_speciifer = {

  },
  choosing_hschooser_specifier = {
    hschooser_speciifer = function(choosing_hschooser_specifier)
      return choosing_hschooser_specifier.hschooser_speciifer
    end,
  },
  thing_name = {
    transf_action_specifier_array = function(thing_name)
      return get.table.array_by_mapped_w_kt_vt_arg_vt_ret_fn(
        transf[thing_name],
        function(thing_name2, fn)
          return {
            d = "transf." .. thing_name .. "." .. thing_name2,
            getfn = fn
          }
        end
      )
    end,
    act_action_specifier_array = function(thing_name)
      return get.table.array_by_mapped_w_kt_vt_arg_vt_ret_fn(
        act[thing_name],
        function(action, fn)
          return {
            d = "act." .. thing_name .. "." .. action,
            getfn = fn
          }
        end
      )
    end,
    action_specifier_array = function(thing_name)
      return transf.two_arrays.array_by_appended(
        transf.thing_name.act_action_specifier_array[thing_name],
        transf.thing_name.transf_action_specifier_array[thing_name]
      )
    end,
  },
  thing_name_hierarchy = {
    thing_name_array = function(thing_name_hierarchy)
      return transf.table.array_by_nested_final_key_label_by_primitive_and_arraylike_is_leaf(thing_name_hierarchy)
    end
  },
  thing_name_array = {
    array_of_action_specifier_arrays = function(thing_name_array)
      return get.array.array_by_mapped_w_t_key_dict(
        thing_name_array,
        tblmap.thing_name.action_specifier_array
      )
    end,
    action_specifier_array = function(thing_name_array)
      return transf.array_of_arrays.array_by_flatten(
        transf.thing_name_array.array_of_action_specifier_arrays(thing_name_array)
      )
    end,
    chooser_image_retriever_specifier_array = function(thing_name_array)
      return hs.fnutils.imap(
        thing_name_array,
        function(thing_name)
          local spec = tblmap.thing_name.chooser_image_partial_retriever_specifier(thing_name)
          local newspec = {}
          newspec.thing_name = spec.thing_name
          newspec.precedence = spec.precedence or 1
          return newspec
        end
      )
    end,
    chooser_text_retriever_specifier_array = function(thing_name_array)
      return hs.fnutils.map(
        thing_name_array,
        function(thing_name)
          local spec = tblmap.thing_name.chooser_text_partial_retriever_specifier(thing_name)
          local newspec = {}
          newspec.thing_name = spec.thing_name
          newspec.precedence = spec.precedence or 1
          return newspec
        end
      )
    end,
    placeholder_text_retriever_specifier_array = function(thing_name_array)
      return hs.fnutils.map(
        thing_name_array,
        function(thing_name)
          local spec = tblmap.thing_name.placeholder_text_partial_retriever_specifier(thing_name)
          local newspec = {}
          newspec.thing_name = spec.thing_name
          newspec.precedence = spec.precedence or 1
          return newspec
        end
      )
    end,
    chooser_subtext_retriever_specifier_array = function(thing_name_array)
      return hs.fnutils.map(
        thing_name_array,
        function(thing_name)
          local spec = tblmap.thing_name.chooser_subtext_partial_retriever_specifier(thing_name)
          local newspec = {}
          newspec.thing_name = spec.thing_name
          newspec.precedence = spec.precedence or 1
          return newspec
        end
      )
    end,
    chooser_initial_selected_index_retriever_specifier_array = function(thing_name_array)
      return hs.fnutils.map(
        thing_name_array,
        function(thing_name)
          local spec = tblmap.thing_name.chooser_initial_selected_index_partial_retriever_specifier(thing_name)
          local newspec = {}
          newspec.thing_name = spec.thing_name
          newspec.precedence = spec.precedence or 1
          return newspec
        end
      )
    end,
  },
  retriever_specifier = {

  },
  retriever_specifier_array = {
    highest_precedence_retriever_specifier = function(retriever_specifier_array)
      return hs.fnutils.reduce(
        retriever_specifier_array,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.table_and_table.larger_table_by_key {a_use, a_use, "precedence"})
      )
    end,
    precedence_ordered_retriever_specifier_array = function(retriever_specifier_array)
      return get.array.array_by_sorted(
        retriever_specifier_array,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.table_and_table.larger_table_by_key) {a_use, a_use, "precedence"})
    end
  },
  ipc_socket_id = {
    ipc_socket_path = function(ipc_socket_id)
      return "/tmp/sockets/" .. ipc_socket_id
    end,
  },
  mpv_ipc_socket_id = {
    current_url = function (mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.string(mpv_ipc_socket_id, "stream-open-filename")
    end,
    title = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.string(mpv_ipc_socket_id, "media-title")
    end,
    playback_seconds_int = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.int(mpv_ipc_socket_id, "time-pos")
    end,
    duration_seconds_int = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.int(mpv_ipc_socket_id, "duration")
    end,
    playback_percent_int = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.int(mpv_ipc_socket_id, "percent-pos")
    end,
    chapter_int = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.int(mpv_ipc_socket_id, "chapter")
    end,
    playback_string = function(mpv_ipc_socket_id)
      return string.format(
        "(%i/%is - %s%%)",
        get.mpv_ipc_socket_id.play_time_seconds_int(mpv_ipc_socket_id) or -1,
        get.mpv_ipc_socket_id.duration_seconds_int(mpv_ipc_socket_id) or -1,
        get.mpv_ipc_socket_id.playback_percent_int(mpv_ipc_socket_id) or -1
      )
    end,
    playlist_index_int = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.int(mpv_ipc_socket_id, "playlist-pos")
    end,
    playlist_length_int = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.int(mpv_ipc_socket_id, "playlist-count")
    end,
    playlist_progress_string = function(mpv_ipc_socket_id)
      return string.format(
        "[%i/%i]",
        get.mpv_ipc_socket_id.playlist_position_int(mpv_ipc_socket_id) or -1,
        get.mpv_ipc_socket_id.playlist_length_int(mpv_ipc_socket_id) or -1
      )
    end,
    summary_line_basics = function(mpv_ipc_socket_id)
      return string.format(
        "%s %s %s",
        transf.mpv_ipc_socket_id.playback_string(mpv_ipc_socket_id),
        transf.mpv_ipc_socket_id.playlist_progress_string(mpv_ipc_socket_id),
        get.mpv_ipc_socket_id.title(mpv_ipc_socket_id) or "<no title>"
      )
    end,
    summary_line_emoji = function(mpv_ipc_socket_id)
      return get.string_or_number_array.string_by_joined(
        hs.fnutils.imap(
          {"pause", "loop", "shuffle", "video"},
          get.fn.first_n_args_bound_fn(get.mpv_ipc_socket_id.boolean_emoji, mpv_ipc_socket_id)
        ),
        ""
      )
    end,
    summary_line = function(mpv_ipc_socket_id)
      return string.format(
        "%s %s",
        transf.mpv_ipc_socket_id.summary_line_emoji(mpv_ipc_socket_id),
        transf.mpv_ipc_socket_id.summary_line_basics(mpv_ipc_socket_id)
      )
    end,
    is_running = function(mpv_ipc_socket_id)
      return transf.any.boolean(
        get.mpv_ipc_socket_id.string(mpv_ipc_socket_id, "pause")
      )
    end,
        
  },
  stream_creation_specifier = {
    flag_dict_by_with_default = function(stream_creation_specifier)
      return transf.two_tables.table_by_take_new(
        tblmap.stream_creation_specifier_flag_profile_name.stream_creation_specifier_flag_profile[stream_creation_specifier.flag_profile_name or "foreground"],
        stream_creation_specifier.flags 
      )
    end,
    flags_string = function(stream_creation_specifier)
      return transf.string_boolean_dict.truthy_long_flag_string(get.stream_creation_specifier.flags_with_default(stream_creation_specifier))
    end,
    source_path = function(stream_created_item_specifier)
      return stream_created_item_specifier.source_path
    end,
  },
  stream_created_item_specifier = {
    stream_state = function(stream_created_item_specifier)
      return stream_created_item_specifier.inner_item.state
    end,
    transitioned_stream_state = function(stream_created_item_specifier)
      return tblmap.state_type.state_transition_table.stream_state[transf.stream_created_item_specifier.stream_state(stream_created_item_specifier)][is.stream_created_item_specifier.alive(stream_created_item_specifier)]
    end,
    is_valid = function(stream_created_item_specifier)
      return stream_created_item_specifier.inner_item.state ~= "ended"
    end,
    source_path = function(stream_created_item_specifier)
      return transf.stream_creation_specifier.source_path(stream_created_item_specifier.creation_specifier)
    end,
    summary_line = function(stream_created_item_specifier)
      return transf.mpv_ipc_socket_id.summary_line(stream_created_item_specifier.mpv_ipc_socket_id)
    end,
    title = function(stream_created_item_specifier)
      return get.mpv_ipc_socket_id.title(stream_created_item_specifier.mpv_ipc_socket_id)
    end,
    current_url = function(stream_created_item_specifier)
      return get.mpv_ipc_socket_id.current_url(stream_created_item_specifier.mpv_ipc_socket_id)
    end,
    creation_urls = function(stream_created_item_specifier)
      return stream_created_item_specifier.creation_specifier.urls
    end,
    is_running = function(stream_created_item_specifier)
      return transf.mpv_ipc_socket_id.is_running(stream_created_item_specifier.mpv_ipc_socket_id)
    end,

  },
  hotkey_created_item_specifier = {
    hshotkey = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.inner_item
    end,
    explanation = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.explanation
    end,
    mnemonic = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.mnemonic
    end,
    mnemonic_string = function(hotkey_created_item_specifier)
      return transf.hotkey_created_item_specifier.mnemonic(hotkey_created_item_specifier) and string.format("[%s] ", transf.hotkey_created_item_specifier.mnemonic(hotkey_created_item_specifier)) or ""
    end,
    shortcut_specifier = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.shortcut_specifier
    end,
    shortcut_string = function(hotkey_created_item_specifier)
      return transf.shortcut_specifier.shortcut_string(transf.hotkey_created_item_specifier.shortcut_specifier(hotkey_created_item_specifier))
    end,
    mod_array = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.shortcut_specifier.mod_array
    end,
    key = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.shortcut_specifier.key
    end,
    fn = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.fn
    end,
    summary = function(hotkey_created_item_specifier)
      return string.format(
        "%s%s: %s",
        transf.hotkey_created_item_specifier.shortcut_string(hotkey_created_item_specifier),
        transf.hotkey_created_item_specifier.mnemonic_string(hotkey_created_item_specifier),
        transf.hotkey_created_item_specifier.explanation(hotkey_created_item_specifier)
      )
    end,

  },
  watcher_created_item_specifier = {
    fn = function(watcher_created_item_specifier)
      return watcher_created_item_specifier.creation_specifier.fn
    end,
    watcher_type = function(watcher_created_item_specifier)
      return watcher_created_item_specifier.creation_specifier.watcher_type
    end,
    hswatcher = function(watcher_created_item_specifier)
      return watcher_created_item_specifier.inner_item
    end,
    running = function(watcher_created_item_specifier)
      return watcher_created_item_specifier.inner_item:running()
    end,
  },
  watcher_creation_specifier = {
    watcher_type = function(watcher_creation_specifier)
      return watcher_creation_specifier.watcher_type
    end,
    hswatcher_creation_fn = function(watcher_creation_specifier)
      return hs[
        transf.watcher_creation_specifier.watcher_type(watcher_creation_specifier)
      ].watcher.new
    end,
  },
  creation_specifier = {
    creation_specifier_type = function(spec)
      return spec.type
    end,
  },
  created_item_specifier = {
    creation_specifier = function(created_item_specifier)
      return created_item_specifier.creation_specifier
    end,
    inner_item = function(created_item_specifier)
      return created_item_specifier.inner_item
    end,
    creation_specifier_type = function(created_item_specifier)
      return transf.creation_specifier.creation_specifier_type(created_item_specifier.creation_specifier)
    end,
  },
  created_item_specifier_array = {
    
  },
  stream_created_item_specifier_array = {
    first_running = function(stream_created_item_specifier_array)
      return hs.fnutils.find(
        stream_created_item_specifier_array,
        transf.stream_created_item_specifier.is_running
      )
    end,
  },
  two_sets = {
    union_set = function(set1, set2)
      return transf.two_arrays.set_by_union(set1, set2)
    end,
    intersection_set = function(set1, set2)
      return transf.two_arrays.set_by_intersection(set1, set2)
    end,
    is_subset = function(set1, set2)
      for _, v in transf.array.index_value_stateless_iter(set1) do
        if not get.array.bool_by_contains(set2, v) then
          return false
        end
      end
    end,
    is_superset = function(set1, set2)
      return transf.two_arrays.is_subset(set2, set1)
    end,
    equals = function(set1, set2)
      return transf.two_sets.is_subset(set1, set2) and transf.two_sets.is_superset(set1, set2)
    end,
  },
  cronspec_string = {
    next_timestamp_s_string = function(cronspec_string)
      return transf.string.string_or_nil_by_evaled_env_bash_stripped("ncron" .. transf.string.single_quoted_escaped(cronspec_string))
    end,
    next_timestamp_s = function(cronspec_string)
      return get.string_or_number.number_or_nil(transf.cronspec_string.next_timestamp_s_string(cronspec_string))
    end,
  },
  timer_spec = {
    int_by_interval_left = function(spec)
      return spec.next_timestamp_s - os.time() 
    end,
    bool_by_ready = function(spec)
      return transf.timer_spec.int_by_interval_left(spec) <= 0
    end,
    bool_by_long_timer = function(spec)
      return spec.largest_interval and spec.largest_interval > 60
    end

  },
  start_stop_step_unit = {
    array = function(start, stop, step, unit)
      start = get.any.default_if_nil(start, 1)
    
      local mode
      if type(start) == "number" then
        mode = "number"
      elseif type(start) == "table" then
        if start.adddays then
          mode = "date"
        elseif start.xy then
          mode = "point"
        end
      elseif type(start) == "string" then
        mode = "string"
      end
    
      local addmethod = function(a, b) 
        return a + b 
      end
    
      if mode == "number" then
        stop = get.any.default_if_nil(stop, 10)
        step = get.any.default_if_nil(step, 1)
      elseif mode == "date" then
        if start then start = start:copy() else start = date() end
        if stop then stop = stop:copy() else stop = date():addays(10) end
        step = get.any.default_if_nil(step, 1)
        unit = get.any.default_if_nil(unit, "days")
        addmethod = function(a, b) 
          local a_copy = a:copy()
          return a_copy["add" .. unit](a_copy, b) 
        end
      elseif mode == "point" then
        start = get.any.default_if_nil(start, hs.geometry.point(0, 0))
        stop = get.any.default_if_nil(stop, hs.geometry.point(10, 10))
        step = get.any.default_if_nil(step, hs.geometry.point(1, 1))
      elseif mode == "string" then
        start = get.any.default_if_nil(start, "a")
        stop = get.any.default_if_nil(stop, "z")
        step = get.any.default_if_nil(step, 1)
        addmethod = function(a, b)
          return string.char(string.byte(a) + b)
        end
      end
    
      local range = {}
      local current = start
      while current <= stop do
        table.insert(range, current)
        current = addmethod(current, step)
      end
    
      return range
    end
    
  },
  form_field_specifier = {

  },
  position_change_state_spec = {
    should_continue = function(position_change_state_spec)
      return position_change_state_spec.num_steps > 0
        and (position_change_state_spec.delta_hs_geometry_point.x > 0.1
          or position_change_state_spec.delta_hs_geometry_point.y > 0.1)
    end,
    next_position_change_state_spec = function(position_change_state_spec)
      local next_position_change_state_spec  = {}
      next_position_change_state_spec.num_steps = position_change_state_spec.num_steps - 1
      next_position_change_state_spec.delta_hs_geometry_point = position_change_state_spec.delta_hs_geometry_point * position_change_state_spec.factor_of_deceleration
      next_position_change_state_spec.past_ideal_hs_geometry_point = position_change_state_spec.past_ideal_hs_geometry_point + position_change_state_spec.delta_hs_geometry_point
      local jittered_delta_hs_geometry_point = next_position_change_state_spec.delta_hs_geometry_point * transf.float_interval_specifier.random({
        start = -position_change_state_spec.jitter_factor,
        stop = position_change_state_spec.jitter_factor
      })
      next_position_change_state_spec.current_hs_geometry_point = next_position_change_state_spec.past_ideal_hs_geometry_point * jittered_delta_hs_geometry_point
      next_position_change_state_spec.jitter_factor = position_change_state_spec.jitter_factor
      return next_position_change_state_spec
    end,
  },
  declared_position_change_input_spec = {
    target_hs_geometry_point = function(declared_position_change_input_spec)
      local target_point = declared_position_change_input_spec.target_hs_geometry_point or hs.geometry.point(0, 0)
      if declared_position_change_input_spec.relative_to then
        if declared_position_change_input_spec.relative_to ~= "curpos" then
          local front_window = transf.running_application.main_window(hs.application.frontmostApplication())
          target_point = get.window.hs_geometry_point_with_offset(front_window, declared_position_change_input_spec.relative_to, target_point)
        else
          target_point = target_point + transf[
            declared_position_change_input_spec.mode .. "_input_spec"
          ].starting_hs_geometry_point(declared_position_change_input_spec)
        end
      end
      return target_point
    end,
    jitter_factor = function(declared_position_change_input_spec)
      return declared_position_change_input_spec.jitter_factor or 0.1
    end,
    duration = function(declared_position_change_input_spec)
      return declared_position_change_input_spec.duration or transf.float_interval_specifier.random({start=0.1, stop=0.3})
    end,
    factor_of_deceleration = function(declared_position_change_input_spec)
      return declared_position_change_input_spec.factor_of_deceleration or 0.95
    end,
    starting_position_change_state_spec = function(declared_position_change_input_spec)
      local starting_point = transf[
        declared_position_change_input_spec.mode .. "_input_spec"
      ].starting_hs_geometry_point(declared_position_change_input_spec)
      local total_delta = transf.declared_position_change_input_spec.target_hs_geometry_point(declared_position_change_input_spec) - starting_point
      local starting_position_change_state_spec = {}
      starting_position_change_state_spec.num_steps = math.ceil(
        transf.declared_position_change_input_spec.duration(declared_position_change_input_spec) / refstore.consts.POLLING_INTERVAL
      )

      --- Function that calculates the initial delta value given a certain distance, factor of deceleration and number of steps.
      --- @param distance number: The total distance to travel.
      --- @param factor_of_deceleration number: The deceleration factor to use. If this is >= 1, we'll move linearly.
      --- @param steps number: The number of steps to take in total.
      --- @return number: The starting delta value.
      function getStartingDelta(distance, factor_of_deceleration, steps)
        if factor_of_deceleration >= 1 then -- invalid deceleration factor, would never reach target ≙ we're just going to move linearly
          return distance / steps 
        else 
          return distance * (1 - factor_of_deceleration) / (1 - factor_of_deceleration ^ (steps - 1))
        end
      end

      starting_position_change_state_spec.past_ideal_hs_geometry_point = hs.geometry.new(starting_point)
      starting_position_change_state_spec.delta_hs_geometry_point = hs.geometry.point(
        getStartingDelta(total_delta.x, transf.declared_position_change_input_spec.factor_of_deceleration(declared_position_change_input_spec), starting_position_change_state_spec.num_steps),
        getStartingDelta(total_delta.y, transf.declared_position_change_input_spec.factor_of_deceleration(declared_position_change_input_spec), starting_position_change_state_spec.num_steps)
      )
      starting_position_change_state_spec.jitter_factor = transf.declared_position_change_input_spec.jitter_factor(declared_position_change_input_spec)
      return starting_position_change_state_spec
    end,
  },

  click_input_spec = {
    click_fn = function(spec)
      return hs.eventtap[
        tblmap.mouse_button_string.mouse_button_function_name[spec.mouse_button_string]
      ]
    end,
  },

  -- <input_spec_string> ::= <click_spec_string> | <key_spec_string> | <move_scroll_spec_string>
  -- <click_spec_string> ::= "." <mouse_button>
  -- <mouse_button> ::= "l" | "r" | "m" | ... -- l for left, r for right, m for middle, etc.
  -- <key_spec_string> ::= ":" <keys>
  -- <keys> ::= <key> | <key> "+" <keys>
  -- <key> ::= <any_valid_key_representation>
  -- <move_scroll_spec_string> ::= <mode> <target_point> [<relative_position_spec_string>]
  -- <mode> ::= "m" | "s" -- m for move, s for scroll
  -- <target_point> ::= <coordinate> "," <coordinate>
  -- <coordinate> ::= <number>
  -- <relative_position_spec_string> ::= " " <relative_position>
  -- <relative_position> ::= "tl" | "tr" | "bl" | "br" | "c" | "curpos" -- tl for top-left, tr for top-right, bl for bottom-left, br for bottom-right, c for center, curpos for current position.
  input_spec_string = {
    input_spec = function(str)
      local input_spec = {}
      if stringy.startswith(str, ".") then
        input_spec.mode = "click"
        if #str == 1 then
          input_spec.mouse_button_string = "l"
        else
          input_spec.mouse_button_string = string.sub(str, 2, 2)
        end
      elseif stringy.startswith(str, ":") then
        input_spec.mode = "key"
        local parts = transf.hole_y_arraylike.array(stringy.split(string.sub(str, 2), "+")) -- separating modifier keys with `+`
        if #parts > 1 then
          input_spec.key = dothis.array.pop(parts)
          input_spec.mods = parts
        else
          input_spec.key = parts[1]
        end
      else
        local mode_char, x, y, optional_relative_specifier = onig.match(str, "^(.)"..mt._r.syntax.point.."( %[a-zA-Z]+)?$")
        if not mode_char or not x or not y then
          error("Tried to parse string series_specifier, but it didn't match any known format:\n\n" .. str)
        end
        if mode_char == "m" then
          input_spec.mode = "move"
        elseif mode_char == "s" then
          input_spec.mode = "scroll"
        else
          error("doInput: invalid mode character `" .. mode_char .. "` in series specifier:\n\n" .. str)
        end
        input_spec.target_point = hs.geometry.new({
          x = get.string_or_number.number_or_nil(x),
          y = get.string_or_number.number_or_nil(y)
        })
        if optional_relative_specifier and #optional_relative_specifier > 0 then
          input_spec.relative_to = string.sub(optional_relative_specifier, 3)
        end
      end
      return input_spec
    end
  },
  input_spec_series_string = {
    input_spec_string_array = function(str)
      return transf.hole_y_arraylike.array(get.string.string_array_split_single_char_stripped(str, "\n"))
    end,
    input_spec_array = function(str)
      return hs.fnutils.imap(
        transf.input_spec_series_string.input_spec_string_array(str),
        transf.input_spec_string.input_spec
      )
    end,
  },
  prompt_args_string = {
    --- @class prompt_args
    --- @field message? any Message to display in the prompt.
    --- @field default? any Default value for the prompt.

    --- @class prompt_args_string : prompt_args
    --- @field informative_text? any Additional text to display in the prompt.
    --- @field buttonA? any Label for the first button.
    --- @field buttonB? any Label for the second button.

    --- @param prompt_args? prompt_args_string
    --- @return (string|nil), boolean
    string_or_nil_and_boolean = function(prompt_args)

      -- set up default values, make sure provided values are strings

      prompt_args = prompt_args or {}
      prompt_args.message = transf.not_nil.string(prompt_args.message) or "Enter a string."
      prompt_args.informative_text = transf.not_nil.string(prompt_args.informative_text) or ""
      prompt_args.default = transf.not_nil.string(prompt_args.default) or ""
      prompt_args.buttonA = transf.not_nil.string(prompt_args.buttonA) or "OK"
      prompt_args.buttonB = transf.not_nil.string(prompt_args.buttonB) or "Cancel"

      -- show prompt

      dothis.mac_application_name.activate("Hammerspoon")
      --- @type string, string|nil
      local button_pressed, raw_return = hs.dialog.textPrompt(prompt_args.message, prompt_args.informative_text, prompt_args.default,
      prompt_args.buttonA, prompt_args.buttonB)

      -- process result

      local ok_button_pressed = button_pressed == prompt_args.buttonA

      if stringy.startswith(raw_return, " ") then -- space triggers lua eval mode
        raw_return = get.string.evaled_as_lua(raw_return)
      end
      if raw_return == "" then
        raw_return = nil
      end

      -- return result

      return raw_return, ok_button_pressed
    end

  },
  prompt_args_path = {

    --- @class prompt_args_path
    --- @field can_choose_files? boolean 
    --- @field can_choose_directories? boolean
    --- @field multiple? boolean
    --- @field allowed_file_types? string[]
    --- @field resolves_aliases? boolean

    --- @param prompt_args prompt_args_path
    --- @return (string|string[]|nil), boolean
    local_absolute_path_or_local_absolute_path_array_and_boolean = function(prompt_args)

      -- set up default values, make sure message and default are strings
  
      prompt_args                        = prompt_args or {}
      prompt_args.message                = get.any.default_if_nil(transf.not_nil.string(prompt_args.message), "Choose a file or folder.")
      prompt_args.default                = get.any.default_if_nil(transf.not_nil.string(prompt_args.default), env.HOME)
      prompt_args.can_choose_files       = get.any.default_if_nil(prompt_args.can_choose_files, true)
      prompt_args.can_choose_directories = get.any.default_if_nil(prompt_args.can_choose_directories, true)
      prompt_args.multiple  = get.any.default_if_nil(prompt_args.multiple, false)
      prompt_args.allowed_file_types     = get.any.default_if_nil(prompt_args.allowed_file_types, {})
      prompt_args.resolves_aliases       = get.any.default_if_nil(prompt_args.resolves_aliases, true)
    
      prompt_args.default = hs.fs.pathToAbsolute(prompt_args.default, true) -- resolve the path ourself, to be sure & remain in control
    
      -- show prompt
    
      local raw_return                    = hs.dialog.chooseFileOrFolder(prompt_args.message, prompt_args.default, prompt_args.can_choose_files, prompt_args.can_choose_directories, prompt_args.multiple, prompt_args.allowed_file_types, prompt_args.resolves_aliases)
    
      -- process result
    
      if raw_return == nil then
        return nil, false
      end
      local list_return = transf.table_or_nil.vt_array(raw_return)
      if #list_return == 0 then
        return nil, true
      end
    
      -- return result
    
      if prompt_args.multiple then
        return list_return, true
      else
        return list_return[1], true
      end
    end,
    local_absolute_path_and_boolean = function(prompt_args)
      prompt_args.multiple = false
      return transf.prompt_args_path.local_absolute_path_or_local_absolute_path_array_and_boolean(prompt_args)
    end,
    local_absolute_path_array_and_boolean = function(prompt_args)
      prompt_args.multiple = true
      return transf.prompt_args_path.local_absolute_path_or_local_absolute_path_array_and_boolean(prompt_args)
    end,
  
  },
  prompt_spec = {

    --- @alias failure_action "error" | "return_nil" | "reprompt"

    --- @class prompt_spec
    --- @field prompter? fun(prompt_args: table): any, boolean The function that implements prompting. Must return nil on the equivalent of an empty value.
    --- @field prompt_args? table Arguments to pass to `prompter`.
    --- @field transformer? fun(rawReturn: any): any transforms the raw return value into the transformed return value. Default is the identity function.
    --- @field raw_validator? fun(rawReturn: any): boolean validates before application of `transformer`. Default is ensuring the return value is not nil.
    --- @field transformed_validator? fun(transformedReturn: any): boolean validates after application of `transformer`. Default is ensuring the return value is not nil.
    --- @field on_cancel? failure_action What to do if the user cancels the prompt. May error, return nil, or reprompt. Default is "error".
    --- @field on_raw_invalid? failure_action What to do if the raw return value is invalid. May error, return nil, or reprompt. Default is "return_nil".
    --- @field on_transformed_invalid? failure_action What to do if the transformed return value is invalid. May error, return nil, or reprompt. Default is "reprompt".

    --- Main function to handle prompts. Uses a given prompt_spec or defaults.
    --- With the default prompt_spec, we will error if cancelled, return nil if the raw return value is the equivalent of an empty value, and never reprompt.
    --- @param prompt_spec prompt_spec
    --- @return any -- Returns the user's input as processed according to the prompt_spec, or the appropriate error or nil value.
    any = function(prompt_spec)

      -- set defaults for all prompt_spec fields
      prompt_spec = get.table.table_by_copy(prompt_spec)
      prompt_spec.prompter = prompt_spec.prompter or transf.prompt_args_string.string_or_nil_and_boolean
      prompt_spec.transformer = prompt_spec.transformer or function(x) return x end
      prompt_spec.raw_validator = prompt_spec.raw_validator or function(x) return x ~= nil end
      prompt_spec.transformed_validator = prompt_spec.transformed_validator or function(x) return x ~= nil end
      prompt_spec.on_cancel = prompt_spec.on_cancel or "error"
      prompt_spec.on_raw_invalid = prompt_spec.on_raw_invalid or "return_nil"
      prompt_spec.on_transformed_invalid = prompt_spec.on_transformed_invalid or "reprompt"
      prompt_spec.prompt_args = prompt_spec.prompt_args or {}
      prompt_spec.prompt_args.message = prompt_spec.prompt_args.message or "Enter a value."

      -- generate some informative text mainly used when prompter is promptStringInner, though other prompters can consume this too
      local validation_extra
      local original_informative_text = prompt_spec.prompt_args.informative_text
      local info_on_reactions = "c: " ..
        prompt_spec.on_cancel ..
        ", r_i: " ..
        prompt_spec.on_raw_invalid .. 
        ", t_i: " .. 
        prompt_spec.on_transformed_invalid
      local static_informative_text 
      if original_informative_text then
        static_informative_text = original_informative_text .. "\n" .. info_on_reactions
      else
        static_informative_text = info_on_reactions
      end

      -- main loop to allow reprompting when prompt_spec conditions for reprompting are met
      while true do

        -- add information on why the prompter is being called to the informative text, if it exists
        if validation_extra then
          prompt_spec.prompt_args.informative_text = static_informative_text .. "\n" .. validation_extra
        else
          prompt_spec.prompt_args.informative_text = static_informative_text
        end

        -- call the prompter
        local raw_return, ok_button_pressed = prompt_spec.prompter(prompt_spec.prompt_args)

        if ok_button_pressed then -- not cancelled
          if prompt_spec.raw_validator(raw_return) then -- raw input was valid
            local transformed_return = prompt_spec.transformer(raw_return)
            if prompt_spec.transformed_validator(transformed_return) then -- transformed input was valid
              return transformed_return
            else -- transformed input was invalid, handle according to prompt_spec.on_transformed_invalid
              if prompt_spec.on_transformed_invalid == "error" then
                error("WARN: User input was invalid (after transformation).", 0)
              elseif prompt_spec.on_transformed_invalid == "return_nil" then
                return nil
              elseif prompt_spec.on_transformed_invalid == "reprompt" then
                local has_string_eqviv, string_eqviv = pcall(tostring, raw_return)
                local transformed_has_string_eqviv, transformed_string_eqviv = pcall(tostring, transformed_return)
                validation_extra =
                    "Invalid input:\n" ..
                    "  Original: " .. (has_string_eqviv and string_eqviv or "<not tostringable>") .. "\n" ..
                    "  Transformed: " .. (transformed_has_string_eqviv and transformed_string_eqviv or "<not tostringable>")
              end
            end
          else -- raw input was invalid, handle according to prompt_spec.on_raw_invalid
            if prompt_spec.on_raw_invalid == "error" then
              error("WARN: User input was invalid (before transformation).", 0)
            elseif prompt_spec.on_raw_invalid == "return_nil" then
              return nil
            elseif prompt_spec.on_raw_invalid == "reprompt" then
              local has_string_eqviv, string_eqviv = pcall(tostring, raw_return)
              validation_extra = "Invalid input: " .. (has_string_eqviv and string_eqviv or "<not tostringable>")
            end
          end
        else -- cancelled, handle according to prompt_spec.on_cancel
          if prompt_spec.on_cancel == "error" then
            error("WARN: User cancelled modal.", 0)
          elseif prompt_spec.on_cancel == "return_nil" then
            return nil
          end
        end
      end
    end,
    any_array = function(prompt_spec)
      local res = {}
      prompt_spec.prompt_args = prompt_spec.prompt_args or {}
      prompt_spec.prompt_args.message = prompt_spec.prompt_args.message or "Enter a value."
      prompt_spec.prompt_args.message = prompt_spec.prompt_args.message .. " Enter an empty value to stop."
      while true do
        local x = transf.prompt_spec.any(prompt_spec)
        if x == nil then
          return res
        else
          dothis.array.push(res, x)
        end
      end
      return res
    end,
  },
  role_content_message_spec = {

  },
  role_content_message_spec_array = {
    api_role_content_message_spec_array = function(arr)
      return transf.any_and_array.array({
        role = "system",
        content = "You are a helpful assistant being queried through an API. Your output will be parsed, so adhere to any instructions given as to the format or content of the output. Only output the result."
      }, arr)
    end,
  },
  --- like a role_content_message_spec_array, but alternating user/assistant role_content_message_specs, where a pair of user/assistant role_content_message_specs is a shot
  n_shot_role_content_message_spec_array = {

  },
  n_shot_llm_spec = {
    n_shot_api_query_role_content_message_spec_array = function(spec)
      return transf.role_content_message_spec_array.api_role_content_message_spec_array(
        transf.array_of_arrays.array_by_flatten(
          {
            {
              role = "user",
              content = spec.query
            }, {
              role = "user",
              content = "If the input is already valid, echo the input."
            }, {
              role = "user",
              content = "If you are unable to fulfill the request, return 'IMPOSSIBLE'."
            }
          },
          transf.string_pair_array.n_shot_role_content_message_spec_array(spec.shots), 
          {
            {
              role = "user",
              content = spec.input
            }
          }
        )
      )
    end,
  },
  fn = {
    rt_or_nil_fn_by_pcall = function(fn)
      return function(...)
        local succ, res = pcall(fn, ...)
        if succ then
          return res
        else
          return nil
        end
      end
    end,
    bool_ret_fn_by_pcall = function(fn)
      return function(...)
        local succ, res = pcall(fn, ...)
        return succ
      end
    end,
  },
  fn_queue_specifier = {
    string_by_waiting_message  = function(qspec)
      return "Waiting to proceed (" .. #qspec.fn_array .. " waiting in queue) ... (Press " .. transf.hotkey_created_item_specifier.shortcut_string(qspec.hotkey_created_item_specifier) .. " to continue.)"
    end,
      
  },
  n_anys_or_err_ret_fn = {
    n_anys_or_nil_ret_fn_by_pcall = function(fn)
      return function(...)
        local rets = {pcall(fn, ...)}
        local succ = dothis.array.shift(rets)
        if succ then
          return table.unpack(rets)
        else
          return nil
        end
      end
    end,
  },
  n_anys_or_nil_ret_fn = {
    n_anys_or_err_ret_fn_by_pcall = function(fn)
      return function(...)
        local rets = {fn(...)}
        if rets[1] == nil then
          return error("Function returned nil.")
        else
          return table.unpack(rets)
        end
      end
    end,
  },
  number_and_two_anys ={
    any_or_any_and_number_by_zero = function(num, a1, a2)
      if num == 0 then
        return a1
      else
        return a2, num
      end
    end,
  },
  string_and_number_or_nil = {
    string_or_nil_by_number = function(str, num)
      if num then
        return nil
      else
        return str
      end
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
        elseif opts.stringify_table_params and type(param) == "table" then
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
  fnname = {
    local_absolute_path_by_in_cache = function(fnname)
      return transf.string.in_cache_dir(fnname, "fsmemoize")
    end,
    rt_by_memo = function(fnid, opts_as_str, params, opts)
      local cache_path = get.fnname.local_absolute_path_by_in_cache_w_string_and_array_or_nil(fnid, opts_as_str, params)
      local raw_cnt = transf.file.contents(cache_path)
      if not raw_cnt then return nil end
      return json.decode(raw_cnt)
    end,
    timestamp_s_by_created_time = function(fnid, opts_as_str)
      local cache_path = get.fnname.local_absolute_path_by_in_cache_w_string_and_array_or_nil(fnid, opts_as_str, "~~~created~~~") -- this is a special path that is used to store the time the cache was created
      return get.string_or_number.number_or_nil(transf.file.contents(cache_path)) or os.time() -- if the file doesn't exist, return the current time
    end,
    
  }
  
}

transf.any.pos_int_by_unique_id_primitives_equal = transf["nil"].any_arg_pos_int_ret_fn_by_unique_id_primitives_equal()
transf.fn.fnid = transf["nil"].any_arg_pos_int_ret_fn_by_unique_id_primitives_equal() -- functionally the same, but I'll limit it to functions 'by hand'