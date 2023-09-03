--- maps one thing_name to another thing_name
--- so transf.<thing_name1>.<thing_name2>(<thing1>) -> <thing2>
transf = {
  nonindicated_number_str_arr = {
    number_arr_by_base_2 = function(hex_arr)
      return get.nonindicated_number_str_arr.number_arr(hex_arr, 2)
    end,
    number_arr_by_base_8 = function(hex_arr)
      return get.nonindicated_number_str_arr.number_arr(hex_arr, 8)
    end,
    number_arr_by_base_10 = function(hex_arr)
      return get.nonindicated_number_str_arr.number_arr(hex_arr, 10)
    end,
    number_arr_by_base_16 = function(hex_arr)
      return get.nonindicated_number_str_arr.number_arr(hex_arr, 16)
    end,
  },
  nonindicated_number_str = {
    number_by_base_2 = function(num)
      return get.nonindicated_number_str.number_or_nil(num, 2)
    end,
    number_by_base_8 = function(num)
      return get.nonindicated_number_str.number_or_nil(num, 8)
    end,
    number_by_base_10 = function(num)
      return get.nonindicated_number_str.number_or_nil(num, 10)
    end,
    number_by_base_16 = function(num)
      return get.nonindicated_number_str.number_or_nil(num, 16)
    end,
  },
  indicated_number_str = {
    nonindicated_number_str = function(indicated_number)
      return indicated_number:sub(3)
    end,
    base_letter = function(indicated_number)
      return indicated_number:sub(2, 2)
    end,
    pos_int_by_base = function(indicated_number)
      return tblmap.base_letter.pos_int_by_base[
        transf.indicated_number_str.base_letter(indicated_number)
        ]
    end,
    number = function(indicated_number)
      return get.nonindicated_number_str.number_or_nil(
        indicated_number:sub(3),
        transf.indicated_number_str.pos_int_by_base(indicated_number)
      )
    end,
  },
  percent_encoded_octet = {
    ascii_char = function(percent)
      local num = percent:sub(2, 3)
      return transf.eight_bit_pos_int.ascii_char(get.str_or_number.number_or_nil(num, 16))
    end,
  },
  unicode_codepoint_str = { -- U+X...`
    number = function(codepoint)
      return get.nonindicated_number_str.number_or_nil(transf.unicode_codepoint_str.nonindicated_hex_number_str(codepoint), 16)
    end,
    nonindicated_hex_number_str = function(codepoint)
      return codepoint:sub(3)
    end,
    unicode_prop_table = function(codepoint)
      return get.fn.rt_or_nil_by_memoized(transf.str.not_userdata_or_function_or_err_by_evaled_env_bash_parsed_json)(
        "uni print -compact -format=all -as=json" 
        .. transf.str.str_by_single_quoted_escaped(
          codepoint
        )
      )[1]
    end
  },
  indicated_utf8_hex_str = {
    unicode_prop_table = function(str)
      return get.fn.rt_or_nil_by_memoized(transf.str.not_userdata_or_function_or_err_by_evaled_env_bash_parsed_json)(
        "uni print -compact -format=all -as=json" 
        .. transf.str.str_by_single_quoted_escaped(
          str
        )
      )[1]
    end
  },
  unicode_prop_table = {
    nonindicated_bin_number_str = function(unicode_prop_table)
      return unicode_prop_table.bin
    end,
    unicode_block_name = function(unicode_prop_table)
      return unicode_prop_table.block
    end,
    unicode_category_name = function(unicode_prop_table)
      return unicode_prop_table.cat
    end,
    utf8_char = function(unicode_prop_table)
      return unicode_prop_table.char
    end,
    unicode_codepoint = function(unicode_prop_table)
      return unicode_prop_table.cpoint
    end,
    unicode_codepoint_dec_str = function(unicode_prop_table)
      return unicode_prop_table.dec
    end,
    unicode_codepoint_hex_str = function(unicode_prop_table)
      return unicode_prop_table.hex
    end,
    unicode_codepoint_oct_str = function(unicode_prop_table)
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
    utf8_hex_str = function(unicode_prop_table)
      return transf.str.not_whitespace_str(unicode_prop_table.utf8)
    end,
    summary = function(unicode_prop_table)
      return transf.unicode_prop_table.utf8_char(unicode_prop_table) .. ": "
        .. transf.unicode_prop_table.unicode_codepoint(unicode_prop_table) .. " "
        .. transf.unicode_prop_table.unicode_character_name(unicode_prop_table)
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
    
    nonindicated_dec_number_str = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.nonindicated_dec_number_str(transf.number.pos_number(num))
    end,
    separated_nonindicated_dec_number_str = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.separated_nonindicated_dec_number_str(transf.number.pos_number(num))
    end,
    indicated_dec_number_str = function(num)
      return transf.number.sign_indicator(num) .. "0d" .. transf.pos_number.nonindicated_dec_number_str(transf.number.pos_number(num))
    end,
    nonindicated_hex_number_str = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.nonindicated_hex_number_str(transf.number.pos_number(num))
    end,
    separated_nonindicated_hex_number_str = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.separated_nonindicated_hex_number_str(transf.number.pos_number(num))
    end,
    indicated_hex_number_str = function(num)
      return transf.number.sign_indicator(num) .. "0x" .. transf.pos_number.nonindicated_hex_number_str(transf.number.pos_number(num))
    end,
    byte_hex_number_str_arr = function(num)
      return  get.str.str_arr_groups_ascii_from_end(
        transf.number.nonindicated_hex_number_str(num),
        2
      )
    end,
    two_byte_hex_number_str_arr = function(num)
      return  get.str.str_arr_groups_ascii_from_end(
        transf.number.nonindicated_hex_number_str(num),
        4
      )
    end,
    
    noninciated_oct_number_str = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.noninciated_oct_number_str(transf.number.pos_number(num))
    end,

    separated_nonindicated_oct_number_str = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.separated_nonindicated_oct_number_str(transf.number.pos_number(num))
    end,
    indicated_oct_number_str = function(num)
      return transf.number.sign_indicator(num) .. "0o" .. transf.pos_number.noninciated_oct_number_str(transf.number.pos_number(num))
    end,

    nonindicated_bin_number_str = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.nonindicated_bin_number_str(transf.number.pos_number(num))
    end,
    separated_nonindicated_bin_number_str = function(num)
      return transf.number.sign_indicator(num) .. transf.pos_number.separated_nonindicated_bin_number_str(transf.number.pos_number(num))
    end,
    indicated_bin_number_str = function(num)
      return transf.number.sign_indicator(num) .. "0b" .. transf.pos_number.nonindicated_bin_number_str(transf.number.pos_number(num))
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
      return transf.nonindicated_number_str.number_by_base_10(
        transf.any.str(
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
    nonindicated_dec_number_str = function(num)
      return 
        transf.pos_int.nonindicated_dec_number_str(
          transf.number.pos_int_part(num)
        ) .. 
        (
          transf.number.pos_float_part(num) == 0 and "" or 
          (
            "." .. transf.pos_int.nonindicated_dec_number_str(
              transf.number.pos_int_float_part(num)
            )
          )
        )
      end,
    separated_nonindicated_dec_number_str = function(num)
      return 
        transf.pos_int.separated_nonindicated_dec_number_str(
          transf.number.pos_int_part(num)
        ) .. 
        (
          transf.number.pos_float_part(num) == 0 and "" or 
          (
            "." .. transf.pos_int.separated_nonindicated_dec_number_str(
              transf.number.pos_int_float_part(num)
            )
          )
        )
      end,
    nonindicated_hex_number_str = function(num)
      return transf.pos_int.nonindicated_hex_number_str(
        transf.number.pos_int_part(num)
      ) .. 
      (
        transf.number.pos_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.nonindicated_hex_number_str(
            transf.number.pos_int_float_part(num)
          )
        )
      )
    end,
    separated_nonindicated_hex_number_str = function(num)
      return transf.pos_int.separated_nonindicated_hex_number_str(
        transf.number.pos_int_part(num)
      ) .. 
      (
        transf.number.pos_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.separated_nonindicated_hex_number_str(
            transf.number.pos_int_float_part(num)
          )
        )
      )
    end,
    noninciated_oct_number_str = function(num)
      return transf.pos_int.noninciated_oct_number_str(
        transf.number.pos_int_part(num)
      ) .. 
      (
        transf.number.pos_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.noninciated_oct_number_str(
            transf.number.pos_int_float_part(num)
          )
        )
      )
    end,
    separated_nonindicated_oct_number_str = function(num)
      return transf.pos_int.separated_nonindicated_oct_number_str(
        transf.number.pos_int_part(num)
      ) .. 
      (
        transf.number.pos_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.separated_nonindicated_oct_number_str(
            transf.number.pos_int_float_part(num)
          )
        )
      )
    end,
    nonindicated_bin_number_str = function(num)
      return transf.pos_int.nonindicated_bin_number_str(
        transf.number.pos_int_part(num)
      ) .. 
      (
        transf.number.pos_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.nonindicated_bin_number_str(
            transf.number.pos_int_float_part(num)
          )
        )
      )
    end,
    separated_nonindicated_bin_number_str = function(num)
      return transf.pos_int.separated_nonindicated_bin_number_str(
        transf.number.pos_int_part(num)
      ) .. 
      (
        transf.number.pos_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.separated_nonindicated_bin_number_str(
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
      return #transf.any.str(int)
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
        transf.pos_int.int_by_smallest_of_length(int),
        transf.pos_int.int_by_largest_of_length(int)
      )
    end,
  },
  pos_int = {
    random_base64_gen_str_of_length = function(int)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("openssl rand -base64 " .. transf.any.str(transf.number.int_by_rounded(int * 3/4))) -- 3/4 because base64 takes the int to be the input length, but we want to specify the output length (which is 4/3 the input length in case of base64)
    end,
    nonindicated_dec_number_str = function(num)
      return transf.any.str(num)
    end,
    separated_nonindicated_dec_number_str = function(num)
      return get.str.str_with_separator_grouped_ascii_from_end(
        transf.pos_int.nonindicated_dec_number_str(num),
        3,
        " "
      )
    end,
    nonindicated_hex_number_str = function(num)
      return get.str.str_by_formatted_w_n_anys("%X", num)
    end,
    separated_nonindicated_hex_number_str = function(num)
      return get.str.str_with_separator_grouped_ascii_from_end(
        transf.pos_int.nonindicated_hex_number_str(num),
        2,
        " "
      )
    end,
    noninciated_oct_number_str = function(num)
      return get.str.str_by_formatted_w_n_anys("%o", num)
    end,
    separated_nonindicated_oct_number_str = function(num)
      return get.str.str_with_separator_grouped_ascii_from_end(
        transf.pos_int.noninciated_oct_number_str(num),
        3,
        " "
      )
    end,
    nonindicated_bin_number_str = function(num)
      return get.str.str_by_formatted_w_n_anys("%b", num)
    end,
    separated_nonindicated_bin_number_str = function(num)
      return get.str.str_with_separator_grouped_ascii_from_end(
        transf.pos_int.nonindicated_bin_number_str(num),
        4,
        " "
      )
    end,
    indicated_utf8_hex_str = function(int)
      return "utf8:" .. transf.pos_int.nonindicated_hex_number_str(int)
    end,
    int_by_largest_of_length = function(int)
      return 10^int - 1
    end,
    int_by_smallest_of_length = function(int)
      return (transf.pos_int.int_by_largest_of_length(int)+1) / 10
    end,
    int_by_center_of_length = function(int)
      return (transf.pos_int.int_by_largest_of_length(int)+1) / 2
    end,
    unicode_codepoint_str = function(num)
      return "U+" .. transf.pos_int.nonindicated_hex_number_str(num)
    end,
    unicode_prop_table_from_unicde_codepoint = function(num)
      return transf.unicode_codepoint_str.unicode_prop_table(transf.pos_int.unicode_codepoint_str(num))
    end,
    unicode_prop_table_from_utf8 = function(num)
      return  transf.indicated_utf8_hex_str.unicode_prop_table(transf.pos_int.indicated_utf8_hex_str(num))
    end,
    gelbooru_post_url = function(pos_int)
      return "https://gelbooru.com/index.php?page=post&s=view&id=" .. pos_int
    end,
    danbooru_post_url = function(pos_int)
      return "https://danbooru.donmai.us/posts/" .. pos_int
    end,
  },
  eight_bit_pos_int = {
    ascii_char = str.char,
  },
  pos_int_arr = {
    unicode_codepoint_str_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.pos_int.unicode_codepoint_str
      )
    end,
    ascii_char_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.pos_int.ascii_char
      )
    end,
    str_from_ascii_char_arr = function(arr)
      return get.str_or_number_arr.str_by_joined(
        transf.pos_int.ascii_char_arr(arr)
      )
    end,
    unicode_prop_table_arr_from_unicode_codepoint_arr = function(arr)
      return get.fn.rt_or_nil_by_memoized(transf.str.table_or_err_by_evaled_env_bash_parsed_json)(
        "uni print -compact -format=all -as=json" 
        .. transf.str.str_by_single_quoted_escaped(
          get.str_or_number_arr.str_by_joined(
            transf.pos_int.unicode_codepoint_str_arr(arr),
            " "
          )
        )
      )
    end,
    indicated_utf8_hex_str_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.pos_int.indicated_utf8_hex_str
      )
    end,
    unicode_prop_table_arr_from_utf8_arr = function(arr)
      return get.fn.rt_or_nil_by_memoized(transf.str.table_or_err_by_evaled_env_bash_parsed_json)(
        "uni print -compact -format=all -as=json" 
        .. transf.str.str_by_single_quoted_escaped(
          get.str_or_number_arr.str_by_joined(
            transf.pos_int.indicated_utf8_hex_str_arr(arr),
            " "
          )
        )
      )
    end,
  },
  not_nil = {
    str = function(arg)
      if arg == nil then
        return nil
      else
        return transf.any.str_by_replicable(arg)
      end
    end,
  },
  arr = {
    arr_by_reversed = function(arr)
      local res = {}
      for i = #arr, 1, -1 do
        dothis.arr.push(res, arr[i])
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
    t_and_arr_by_first_rest = function(arr)
      return arr[1], get.arr.arr_by_slice_w_3_pos_int_any_or_nils(arr, 2)
    end,
    arr_by_nofirst = function(arr)
      return get.arr.arr_by_slice_w_3_pos_int_any_or_nils(arr, 2)
    end,
    arr_by_nolast = function(arr)
      return get.arr.arr_by_slice_w_3_pos_int_any_or_nils(arr, 1, -2)
    end,
    empty_str_value_assoc = function(arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        arr,
        transf.any.self_and_empty_str
      )
    end,
    str_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.any.str_by_replicable
      )
    end,
    contents_summary = function(arr)
      return transf.str_arr.contents_summary(
        transf.arr.str_arr(arr)
      )
    end,
    summary = function(arr)
      return "arr ("..#arr.."):" .. transf.arr.contents_summary(arr)
    end,
    multiline_str = function(arr)
      return transf.str_arr.multiline_str(transf.arr.str_arr(arr))
    end,
    
    index_value_stateless_iter = ipairs,
    index_vt_stateful_iter = get.stateless_generator.stateful_generator(transf.arr.index_value_stateless_iter),
    index_stateful_iter = get.stateless_generator.stateful_generator(transf.arr.index_value_stateless_iter, 1, 1),
    value_bool_assoc = function(arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(arr, function(v) return v, true end)
    end,
    set = function(arr)
      return transf.table_or_nil.kt_arr(
        transf.arr.value_bool_assoc(arr)
      )
    end,
    permutation_arr = function(arr)
      if #arr == 0 then
        return {{}}
      else
        return get.any_stateful_generator.arr(combine.permute, arr)
      end
    end,
    powerset = function(arr)
      if #arr == 0 then
        return {{}}
      else
        local output = transf.arr_and_any.arr( get.any_stateful_generator.arr(combine.powerset, arr), {} )
        return output
      end
    end,
    n_anys = table.unpack,
    initial_selected_index = function(arr)
      return get.thing_name_arr.initial_selected_index(
        transf.any.applicable_thing_name_arr(arr)
      ) or 1 
    end,
  },
  hole_y_arrlike = {
    arr = function(tbl)
      local new_tbl = {}
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
  assoc_arr = {
    assoc_with_index_as_key_arr = function(arr)
      local res = get.table.table_by_copy(arr, true)
      for i, v in transf.arr.index_value_stateless_iter(arr) do
        v.index = i
      end
      return res
    end,
  },
  char = {
    unicode_prop_table = function(char)
      return get.fn.rt_or_nil_by_memoized(transf.str.table_or_err_by_evaled_env_bash_parsed_json)("uni identify -compact -format=all -as=json".. transf.str.str_by_single_quoted_escaped(char))[1]
    end
  },
  ascii_char = {
    eight_bit_pos_int = str.byte,
    indicated_hex_number_str = function(char)
      return get.str.str_by_formatted_w_n_anys("0x%02X", transf.ascii_char.eight_bit_pos_int(char))
    end,
    percent_encoded_octet = function(char)
      return get.str.str_by_formatted_w_n_anys("%%%02X", transf.ascii_char.eight_bit_pos_int(char))
    end,
  },
  leaf = {
    rf3339like_dt_or_interval_general_name_fs_tag_str = function(leaf)
      return get.str.n_strs_by_extracted_onig(
        leaf,
        ("^(%s(?:_to_%s)?--)?([^%%]*)(%%.*)?$"):format(
          r.g.date.rfc3339like_dt,
          r.g.date.rfc3339like_dt
        )
      )
    end,
  },
  ascii_str = {
    printable_ascii_by_remove = function(str)
      return get.str.str_by_removed_onig_inverted_w_regex_character_class_innards(str, r.g.char_range.printable_ascii)
    end,
  },
  path = {
    atpath = function(path)
      return "@" .. path
    end,
    path_component_arr = function(path)
      if path == "" then
        return {""}
      elseif path == "/" then
        return {"/"}
      else
        -- remove leading and trailing slashes
        if get.str.str_by_sub_eutf8(path, 1, 1) == "/" then
          path = get.str.str_by_sub_eutf8(path, 2)
        end
        if get.str.str_by_sub_eutf8(path, -1) == "/" then
          path = get.str.str_by_sub_eutf8(path, 1, -2)
        end

        -- split into components
        return get.str.str_arr_by_split_w_ascii_char(path, "/")
      end
    end,
    pos_int_by_path_component_arr_length = function(path)
      return #transf.path.path_component_arr(path)
    end,
    path_arr_by_path_component_arr = function(path)
      return get.path.path_arr_from_sliced_path_component_arr(
        get.path.path_component_arr(path),
        {start = 1, stop = -1}
      )
    end,
    path_segments = function(path)
      local path_components = transf.path.path_component_arr(path)
      local leaf = act.arr.pop(path_components)
      local without_extension = ""
      local extension = ""
      if leaf == "" then
        -- already both empty, nothing to do
      elseif get.str.bool_by_startswith(leaf, ".") then -- dotfile
        without_extension = leaf
      elseif get.str.bool_by_endswith(leaf, ".") then -- file that ends with a dot, does not count as having an extension
        without_extension = leaf
      elseif get.str.bool_by_not_contains_w_ascii_str(leaf, ".") then
        without_extension = leaf
      else -- in case of multiple dots, everything after the last dot is considered the extension
        without_extension, extension = get.str.n_strs_by_extracted_eutf8(leaf, transf.str.str_by_whole_regex(r.lua.without_extension_and_extension))
      end
      dothis.arr.push(path_components, without_extension)
      dothis.arr.push(path_components, extension)
    end,
    extension = function(path)
      local psegments = transf.path.path_segments(path)
     ---@diagnostic disable-next-line: need-check-nil -- path_segments always returns a table with at least two elements for any valid path
      return psegments[#psegments]
    end,
    normalized_extension = function(path)
      local ext = transf.path.extension(path)
      return tblmap.extension.normalized_extension[
        ext
      ] or ext
    end,
    path_without_extension = function(path)
      return get.path.path_from_sliced_path_segment_arr(
        get.path.path_segments(path),
        {start = 1, stop = -2}
      )
    end,
    filename = function(path)
      local psegments = transf.path.path_segments(path)
      act.arr.pop(psegments)
      ---@diagnostic disable-next-line: need-check-nil -- path_segments always returns a table with at least two elements for any valid path
      return psegments[#psegments]
    end,
    ending_with_slash = function(path)
      return get.str.str_by_with_suffix(path or "", "/")
    end,
    initial_path_component = function(path)
      return transf.path.path_component_arr(path)[1]
    end,
    leaf = function(path)
      local pcomponents = transf.path.path_component_arr(path)
      return pcomponents[#pcomponents]
    end,
    parent_path = function(path)
      return get.path.path_from_sliced_path_component_arr(
        get.path.path_component_arr(path),
        {start = 1, stop = -2}
      )
    end,
    parent_leaf = function(path)
      local pcomponents = transf.path.path_component_arr(path)
      act.arr.pop(pcomponents)
      return pcomponents[#pcomponents]
    end,
    parent_path_component_arr = function(path)
      return transf.path.path_component_arr(
        transf.path.parent_path(path)
      )
    end,
    path_arr_by_path_component_arr_via_parent = function(path)
      return transf.path.path_arr_by_path_component_arr(
        transf.path.parent_path(path)
      )
    end,
    path_leaf_specifier = function(path)
      local rf3339like_dt_or_interval, general_name, fs_tag_str = transf.leaf.rf3339like_dt_or_interval_general_name_fs_tag_str(transf.path.leaf(path))
      return {
        extension = transf.path.extension(path),
        path = transf.path.parent_path(path),
        rfc3339like_dt_or_interval = rf3339like_dt_or_interval,
        general_name = general_name,
        fs_tag_assoc = transf.fs_tag_str.fs_tag_assoc(fs_tag_str),
      }
    end,
    window_with_leaf_as_title = function(path)
      return transf.str.window_or_nil_by_title(transf.path.leaf(path))
    end,
    local_or_remote_str = function(path)
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
      local parts = get.str.str_arr_by_split_w_ascii_char(path, ":")
      local final_part = act.arr.pop(parts)
      local specifier = {}
      if is.str.number_str(parts[#parts]) then
        specifier = {
          column = final_part,
          line = act.arr.pop(parts),
          path = get.str_or_number_arr.str_by_joined(parts, ":")
        }
      else
        specifier = {
          line = final_part,
          path = get.str_or_number_arr.str_by_joined(parts, ":")
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
    input_spec_arr = function(specifier)
      return ":ctrl+g,:+" .. transf.path_with_intra_file_locator_specifier.intra_file_locator(specifier) .. ",:+return"
    end,
     
  },
  local_path = {
    local_path_by_percent_encoded = function(path)
      return plurl.quote(path)
    end
  },
  local_resolvable_path = {
    local_absolute_path = hs.fs.pathToAbsolute, -- resolves ~, ., .., and symlinks
  },
  remote_path = {

  },
  absolute_path = {
    file_url = function(path)
      return transf.local_absolute_path.file_url(transf.absolute_path.local_absolute_path(path))
    end,
    str_or_nil_by_file_contents = function(path)
      if is.absolute_path.file(path) then
        return transf.file.str_by_contents(path)
      else
        return nil
      end
    end,
  },
  local_absolute_path = {
    file_url = function(path)
      return "file://" .. path
    end,
    prompted_multiple_local_absolute_path_from_default = function(path)
      return transf.prompt_spec.any_arr({
        prompter = transf.prompt_args_str.str_or_nil_and_bool,
        prompt_args = {
          message =  "Enter a subdirectory (or file, if last) (started with: " .. path .. ")",
        }
      })
    end,
    prompted_once_local_absolute_path_from_default = function(path)
      return transf.prompt_spec.any({
        prompter = transf.prompt_args_str.str_or_nil_and_bool,
        prompt_args = {
          message =  "Enter a directory or file as a child of " .. path,
        }
      })
    end,

  },
  volume_local_extant_path = {

  },
  extant_path = {
    absolute_path_arr_by_siblings = function(path)
      return transf.dir.absolute_path_arr_by_children(transf.path.parent_path(path))
    end,
    absolute_path_arr_by_descendants = function(path)
      return get.extant_path.absolute_path_arr(
        path,
        {recursion = true}
      )
    end,
    absolute_path_arr_by_descendants_depth_3 = function(path)
      return get.extant_path.absolute_path_arr(
        path,
        {recursion = 3}
      )
    end,
    file_arr_by_descendants = function(path)
      return get.extant_path.absolute_path_arr(
        path,
        {recursion = true, include_dirs = false}
      )
    end,
    plaintext_file_arr_by_descendants = function(path)
      return transf.file_arr.plaintext_file_arr(
        transf.extant_path.file_arr_by_descendants(path)
      )
    end,
    m3u_file_arr_by_descendants = function(path)
      return transf.plaintext_file_arr.m3u_file_arr(
        transf.extant_path.plaintext_file_arr_by_descendants(path)
      )
    end,
    url_or_local_path_arr_by_descendant_m3u_file_content_lines = function(path)
      return transf.file_arr.url_or_local_path_arr_by_m3u_file_content_lines(
        transf.extant_path.file_arr_by_descendants(path)
      )
    end,
    
    dir_arr_by_descendants = function(path)
      return get.extant_path.absolute_path_arr(
        path,
        {recursion = true, include_files = false}
      )
    end,
    descendants_leaves_arr = function(path)
      return transf.path_arr.leaves_arr(transf.extant_path.absolute_path_arr_by_descendants(path))
    end,
    descendants_filenames_arr = function(path)
      return transf.path_arr.filenames_arr(transf.extant_path.absolute_path_arr_by_descendants(path))
    end,
    extension_arr_by_descendants = function(path)
      return transf.path_arr.extensions_arr(transf.extant_path.absolute_path_arr_by_descendants(path))
    end,

    dir_arr_by_descendants_depth_3 = function(path)
      return get.extant_path.absolute_path_arr(
        path,
        {recursion = 3, include_files = false}
      )
    end,
    git_root_dir_arr_by_descendants = function(dir)
      return transf.dir_arr.git_root_dir_arr_by_filter(transf.extant_path.absolute_path_arr_by_descendants(dir))
    end,
  },
  local_extant_path = {
    int_by_size_bytes = function(path)
      return get.extant_path.attr(path, "size")
    end,
    timestamp_s_by_modification = function(path)
      return get.extant_path.attr(path, "modification")
    end,
    date_by_modification = function(path)
      return transf.timestamp_s.date(transf.extant_path.m_timestamp_s(path))
    end,
    timestamp_s_by_creation = function(path)
      return get.extant_path.attr(path, "creation")
    end,
    date_by_creation = function(path)
      return transf.timestamp_s.date(transf.extant_path.timestamp_s_by_creation(path))
    end,
    timestamp_s_by_change = function(path)
      return get.extant_path.attr(path, "change")
    end,
    date_by_change = function(path)
      return transf.timestamp_s.date(transf.extant_path.timestamp_s_by_change(path))
    end,
    timestamp_s_by_access = function(path)
      return get.extant_path.attr(path, "access")
    end,
    date_by_access = function(path)
      return transf.timestamp_s.date(transf.extant_path.timestamp_s_by_access(path))
    end,
    project_dir_arr_by_descendants_depth_3 = function(path)
      return transf.local_dir_arr.project_dir_arr_by_filter(
        transf.extant_path.dir_arr_by_descendants_depth_3(path)
      )

    end

    
  },
  local_dir = {
    absolute_path_vt_stateful_iter_by_children = hs.fs.dir,
    local_extant_path_arr_by_descendants = function(path)
      return transf.local_extant_path_arr.installed_app_dir_arr_by_filter(
        transf.extant_path.dir_arr_by_descendants(path)
      )
    end
  },
  in_home_local_absolute_path = {
    http_protocol_url_by_local_http_server = function(path)
      return env.FS_HTTP_SERVER .. path
    end,
    local_nonabsolute_path_by_relative_to_home = function(path)
      return get.absolute_path.relative_path_from(path, env.HOME)
    end,
    labelled_remote_path = function(path)
      return transf.local_nonabsolute_path_relative_to_home.labelled_remote_absolute_path(transf.in_home_local_absolute_path.local_nonabsolute_path_by_relative_to_home(path))
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
  path_arr = {
    leaves_arr = function(path_arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(path_arr, transf.path.leaf)
    end,
    filenames_arr = function(path_arr)
      local filenames = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(path_arr, transf.path.filename)
      return transf.arr.set(filenames)
    end,
    extensions_arr = function(path_arr)
      local extensions = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(path_arr, transf.path.extension)
      return transf.arr.set(extensions)
    end,
    extant_path_arr = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.path.extant_path)
    end,
    not_useless_file_leaf_path_arr_by_filtered = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.path.not_useless_file_leaf_path)
    end,
    path_leaf_specifier_arr = function(path_arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(path_arr, transf.path.path_leaf_specifier)
    end,
    date_interval_specifier_arr = function(path_arr)
      return transf.path_leaf_specifier_arr.date_interval_specifier_arr(
        transf.path_arr.path_leaf_specifier_arr(path_arr)
      )
    end,
    rfc3339like_dt_or_interval_by_union = function(path_arr)
      return transf.path_leaf_specifier_arr.rfc3339like_dt_or_interval_by_union(
        transf.path_arr.path_leaf_specifier_arr(path_arr)
      )
    end,
    citable_path_arr_by_filtered = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.path.citable_path)
    end,
    csl_table_arr_by_filtered_mapped = function(path_arr)
      return transf.citable_path_arr.csl_table_arr(
        transf.path_arr.citable_path_arr_by_filtered(path_arr)
      )
    end,
    indicated_citable_object_id_arr_by_filtered_mapped = function(path_arr)
      return transf.citable_path_arr.indicated_citable_object_id_arr(
        transf.path_arr.citable_path_arr_by_filtered(path_arr)
      )
    end,
  },
  extant_path_arr = {
    extant_path_by_newest_creation = function(path_arr)
      return get.extant_path_arr.extant_by_largest_of_attr(path_arr, "creation")
    end,
    dir_arr_by_filter = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.path.dir)
    end,
    file_arr_by_filter = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.path.file)
    end,
    git_root_dir_arr_by_filter = function(path_arr)
      return transf.dir_arr.git_root_dir_arr_by_filter(transf.extant_path_arr.dir_arr_by_filter(path_arr))
    end,
    file_arr_by_descendants = function(path_arr)
      return get.arr_arr.arr_by_mapped_w_vt_arg_vt_ret_fn_and_flatten(
        path_arr,
        transf.extant_path.file_arr_by_descendants
      )
    end,
  },
  local_extant_path_arr = {
    installed_app_dir_arr_by_filter = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.local_extant_path.installed_app_dir)
    end,
  },
  dir_arr = {
    git_root_dir_arr_by_filter = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.dir.git_root_dir)
    end,
    absolute_path_arr_by_children = function(path_arr)
      return get.arr_arr.arr_by_mapped_w_vt_arg_vt_ret_fn_and_flatten(
        path_arr,
        transf.dir.absolute_path_arr_by_children
      )
    end,
  },
  local_dir_arr = {
    project_dir_arr_by_filter = function(arr)
      return get.arr.arr_by_filtered(arr, is.local_dir.project_dir)
    end
  },
  file_arr = {
    plaintext_file_arr = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.file.plaintext_file)
    end,
    url_or_local_path_arr_by_m3u_file_content_lines = function(path_arr)
      return transf.plaintext_file_arr.url_or_local_path_arr_by_m3u_file_content_lines(
        transf.file_arr.plaintext_file_arr(path_arr)
      )
    end
  },
  labelled_remote_dir = {
    children_absolute_path_arr = function(remote_extant_path)
      local output = transf.str.str_or_nil_by_evaled_env_bash_stripped("rclone lsf" .. transf.str.str_by_single_quoted_escaped(remote_extant_path))
      if output then
        items = transf.str.noempty_line_str_arr(output)
        items = transf.str_arr.stripped_str_arr(items)
      else
        items = {}
      end
      return items
    end,
    children_absolute_path_vt_stateful_iter = function(remote_extant_path)
      return transf.table.vt_stateful_iter(
        transf.remote_dir.absolute_path_arr_by_children(remote_extant_path)
      )
    end,
  },
  remote_dir = {
    absolute_path_arr_by_children = function(remote_extant_path)
      return transf.labelled_remote_dir.children_absolute_path_arr(remote_extant_path)
    end,
    absolute_path_vt_stateful_iter_by_children = function(remote_extant_path)
      return transf.labelled_remote_dir.children_absolute_path_vt_stateful_iter(remote_extant_path)
    end,
  },
  local_file = {
    str_by_contents = function(path)
      local file = io.open(path, "r")
      if file ~= nil then
        local contents = file:read("*a")
        io.close(file)
        return contents
      else
        error("Couldn't read file at " .. path .. "!")
      end
    end,
    attachment_str = function(path)
      local mimetype = mimetypes.guess(path) or "text/plain"
      return "#" .. mimetype .. " " .. path
    end,
    email_specifier = function(path)
      return {
        non_inline_attachment_local_file_arr = {path}
      }
    end,
  },
  local_file_arr = {
    attachment_arr = function(path_arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(path_arr, transf.local_file.attachment_str)
    end,
    attachment_str = function(path_arr)
      return get.str_or_number_arr.str_by_joined(transf.path_arr.attachment_arr(path_arr), "\n")
    end,
    email_specifier = function(path_arr)
      return {
        non_inline_attachment_local_file_arr = path_arr
      }
    end,
  },
  labelled_remote_file = {
    str_by_contents = function(path)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("rclone cat" .. transf.str.str_by_single_quoted_escaped(path))
    end,
  },
  remote_file = {
    str_by_contents = function(path)
      return transf.labelled_remote_file.str_by_contents(path)
    end,
  },
  file = {
    str_by_contents = function(path)
      if is.path.remote_path(path) then
        return transf.remote_file.str_by_contents(path)
      else
        return transf.local_file.str_by_contents(path)
      end
    end,
  },
  dir = {
    absolute_path_arr_by_children = function(dir)
      return get.extant_path.absolute_path_arr(dir)
    end,
    absolute_path_arr_by_children_or_self = function(dir)
      return transf.arr_and_any.arr(
        transf.dir.absolute_path_arr_by_children(dir),
        dir
      )
    end,
    absolute_path_arr_by_children_or_parent = function(dir)
      return transf.arr_and_any.arr(
        transf.dir.absolute_path_arr_by_children(dir),
        transf.path.parent_path(dir)
      )
    end,
    file_arr_by_children = function(dir)
      return get.extant_path.absolute_path_arr(dir, {include_dirs = false})
    end,
    absolute_path_arr_by_file_children_or_self = function(dir)
      return transf.arr_and_any.arr(
        transf.dir.file_arr_by_children(dir),
        dir
      )
    end,
    dir_arr_by_children = function(dir)
      return get.extant_path.absolute_path_arr(dir, {include_files = false})
    end,
    dir_arr_by_children_or_self = function(dir)
      return transf.arr_and_any.arr(
        transf.dir.dir_arr_by_children(dir),
        dir
      )
    end,
    children_absolute_path_vt_stateful_iter = function(dir)
      if is.path.remote_path(dir) then
        return transf.remote_dir.absolute_path_vt_stateful_iter_by_children(dir)
      else
        return transf.local_dir.absolute_path_vt_stateful_iter_by_children(dir)
      end
    end,
    children_leaves_arr = function(dir)
      return transf.path_arr.leaves_arr(transf.dir.absolute_path_arr_by_children(dir))
    end,
    children_leaves_arr_or_dot = function(dir)
      return transf.arr_and_any.arr(
        transf.dir.children_leaves_arr(dir),
        "."
      )
    end,
    children_leaves_arr_or_dotdot = function(dir)
      return transf.arr_and_any.arr(
        transf.dir.children_leaves_arr(dir),
        ".."
      )
    end,
    children_filename_arr = function(dir)
      return transf.path_arr.filenames_arr(transf.dir.absolute_path_arr_by_children(dir))
    end,
    children_extensions_arr = function(dir)
      return transf.path_arr.extensions_arr(transf.dir.absolute_path_arr_by_children(dir))
    end,
    newest_child = function(dir)
      return transf.extant_path_arr.extant_path_by_newest_creation(transf.dir.absolute_path_arr_by_children(dir))
    end,
    grandchildren_absolute_path_arr = function(dir)
      return get.arr_arr.arr_by_mapped_w_vt_arg_vt_ret_fn_and_flatten(transf.dir.absolute_path_arr_by_children(dir), transf.dir.absolute_path_arr_by_children)
    end,
    absolute_path_key_leaf_str_or_nested_value_assoc = function(path)
      local res = {}
      path = get.str.str_by_with_suffix(path, "/")
      for child_path in transf.dir.children_absolute_path_vt_stateful_iter(path) do
        if is.absolute_path.dir(child_path) then
          res[child_path] = transf.dir.absolute_path_key_leaf_str_or_nested_value_assoc(child_path)
        else
          res[child_path] = "leaf"
        end
      end
      return res
    end,
    plaintext_assoconary_read_assoc = function(path)
      transf.absolute_path_key_leaf_str_or_nested_value_assoc.plaintext_assoconary_read_assoc(
        transf.dir.absolute_path_key_leaf_str_or_nested_value_assoc(path)
      )
    end,
    str_by_ls = function(path)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("ls -F -1" .. transf.str.str_by_single_quoted_escaped(path))
    end,
    str_by_tree = function(path)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("tree -F --noreport" .. transf.str.str_by_single_quoted_escaped(path))
    end,
    path_leaf_specifier_arr_by_children = function(path)
      return transf.path_arr.path_leaf_specifier_arr(
        transf.dir.absolute_path_arr_by_children(path)
      )
    end,
    rfc3339like_dt_or_interval_by_union_of_children = function(path)
      return transf.path_leaf_specifier_arr.rfc3339like_dt_or_interval_by_union(
        transf.dir.path_leaf_specifier_arr_by_children(path)
      )
    end,
    path_leaf_specifier_by_using_union_rf3339like_dt_or_interval = function(path)
      local path_leaf_specifier = transf.path.path_leaf_specifier(path)
      local union_rf3339like_dt_or_interval = transf.dir.rfc3339like_dt_or_interval_by_union_of_children(path)
      if union_rf3339like_dt_or_interval then
        path_leaf_specifier.rfc3339like_dt_or_interval = union_rf3339like_dt_or_interval
      end
      return path_leaf_specifier
    end,
    path_by_using_union_rfc3339like_dt_or_interval = function(path)
      local path_leaf_specifier = transf.dir.path_leaf_specifier_by_using_union_rf3339like_dt_or_interval(path)
      return transf.path_leaf_specifier.path(path_leaf_specifier)
    end
  },
  absolute_path_key_leaf_str_or_nested_value_assoc = {
    leaf_key_leaf_str_or_nested_value_assoc = function(assoc)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(assoc) do
        local leaf = transf.path.leaf(k)
        if is.any.table(v) then
          res[leaf] = transf.absolute_path_key_leaf_str_or_nested_value_assoc.leaf_key_leaf_str_or_nested_value_assoc(v)
        else
          res[leaf] = v
        end
      end
      return res
    end,
    plaintext_assoconary_read_assoc = function(assoc)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(assoc) do
        local filename = transf.path.filename(k)
        if is.any.table(v) then
          res[filename] = transf.absolute_path_key_leaf_str_or_nested_value_assoc.plaintext_assoconary_read_assoc(v)
        else
          if is.file.plaintext_assoc_file(k) then
            res[filename] = transf.plaintext_assoc_file.table(k)
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
    nonabsolute_path_by_from_git_root_dir = function(path)
      return transf.path.relative_path(
        path,
        transf.in_git_dir.git_root_dir(path)
      )
    end,
    absolute_path_by_root_gitignore = function(path)
      return transf.path.ending_with_slash(transf.in_git_dir.git_root_dir(path)) .. ".gitignore"
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
      raw = get.str.str_by_no_suffix(raw, ".git")
      raw = get.str.str_by_no_suffix(raw, "/")
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
      if get.arr.bool_by_contains(ls.remote_types, transf.in_git_dir.remote_sld(path)) then
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
      return transf.str.noempty_line_str_arr(raw_hashes)
    end


  },
  in_git_dir_arr = {
    in_has_changes_git_dir_arr_by_filtered = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.in_git_dir.in_has_changes_git_dir)
    end,
    in_has_unpushed_commits_git_dir_arr_by_filtered = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.in_git_dir.in_has_unpushed_commits_git_dir)
    end,
  },
  git_root_dir = {
    dotgit_dir = function(git_root_dir)
      return transf.path.ending_with_slash(git_root_dir) .. ".git"
    end,
    hooks_dir = function(git_root_dir)
      return transf.path.ending_with_slash(git_root_dir) .. ".git/hooks"
    end,
    hooks_absolute_path_arr = function(git_root_dir)
      return transf.dir.absolute_path_arr_by_children(transf.git_root_dir.hooks_dir(git_root_dir))
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
    date_interval_specifier_or_nil = function(path_leaf_specifier)
      if path_leaf_specifier.rf3339like_dt_or_interval then
        return transf.rf3339like_dt_or_interval.date_interval_specifier(path_leaf_specifier.rf3339like_dt_or_interval)
      else
        return nil
      end
    end,
    path_part = function(path_leaf_specifier)
      return transf.path.ending_with_slash(path_leaf_specifier.path) 
    end,
    fs_tag_assoc = function(path_leaf_specifier)
      return path_leaf_specifier.fs_tag_assoc
    end,
    fs_tag_str_assoc = function(path_leaf_specifier)
      return transf.fs_tag_assoc.fs_tag_str_assoc(path_leaf_specifier.fs_tag_assoc)
    end,
    fs_tag_str_part_arr = function(path_leaf_specifier)
      return transf.fs_tag_assoc.fs_tag_str_part_arr(path_leaf_specifier.fs_tag_assoc)
    end,
    fs_tag_str = function(path_leaf_specifier)
      return transf.fs_tag_assoc.fs_tag_str(path_leaf_specifier.fs_tag_assoc)
    end,
    fs_tag_keys = function(path_leaf_specifier)
      return transf.table_or_nil.kt_arr(path_leaf_specifier.fs_tag_assoc)
    end,
    path = function(path_leaf_specifier)
      return transf.path.ending_with_slash(path_leaf_specifier.path) 
      .. transf.path_leaf_specifier.rf3339like_dt_or_interval_part(path_leaf_specifier)
      .. transf.path_leaf_specifier.general_name_part(path_leaf_specifier)
      .. transf.path_leaf_specifier.fs_tag_str(path_leaf_specifier)
      .. transf.path_leaf_specifier.extension_part(path_leaf_specifier)
    end
  },
  fs_tag_str = {
    fs_tag_str_part_arr = function(fs_tag_str)
      return get.str.str_arr_by_split_w_ascii_char(
        fs_tag_str:sub(2),
        "%"
      )
    end,
    fs_tag_str_assoc = function(fs_tag_str)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        transf.fs_tag_str.fs_tag_str_part_arr(fs_tag_str),
        get.fn.arbitrary_args_bound_or_ignored_fn(get.str.n_strs_split, {a_use, "-", 2})
      )
    end,
    fs_tag_assoc = function(fs_tag_str)
      transf.fs_tag_str_assoc.fs_tag_assoc(
        transf.fs_tag_str.fs_tag_str_assoc(fs_tag_str)
      )
    end,
  },
  fs_tag_str_part_arr = {
    fs_tag_str_assoc = function(fs_tag_str_part_arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        fs_tag_str_part_arr,
        get.fn.second_n_args_bound_fn(get.str.two_strs_split_or_nil, "-")
      )
    end,
    fs_tag_assoc = function(fs_tag_str_part_arr)
      transf.fs_tag_str_assoc.fs_tag_assoc(
        transf.fs_tag_str_part_arr.fs_tag_str_assoc(fs_tag_str_part_arr)
      )
    end,
    fs_tag_str = function(fs_tag_str_part_arr)
      return "%" .. get.str_or_number_arr.str_by_joined(fs_tag_str_part_arr, "%")
    end,
  },
  fs_tag_str_assoc = {
    fs_tag_assoc = function(assoc)
      return hs.fnutils.map(
        assoc,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.str.str_arr_by_split_w_ascii_char, {a_use, ","})
      )
    end,
    fs_tag_str_part_arr = function(assoc)
      return get.table.str_arr_by_mapped_w_fmt_str(
        assoc,
        "%s-%s"
      )
    end,
    fs_tag_str = function(assoc)
      return transf.fs_tag_str_part_arr.fs_tag_str(
        transf.fs_tag_str_assoc.fs_tag_str_part_arr(assoc)
      )
    end,
  },
  fs_tag_assoc = {
    fs_tag_str_assoc = function(fs_tag_assoc)
      return hs.fnutils.map(
        fs_tag_assoc,
        transf.any.join_if_arr
      )
    end,
    fs_tag_str_part_arr = function(fs_tag_assoc)
      return transf.fs_tag_str_assoc.fs_tag_str_part_arr(
        transf.fs_tag_assoc.fs_tag_str_assoc(fs_tag_assoc)
      )
    end,
    fs_tag_str = function(fs_tag_assoc)
      return transf.fs_tag_str_part_arr.fs_tag_str(
        transf.fs_tag_assoc.fs_tag_str_part_arr(fs_tag_assoc)
      )
    end,
  },
  path_leaf_specifier_arr = {
    path_leaf_specifier_date_interval_specifier_assoc = function(arr)
      return get.table.table_by_mapped_w_kt_arg_kt_vt_ret_fn(
        arr,
        function(path_leaf_specifier)
          return 
            path_leaf_specifier,
            transf.path_leaf_specifier.date_interval_specifier_or_nil(
              path_leaf_specifier
            )
        end
      )
    end,
    date_interval_specifier_arr = function(arr)
      return get.table.arr_by_mapped_w_vt_arg_vt_ret_fn(
        arr,
        transf.path_leaf_specifier.date_interval_specifier_or_nil
      )
    end,
    date_interval_specifier_or_nil_by_earliest_start = function(arr)
      return transf.interval_specifier_arr.interval_specifier_with_earliest_start(
        transf.path_leaf_specifier_arr.date_interval_specifier_arr(arr)
      )
    end,
    date_by_earliest_start = function(arr)
      return transf.interval_specifier_arr.earliest_start(
        transf.path_leaf_specifier_arr.date_interval_specifier_arr(arr)
      )
    end,
    date_by_latest_end = function(arr)
      return transf.interval_specifier_arr.latest_end(
        transf.path_leaf_specifier_arr.date_interval_specifier_arr(arr)
      )
    end,
    date_interval_specifier_by_union = function(arr)
      return transf.interval_specifier_arr.interval_specifier_by_union(
        transf.path_leaf_specifier_arr.date_interval_specifier_arr(arr)
      )
    end,
    rfc3339like_dt_or_interval_by_union = function(arr)
      return transf.date_interval_specifier.rf3339like_dt_or_interval(
        transf.path_leaf_specifier_arr.date_interval_specifier_by_union(arr)
      )
    end,
    path_leaf_specifier_or_nil_by_earliest_start = function(arr)
      return get.assoc.kt_or_nil_by_first_match_w_vt(
        transf.path_leaf_specifier_arr.path_leaf_specifier_date_interval_specifier_assoc(arr),
        transf.path_leaf_specifier_arr.date_interval_specifier_or_nil_by_earliest_start(arr)
      )
    end,
  },
  whisper_file = {
    transcribed = function(path)
      return get.fn.rt_or_nil_by_memoized_invalidate_1_year(rest, "rest")({
        api_name = "openai",
        endpoint = "audio/transcriptions",
        request_table_type = "form",
        request_table = {
          model = "whisper-1",
          file = transf.path.atpath(path),
        }
      }).text
    end
  },
  local_image_file = {
    qr_data = function(path)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("zbarimg -q --raw " .. transf.str.str_by_single_quoted_escaped(path))
    end,
    hs_image = function(path)
      return get.fn.rt_or_nil_by_memoized_invalidate_1_week(hs.image.imageFromPath, "hs.image.imageFromPath")(path)
    end,
    booru_post_url = function(path)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "saucenao --file" ..
        transf.str.str_by_single_quoted_escaped(path)
        .. "--output-properties booru-url"
      )
    end,
    data_url = function(path)
      local ext = transf.path.extension(path)
      return get.fn.rt_or_nil_by_memoized(hs.image.encodeAsURLstr)(transf.local_image_file.hs_image(path), ext)
    end,
  },
  email_file = {
    all_headers_raw = function(path)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "mshow -L" .. transf.str.str_by_single_quoted_escaped(path)
      )
    end,
    all_useful_headers_raw = function(path)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "mshow -q" .. transf.str.str_by_single_quoted_escaped(path)
      )
    end,
    useful_header_assoc = function(path)
      error("TODO: currently the way the headers are rendered contains a bunch of stuff we wouldn't want in the assoc. In particular, emails without a name are rendered as <email>, which may not be what we want.")
      return transf.header_str.assoc(transf.email_file.all_useful_headers_raw(path))
    end,
    rendered_body = function(path)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)(
        "mshow -R" .. transf.str.str_by_single_quoted_escaped(path)
      )
    end,
    simple_view = function(path)
      return transf.email_file.all_useful_headers_raw(path) .. "\n\n" .. transf.email_file.rendered_body(path)
    end,
    email_specifier = function(path)
      local specifier = transf.email_file.useful_header_assoc(path)
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
      transf.str.email_quoted(transf.email_file.rendered_body(path))
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
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "mshow -t" .. transf.str.str_by_single_quoted_escaped(path)
      )
    end,
    attachments = function(path)
      return transf.mime_parts_raw.attachments(transf.email_file.mime_parts_raw(path))
    end,
    summary = function(path)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)("mscan -f %D **%f** %200s" .. transf.str.str_by_single_quoted_escaped(path))
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
        body = "\n\n" .. transf.str.email_quoted(specifier.body)
      }
    end,
    forward_email_specifier = function(specifier)
      return {
        subject = "Fwd: " .. specifier.subject,
        body = "\n\n" .. transf.str.email_quoted(specifier.body)
      }
    end,
    email_str = function(specifier)
      specifier = get.table.table_by_copy(specifier)
      local body = specifier.body or ""
      specifier.body = nil
      local non_inline_attachment_local_file_arr = specifier.non_inline_attachment_local_file_arr
      specifier.non_inline_attachment_local_file_arr = nil
      local header = transf.assoc.email_header(specifier)
      local mail = get.str.str_by_formatted_w_n_anys("%s\n\n%s", header, body)
      if non_inline_attachment_local_file_arr then
        mail = mail .. "\n" .. transf.path_arr.attachment_str(non_inline_attachment_local_file_arr)
      end
      return mail
    end,

    draft_email_file = function(specifier)
      

      local mail = join.str.table.email(body, specifier)
      local evaled_mail = get.str.str_by_evaled_as_template(mail)
      local temppath = transf.not_userdata_or_function.in_tmp_dir(evaled_mail)
      local outpath = temppath .. "_out"
      transf.str.str_or_nil_by_evaled_env_bash_stripped("mmime < " .. transf.str.str_by_single_quoted_escaped(temppath) .. " > " .. transf.str.str_by_single_quoted_escaped(outpath))
      dothis.absolute_path.delete(temppath)
      return outpath
    end
  },
  mime_parts_raw = {
    attachments = function(mime_parts_raw)
      local attachments = {}
      for line in transf.str.line_arr(mime_parts_raw) do
        local name = line:match("name=\"(.-)\"")
        if name then
          dothis.arr.insert_at_index(attachments, name)
        end
      end
      return attachments
    end,
  },
  bib_file = {
    csl_table_arr = function(path)
      return transf.str.table_or_err_by_evaled_env_bash_parsed_json({
        "citation-js --input" .. transf.str.str_by_single_quoted_escaped(path) ..
        "--output-language json"
      })
    end,

  },

  ics_file = {
    assoc_arr = function(path)
      local temppath = transf.str.in_tmp_dir(transf.path.filename(path) .. ".ics")
      dothis.extant_path.copy_to_absolute_path(path, temppath)
      act.ics_file.generate_json_file(temppath)
      local jsonpath = transf.file.str_by_contents(get.path.with_different_extension(temppath, "json"))
      local res = json.decode(transf.file.str_by_contents(jsonpath))
      dothis.absolute_path.delete(temppath)
      dothis.absolute_path.delete(jsonpath)
      return res
    end,
  },
  json_file = {
    not_userdata_or_function = function(path)
      return transf.json_str.not_userdata_or_function(transf.file.str_by_contents(path))
    end,
    table_or_nil = function(path)
      return transf.json_str.table_or_nil(transf.file.str_by_contents(path))
    end,
  },
  ini_file = {
    assoc = function(path)
      return transf.ini_str.assoc(transf.file.str_by_contents(path))
    end,
  },
  toml_file = {
    assoc = function(path)
      return transf.toml_str.assoc(transf.file.str_by_contents(path))
    end,
  },
  backuped_thing_identifier = {
    timestamp_ms = function(identifier)
      return  transf.absolute_path.str_or_nil_by_file_contents(
        transf.path.ending_with_slash(env.MLAST_BACKUP) .. identifier
      ) or 0
    end
  },
  xml_local_file = {
    tree = xml.parseFile
  },
  -- a tree_node_like is a table with a key <ckey> which at some depth contains a tree_node_like_arr, and a key <lkey> which contains a thing of any type that can be seen as the label of the node (or use self), such the tree_node_like it can be transformed to a tree_node
  tree_node_like = {

  },
  tree_node_like_arr = {

  },
  tree_node = {
    arr_arr_by_label = function(node, path, include_inner)
      path = get.table.table_by_copy(path) or {}
      dothis.arr.push(path, node.label)
      local res = {}
      if not node.children or include_inner then
        res = {path}
      end
      if node.children then
        res = transf.two_arrs.arr_by_appended(res, transf.tree_node_arr.arr_arr_by_label(node.children, path, include_inner))
      end
      return res
    end
  },
  tree_node_arr = {
    arr_arr_by_label = function(arr, path, include_inner)
      local res = {}
      for _, node in transf.arr.index_value_stateless_iter(arr) do
        res = transf.two_arrs.arr_by_appended(res, transf.tree_node.arr_arr_by_label(node, path, include_inner))
      end
      return res
    end,
  },

  env_var_name_value_assoc = {
    key_value_and_dependency_assoc = function(assoc)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(assoc, function(value)
        return {
          value = value,
          dependencies = get.stateless_iter.table(
            get.str.n_str_stateful_iter_by_extracted_eutf8(value, "%$([A-Z0-9_]+)")), {tolist=true, ret="v"}
        }
      end)
    end,
    dependency_ordered_key_value_arr = function(assoc)
      return transf.key_value_and_dependency_assoc.dependency_ordered_key_value_arr(
        transf.key_value_and_dependency_assoc.key_value_and_dependency_assoc(assoc)
      )
    end,
    env_str = function(assoc)
      transf.env_line_arr.env_str(
        transf.two_strs_arr_arr.env_line_arr(
          transf.env_var_name_value_assoc.dependency_ordered_key_value_arr(assoc)
        )
      )
    end

  },
  key_value_and_dependency_assoc = {
    dependency_ordered_key_value_arr = function(assoc)local result = {}  -- Table to store the sorted keys
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
              for _, dep in transf.arr.index_value_stateless_iter(assoc[key]['dependencies']) do
                  dfs(dep)
              end
  
              temp_stack[key] = nil  -- Remove key from temporary stack
              visited[key] = true  -- Mark key as visited
              dothis.arr.insert_at_index(result, { key, assoc[key]['value'] })  -- Append {key, value} two_anys_arr to result
          end
      end
  
      -- Perform DFS traversal for each key in the graph
      for key, _ in transf.table.kt_vt_stateless_iter(assoc) do
          dfs(key)
      end
  
      return result
    end
  },

  shellscript_file = {
    gcc_str_errors = function(path)
      return get.shellscript_file.lint_gcc_str(path, "errors")
    end,
    gcc_str_warnings = function(path)
      return get.shellscript_file.lint_gcc_str(path, "warnings")
    end,
  },

  plaintext_file = {
    str_by_contents = function(path)
      return transf.file.str_by_contents(path)
    end,
    str_arr_by_lines = function(path)
      return transf.str.line_arr(transf.plaintext_file.str_by_contents(path))
    end,
    str_arr_by_content_lines = function(path)
      return transf.str.noempty_line_str_arr(transf.plaintext_file.str_by_contents(path))
    end,
    noindent_content_lines = function(path)
      return transf.str.noindent_content_lines(transf.plaintext_file.str_by_contents(path))
    end,
    nocomment_noindent_content_lines = function(path)
      return transf.str.nocomment_noindent_content_lines(transf.plaintext_file.str_by_contents(path))
    end,
    first_line = function(path)
      return transf.str.line_by_first(transf.plaintext_file.str_by_contents(path))
    end,
    last_line = function(path)
      return transf.str.line_by_last(transf.plaintext_file.str_by_contents(path))
    end,
    byte_char_arr = function(path)
      return transf.str.byte_char_arr(transf.plaintext_file.str_by_contents(path))
    end,
    utf8_char_arr = function(path)
      return transf.str.utf8_char_arr(transf.plaintext_file.str_by_contents(path))
    end,
    no_final_newlines = function(path)
      return transf.str.str_by_no_final_newlines(transf.plaintext_file.str_by_contents(path))
    end,
    one_final_newline = function(path)
      return transf.str.str_by_one_final_newline(transf.plaintext_file.str_by_contents(path))
    end,
    len_lines = function(path)
      return transf.str.pos_int_by_len_lines(transf.plaintext_file.str_by_contents(path))
    end,
    pos_int_by_len_utf8_chars = function(path)
      return transf.str.pos_int_by_len_utf8_chars(transf.plaintext_file.str_by_contents(path))
    end,
    pos_int_by_len_byte_chars = function(path)
      return transf.str.pos_int_by_len_byte_chars(transf.plaintext_file.str_by_contents(path))
    end,

    
  },

  plaintext_table_file = {
    field_separator = function(path)
      return tblmap.extension.likely_field_separator[transf.path.extension(path)]
    end,
    record_separator = function(path)
      return tblmap.extension.likely_record_separator[transf.path.extension(path)]
    end,
    field_arr_arr = function(path)
      return ftcsv.parse(path, transf.plaintext_table_file.field_separator(path), {
        headers = false
      })
    end,
    iter_of_field_arr = function(path)
      local iter = ftcsv.parseLine(path, transf.plaintext_table_file.field_separator(path), {
        headers = false
      })
      iter() -- skip header, seems to be a bug in ftcsv
      return iter
    end,
    assoc_arr = function(path)
      return select(1, ftcsv.parse(path, transf.plaintext_table_file.field_separator(path)))
    end,
    iter_of_assocs = function(path)
      return ftcsv.parseLine(path, transf.plaintext_table_file.field_separator(path))
    end,
  },
  timestamp_s_key_assoc_value_assoc_json_file = {

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
  semver_str = {
    semver_component_specifier = function(str)
      local major, minor, patch, prerelease, build = get.str.n_strs_by_extracted_onig(str, r.g.version.semver)
      return {
        major = get.str_or_number.number_or_nil(major),
        minor = get.str_or_number.number_or_nil(minor),
        patch = get.str_or_number.number_or_nil(patch),
        prerelease = prerelease,
        build = build
      }
    end,
  },
  package_name_semver_compound_str = {
    package_name_semver_str_arr = function(str)
      return get.str.str_arr_split_noedge(str, "@")
    end,
    package_name = function(str)
      return transf.package_name_semver_compound_str.package_name_semver_str_arr(str)[1]
    end,
    semver_str = function(str)
      return transf.package_name_semver_compound_str.package_name_semver_str_arr(str)[2]
    end,
  },
  package_name_semver_package_manager_name_compound_str = {
    package_name_semver_compound_str = function(str)
      return get.str.str_arr_split_noedge(str, ":")[1]
    end,
    package_name = function(str)
      return transf.package_name_semver_compound_str.package_name(
        transf.package_name_semver_package_manager_name_compound_str.package_name_semver_compound_str(str)
      )
    end,
    semver_str = function(str)
      return transf.package_name_semver_compound_str.semver_str(
        transf.package_name_semver_package_manager_name_compound_str.package_name_semver_compound_str(str)
      )
    end,
    package_manager_name = function(str)
      return get.str.str_arr_split_noedge(str, ":")[2]
    end,
  },
  package_name_package_manager_name_compound_str = {
    package_name = function(str)
      return get.str.str_arr_split_noedge(str, ":")[1]
    end,
    package_manager_name = function(str)
      return get.str.str_arr_split_noedge(str, ":")[2]
    end,
  },
  dice_notation = {
    nonindicated_dec_number_str_result = function(dice_notation)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("roll" .. transf.str.str_by_single_quoted_escaped(dice_notation))
    end,
    int_result = function(dice_notation)
      return transf.nonindicated_number_str.number_by_base_10(
        transf.dice_notation.nonindicated_dec_number_str_result(dice_notation)
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
      return get.str_or_number_arr.str_by_joined(transf.date.y_ym_ymd_table(date), "/")
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
    full_date_component_name_value_assoc = function(date)
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
      return get.date.str_w_date_format_indicator(date, tblmap.date_format_name.date_format["rfc3339-datetime"])
    end,
    full_rfc3339like_time = function(date)
      return get.date.str_w_date_format_indicator(date, tblmap.date_format_name.date_format["rfc3339-time"])
    end,
    timestamp_s = function(date)
      return transf.full_date_component_name_value_assoc.timestamp_s(
        transf.date.full_date_component_name_value_assoc(date)
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
      return get.date.str_w_date_format_indicator(date, "detailed")
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
    date_component_name_arr_larger_or_same = function(date_component_name)
      return get.arr.arr_by_slice_w_3_pos_int_any_or_nils(ls.date.date_component_names, 1, date_component_name)
    end,
    date_component_name_arr_same_or_smaller = function(date_component_name)
      return get.arr.arr_by_slice_w_3_pos_int_any_or_nils(ls.date.date_component_names, date_component_name)
    end,
    date_component_index = function(date_component_name)
      return tblmap.date_component_name.date_component_index[date_component_name]
    end,
    
  },
  date_component_name_arr = {
    min_date_component_name_value_assoc = function(arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        arr,
        function(component)
          return component, tblmap.date_component_name.min_date_component_value[component]
        end
      )
    end,
    max_date_component_name_value_assoc = function(arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        arr,
        function(component)
          return component, tblmap.date_component_name.max_date_component_value[component]
        end
      )
    end,
    date_component_name_ordered_arr = function(arr)
      return get.arr.arr_by_sorted(arr, transf.two_date_component_names.date_component_name_by_larger)
    end,
    largest_date_component_name = function(arr)
      return transf.date_component_name_arr.date_component_name_ordered_arr(
        arr
      )[1]
    end,
    smallest_date_component_name = function(arr)
      return transf.date_component_name_arr.date_component_name_ordered_arr(
        arr
      )[#arr]
    end,
    date_component_name_arr_inverse = function(arr)
      return transf.two_arrs.set_by_difference(ls.date.date_component_names, arr)
    end,
    rfc3339like_dt_separator_arr  = function(arr)
      return get.arr.arr_by_mapped_w_t_key_assoc(
        arr,
        tblmap.date_component_name.rfc3339like_dt_separator
      )
    end,
    rfc3339like_dt_str_format_part_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_key_assoc(
        arr,
        tblmap.date_component_name.rfc3339like_dt_str_format_part
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
    date_component_name_value_assoc = function(str)
      local comps = {get.str.n_strs_by_extracted_onig(str, r.g.date.rfc3339like_dt)}
      return get.table.table_by_mapped_w_kt_vt_arg_kt_vt_ret_fn(ls.date.date_component_names, function(k, v)
        return v and get.str_or_number.number_or_nil(comps[k]) or nil
      end)
    end,
    date_interval_specifier = function(str)
      return transf.date_component_name_value_assoc.date_interval_specifier(transf.rfc3339like_dt.date_component_name_value_assoc(str))
    end,
    min_full_date_component_name_value_assoc = function(str)
      return transf.date_component_name_value_assoc.min_full_date_component_name_value_assoc(
        transf.rfc3339like_dt.date_component_name_value_assoc(str)
      )
    end,
    max_full_date_component_name_value_assoc = function(str)
      return transf.date_component_name_value_assoc.max_full_date_component_name_value_assoc(
        transf.rfc3339like_dt.date_component_name_value_assoc(str)
      )
    end,
    min_date = function(str)
      return transf.full_date_component_name_value_assoc.date(
        transf.rfc3339like_dt.min_full_date_component_name_value_assoc(str)
      )
    end,
    max_date = function(str)
      return transf.full_date_component_name_value_assoc.date(
        transf.rfc3339like_dt.max_full_date_component_name_value_assoc(str)
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
      transf.full_date_component_name_value_assoc.date(
        transf.rfc3339like_dt.date_component_name_value_assoc(str)
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
      return get.str.str_arr_by_split_w_string(str, "_to_")[1]
    end,
    start_date_component_name_value_assoc = function(str)
      return transf.rfc3339like_dt.date_component_name_value_assoc(
        transf.rfc3339like_interval.start_rfc3339like_dt(str)
      )
    end,
    start_min_full_date_component_name_value_assoc = function(str)
      return transf.date_component_name_value_assoc.min_full_date_component_name_value_assoc(
        transf.rfc3339like_interval.start_date_component_name_value_assoc(str)
      )
    end,
    start_min_date = function(str)
      return transf.full_date_component_name_value_assoc.date(
        transf.rfc3339like_interval.start_min_full_date_component_name_value_assoc(str)
      )
    end,
    end_rfc3339like_dt = function(str)
      return get.str.str_arr_by_split_w_string(str, "_to_")[2]
    end,
    end_date_component_name_value_assoc = function(str)
      return transf.rfc3339like_dt.date_component_name_value_assoc(
        transf.rfc3339like_interval.end_rfc3339like_dt(str)
      )
    end,
    end_max_full_date_component_name_value_assoc = function(str)
      return transf.date_component_name_value_assoc.max_full_date_component_name_value_assoc(
        transf.rfc3339like_interval.end_date_component_name_value_assoc(str)
      )
    end,
    end_min_full_date_component_name_value_assoc = function(str)
      return transf.date_component_name_value_assoc.min_full_date_component_name_value_assoc(
        transf.rfc3339like_interval.end_date_component_name_value_assoc(str)
      )
    end,
    end_max_date = function(str)
      return transf.full_date_component_name_value_assoc.date(
        transf.rfc3339like_interval.end_max_full_date_component_name_value_assoc(str)
      )
    end,
    end_min_date = function(str)
      return transf.full_date_component_name_value_assoc.date(
        transf.rfc3339like_interval.end_min_full_date_component_name_value_assoc(str)
      )
    end,
    start_smallest_date_component_set = function(str)
      return transf.date_component_name_value_assoc.smallest_date_component_set(
        transf.rfc3339like_interval.start_date_component_name_value_assoc(str)
      )
    end,
    end_smallest_date_component_set = function(str)
      return transf.date_component_name_value_assoc.smallest_date_component_set(
        transf.rfc3339like_interval.end_date_component_name_value_assoc(str)
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
      if get.str.bool_by_contains_w_ascii_str(str, "_to_") then
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
      ].date_interval_specifier_or_nil(str)
    end,
  },
  rf3339like_dt_or_interval_arr = {
    date_interval_specifier_arr = function(rf3339like_dt_or_interval_arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(rf3339like_dt_or_interval_arr, transf.rf3339like_dt_or_interval.date_interval_specifier)
    end,
  },
  basic_interval_str = {
    start_stop = function(str)
      return get.str.str_arr_by_split_w_ascii_char(str, "-")
    end,
    interval_specifier = function(str)
      local start, stop = transf.basic_interval_str.start_stop(str)
      return {
        start = start,
        stop = stop,
      }
    end,
  },
  single_value_or_basic_interval_str = {
    interval_specifier = function(str)
      if get.str.bool_by_contains_w_ascii_str(str, "-") then
        return transf.basic_interval_str.interval_specifier(str)
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
    arr = function(sequence)
      return transf.start_stop_step_unit.arr(sequence.start, sequence.stop, sequence.step, sequence.unit)
    end,
    interval_specifier = function(sequence)
      return {
        start = sequence.start,
        stop = sequence.stop,
      }
    end,
  },
  interval_specifier_arr = {
    interval_specifier_with_earliest_start = function(interval_specifier_arr)
      return hs.fnutils.reduce(
        interval_specifier_arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.table_and_table.smaller_table_by_key, {a_use, a_use, "start"})
      )
    end,
    earliest_start = function(interval_specifier_arr)
      return transf.interval_specifier_arr.interval_specifier_with_earliest_start(
          interval_specifier_arr
        ).start
    end,
    interval_specifier_with_latest_start = function(interval_specifier_arr)
      return hs.fnutils.reduce(
        interval_specifier_arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.table_and_table.larger_table_by_key, {a_use, a_use, "start"})
      )
    end,
    latest_start = function(interval_specifier_arr)
      return transf.interval_specifier_arr.interval_specifier_with_latest_start(
          interval_specifier_arr
        ).start
    end,
    interval_specifier_with_latest_stop = function(interval_specifier_arr)
      return hs.fnutils.reduce(
        interval_specifier_arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.table_and_table.larger_table_by_key, {a_use, a_use, "stop"})
      )
    end,
    latest_stop = function(interval_specifier_arr)
      return transf.interval_specifier_arr.interval_specifier_with_latest_stop(
          interval_specifier_arr
        ).stop
    end,
    interval_specifier_with_earliest_stop = function(interval_specifier_arr)
      return hs.fnutils.reduce(
        interval_specifier_arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.table_and_table.smaller_table_by_key, {a_use, a_use, "stop"})
      )
    end,
    earliest_stop = function(interval_specifier_arr)
      return transf.interval_specifier_arr.interval_specifier_with_earliest_stop(
          interval_specifier_arr
        ).stop
    end,
    intersection_interval_specifier = function(interval_specifier_arr)
      return {
        start = transf.interval_specifier_arr.latest_start(interval_specifier_arr),
        stop = transf.interval_specifier_arr.earliest_stop(interval_specifier_arr),
      }
    end,
    intrval_specifier_by_union = function(interval_specifier_arr)
      return {
        start = transf.interval_specifier_arr.earliest_start(interval_specifier_arr),
        stop = transf.interval_specifier_arr.latest_stop(interval_specifier_arr),
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
    full_rfc3339like_dt_by_start = function(date_interval_specifier)
      return transf.date.full_rfc3339like_dt(date_interval_specifier.start)
    end,
    full_rfc3339like_dt_by_end = function(date_interval_specifier)
      return transf.date.full_rfc3339like_dt(date_interval_specifier.stop)
    end,
    start_full_date_component_name_value_assoc = function(date_interval_specifier)
      return transf.date.full_date_component_name_value_assoc(date_interval_specifier.start)
    end,
    end_full_date_component_name_value_assoc = function(date_interval_specifier)
      return transf.date.full_date_component_name_value_assoc(date_interval_specifier.stop)
    end,
    start_prefix_date_component_name_value_assoc_where_date_component_value_is_not_min_date_component_value = function(date_interval_specifier)
      return transf.date_component_name_value_assoc.prefix_date_component_name_value_assoc_where_date_component_value_is_not_min_date_component_value(
        transf.date_interval_specifier.start_full_date_component_name_value_assoc(date_interval_specifier)
      )
    end,
    end_prefix_date_component_name_value_assoc_where_date_component_value_is_not_max_date_component_value = function(date_interval_specifier)
      return transf.date_component_name_value_assoc.prefix_date_component_name_value_assoc_where_date_component_value_is_not_max_date_component_value(
        transf.date_interval_specifier.end_full_date_component_name_value_assoc(date_interval_specifier)
      )
    end,
    start_rfc3339like_dt_where_date_component_value_is_not_min_date_component_value = function(date_interval_specifier)
      return transf.date_component_name_value_assoc.rfc3339like_dt(
        transf.date_interval_specifier.start_prefix_date_component_name_value_assoc_where_date_component_value_is_not_min_date_component_value(date_interval_specifier)
      )
    end,
    end_rfc3339like_dt_where_date_component_value_is_not_max_date_component_value = function(date_interval_specifier)
      return transf.date_component_name_value_assoc.rfc3339like_dt(
        transf.date_interval_specifier.end_prefix_date_component_name_value_assoc_where_date_component_value_is_not_max_date_component_value(date_interval_specifier)
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
  date_component_name_value_assoc = {
    date_component_name_list_set = function(date_component_name_value_assoc)
      return transf.table_or_nil.kt_arr(date_component_name_value_assoc)
    end,
    date_component_value_list_set = function(date_component_name_value_assoc)
      return transf.table_or_nil.vt_arr(date_component_name_value_assoc)
    end,
    date_component_name_list_not_set = function(date_component_name_value_assoc)
      return transf.date_component_name_arr.date_component_name_arr_inverse(transf.date_component_name_value_assoc.date_component_name_list_set(date_component_name_value_assoc))
    end,
    date_component_value_list_not_set = function(date_component_name_value_assoc)
      return get.date_component_name_list.date_component_value_list(
        transf.date_component_name_value_assoc.date_component_name_list_not_set(date_component_name_value_assoc),
        date_component_name_value_assoc
      )
    end,
    date_component_name_ordered_list_set = function(date_component_name_value_assoc)
      return transf.date_component_name_arr.date_component_name_ordered_arr(transf.date_component_name_value_assoc.date_component_name_list_set(date_component_name_value_assoc))
    end,
    date_component_value_ordered_list_set = function(date_component_name_value_assoc)
      return get.date_component_name_list.date_component_value_ordered_list(
        transf.date_component_name_value_assoc.date_component_name_list_set(date_component_name_value_assoc),
        date_component_name_value_assoc
      )
    end,
    date_component_name_ordered_list_not_set = function(date_component_name_value_assoc)
      return transf.date_component_name_arr.date_component_name_ordered_arr(transf.date_component_name_value_assoc.date_component_name_list_not_set(date_component_name_value_assoc))
    end,
    largest_date_component_name_set = function(date_component_name_value_assoc)
      return transf.date_component_name_arr.largest_date_component_name(transf.date_component_name_value_assoc.date_component_name_list_set(date_component_name_value_assoc))
    end,
    smallest_date_component_name_set = function(date_component_name_value_assoc)
      return transf.date_component_name_arr.smallest_date_component_name(transf.date_component_name_value_assoc.date_component_name_list_set(date_component_name_value_assoc))
    end,
    largest_date_component_name_not_set = function(date_component_name_value_assoc)
      return transf.date_component_name_arr.largest_date_component_name(transf.date_component_name_value_assoc.date_component_name_list_not_set(date_component_name_value_assoc))
    end,
    smallest_date_component_name_not_set = function(date_component_name_value_assoc)
      return transf.date_component_name_arr.smallest_date_component_name(transf.date_component_name_value_assoc.date_component_name_list_not_set(date_component_name_value_assoc))
    end,
    min_date_component_name_value_assoc_not_set = function(date_component_name_value_assoc)
      return transf.date_component_name_arr.min_date_component_name_value_assoc(transf.date_component_name_value_assoc.date_component_name_list_not_set(date_component_name_value_assoc))
    end,
    max_date_component_name_value_assoc_not_set = function(date_component_name_value_assoc)
      return transf.date_component_name_arr.max_date_component_name_value_assoc(transf.date_component_name_value_assoc.date_component_name_list_not_set(date_component_name_value_assoc))
    end,
    min_full_date_component_name_value_assoc = function(date_component_name_value_assoc)
      return transf.two_tables.table_by_take_new(
        date_component_name_value_assoc,
        transf.date_component_name_value_assoc.min_date_component_name_value_assoc_not_set(date_component_name_value_assoc)
      )
    end,
    max_full_date_component_name_value_assoc = function(date_component_name_value_assoc)
      return transf.two_tables.table_by_take_new(
        date_component_name_value_assoc,
        transf.date_component_name_value_assoc.max_date_component_name_value_assoc_not_set(date_component_name_value_assoc)
      )
    end,
    date_interval_specifier = function(date_component_name_value_assoc)
      return {
        start = date(transf.date_component_name_value_assoc.min_full_date_component_name_value_assoc(date_component_name_value_assoc)),
        stop = date(transf.date_component_name_value_assoc.max_full_date_component_name_value_assoc(date_component_name_value_assoc))
      }
    end, 
    prefix_date_component_name_value_assoc = function(date_component_name_value_assoc)
      local res = {}
      for _, date_component_name in transf.arr.index_value_stateless_iter(ls.date.date_component_names) do
        if date_component_name_value_assoc[date_component_name] == nil then
          return res
        end
        res[date_component_name] = date_component_name_value_assoc[date_component_name]
      end
    end,
    prefix_date_component_name_list_set = function(date_component_name_value_assoc)
      return transf.date_component_name_value_assoc.date_component_name_list_set(
        transf.date_component_name_value_assoc.prefix_date_component_name_value_assoc(date_component_name_value_assoc)
      )
    end,
    prefix_date_component_name_ordered_list_set = function(date_component_name_value_assoc)
      return transf.date_component_name_arr.date_component_name_ordered_list_set(
        transf.date_component_name_value_assoc.prefix_date_component_name_value_assoc(date_component_name_value_assoc)
      )
    end,
    --- gets a date_component_names_ordered_list which has all date_component_names where there is a date_component_name within the date_component_name_value_assoc that is smaller and equal that is not nil
    --- i.e. { month = 02, hour = 12 } will return { "year", "month", "day", "hour" }
    --- this should be equal to prefix_date_component_name_ordered_list_set if date_component_name_value_assoc is a prefix_date_component_name_value_assoc since prefix_ is defined as having no nil values before potential trailing nil values
    prefix_date_component_name_ordered_list_no_trailing_nil = function(date_component_name_value_assoc)
      local ol = get.table.table_by_copy(ls.date.date_component_names)
      while(date_component_name_value_assoc[
        ol[#ol]
      ] == nil) do
        ol[#ol] = nil
      end
      return ol
    end,
    rfc3339like_dt_str_format_part_specifier_arr = function(date_component_name_value_assoc)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        transf.date_component_name_value_assoc.prefix_date_component_name_ordered_list_no_trailing_nil(date_component_name_value_assoc),
        function(date_component_name)
          return {
            fallback = tblmap.date_component_name.rfc3339like_dt_str_format_part_fallback[date_component_name],
            value = date_component_name_value_assoc[date_component_name],
            str_format_part = tblmap.date_component_name.rfc3339like_dt_str_format_part[date_component_name]
          }
        end
      )
    end,
    rfc3339like_dt = function(date_component_name_value_assoc)
      local res = transf.str_format_part_specifier_arr.str(
        transf.date_component_name_value_assoc.rfc3339like_dt_str_format_part_specifier_arr(date_component_name_value_assoc)
      )
      if res:sub(-1) == "Z" then
        return res
      else
        return res:sub(1, -2) -- not full rfc3339like_dt, thus the trailing sep will be something like - or : and must be removed
      end
    end,
    date_component_name_value_assoc_where_date_component_value_is_max_date_component_value = function(date_component_name_value_assoc)
      return get.assoc.assoc_by_filtered_w_kt_vt_fn(
        date_component_name_value_assoc,
        function(k, v) return v == tblmap.date_component_name.max_date_component_value[k] end
      )
    end,
    date_component_name_value_assoc_where_date_component_value_is_min_date_component_value = function(date_component_name_value_assoc)
      return get.assoc.assoc_by_filtered_w_kt_vt_fn(
        date_component_name_value_assoc,
        function(k, v) return v == tblmap.date_component_name.min_date_component_value[k] end
      )
    end,
    date_component_name_value_assoc_where_date_component_value_is_not_max_date_component_value = function(date_component_name_value_assoc)
      return get.assoc.assoc_by_filtered_w_kt_vt_fn(
        date_component_name_value_assoc,
        function(k, v) return v ~= tblmap.date_component_name.max_date_component_value[k] end
      )
    end,
    date_component_name_value_assoc_where_date_component_value_is_not_min_date_component_value = function(date_component_name_value_assoc)
      return get.assoc.assoc_by_filtered_w_kt_vt_fn(
        date_component_name_value_assoc,
        function(k, v) return v ~= tblmap.date_component_name.min_date_component_value[k] end
      )
    end,
    prefix_date_component_name_value_assoc_where_date_component_value_is_not_max_date_component_value = function(date_component_name_value_assoc)
      local date_component_name_value_assoc_where_date_component_value_is_not_max_date_component_value = transf.date_component_name_value_assoc.date_component_name_value_assoc_where_date_component_value_is_not_max_date_component_value(date_component_name_value_assoc)
      return transf.date_component_name_value_assoc.prefix_date_component_name_value_assoc(date_component_name_value_assoc_where_date_component_value_is_not_max_date_component_value)
    end,
    prefix_date_component_name_value_assoc_where_date_component_value_is_not_min_date_component_value = function(date_component_name_value_assoc)
      local date_component_name_value_assoc_where_date_component_value_is_not_min_date_component_value = transf.date_component_name_value_assoc.date_component_name_value_assoc_where_date_component_value_is_not_min_date_component_value(date_component_name_value_assoc)
      return transf.date_component_name_value_assoc.prefix_date_component_name_value_assoc(date_component_name_value_assoc_where_date_component_value_is_not_min_date_component_value)
    end,
    

  },
  str_format_part_specifier = {
    str = function(str_format_part_specifier)
      local succ, res = pcall(str_format_part_specifier.str_format_part, str_format_part_specifier.value)
      local finalres 
      if succ then
        finalres = res
      else
        finalres = str_format_part_specifier.fallback
      end
      if finalres then
        return finalres .. (str_format_part_specifier.suffix or "")
      else
        return ""
      end
    end
  },
  str_format_part_specifier_arr = {
    str = function(str_format_part_specifier_arr)
      return get.str_or_number_arr.str_by_joined(
        get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
          str_format_part_specifier_arr,
          transf.str_format_part_specifier.str
        ),
        ""
      )
    end
  },
  prefix_date_component_name_value_assoc = {
    
    
  },
  suffix_date_component_name_value_assoc = {

  },
  partial_date_component_name_value_assoc = {

  },
  -- date components are full if all components are set
  full_date_component_name_value_assoc = {
    date = function(full_date_component_name_value_assoc)
      return date(full_date_component_name_value_assoc)
    end,
    timestamp_s = function(full_date_component_name_value_assoc)
      return os.time(full_date_component_name_value_assoc)
    end,
    timestamp_ms = function(full_date_component_name_value_assoc)
      return transf.date.timestamp_s(full_date_component_name_value_assoc) * 1000
    end,
    full_rfc3339like_dt = function(full_date_component_name_value_assoc)
      return transf.date.full_rfc3339like_dt(
        transf.full_date_component_name_value_assoc.date(full_date_component_name_value_assoc)
      )
    end,
  },
  iban = {
    cleaned_iban = function(iban)
      return select(1, get.str.str_and_int_by_replaced_eutf8_w_regex_str(iban, "[ %-_]", ""))
    end,
    bic = function(iban)
      return transf.cleaned_iban.bic(transf.iban.cleaned_iban(iban))
    end,
    bank_name = function(iban)
      return transf.cleaned_iban.bank_name(transf.iban.cleaned_iban(iban))
    end,
    iban_bic_bank_name_arr = function(iban)
      return {iban, transf.iban.bic(iban), transf.iban.bank_name(iban)}
    end,
    bank_details_str = function(iban)
      return get.str_or_number_arr.str_by_joined(
        transf.iban.iban_bic_bank_name_arr(iban),
        "\n"
      )
    end,
    separated_iban = function(iban)
      return transf.cleaned_iban.separated_iban(transf.iban.cleaned_iban(iban))
    end,
  },
  cleaned_iban = {
    data = function(iban)
      local res = get.fn.rt_or_nil_by_memoized_invalidate_1_month(rest, "rest")({
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
      return get.str_or_number_arr.str_by_joined(
        get.str.str_arr_groups_utf8_from_end(
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

      -- The raw contact data, which is in yaml str format, is transformed into a table. 
      -- This is done because table format is easier to handle and manipulate in Lua.
      local contact_table = transf.yaml_str.not_userdata_or_function(raw_contact)

      -- In the vCard standard, some properties can have vcard_types. 
      -- For example, a phone number can be 'work' or 'home'. 
      -- Here, we're iterating over the keys in the contact data that have associated vcard_types.
      for _, vcard_key in transf.arr.index_value_stateless_iter(ls.vcard.keys_with_vcard_type) do
      
          -- We iterate over each of these keys. Each key can have multiple vcard_types, 
          -- which we get as a comma-separated str (type_list). 
          -- We also get the corresponding value for these vcard_types.
          for type_list, value in transf.arr.index_value_stateless_iter(contact_table[vcard_key]) do
          
              -- We split the type_list into individual vcard_types. This is done because 
              -- each vcard_type might need to be processed independently in the future. 
              -- It also makes the data more structured and easier to handle.
              local vcard_types = get.str.str_arr_by_split_w_string(type_list, ", ")
        
              -- For each vcard_type, we create a new key-value two_anys_arr in the contact_table. 
              -- This way, we can access the value directly by vcard_type, 
              -- without needing to parse the type_list each time.
              for _, vcard_type in transf.arr.index_value_stateless_iter(vcard_types) do
                  contact_table[vcard_key][vcard_type] = value
              end
          end
      end

      -- Here, we're handling the 'Addresses' key separately. Each address is a table itself,
      -- and we're adding a 'contact' field to each of these tables. 
      -- This 'contact' field holds the complete contact information.
      -- This could be useful in scenarios where address tables are processed individually,
      -- and there's a need to reference back to the full contact details.
      for _, address_table in transf.arr.index_value_stateless_iter(contact_table["Addresses"]) do
          address_table.contact = contact_table
      end
      
      -- Finally, we return the contact_table, which now has a more structured and accessible format.
      return contact_table
    end

  },
  uuid = {
    raw_contact = function(uuid)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)( "khard show --format=yaml uid:" .. uuid)
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
      if is.any.table(contact_table.homepage_raw) then
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
      return get.str_or_number.number_or_nil(contact_table.Private["translation-rate"])
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
    bank_details_str = function (contact_table)
      return transf.iban.bank_details_str(transf.contact_table.iban(contact_table))
    end,
    personal_tax_number = function (contact_table)
      return get.contact_table.tax_number(contact_table, "personal")
    end,
    full_name_western_arr = function(contact_table)
      return transf.hole_y_arrlike.arr({ 
        transf.contact_table.name_pref(contact_table),
        transf.contact_table.first_name(contact_table),
        transf.contact_table.middle_name(contact_table),
        transf.contact_table.last_name(contact_table),
        transf.contact_table.name_suf(contact_table)
      })
    end,
    full_name_western = function(contact_table)
      return get.str_or_number_arr.str_by_joined(
        transf.contact_table.full_name_western_arr(contact_table),
        " "
      )
    end,
    normal_name_western_arr = function(contact_table)
      return transf.hole_y_arrlike.arr({ 
        transf.contact_table.first_name(contact_table),
        transf.contact_table.last_name(contact_table),
      })
    end,
    normal_name_western = function(contact_table)
      return get.str_or_number_arr.str_by_joined(
        transf.contact_table.normal_name_western_arr(contact_table),
        " "
      )
    end,
    main_name = function(contact_table)
      return transf.contact_table.pref_name(contact_table) or transf.contact_table.normal_name_western(contact_table)
    end,
    full_name_eastern_arr = function(contact_table)
      return transf.hole_y_arrlike.arr({ 
        transf.contact_table.name_pref(contact_table),
        transf.contact_table.last_name(contact_table),
        transf.contact_table.first_name(contact_table),
        transf.contact_table.name_suf(contact_table)
      })
    end,
    full_name_eastern = function(contact_table)
      return get.str_or_number_arr.str_by_joined(
        transf.contact_table.full_name_eastern_arr(contact_table),
        " "
      )
    end,
    normal_name_eastern_arr = function(contact_table)
      return transf.hole_y_arrlike.arr({ 
        transf.contact_table.last_name(contact_table),
        transf.contact_table.first_name(contact_table),
      })
    end,
    normal_name_eastern = function(contact_table)
      return get.str_or_number_arr.str_by_joined(
        transf.contact_table.normal_name_eastern_arr(contact_table),
        " "
      )
    end,
    name_additions_arr = function(contact_table)
      return transf.hole_y_arrlike.arr({ 
        transf.contact_table.title(contact_table),
        transf.contact_table.role(contact_table),
        transf.contact_table.organization(contact_table),
      })
    end,
    name_additions = function(contact_table)
      return get.str_or_number_arr.str_by_joined(
        transf.contact_table.name_additions_arr(contact_table),
        ", "
      )
    end,
    indicated_nickname = function(contact_table)
      return '"' .. transf.contact_table.nickname(contact_table) .. '"'
    end,
    main_name_iban_bic_bank_name_arr = function(contact_table)
      return {
        transf.contact_table.main_name(contact_table),
        transf.contact_table.iban(contact_table),
        transf.contact_table.bic(contact_table),
        transf.contact_table.bank_name(contact_table),
      }
    end,
    name_bank_details_str = function(contact_table)
      return get.str_or_number_arr.str_by_joined(
        transf.contact_table.main_name_iban_bic_bank_name_arr(contact_table),
        "\n"
      )
    end,
    vcard_type_phone_number_assoc = function (contact_table)
      return contact_table.Phone
    end,
    phone_number_arr = function (contact_table)
      return transf.table.vt_set(transf.contact_table.vcard_type_phone_number_assoc(contact_table))
    end,
    phone_number_str = function (contact_table)
      return get.str_or_number_arr.str_by_joined(transf.contact_table.phone_number_arr(contact_table), ", ")
    end,
    vcard_type_email_assoc = function (contact_table)
      return contact_table.Email
    end,
    email_arr = function (contact_table)
      return transf.table.vt_set(transf.contact_table.vcard_type_email_assoc(contact_table))
    end,
    email_str = function (contact_table)
      return get.str_or_number_arr.str_by_joined(transf.contact_table.email_arr(contact_table), ", ")
    end,
    vcard_type_address_table_assoc = function (contact_table)
      return contact_table.Addresses
    end,
    address_table_arr = function (contact_table)
      return transf.table.vt_set(transf.contact_table.vcard_type_address_table_assoc(contact_table))
    end,
    summary = function (contact_table)
      local sumstr = transf.contact_table.full_name_western(contact_table)
      if transf.contact_table.nickname(contact_table) then
        sumstr = sumstr .. " " .. transf.contact_table.indicated_nickname(contact_table)
      end
      if transf.contact_table.name_additions(contact_table) then
        sumstr = sumstr .. " (" .. transf.contact_table.name_additions(contact_table) .. ")"
      end
      if transf.contact_table.phone_number_str(contact_table) ~= "" then
        sumstr = sumstr .. " [" .. transf.contact_table.phone_number_str(contact_table) .. "]"
      end
      if transf.contact_table.email_str(contact_table) ~= "" then
        sumstr = sumstr .. " <" .. transf.contact_table.email_str(contact_table) .. ">"
      end
    end,
    main_email = function (contact_table)
      return get.contact_table.email(contact_table, "pref") or transf.contact_table.email_arr(contact_table)[1]
    end,
    main_phone_number = function (contact_table)
      return get.contact_table.phone_number(contact_table, "pref") or transf.contact_table.phone_number_arr(contact_table)[1]
    end,
    main_address_table = function (contact_table)
      return get.contact_table.address_table(contact_table, "pref") or transf.contact_table.address_table_arr(contact_table)[1]
    end,
    main_relevant_address_label = function (contact_table)
      return transf.address_table.relevant_address_label(
        transf.contact_table.main_address_table(contact_table)
      )
    end

  },
  vcard_type_assoc = {
    vcard_types = function (vcard_type_assoc)
      return transf.table_or_nil.kt_arr(vcard_type_assoc)
    end
  },
  vcard_type_address_table_assoc = {

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
    country_identifier_str = function(single_address_table)
      return single_address_table.Country
    end,
    iso_3366_1_alpha_2_country_code = function(single_address_table)
      return transf.country_identifier_str.iso_3366_1_alpha_2_country_code(
        transf.address_table.country_identifier_str(single_address_table)
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
    addressee_arr = function(single_address_table)
      return transf.hole_y_arrlike.arr({
        transf.contact_table.main_name(single_address_table.contact),
        transf.address_table.extended(single_address_table)
      })
    end,
    in_country_location_arr = function(single_address_table)
      return transf.hole_y_arrlike.arr({
        transf.address_table.street(single_address_table),
        transf.address_table.postal_code(single_address_table),
        transf.address_table.city(single_address_table),
      })
    end,
    international_location_arr = function(single_address_table)
      return transf.hole_y_arrlike.arr({
        transf.address_table.street(single_address_table),
        transf.address_table.postal_code(single_address_table),
        transf.address_table.city(single_address_table),
        transf.address_table.region(single_address_table),
        transf.address_table.country_identifier(single_address_table),
      })
    end,
    relevant_location_arr = function(single_address_table)
      if transf.address_table.iso_3366_1_alpha_2_country_code(single_address_table) == "de" then
        return transf.address_table.in_country_location_arr(single_address_table)
      else
        return transf.address_table.international_location_arr(single_address_table)
      end
    end,
    in_country_address_arr = function(single_address_table)
      return transf.two_arrs.arr_by_appended(
        transf.address_table.addressee_arr(single_address_table),
        transf.address_table.in_country_location_arr(single_address_table)
      )
    end,
    international_address_arr = function(single_address_table)
      return transf.two_arrs.arr_by_appended(
        transf.address_table.addressee_arr(single_address_table),
        transf.address_table.international_location_arr(single_address_table)
      )
    end,
    relevant_address_arr = function(single_address_table)
      if transf.address_table.iso_3366_1_alpha_2_country_code(single_address_table) == "de" then
        return transf.address_table.in_country_address_arr(single_address_table)
      else
        return transf.address_table.international_address_arr(single_address_table)
      end
    end,
    in_country_address_label = function(single_address_table)
      return 
        get.str_or_number_arr.str_by_joined(transf.address_table.addressee_arr(single_address_table), "\n") .. "\n" ..
        transf.address_table.street(single_address_table) .. "\n" ..
        transf.address_table.postal_code_city_line(single_address_table)
    end,
    international_address_label = function(single_address_table)
      return 
        get.str_or_number_arr.str_by_joined(transf.address_table.addressee_arr(single_address_table), "\n") .. "\n" ..
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
      return get.fn.rt_or_nil_by_memoized_invalidate_1_month(rest)({
        api_name = "youtube",
        endpoint = "videos",
        params = {
          id = id,
          part = "snippet,status",
        },
      }).items[1]
    end,
    str_by_title = function(id)
      return transf.youtube_video_id.youtube_video_item(id).snippet.title
    end,
    str_by_cleaned_title = function(id)
      return transf.str.str_by_cleaned_youtube_video_title(
        transf.youtube_video_id.str_by_title(id)
      )
    end,
    str_by_channel_title = function(id)
      return transf.youtube_video_id.youtube_video_item(id).snippet.channelTitle
    end,
    str_by_cleaned_channel_title = function(id)
      return transf.str.str_by_cleaned_youtube_video_channel_title(
        transf.youtube_video_id.str_by_channel_title(id)
      )
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
      return get.fn.rt_or_nil_by_memoized_invalidate_1_month(rest)({
        api_name = "youtube",
        endpoint = "captions",
        params = {
          videoId = id,
          part = "snippet",
        },
      }).items
    end,
    fs_tag_assoc = function(id)
      local assoc = transf.form_filling_specifier.filled_str_assoc({
        in_fields = {
          title = transf.youtube_video_id.str_by_title(id),
          channel_title = transf.youtube_video_id.str_by_channel_title(id),
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
          }
        }
      })
      return get.table.table_by_mapped_w_vt_arg_vt_ret_fn(
        assoc,
        transf.str.lower_alphanum_underscore_str_by_romanized
      )
    end
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
      return transf.youtube_video_id.str_by_title(transf.youtube_video_url.youtube_video_id(url))
    end,
    channel_title = function(url)
      return transf.youtube_video_id.str_by_channel_title(transf.youtube_video_url.youtube_video_id(url))
    end,
    fs_tag_assoc = function(url)
      return transf.youtube_video_id.fs_tag_assoc(transf.youtube_video_url.youtube_video_id(url))
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
      return get.fn.rt_or_nil_by_memoized_invalidate_1_month(rest, "rest")({
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
  handle = {
    youtube_channel_item = function(handle)
      return get.fn.rt_or_nil_by_memoized_invalidate_1_month(rest, "rest")({
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
      return get.str.str_by_sub_eutf8(handle, 2)
    end,
  },
  youtube_channel_url = {
    handle = function(url)
      return get.str.str_by_no_adfix(
        transf.url.path(url),
        "/"
      )
    end,
    youtube_channel_id = function(url)
      return transf.handle.youtube_channel_id(transf.youtube_channel_url.handle(url))
    end,
  },
  str = {
    raw_syn_output = function(str)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)( "syn -p" .. transf.str.str_by_single_quoted_escaped(str) )
    end,
    term_syn_specifier_assoc = function(str)
      local synonym_parts = get.str.str_arr_by_split_w_string(transf.str.raw_syn_output(str), "\n\n")
      local synonym_tables = get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        synonym_parts,
        function (synonym_part)
          local synonym_part_lines = get.str.str_arr_by_split_w_ascii_char(synonym_part, "\n")
          local synonym_term = get.str.str_by_sub_eutf8(synonym_part_lines[1], 2) -- syntax: ❯<term>
          local synonyms_raw = get.str.str_by_sub_eutf8(synonym_part_lines[2], 12) -- syntax:  ⬤synonyms: <term>{, <term>}
          local antonyms_raw = get.str.str_by_sub_eutf8(synonym_part_lines[3], 12) -- syntax:  ⬤antonyms: <term>{, <term>}
          local synonyms = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(get.str.str_arr_by_split_w_ascii_char(synonyms_raw, ", "), transf.str.not_starting_or_ending_with_whitespace_str)
          local antonyms = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(get.str.str_arr_by_split_w_ascii_char(antonyms_raw, ", "), transf.str.not_starting_or_ending_with_whitespace_str)
          return synonym_term, {
            synonyms = synonyms,
            antonyms = antonyms,
          }
        end
      )
      return synonym_tables
    end,
    raw_av_output = function (str)
      get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)(
        "synonym" .. transf.str.str_by_single_quoted_escaped(str)
      )
    end,
    title_case_policy = function(word)
      if get.arr.bool_by_contains(ls.small_words, word) then
        return word
      elseif eutf8.find(word, "%u") then -- words with uppercase letters are presumed to already be correctly title cased (acronyms, brands, the like)
        return word
      else
        return transf.str.str_by_first_eutf8_upper(word)
      end
    end,
    long_flag = function(word)
      return "--" .. word
    end,
    synonym_str_arr = function(str)
      local items = get.str.str_arr_by_split_w_ascii_char(transf.str.raw_av_output(str), "\t")
      items = get.arr.arr_by_filtered(items, function(itm)
        if itm == nil then
          return false
        end
        itm = transf.str.not_starting_or_ending_with_whitespace_str(itm)
        return #itm > 0
      end)
      return items
    end,
    consonants = function(str)
      error("todo")
    end,
    str_by_env_getter_comamnds_prepended = function(str)
      return get.str.str_by_formatted_w_n_anys(
        "base64 -d <<< '%s' | /opt/homebrew/bin/bash -s",
        transf.str.base64_gen_str_by_utf8(
          "cd && source \"$HOME/.target/envfile\" && " ..  str
        )
      )
    end,
    str_by_minimal_locale_setter_commands_prepended = function(str)
      return "LC_ALL=en_US.UTF-8 && LANG=en_US.UTF-8 && LANGUAGE=en_US.UTF-8 && " .. str
    end,
    str_or_str_and_8_bit_pos_int_by_evaled_raw_bash = function(str)
      local command = transf.str.str_by_minimal_locale_setter_commands_prepended(str)
      local output, status, reason, code = hs.execute(command)
      if status then
        return output -- stdout
      else
        return output, code -- stderr, exit code
      end
    end,
    str_or_str_and_8_bit_pos_int_by_evaled_raw_bash_stripped = function(str)
      local res, code = transf.str.str_or_str_and_8_bit_pos_int_by_evaled_raw_bash(str)
      res = transf.str.not_starting_or_ending_with_whitespace_str(res)
      return res, code
    end,
    str_or_nil_by_evaled_raw_bash_stripped = function(str)
      local res, code = transf.str.str_or_str_and_8_bit_pos_int_by_evaled_raw_bash_stripped(str)
      if code == 0 then
        return res
      else
        return nil
      end
    end,
    str_or_err_by_evaled_raw_bash_stripped = function(str)
      local res, code = transf.str.str_or_str_and_8_bit_pos_int_by_evaled_raw_bash_stripped(str)
      if code == 0 then
        return res
      else
        error("Exit code " .. code .. " for command " .. str ". Stderr:\n\n" .. res)
      end
    end,
    str_or_str_and_8_bit_pos_int_by_evaled_env_bash = function(str)
      local command = transf.str.str_by_env_getter_comamnds_prepended(str)
      local output, status, reason, code = hs.execute(command)
      if status then
        return output -- stdout
      else
        return output, code -- stderr, exit code
      end
    end,
    bool_by_evaled_env_bash_success = function(str)
      local res, code = transf.str.str_or_str_and_8_bit_pos_int_by_evaled_env_bash(str)
      return code == 0
    end,
    str_or_str_and_8_bit_pos_int_by_evaled_env_bash_stripped = function(str)
      local res, code = transf.str.str_or_str_and_8_bit_pos_int_by_evaled_env_bash(str)
      res = transf.str.not_starting_or_ending_with_whitespace_str(res)
      return res, code
    end,
    str_or_nil_by_evaled_env_bash_stripped = function(str)
      local res, code = transf.str.str_or_str_and_8_bit_pos_int_by_evaled_env_bash_stripped(str)
      if code == 0 then
        return res
      else
        return nil
      end
    end,
    str_or_err_by_evaled_env_bash_stripped = function(str)
      local res, code = transf.str.str_or_str_and_8_bit_pos_int_by_evaled_env_bash_stripped(str)
      if code == 0 then
        return res
      else
        error("Exit code " .. code .. " for command " .. str ". Stderr:\n\n" .. res)
      end
    end,
    str_or_err_by_evaled_env_bash = function(str)
      local res, code = transf.str.str_or_str_and_8_bit_pos_int_by_evaled_env_bash(str)
      if code == 0 then
        return res
      else
        error("Exit code " .. code .. " for command " .. str ". Stderr:\n\n" .. res)
      end
    end,
    str_or_err_by_evaled_env_bash_stripped_noempty = function(str)
      local res = transf.str.str_or_err_by_evaled_env_bash_stripped(str)
      if res == "" then
        error("Empty result for command " .. str)
      else
        return res
      end
    end,
    not_userdata_or_function_or_err_by_evaled_env_bash_parsed_json = function(str)
      local res = transf.str.str_or_err_by_evaled_env_bash_stripped_noempty(str)
      return transf.json_str.not_userdata_or_function(res)
    end,
    table_or_err_by_evaled_env_bash_parsed_json = function(str)
      local res = transf.str.not_userdata_or_function_or_err_by_evaled_env_bash_parsed_json(str)
      if is.any.table(res) then
        return res
      else
        error("Result for command " .. str .. " is not a table")
      end
    end,
    table_or_nil_by_evaled_env_bash_parsed_json = function(str)
      return transf.n_anys_or_err_ret_fn.n_anys_or_nil_ret_fn_by_pcall(
        transf.str.table_or_err_by_evaled_env_bash_parsed_json
      )(str)
    end,
    table_or_err_by_evaled_env_bash_parsed_json_err_error_key = function(str)
      local res = transf.str.table_or_err_by_evaled_env_bash_parsed_json(str)
      if res.error then
        error("Error for command " .. str .. ":\n\n" .. transf.not_userdata_or_function.json_str_pretty(res.error))
      else
        return res
      end
    end,
    table_or_nil_by_evaled_env_bash_parsed_json_nil_error_key = function(str)
      return transf.n_anys_or_err_ret_fn.n_anys_or_nil_ret_fn_by_pcall(
        transf.str.table_or_err_by_evaled_env_bash_parsed_json_err_error_key
      )(str)
    end,
    escaped_lua_regex = function(str)
      return get.str.str_by_prepended_all_w_ascii_str_arr(
        str,
        ls.lua_regex_metacharacters,
        "%"
      )
    end,
    escaped_general_regex = function(str)
      return get.str.str_by_prepended_all_w_ascii_str_arr(
        str,
        ls.general_regex_metacharacters,
        "%"
      )
    end,
    window_arr_by_pattern = function(str)
      local res = hs.window.find(str)
      if is.any.table(res) then return res 
      else return {res} end
    end,
    window_or_nil_by_title = hs.window.get,
    in_cache_dir = function(data, type)
      return env.XDG_CACHE_HOME .. "/hs/" .. (type or "default") .. "/" .. transf.str.safe_filename(data)
    end,
    in_tmp_dir = function(data, type) -- in contrast to the above method, we also ensure that it's unique by using a timestamp
      return env.TMPDIR .. "/hs/" .. (type or "default") .. "/" .. os.time() .. "-" .. transf.str.safe_filename(data)
    end,
    qr_utf8_image_bow = function(data)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)("qrencode -l M -m 2 -t UTF8 " .. transf.str.str_by_single_quoted_escaped(data))
    end,
    qr_utf8_image_wob = function(data)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_err_by_evaled_env_bash, {
        strify_table_params = true,
        table_param_subset = "json"
      })("qrencode -l M -m 2 -t UTF8i " .. transf.str.str_by_single_quoted_escaped(data))
    end,
    qr_png_in_cache = function(data)
      local path = transf.str.in_cache_dir(data, "qr")
      dothis.str.generate_qr_png(data, path)
      return path
    end,
    --- does the minimum to make a str safe for use as a filename, but doesn't impose any policy
    safe_filename = function(filename)
      -- Replace forward slash ("/") with underscore
      filename = get.str.str_and_int_by_replaced_eutf8_w_regex_str(filename, "/", "_")

      -- Replace control characters (ASCII values 0 - 31 and 127)
      for i = 0, 31 do
        filename = get.str.str_and_int_by_replaced_eutf8_w_regex_str(filename, transf.eight_bit_pos_int.ascii_char(i), "_")
      end
      filename = get.str.str_and_int_by_replaced_eutf8_w_regex_str(filename, transf.eight_bit_pos_int.ascii_char(127), "_")

      -- Replace sequences of whitespace characters with a single underscore
      filename = get.str.str_and_int_by_replaced_eutf8_w_regex_str(filename, "%s+", "_")

      if filename == "." then
        filename = "_"
      elseif filename == ".." then
        filename = "__"
      end

      if #filename > 255 then
        filename = get.str.str_by_sub_eutf8(filename, 1, 255)
      elseif #filename == 0 then
        filename = "_"
      end
      
      return filename
    end,
    alphanum_underscore = function(str)
      local naive_alphanum_underscore = get.str.str_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "[^%w%d]+", "_")
      local multi_cleaned_alphanum_underscore = get.str.str_by_continuous_collapsed_eutf8_w_regex_quantifiable(naive_alphanum_underscore, "_")
      return get.str.str_by_no_adfix(multi_cleaned_alphanum_underscore, "_")
    end,
    lower_alphanum_underscore = function(str)
      return transf.str.str_by_all_eutf8_lower(transf.str.alphanum_underscore(str))
    end,
    upper_alphanum_underscore = function(str)
      return transf.str.str_by_all_eutf8_upper(transf.str.alphanum_underscore(str))
    end,
    alphanum_array = function(str) -- word separation is notoriously tricky. For now, we'll just use the same logic as in the snake_case function
      return get.str.str_arr_by_split_w_ascii_char(transf.str.alphanum_underscore(str), "_")
    end,
    upper_camel_snake_case = function(str)
      local parts = transf.str.alphanum_array(str)
      local upper_parts = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(parts, transf.str.str_by_first_eutf8_upper)
      return get.str_or_number_arr.str_by_joined(upper_parts, "_")
    end,
    lower_camel_snake_case = function(str)
      return transf.str.str_by_all_eutf8_lower(transf.str.upper_camel_snake_case(str))
    end,
    upper_camel_case = function(str)
      local parts = transf.str.alphanum_array(str)
      local upper_parts = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(parts, transf.str.str_by_first_eutf8_upper)
      return get.str_or_number_arr.str_by_joined(upper_parts, "")
    end,
    lower_camel_case = function(str)
      return transf.str.str_by_all_eutf8_lower(transf.str.upper_camel_case(str))
    end,
    kebap_case = function(str)
      local naive_kebap_case = get.str.str_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "[^%w%d]+", "-")
      local multi_cleaned_kebap_case = get.str.str_by_continuous_collapsed_eutf8_w_regex_quantifiable(naive_kebap_case, "-")
      return get.str.str_by_no_adfix(multi_cleaned_kebap_case, "-")
    end,
    lower_kebap_case = function(str)
      return transf.str.str_by_all_eutf8_lower(transf.str.kebap_case(str))
    end,
    upper_kebap_case = function(str)
      return transf.str.str_by_all_eutf8_upper(transf.str.kebap_case(str))
    end,
    str_by_all_eutf8_lower = eutf8.lower,
    str_by_all_eutf8_upper = eutf8.upper,
    str_by_first_eutf8_upper = function(str)
      return transf.str.str_by_all_eutf8_upper(get.str.str_by_sub_eutf8(str, 1, 1)) .. get.str.str_by_sub_eutf8(str, 2)
    end,
    str_by_first_eutf8_lower = function(str)
      return transf.str.str_by_all_eutf8_lower(get.str.str_by_sub_eutf8(str, 1, 1)) .. get.str.str_by_sub_eutf8(str, 2)
    end,
    alphanum = function(str)
      return get.str.str_by_removed_eutf8_w_regex_quantifiable(str, "[^%w%d]")
    end,
    encoded_query_param_value = function(str)
      return plurl.quote(str, true)
    end,
    encoded_query_param_value_by_folded = function(str)
      local folded = transf.str.singleline_str_by_folded(str)
      return transf.str.encoded_query_param_value(folded)
    end,
    str_by_percent_decoded_also_plus = plurl.unquote,
    str_by_percent_decoded_no_plus = function(str)
      return transf.str.str_by_percent_decoded_also_plus(
        get.str.str_and_int_by_replaced_eutf8_w_regex_str(str, "%+", "%%2B") -- encode plus sign as %2B, so that it then gets decoded as a plus sign
      )
    end,
    escaped_csv_field = function(field)
      local escaped = get.str.str_and_int_by_replaced_eutf8_w_regex_str(field, '"', '""')
      return '"' .. escaped  .. '"'
    end,
    unicode_prop_table_arr = function(str)
      return get.fn.rt_or_nil_by_memoized(transf.str.table_or_err_by_evaled_env_bash_parsed_json)("uni identify -compact -format=all -as=json".. transf.str.str_by_single_quoted_escaped(str))
    end,
    unicode_prop_table_item_arr = function(str)
      return transf.unicode_prop_table_arr.unicode_prop_table_item_arr(
        transf.str.unicode_prop_table_arr(str)
      )
    end,
    str_by_single_quoted_escaped = function(str)
      return " '" .. get.str.str_and_int_by_replaced_eutf8_w_regex_str(str, "'", "\\'") .. "'"
    end,
    str_by_double_quoted_escaped = function(str)
      return ' "' .. get.str.str_and_int_by_replaced_eutf8_w_regex_str(str, '"', '\\"') .. '"'
    end,
    str_by_envsubsted = function(str)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("echo " .. transf.str.str_by_single_quoted_escaped(str) .. " | envsubst")
    end,
    nonindicated_bin_number_str_by_utf8 = basexx.to_bit,
    nonindicated_hex_number_str_by_utf8 = basexx.to_hex,
    base64_gen_str_by_utf8 = basexx.to_base64,
    base64_url_str_by_utf8 = basexx.to_url64,
    base32_gen_str_by_utf8 = basexx.to_base32,
    base32_crock_str_by_utf8 = basexx.to_crockford,
    str_by_html_entities_encoded = function(str)
      return transf.str.str_or_err_by_evaled_env_bash_stripped(
        "he --encode --use-named-refs" .. transf.str.here_str(str)
      )
    end,
    str_by_html_entities_decoded = function(str)
      return transf.str.str_or_err_by_evaled_env_bash_stripped(
        "he --decode" .. transf.str.here_str(str)
      )
    end,
    two_strs_by_split_header = function(str)
      local k, v = get.str.n_strs_by_extracted_eutf8(str, "^([^:]+):%s*(.+)$")
      return transf.str.str_by_initial_lower(k), v
    end,
    two_str_or_nils_by_split_envlike = function(str)
      return get.str.two_strs_split_or_nil(str, "=")
    end,
    two_str_or_nils_by_split_ini = function(str)
      return get.str.two_strs_split_or_nil(str, " = ")
    end,
    str_by_title_case = function(str)
      local words, removed = get.str.two_str_arrs_by_onig_regex_match_nomatch(str, "[ :–\\—\\-\\t\\n]")
      local title_cased_words = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(words, transf.str.title_case_policy)
      title_cased_words[1] = transf.str.str_by_first_eutf8_upper(title_cased_words[1])
      title_cased_words[#title_cased_words] = transf.str.str_by_first_eutf8_upper(title_cased_words[#title_cased_words])
      local arr = transf.two_arrs.arr_by_interleaved_stop_a1(title_cased_words, removed)
      return get.str_or_number_arr.str_by_joined(arr, "")
    end, 
    romanized_deterministic = function(str)
      local raw_romanized = transf.str.str_or_nil_by_evaled_env_bash_stripped(
         "echo -n" .. transf.str.str_by_single_quoted_escaped(str) .. "| kakasi -iutf8 -outf8 -ka -Ea -Ka -Ha -Ja -s -ga" 
      )
      local is_ok, romanized = pcall(get.str.str_and_int_by_replaced_eutf8_w_regex_str, raw_romanized, "(%w)%^", "%1%1")
      if not is_ok then
        return str -- if there's an error, just return the original str
      end
      replace(romanized, {{"(kigou)", "'"}, {}}, {
        mode = "remove",
      })
      return romanized
    end,
    lower_alphanum_underscore_str_by_romanized = function(str)
      str = get.str.str_by_removed_eutf8_w_regex_quantifiable(str, "[%^']")
      str = transf.str.romanized_deterministic(str)
      str = transf.str.str_by_all_eutf8_lower(str)
      str = transf.str.alphanum_underscore(str)
      return str
    end,
    romanized_gpt = function(str)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_str({input = str, query =  "Please romanize the following text with wapuro-like romanization, where:\n\nっ -> duplicated letter (e.g. っち -> cchi)\nlong vowel mark -> duplicated letter (e.g. ローマ -> roomaji)\nづ -> du\nんま -> nma\nじ -> ji\nを -> wo\nち -> chi\nparticles are separated by spaces (e.g. これに -> kore ni)\nbut morphemes aren't (真っ赤 -> makka)", shots = {
        {"こっち", "kocchi"}
      }})
    end,
    singleline_str_by_folded = function(str)
      return get.str.str_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "[\n\r\v\f]", " ")
    end,
    whitespace_collapsed_str = function(str)
      return get.str.str_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "%s", " ")
    end,
    not_whitespace_str = function(str)
      return get.str.str_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "%s", "")
    end,
    --- @param str str
    --- @return str[]
    byte_char_arr = function(str)
      local t = {}
      for i = 1, #str do
        t[i] = str:sub(i, i)
      end
      return t
    end,

    pos_int_by_len_byte_chars = str.len,


    --- @param str str
    --- @return str[]
    utf8_char_arr = function(str)
      local t = {}
      for i = 1, transf.str.pos_int_by_len_utf8_chars(str) do
        t[i] = get.str.str_by_sub_eutf8(str, i, i)
      end
      return t
    end,

    pos_int_by_len_utf8_chars = eutf8.len,

    --- @param str str
    --- @return str[]
    line_arr = function(str)
      return get.str.str_arr_by_split_w_ascii_char(
        transf.str.not_starting_or_ending_with_whitespace_str(str),
        "\n"
      )
    end,

    pos_int_by_len_lines = function(str)
      return #transf.str.line_arr(str)
    end,


    noempty_line_str_arr = function(str)
      return transf.str_arr.noemtpy_str_arr(
        transf.str.line_arr(str)
      )
    end,
    noindent_content_lines = function(str)
      return transf.str_arr.noindent_str_arr(transf.str.noempty_line_str_arr(str))
    end,
    nocomment_noindent_content_lines = function(str)
      return transf.str_arr.nocomment_noindent_str_arr(transf.str.noempty_line_str_arr(str))
    end,

    line_by_first = function(str)
      return transf.str.line_arr(str)[1]
    end,
    noempty_line_by_first = function(str)
      return transf.str.noempty_line_str_arr(str)[1]
    end,
    line_by_last = function(str)
      local lines = transf.str.line_arr(str)
      return lines[#lines]
    end,
    noempty_line_by_last = function(str)
      local lines = transf.str.noempty_line_str_arr(str)
      return lines[#lines]
    end,
    char_by_first = function(str)
      return get.str.str_by_sub_eutf8(str, 1, 1)
    end,
    char_by_last = function(str)
      return get.str.str_by_sub_eutf8(str, -1)
    end,
    str_by_no_final_newlines = function(str)
      return get.str.str_by_final_removed_eutf8_w_regex_quantifiable(str, "\n")
    end,
    str_by_one_final_newline = function(str)
      return get.str.str_by_final_continuous_collapsed_eutf8_w_regex_quantifiable(str, "\n")
    end,
    here_str = function(str)
      return " <<EOF\n" .. str .. "\nEOF"
    end,
    rfc3339like_dt = function(str)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_str({input = str, query = "Please transform the following thing indicating a date(time) into the corresponding RFC3339-like date(time) (UTC). Leave out elements that are not specified."})
    end,
    raw_contact = function(searchstr)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)("khard show --format=yaml " .. searchstr )
    end,
    contact_table = function(searchstr)
      local raw_contact = transf.str.raw_contact(searchstr)
      local contact = transf.raw_contact.contact_table(raw_contact)
      return contact
    end,
    event_table = function(str)
      local components = get.str.str_arr_by_split_w_string(str, fixedstr.unique_field_separator)
      local parsed = ovtable.new()
      for i, component in transf.arr.index_value_stateless_iter(components) do
        local key = ls.khal.parseable_format_components[i]
        if key == "alarms" then
          parsed[key] = get.str.str_arr_by_split_w_ascii_char(component, ",")
        elseif key == "description" then
          parsed[key] = component
        else
          parsed[key] = get.str.str_by_replaced_w_ascii_str(component, "\n", "")
        end
      end
      return parsed
    end,
    kana_inner = function(argstr)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("kana --vowel-shortener x " .. argstr )
    end,
    kana_inner_nospaces = function(argstr)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("kana --vowel-shortener x " .. argstr .. "| tr -d ' '")
    end,
    hiragana_only = function(str)
      return transf.str.kana_inner(transf.str.str_by_single_quoted_escaped(str))
    end,
    katakana_only = function(str)
      return transf.str.kana_inner("--katakana --extended" .. transf.str.str_by_single_quoted_escaped(str))
    end,
    hiragana_punct = function(str)
      return transf.str.kana_inner_nospaces("--punctuation" .. transf.str.str_by_single_quoted_escaped(str))
    end,
    katakana_punct = function(str)
      return transf.str.kana_inner_nospaces("--katakana --extended --punctuation" .. transf.str.str_by_single_quoted_escaped(str))
    end,
    kana_mixed = function(str)
      return transf.str.kana_inner("--extended --punctuation --kana-toggle 'Δ' --raw-toggle '†'" .. transf.str.str_by_single_quoted_escaped(str))
    end,
    japanese_writing = function(str)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_str({input = str, query =  "You're a dropin IME for already written text. Please transform the following into its Japanese writing system equivalent:"})
    end,
    kana_readings = function(str)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_str({input = str, query =  "Provide kana readings for:"})
    end,
    ruby_annotated_kana = function(str)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_str({input = str, query =  "Add kana readings to this text as <ruby> annotations, including <rp> fallback:"})
    end,
    --- @param str str
    --- @return hs.styledtext
    with_styled_start_end_markers = function(str)
      local res =  hs.styledtext.new("^" .. str .. "$")
      res = get.styledtext.styledtext_with_slice_styled(res, "light", 1, 1)
      res = get.styledtext.styledtext_with_slice_styled(res, "light", #res, #res)
      return res
    end,
    email_quoted = function(str)
      return get.str_or_number_arr.str_by_joined(
        get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
          get.str.str_arr_splitlines(
            transf.str.not_starting_or_ending_with_whitespace_str(str)
          ),
          function(v)
            if get.str.bool_by_startswith(v, ">") then
              return ">" .. v
            else
              return ">" .. " " .. v
            end
          end
        ),
        "\n"
      )
    end,
    url_arr = function(str)
      return transf.str_arr.filter_nocomment_noindent_to_url_arr(
        transf.str.line_arr(str)
      )
    end,
    str_by_whole_regex = function(str)
      return "^" .. str .. "$"
    end,
    two_strs_arr_split_by_minus_or_nil = function(str)
      return get.str.two_strs_arr_split_or_nil(str, "-")
    end,
    prompted_once_two_strs_arr_for = function(str)
      return transf.prompt_spec.any({
        prompter = transf.prompt_args_str.str_or_nil_and_bool,
        transformer = transf.str.two_strs_arr_split_by_minus_or_nil,
        prompt_args = {
          message = "Please enter a str two_anys_arr for " .. str .. " (e.g. 'foo-bar')",
        }
      })
    end,
    prompted_multiple_two_strs_arr_arr_for = function(str)
      return transf.prompt_spec.any_arr({
        prompter = transf.prompt_args_str.str_or_nil_and_bool,
        transformer = transf.str.two_strs_arr_split_by_minus_or_nil,
        prompt_args = {
          message = "Please enter a str two_anys_arr for " .. str .. " (e.g. 'foo-bar')",
        }
      })
    end,
    prompted_once_str_from_default = function(str)
      return get.str.str_by_prompted_once_from_default(str, "Enter a str...")
    end,
    prompted_once_alphanum_minus_underscore_str_from_default = function(str)
      return get.str.alphanum_minus_underscore_str_by_prompted_once_from_default(str, "Enter a str (alphanum, minus, underscore)...")
    end,
    not_whitespace_str_arr = function(str)
      return get.str.str_arr_split_single_char_stripped(
        transf.str.whitespace_collapsed_str(str),
        " "
      )
    end,
    nonindicated_number_str = function(str)
      local res = str
      res = get.str.str_and_int_by_replaced_eutf8_w_regex_str(res, ",", ".")
      res = get.str.str_and_int_by_replaced_eutf8_w_regex_str(str, "^[0-9a-zA-Z]+", "")
      return res
    end
  },
  line = {
    noindent_line = function(str)
      return get.str.n_strs_by_extracted_eutf8(str, "^%s*(.*)$")
    end,
    nocomment_line = function(str)
      return get.str.str_arr_by_split_w_string(str, " # ")[1]
    end,
    nocomment_noindent = function(str)
      return transf.line.noindent_line(transf.line.nocomment_line(str))
    end,
    line_by_comment = function(str)
      return get.str.str_arr_by_split_w_string(str, " # ")[2]
    end,
  },
  potentially_atpath = {
    potentially_atpath_resolved = function(str)
      if get.str.bool_by_startswith(str, "@") then
        local valpath = get.str.str_by_sub_eutf8(str, 2)
        valpath = hs.fs.pathToAbsolute(valpath, true)
        str = "@" .. valpath
      end
      return str
    end,
  },
  alphanum_minus = {
    alphanum_by_remove = function(str)
      return get.str.str_by_removed_onig_w_regex_quantifiable(str, "-")
    end,
  },
  alphanum_underscore = {
    evaled_shell_var = function(str)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("echo $" .. str)
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
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("pass otp otp/" .. item)
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
    str = function(st)
      return st:getstr()
    end,
  },
  styledtext_or_str = {
    str = function(st_or_str)
      if is.any.str(st_or_str) then
        return st_or_str
      else
        return transf.styledtext.str(st_or_str)
      end
    end,
  },
  yaml_str = {
    not_userdata_or_function = function(str)
      local res = yaml.load(str)
      null2nil(res)
      return res
    end,
    json_str = function(str)
      return transf.not_userdata_or_function.json_str(
        transf.yaml_str.not_userdata_or_function(str)
      )
    end,
  },
  json_str = {
    not_userdata_or_function = function(str)
      return transf.fn.rt_or_nil_fn_by_pcall(json.decode)(str)
    end,
    table_or_nil = function(str)
      local res =  transf.not_userdata_or_function.json_str(str)
      if is.any.table(res) then
        return res
      else
        return nil
      end
    end,
    yaml_str = function(str)
      return transf.not_userdata_or_function.yaml_str(
        transf.json_str.not_userdata_or_function(str)
      )
    end,
  },
  toml_str = {
    assoc = toml.decode
  },
  yaml_file = {
    not_userdata_or_function = function(path)
      return transf.yaml_str.not_userdata_or_function(transf.plaintext_file.str_by_contents(path))
    end
  },
  
  ini_str = {
    assoc = function(str)
      return transf.str.table_or_err_by_evaled_env_bash_parsed_json(
        "jc --ini <<EOF " .. str .. "EOF"
      )
    end,
  },
  plaintext_assoc_file = {
    table = function(file)
      if is.plaintext_assoc_file.yaml_file(file) then
        return transf.yaml_file.not_userdata_or_function(file)
      elseif is.plaintext_assoc_file.json_file(file) then
        return transf.json_file.not_userdata_or_function(file)
      elseif is.plaintext_assoc_file.ini_file(file) then
        return transf.ini_file.assoc(file)
      elseif is.plaintext_assoc_file.toml_file(file) then
        return transf.toml_file.assoc(file)
      elseif is.plaintext_assoc_file.ics_file(file) then
        return transf.ics_file.assoc_arr(file) 
      end
    end
  },
  header_str = {
    assoc = function(str)
      local lines = transf.str.noempty_line_str_arr(str)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        lines,
        transf.str.two_strs_by_split_header
      )

    end
  },
  base64_gen_str = {
    decoded_str = basexx.from_base64,
  },
  base64_url_str = {
    decoded_str = basexx.from_url64,
  },
  base32_gen_str = {
    decoded_str = basexx.from_base32,
  },
  base32_crock_str = {
    decoded_str = basexx.from_crockford,
  },
  base64 = {
    decoded_str = function(b64)
      if is.printable_ascii_not_whitespace_str.base64_gen_str(b64) then
        return transf.base64_gen_str.decoded_str(b64)
      else
        return transf.base64_url_str.decoded_str(b64)
      end
    end
  },
  base32 = {
    decoded_str = function(b32)
      if is.printable_ascii_not_whitespace_str.base32_gen_str(b32) then
        return transf.base32_gen_str.decoded_str(b32)
      else
        return transf.base32_crock_str.decoded_str(b32)
      end
    end
  },
  event_table = {
    yaml_str_by_calendar_template = function(event_table)
      local template = transf["nil"].calendar_template_table_by_empty()
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
        template.alarms.value = get.str_or_number_arr.str_by_joined(template.alarms.value, ",")
      end
      --- in refactoring, the key order maintaining mechanism was removed. I'm not sure how my current aligment mechanism handles key order, so for now I'm just gonna leave it as is, but if it turns out that it's not working, I'll have to add it back in.
      return transf.table.yaml_str_by_aligned(template)

    end,
    str_by_event_tagline = function(event_table)
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
  multiline_str = {
    trimmed_lines_multiline_str = function(str)
      local lines = get.str.str_arr_by_split_w_string(str, "\n")
      local trimmed_lines = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(lines, transf.str.not_starting_or_ending_with_whitespace_str)
      return get.str_or_number_arr.str_by_joined(trimmed_lines, "\n")
    end,
    iso_3366_1_alpha_2_country_code_key_mullvad_city_code_key_mullvad_relay_identifier_str_arr_value_assoc_value_assoc = function(raw)
      local raw_countries = get.str.str_arr_split_noempty(raw, "\n\n")
      local countries = {}
      for _, raw_country in transf.arr.index_value_stateless_iter(raw_countries) do
        local raw_country_lines = get.str.not_empty_str_arr_by_split_w_ascii_char(raw_country, "\n")
        local country_header = raw_country_lines[1]
        local country_code = get.str.n_strs_by_extracted_onig(country_header, "\\(([^\\)]+\\)")
        if country_code == nil then error("could not find country code in header. header was " .. country_header) end
        local payload_lines = transf.arr.arr_by_nofirst(raw_country_lines)
        countries[country_code] = {}
        local city_code
        for _, payload_line in transf.arr.index_value_stateless_iter(payload_lines) do
          if get.str.bool_by_startswith(payload_line, "\t\t") then -- line specifying a single relay
            local relay_code = payload_line:match("^\t\t([%w%-]+) ") -- lines look like this: \t\tfi-hel-001 (185.204.1.171) - OpenVPN, hosted by Creanova (Mullvad-owned)
            dothis.arr.push(countries[country_code][city_code], relay_code)
          elseif get.str.bool_by_startswith(payload_line, "\t") then -- line specifying an entire city
            city_code = get.str.n_strs_by_extracted_onig(payload_line," \\(([^\\)]+\\) " ) -- lines look like this: \tHelsinki (hel) @ 60.19206°N, 24.94583°W
            countries[country_code][city_code] = {}
          end
        end

      end
    
      return countries
    end,
    
  },
  multirecord_str = {
    record_str_arr = function(str)
      return get.str.str_arr_split_noempty(
        str,
        fixedstr.unique_record_separator
      )
    end,
    event_table_arr = function(str)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        transf.multirecord_str.record_str_arr(str),
        transf.str.event_table
      )
    end,
  },
  syn_specifier = {
    str_arr_by_synonyms = function (syn_specifier)
      return syn_specifier.synonyms
    end,
    str_arr_by_antonyms = function (syn_specifier)
      return syn_specifier.antonyms
    end,
    summary = function (syn_specifier)
      return 
        "synonyms: " ..
        get.arr.arr_by_slice_removed_indicator_and_flatten_w_slice_spec(syn_specifier.synonyms, { stop = 2}, "...") ..
        "\n" ..
        "antonyms: " ..
        get.arr.arr_by_slice_removed_indicator_and_flatten_w_slice_spec(syn_specifier.antonyms, { stop = 2}, "...")
    end,
  },
  two_anys_arr = {
    key_value = function(two_anys_arr)
      return two_anys_arr[1], two_anys_arr[2]
    end,
    key = function(two_anys_arr)
      return two_anys_arr[1]
    end,
    value = function(two_anys_arr)
      return two_anys_arr[2]
    end,
    header = function(two_anys_arr)
      return transf.two_anys.header(two_anys_arr[1], two_anys_arr[2])
    end,
    email_header = function(two_anys_arr)
      return transf.two_anys.email_header(two_anys_arr[1], two_anys_arr[2])
    end,
    url_param = function(two_anys_arr)
      return transf.two_anys.url_param(two_anys_arr[1], two_anys_arr[2])
    end,
    ini_line = function(two_anys_arr)
      return transf.two_anys.ini_line(two_anys_arr[1], two_anys_arr[2])
    end,
    envlike_line = function(two_anys_arr)
      return transf.two_anys.envlike_line(two_anys_arr[1], two_anys_arr[2])
    end,
    curl_form_field_args = function(two_anys_arr)
      return transf.two_anys.curl_form_field_args(two_anys_arr[1], two_anys_arr[2])
    end,
    assoc_entry_str = function(two_anys_arr)
      return transf.two_anys.assoc_entry_str(two_anys_arr[1], two_anys_arr[2])
    end,
    larger = function(two_anys_arr)
      return transf.two_comparables.comparable_by_larger(two_anys_arr[1], two_anys_arr[2])
    end,
  },
  two_anys = {
    bool_by_and = function(a, b)
      return a and b
    end,
    bool_by_or = function(a, b)
      return a or b
    end,
    str_two_anys = function(a, b)
      return transf.any.str_by_replicable(a), transf.any.str_by_replicable(b)
    end,
    two_anys_arr = function(key, value)
      return {key, value}
    end,
    key = function(key, value)
      return key
    end,
    value = function(key, value)
      return value
    end,
    header = function(k, v)
      return transf.str.str_by_first_eutf8_upper(transf.any.str_by_replicable(k)) .. ": " .. transf.any.str_by_replicable(v)
    end,
    email_header = function(key, value)
      return transf.str.str_by_first_eutf8_upper(transf.any.str_by_replicable(key)) .. ": " .. get.str.str_by_evaled_as_template(transf.any.str_by_replicable(value))
    end,
    url_param = function(key, value)
      return transf.any.str_by_replicable(key) .. "=" .. transf.str.encoded_query_param_value(transf.any.str_by_replicable(value))
    end,
    ini_line = function(key, value)
      return transf.any.str_by_replicable(key) .. " = " .. transf.any.str_by_replicable(value)
    end,
    envlike_line = function(key, value)
      return transf.any.str_by_replicable(key) .. "=" .. transf.any.str_by_replicable(value)
    end,
    curl_form_field_args = function(key, value)
      return {
        "-F",
        transf.any.str_by_replicable(key) .. "=" .. transf.potentially_atpath.potentially_atpath_resolved(transf.any.str_by_replicable(value)),
      }
    end,
    assoc_entry_str = function(key, value)
      return "[" .. transf.any.str_by_replicable(key) .. "] = " .. transf.any.str_by_replicable(value)
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
    number_by_sum = function(a, b)
      return a + b
    end,
  },
  two_date_component_names = {
    date_component_name_by_larger = function(a, b)
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
  email = {
    mailto_url = function(str)
      return "mailto:" .. str
    end,
  },
  displayname_email = {
    email = function(str)
      return get.str.n_strs_by_extracted_eutf8(str, " <(.*)> *$")
    end,
    displayname = function(str)
      return get.str.n_strs_by_extracted_eutf8(str, "^(.*) <")
    end,
    displayname_email_assoc = function(str)
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
    displayname_email_assoc = function(str)
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
  str_arr = {
    repeated_option_str = function(arr, opt)
      return get.str_or_number_arr.str_by_joined(
        get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
          arr,
          function (itm)
            return " " .. opt .. " " .. itm
          end
        ),
        ""
      )
    end,
    single_quoted_escaped_str_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.str.str_by_single_quoted_escaped
      )
    end,
    single_quoted_escaped_str = function(arr)
      return get.str_or_number_arr.str_by_joined(
        transf.str_arr.single_quoted_escaped_str_arr(arr),
        " "
      )
    end,
    action_path_str = function(arr)
      return get.str_or_number_arr.str_by_joined(arr, " > ")
    end,
    path = function(arr)
      return get.str_or_number_arr.str_by_joined(
        get.arr.arr_by_mapped_w_t_arg_t_ret_fn(arr, transf.str.safe_filename), 
        "/"
      )
    end,
    noemtpy_str_arr = function(arr)
      return get.arr.arr_by_filtered(arr, is.str.not_empty_str)
    end,
    noindent_str_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(arr, transf.line.noindent_line)
    end,
    nocomment_line_filtered_str_arr = function(arr)
      return get.arr.arr_by_filtered(
        arr,
        is.str.nocomment_line
      )
    end,
    nocomment_str_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        transf.str_arr.nocomment_line_filtered_str_arr(arr),
        transf.line.nocomment_line
      )
    end,
    nocomment_line_filtered_noindent_str_arr = function(arr)
      return transf.str_arr.noindent_str_arr(
        transf.str_arr.nocomment_line_filtered_str_arr(arr)
      )
    end,
    nocomment_noindent_str_arr = function(arr)
      return transf.str_arr.noindent_str_arr(
        transf.str_arr.nocomment_str_arr(arr)
      )
    end,
    filter_to_url_arr = function(arr)
      return get.arr.arr_by_filtered(arr, is.str.url)
    end,
    filter_nocomment_noindent_to_url_arr = function(arr)
      return transf.str_arr.filter_to_url_arr(
        transf.str_arr.nocomment_noindent_str_arr(arr)
      )
    end,
    stripped_str_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(arr, transf.str.not_starting_or_ending_with_whitespace_str)
    end,
    multiline_str = function(arr)
      return get.str_or_number_arr.str_by_joined(arr, "\n")
    end,
    contents_summary = function(arr)
      return get.str_or_number_arr.str_by_joined(
        get.arr.arr_by_slice_removed_indicator_and_flatten_w_slice_spec(arr, {
          start = 1,
          stop = 10,
        }, "..."),
        ", "
      )
    end,
    
  },
  env_line_arr = {
    env_str = function(arr)
      local env_str_inner = get.str_or_number_arr.str_by_joined(arr, "\n")
      return "#!/usr/bin/env bash\n\n" ..
          "set -u\n\n" .. 
          env_str_inner .. 
          "\n\nset +u\n"
    end,
  },
  slice_notation = {
    three_pos_int_or_nils = function(notation)
      local stripped_str = transf.str.not_starting_or_ending_with_whitespace_str(notation)
      local start_str, stop_str, step_str = get.str.n_strs_by_extracted_onig(
        stripped_str, 
        "^\\[?(-?\\d*):(-?\\d*)(?::(-?\\d+))?\\]?$"
      )
      return
        start_str == "" and nil or get.str.number_or_nil(start_str),
        stop_str == "" and nil or get.str.number_or_nil(stop_str),
        step_str == "" and nil or get.str.number_or_nil(step_str)
    end,
  },
  two_arrs = {
    two_anys_by_first = function(arr1, arr2)
      return arr1[1], arr2[1]
    end,
    bool_by_larger_first_item = function(arr1, arr2)
      return transf.two_comparables.bool_by_larger(arr1[1], arr2[1])
    end,
    bool_by_smaller_first_item = function(arr1, arr2)
      return transf.two_comparables.bool_by_smaller(arr1[1], arr2[1])
    end,
    arr_by_appended = function(arr1, arr2)
      local res = get.table.table_by_copy(arr1)
      for _, v in transf.arr.index_value_stateless_iter(arr2) do
        res[#res + 1] = v
      end
      return res
    end,
    pair_arr_by_zip_stop_a1 = function(arr1, arr2)
      local res = {}
      for i = 1, #arr1 do
        res[#res + 1] = {arr1[i], arr2[i]}
      end
      return res
    end,
    pair_arr_by_zip_stop_a2 = function(arr1, arr2)
      local res = {}
      for i = 1, #arr2 do
        res[#res + 1] = {arr1[i], arr2[i]}
      end
      return res
    end,
    pair_arr_by_zip_stop_shortest = function(arr1, arr2)
      local res = {}
      local shortest = transf.two_comparables.comparable_by_smaller(#arr1, #arr2)
      for i = 1, shortest do
        res[#res + 1] = {arr1[i], arr2[i]}
      end
      return res
    end,
    assoc_by_zip_stop_shortest = function(arr1, arr2)
      return transf.pair_arr.assoc(
        transf.two_arrs.pair_arr_by_zip_stop_shortest(arr1, arr2)
      )
    end,
    pair_arr_by_zip_stop_longest = function(arr1, arr2)
      local res = {}
      local longest = transf.two_comparables.comparable_by_larger(#arr1, #arr2)
      for i = 1, longest do
        res[#res + 1] = {arr1[i], arr2[i]}
      end
      return res
    end,
    arr_by_interleaved_stop_a1 = function(arr1, arr2)
      local res = {}
      for i, v in transf.arr.index_value_stateless_iter(arr1) do
        res[#res + 1] = v
        res[#res + 1] = arr2[i]
      end
      return res
    end,
    arr_by_interleaved_stop_a2 = function(arr1, arr2)
      local res = {}
      for i, v in transf.arr.index_value_stateless_iter(arr2) do
        res[#res + 1] = arr1[i]
        res[#res + 1] = v
      end
      return res
    end,
    arr_by_interleaved_stop_shortest = function(arr1, arr2)
      local res = {}
      local shortest = transf.two_comparables.comparable_by_smaller(#arr1, #arr2)
      for i = 1, shortest do
        res[#res + 1] = arr1[i]
        res[#res + 1] = arr2[i]
      end
      return res
    end,
    arr_by_interleaved_stop_longest = function(arr1, arr2)
      local res = {}
      local longest = transf.two_comparables.comparable_by_larger(#arr1, #arr2)
      for i = 1, longest do
        res[#res + 1] = arr1[i]
        res[#res + 1] = arr2[i]
      end
      return res
    end,

    set_by_union = function(arr1, arr2)
      local new_arr = transf.two_arrs.arr_by_appended(arr1, arr2)
      return transf.arr.set(new_arr)
    end,
    set_by_intersection = function(arr1, arr2)
      local new_arr = {}
      for _, v in transf.arr.index_value_stateless_iter(arr1) do
        if get.arr.bool_by_contains(arr2, v) then
          new_arr[#new_arr + 1] = v
        end
      end
      return transf.arr.set(new_arr)
    end,
    set_by_difference = function(arr1, arr2)
      local new_arr = {}
      for _, v in transf.arr.index_value_stateless_iter(arr1) do
        if not get.arr.bool_by_contains(arr2, v) then
          new_arr[#new_arr + 1] = v
        end
      end
      return transf.arr.set(new_arr)
    end,
    set_by_symmetric_difference = function(arr1, arr2)
      local new_arr = {}
      for _, v in transf.arr.index_value_stateless_iter(arr1) do
        if not get.arr.bool_by_contains(arr2, v) then
          new_arr[#new_arr + 1] = v
        end
      end
      for _, v in transf.arr.index_value_stateless_iter(arr2) do
        if not get.arr.bool_by_contains(arr1, v) then
          new_arr[#new_arr + 1] = v
        end
      end
      return transf.arr.set(new_arr)
    end,
  },
  two_arr_or_nils = {
    arr = function(arr1, arr2)
      if arr1 == nil then arr1 = {} end
      if arr2 == nil then arr2 = {} end
      return transf.two_arrs.arr_by_appended(arr1, arr2)
    end,
  },
  any_and_arr = {
    arr = function(any, arr)
      local res = get.table.table_by_copy(arr)
      dothis.arr.unshift(res, any)
      return res
    end,
  },
  arr_and_any = {
    arr = function(arr, any)
      local res = get.table.table_by_copy(arr)
      dothis.arr.push(res, any)
      return res
    end,
  },
  arr_or_nil_and_any = {
    arr = function(arr, any)
      if arr == nil then arr = {} end
      return transf.arr_and_any.arr(arr, any)
    end,
  },
  str_arr_arr = {

  },
  url_arr = {
    url_potentially_with_title_comment_arr = function(sgml_url_arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        sgml_url_arr,
        transf.url.url_potentially_with_title_comment
      )
    end,
    session_str = function(sgml_url_arr)
      return get.str_or_number_arr.str_by_joined(
        transf.url.url_potentially_with_title_comment_arr(sgml_url_arr),
        "\n"
      )
    end,
    nonabsolute_path_key_assoc_of_url_files = function(url_arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        url_arr,
        function(url)
          return 
            transf.url.title_or_url_as_filename(url),
            url
        end
      )
    end,
  },
  sgml_url_arr = {
    sgml_url_with_title_comment_arr = function(sgml_url_arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        sgml_url_arr,
        transf.sgml_url.sgml_url_with_title_comment
      )
    end,
    
  },
  plaintext_url_or_local_path_file = {

  },
  plaintext_file_arr = {
    str_arr_by_contents = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(arr, transf.plaintext_file.str_by_contents)
    end,
    str_arr_by_lines = function(arr)
      return get.arr_arr.arr_by_mapped_w_vt_arg_vt_ret_fn_and_flatten(arr, transf.plaintext_file.str_arr_by_lines)
    end,
    str_arr_by_content_lines = function(arr)
      return get.arr_arr.arr_by_mapped_w_vt_arg_vt_ret_fn_and_flatten(arr, transf.plaintext_file.str_arr_by_content_lines)
    end,
    m3u_file_arr = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.plaintext_file.m3u_file)
    end,
    url_or_local_path_arr_by_m3u_file_content_lines = function(arr)
      return transf.plaintext_file_arr.str_arr_by_content_lines(
        transf.plaintext_file_arr.m3u_file_arr(arr)
      )
    end,
    
  },
  event_table_arr = {
  },
  email_file_arr = {
    email_file_summary_assoc = function(email_file_arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        email_file_arr,
        transf.email_file.email_file_summary_key_value
      )
    end,
    email_file_simple_view_assoc = function(email_file_arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        email_file_arr,
        transf.email_file.email_file_simple_view_key_value
      )
    end,
  },
  stateless_iter = {
    arr = function(...)
      local res = {}
      for a1, a2, a3, a4, a5, a6, a7, a8, a9 in ... do
        dothis.arr.push(
          res,
          {a1, a2, a3, a4, a5, a6, a7, a8, a9}
        )
      end
      return res
    end,
  },
  table_or_nil = {
    kt_vt_stateless_iter = function(t)
      if t == nil then t = {} end
      return transf.table.stateless_key_value_iter(t)
    end,
    kt_arr = function(t)
      if t == nil then return {} end
      return transf.table.kt_arr(t)
    end,
    vt_arr = function(t)
      if t == nil then return {} end
      return transf.table.vt_arr(t)
    end,
  },
  table = {
    two_anys_arr = function(t)
      return get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
        t,
        transf.two_anys.two_anys_arr
      )
    end,
    two_anys_arr_by_sorted_larger_key_first = function(t)
      return transf.arr_arr.arr_arr_by_sorted_larger_first_item(
        transf.table.two_anys_arr(t)
      )
    end,
    two_anys_arr_by_sorted_smaller_key_first = function(t)
      return transf.arr_arr.arr_arr_by_sorted_smaller_first_item(
        transf.table.two_anys_arr(t)
      )
    end,
    kt_arr = function(t)
      local res = {}
      for k, _ in transf.table.kt_vt_stateless_iter(t) do
        res[#res + 1] = k
      end
      return res
    end,
    pos_int_by_num_keys = function(t)
      return #transf.table.kt_arr(t)
    end,
    vt_arr = function(t)
      local res = {}
      for _, v in transf.table.kt_vt_stateless_iter(t) do
        res[#res + 1] = v
      end
      return res
    end,
    kt_arr_by_sorted_smaller_first = function(t)
      return get.table.kt_arr_by_sorted(t, transf.two_comparables.bool_by_smaller)
    end,
    kt_arr_by_sorted_larger_first = function(t)
      return get.table.kt_arr_by_sorted(t, transf.two_comparables.bool_by_larger)
    end,
    vt_arr_by_sorted_smaller_first = function(t)
      return get.table.vt_arr_by_sorted(t, transf.two_comparables.bool_by_smaller)
    end,
    vt_arr_by_sorted_larger_first = function(t)
      return get.table.vt_arr_by_sorted(t, transf.two_comparables.bool_by_larger)
    end,
    kt_vt_stateless_iter = pairs,
    kt_vt_stateful_iter = get.stateless_generator.stateful_generator(transf.table.kt_vt_stateless_iter),
    kt_stateful_iter = get.stateless_generator.stateful_generator(transf.table.kt_vt_stateful_iter, 1, 1),
    vt_stateful_iter = get.stateless_generator.stateful_generator(transf.table.kt_vt_stateful_iter, 2, 2),
    toml_str = toml.encode,
    yaml_str_by_aligned = function(tbl)
      local tmp = transf.str.in_tmp_dir(
        transf.not_userdata_or_function.yaml_str(tbl),
        "shell-input"
      )
      transf.str.str_or_nil_by_evaled_env_bash_stripped("align " .. transf.str.str_by_single_quoted_escaped(tmp))
      local res = transf.yaml_file.not_userdata_or_function(tmp)
      dothis.local_extant_path.delete(tmp)
      return res
    end,
    yaml_metadata = function(t)
      local str_contents = transf.not_userdata_or_str.yaml_str(t)
      return "---\n" .. str_contents .. "\n---\n"
    end,
    
    ics_str = function(t)
      local tmpdir_ics_path = transf.not_userdata_or_function.in_tmp_dir(t) .. ".ics"
      dothis.table.write_ics_file(t, tmpdir_ics_path)
      local contents = transf.file.str_by_contents(tmpdir_ics_path)
      dothis.absolute_path.delete(tmpdir_ics_path)
      return contents
    end,
    vt_set = function(t)
      return transf.arr.set(transf.table_or_nil.vt_arr(t))
    end,
    json_str_by_pretty = function(t)
      return hs.json.encode(t, true)
    end,
    arr_arr_by_label_root_to_leaf_only_primitive_is_leaf = function(t)
      return get.table.arr_arr_by_label_root_to_leaf(
        t,
        transf["nil"]["false"]()
      )
    end,
    arr_arr_by_label_root_to_leaf_primitive_and_arrlike_is_leaf = function(t)
      return get.table.arr_arr_by_label_root_to_leaf(
        t,
        is.table.only_int_key_table
      )
    end,
    arr_arr_by_key_label_only_primitive_is_leaf = function(t)
      return get.table.arr_arr_by_key_label(
        t,
        transf["nil"]["false"]()
      )
    end,
    arr_arr_by_key_label_primitive_and_arrlike_is_leaf = function(t)
      return get.table.arr_arr_by_key_label(
        t,
        is.table.only_int_key_table
      )
    end,
    relative_path_key_assoc_by_primitive_and_arrlike_is_leaf = function(t)
      return get.table.str_by_joined_key_any_value_assoc(
        t,
        is.table.only_int_key_table,
        "/"
      )
    end,
    dot_notation_key_assoc_by_primitive_and_arrlike_is_leaf = function(t)
      return get.table.str_by_joined_key_any_value_assoc(
        t,
        is.table.only_int_key_table,
        "."
      )
    end,
    arr_by_nested_final_key_label_by_primitive_and_arrlike_is_leaf = function(t)
      return transf.arr_arr.arr_by_map_to_last(
        get.table.arr_arr_by_key_label(
          t,
          is.table.only_int_key_table
        )
      )
    end,
    arr_by_nested_value_primitive_and_arrlike_is_leaf = function(t)
      return transf.arr.arr_by_map_to_last(
        get.table.arr_arr_by_label_root_to_leaf(
          t,
          is.table.only_int_key_table
        )
      )
    end,
    table_by_mapped_nested_w_kt_arg_kt_ret_fn_only_primitive_is_leaf = function(t, fn)
      return get.table.table_by_mapped_nested_w_kt_arg_kt_ret_fn(
        t,
        transf["nil"]["false"](),
        fn
      )
    end,
  },
  assoc = {
    int_by_length = function(t)
      return #transf.table.two_anys_arr(t)
    end,
    url_param_arr = function(t)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(transf.table.two_anys_arr(t), transf.two_anys_arr.url_param)
    end,
    url_params = function(t)
      return get.str_or_number_arr.str_by_joined(transf.assoc.url_param_arr(t), "&")
    end,
    --- @param t { [str]: str }
    --- @return str
    email_header = function(t)
      local header_lines = {}
      local initial_headers = ls.initial_headers
      for _, header_name in transf.arr.index_value_stateless_iter(initial_headers) do
        local header_value = t[header_name]
        if header_value then
          dothis.arr.insert_at_index(header_lines, transf.two_anys_arr.email_header({header_name, header_value}))
          t[header_name] = nil
        end
      end
      header_lines = transf.two_arrs.arr_by_appended(
        header_lines,
        get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
          transf.table.two_anys_arr_by_sorted_larger_key_first(t),
          transf.two_anys_arr.email_header
        )
      )
      return get.str_or_number_arr.str_by_joined(header_lines, "\n")
    end,
    curl_form_field_arr = function(t)
      return transf.arr_arr.arr_by_flatten(
        get.arr.arr_by_mapped_w_t_arg_t_ret_fn(transf.table.two_anys_arr(t), transf.two_anys_arr.curl_form_field_args)
      )
    end,
    ini_line_arr = function(t)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(transf.table.two_anys_arr(t), transf.two_anys_arr.ini_line)
    end,
    ini_str = function(t)
      return get.str_or_number_arr.str_by_joined(transf.assoc.ini_line_arr(t), "\n")
    end,
    envlike_line_arr = function(t)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(transf.table.two_anys_arr(t), transf.two_anys_arr.envlike_line)
    end,
    assoc_entry_str_arr = function(t)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(transf.table.two_anys_arr(t), transf.two_anys_arr.assoc_entry_str)
    end,
    contents_summary = function(t)
      return transf.str_arr.contents_summary(
        transf.assoc.assoc_entry_str_arr(t)
      )
    end,
    summary = function(t)
      return "assoc (" .. transf.assoc.int_by_length(t) .. "): " .. transf.assoc.contents_summary(t)
    end,
    assoc_entry_multiline_str = function(t)
      return get.str_or_number_arr.str_by_joined(transf.assoc.assoc_entry_str_arr(t), "\n")
    end,
    envlike_str = function(t)
      return get.str_or_number_arr.str_by_joined(transf.assoc.envlike_line_arr(t), "\n")
    end,
    truthy_value_assoc = function(t)
      return get.arr.arr_by_filtered(
        t,
        transf.any.bool
      )
    end,
    truthy_value_key_arr = function(t)
      return transf.table_or_nil.kt_arr(transf.assoc.truthy_value_assoc(t))
    end,
  },
  table_arr = {
    table_by_take_new = function(t)
      local res = {}
      for _, assoc in transf.arr.index_value_stateless_iter(t) do
        for k, v in transf.table.stateless_key_value_iter(assoc) do
          res[k] = v
        end
      end
      return res
    end,
    table_by_take_old = function(t)
      local res = {}
      for _, assoc in transf.arr.index_value_stateless_iter(t) do
        for k, v in transf.table.stateless_key_value_iter(assoc) do
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
      return transf.table_arr.table_by_take_new({t1, t2})
    end,
    table_by_take_old = function(t1, t2)
      return transf.table_arr.table_by_take_old({t1, t2})
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
  str_value_assoc = {
    str_value_assoc_by_prompted_once_from_default = function(assoc)
      return get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(assoc, function(k, v)
        return get.str.str_by_prompted_once_from_default(
          v,
          "Enter a new value for '" .. k .. "'"
        )
      end)
    end,
  },
  str_key_assoc = {
    str_key_assoc_of_str_key_assocs_or_prev_values_by_space = function(tbl)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(tbl) do
        local key_parts = get.str.str_arr_by_split_w_ascii_char(k, " ")
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
  str_key_value_assoc = {

  },
  str_bool_assoc = {
    truthy_long_flag_arr = function(assoc)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        transf.assoc.truthy_value_key_arr(assoc),
        transf.str.long_flag
      )
    end,
    truthy_long_flag_str = function(assoc)
      return get.str_or_number_arr.str_by_joined(transf.assoc.truthy_long_flag_arr(assoc), " ")
    end,
  },
  arr_arr = {
    arr_arr_by_sorted_larger_first_item = function(arr)
      return get.arr.arr_by_sorted(
        arr,
        transf.two_arrs.bool_by_larger_first_item
      )
    end,
    arr_arr_by_sorted_smaller_first_item = function(arr)
      return get.arr.arr_by_sorted(
        arr,
        transf.two_arrs.bool_by_smaller_first_item
      )
    end,

    arr_by_flatten = plarray2d.flatten,
    arr_by_map_to_last = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(arr, transf.arr.t_by_last)
    end,
    arr_by_map_to_first = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(arr, transf.arr.t_by_first)
    end,
    arr_by_longest_common_prefix = function(a_o_a)
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
      return get.arr.arr_by_slice_w_3_pos_int_any_or_nils(a_o_a[1], 1, last_matching_index)
    end,
    arr_arr_by_reverse = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(arr, transf.arr.arr_by_reverse)
    end,
    arr_by_longest_common_suffix = function(arr)
      local reversed_res = transf.arr.arr_by_longest_common_prefix(
        transf.arr.reverse_mapped(arr)
      )
      return transf.arr_by_reversed.arr(reversed_res)
    end,
  },
  pair_arr = {
    assoc = function(arr)
      local res = {}
      for _, two_anys_arr in transf.arr.index_value_stateless_iter(arr) do
        res[two_anys_arr[1]] = two_anys_arr[2]
      end
      return res
    end,
  },
  two_strs_arr_arr = {
    env_line_arr = function (arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        function(two_anys_arr)
          return "export " .. two_anys_arr[1] .. "=" .. transf.str.str_by_double_quoted_escaped(two_anys_arr[2])
        end
      )
    end,
    n_shot_role_content_message_spec_arr = function(arr)
      local res = {}
      for _, two_anys_arr in transf.arr.index_value_stateless_iter(arr) do
        dothis.arr.push(res, {
          role = "user",
          content = two_anys_arr[1],
        })
        dothis.arr.push(res, {
          role = "assistant",
          content = two_anys_arr[2],
        })
      end
      return res
    end
  },
  assoc_of_str_value_assocs = {
    ini_str = function(t)
      return get.str_or_number_arr.str_by_joined(get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
        t,
        function(k,v)
          return "[" .. k .. "]\n" .. transf.assoc.ini_str(v)
        end
      ), "\n\n")
    end,
  },
  assoc_of_assocs = {
    assoc_by_space = function(assoc_of_assocs)
      local res = {}
      for label, assoc in transf.table.stateless_key_value_iter(assoc_of_assocs) do
        for k, v in transf.table.stateless_key_value_iter(assoc) do
          res[label .. " " .. k] = v
        end
      end
      return res
    end,

  },
  arr_value_assoc = {
    arr_arr = function(arr)
      return transf.table.vt_arr(arr)
    end,
    arr_by_flatten = function(arr)
      return transf.arr_arr.arr_by_flatten(transf.table.vt_arr(arr))
    end,
        
  },
  timestamp_ms_key_assoc_value_assoc = {
    nonabsolute_path_key_timestamp_ms_key_assoc_value_assoc_by_ymd = function(timestamp_key_table)
      local tbl = {}
      for timestamp_ms, assoc in transf.table.kt_vt_stateless_iter(timestamp_key_table) do
        local ymd = os.date("%Y/%Y-%m/%Y-%m-%d", timestamp_ms/1000)
        if not tbl[ymd] then tbl[ymd] = {} end
        local found_unoccupied = false
        -- we don't want to overwrite any existing entries, so we will increment the timestamp_ms until we find an unoccupied slot
        -- this is acceptable as none of our use-cases require sub-second precision, and neither do I expect there to be many entries per second
        -- ergo our drift will be limited to a few ms at most, and the loop will terminate
        while not found_unoccupied do
          if not tbl[ymd][timestamp_ms] then
            tbl[ymd][timestamp_ms] = assoc
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
    timestamp_ms_key_assoc_value_assoc = function(raw_backup)
      -- data we care about is in the backupManga arr in the json file
      -- each arr element is a manga which has general metadata keys such as title, author, url, etc
      -- and a chapters arr which has chapter metadata keys such as name, chapterNumber, url, etc
      -- and a history arr which has the keys url and lastRead (unix timestamp in ms)
      -- we want to transform this into a table of our own design, where the key is a timestamp (but in seconds) and the value is a assoc consisting of some of the metadata of the manga and some of the metadata of the chapter
      -- specifically: url (of the manga), title, chapterNumber, name (of the chapter)
      -- for that, we need to match the key url in the history arr with the key url in the chapters arr, for which we will create a temporary table with the urls as keys and the chapter metadata we will use as values

      local manga = raw_backup.backupManga
      local manga_url, manga_title = manga.url, manga.title
      local chapter_map = {}
      for _, chapter in transf.arr.index_value_stateless_iter(manga.chapters) do
        chapter_map[chapter.url] = {
          chapterNumber = chapter.chapterNumber,
          name = chapter.name
        }
      end
      local history_assoc = {}
      for _, hist_item in transf.arr.index_value_stateless_iter(manga.history) do
        local chapter = chapter_map[hist_item.url]
        history_assoc[hist_item.lastRead] = {
          url = manga_url,
          title = manga_title,
          chapter_number = chapter.chapterNumber,
          chapter_name = chapter.name
        }
      end
      return history_assoc
    end,
  },
  vdirsyncer_pair_specifier = {
    assoc_of_assocs = function(specifier)
      local local_name = specifier.name .. "_local"
      local remote_name = specifier.name .. "_remote"
      return {
        two_anys_arr = {
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
    ini_str = function(specifier)
      return transf.assoc_of_str_value_assocs.ini_str(
        transf.assoc_of_assocs.assoc_by_space(
          transf.vdirsyncer_pair_specifier.assoc_of_assocs(specifier)
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
        url = url .. get.str.str_by_with_suffix(comps.host, "/")
        if comps.endpoint then
          url = url .. (get.str.no_prefix_str(comps.endpoint, "/") or "/")
        end   
      end     
      if comps.params then
        if is.any.table(comps.params) then
          url = url .. "?" .. transf.assoc.url_params(comps.params)
        else
          url = url .. get.str.with_prefix_str(comps.params, "?")
        end
      end
      return url
    end,
  },
  doilike = {
    doi = function(doilike)
      local doi = transf.indicated_doi.doi(doilike)
      doi = transf.doi_url.doi(doi)
      return doi
    end,
    doi_url = function(doilike)
      local doi = transf.indicated_doi.doi(doilike)
      doi = transf.doi.doi_url(doi)
      return doi
    end,
    indicated_doi = function(doilike)
      local doi = transf.doi_url.doi(doilike)
      doi = transf.doi.indicated_doi(doi)
      return doi
    end,
    csl_table_by_online = function(doilike)
      local doi = transf.doi_url.doi(doilike)
      return transf.doi.csl_table_by_online(doi)
    end,
  },
  doi_url = {
    doi = function(url)
      return get.str.n_strs_by_extracted_onig(url, r.g.id.doi_prefix .. "(.+)/?$")
    end,
    indicated_doi = function(url)
      return transf.doi.indicated_doi(transf.doi_url.doi(url))
    end,
  },
  indicated_doi = {
    doi = function(urnlike)
      doi = urnlike:lower()
      doi = get.str.no_prefix_str(urnlike, "urn:")
      doi = get.str.no_prefix_str(urnlike, "doi:")
      return doi
    end,
    doi_url = function(urnlike)
      return transf.doi.doi_url(transf.indicated_doi.doi(urnlike))
    end,
  },
  doi = {
    doi_url = function(doi)
      return "https://doi.org/" .. doi
    end,
    indicated_doi = function(doi)
      return "doi:" .. doi
    end,
    online_bib = function(doi)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "curl -LH Accept: application/x-bibtex" .. transf.str.str_by_single_quoted_escaped(
          transf.doi.doi_url(doi)
        )
      )
    end,
    csl_table_by_online = function(doi)
      return rest({
        url = transf.doi.doi_url(doi),
        accept_json_different_header = "application/vnd.citationstyles.csl+json",
      })
    end,
    indicated_citable_object_id = function(doi)
      return "doi:" .. doi
    end,
  },
  isbn = {
    online_bib = function(isbn)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "isbn_meta" .. transf.str.str_by_single_quoted_escaped(isbn) .. " bibtex"
      )
    end,
    csl_table_by_online = function(isbn)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "isbn_meta" .. transf.str.str_by_single_quoted_escaped(isbn) .. " csl"
      )
    end,
    indicated_citable_object_id = function(isbn)
      return "isbn:" .. isbn
    end,
  },
  isbn10 = {
    isbn13 = function(isbn10)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "to_isbn13" .. transf.str.str_by_single_quoted_escaped(isbn10)
      )
    end,
  },
  isbn13 = {
    isbn10 = function(isbn13)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "to_isbn10" .. transf.str.str_by_single_quoted_escaped(isbn13)
      )
    end,
  },
  indicated_citable_object_id = {
    mcitations_csl_file = function(id)
      return transf.filename_safe_indicated_citable_object_id.mcitations_csl_file_or_nil(
        transf.str.encoded_query_param_value(id)
      )
    end,
    local_csl_table = function(id)
      return transf.filename_safe_indicated_citable_object_id.csl_table_or_nil(
        transf.str.encoded_query_param_value(id)
      )
    end,
    citable_object_id = function(id)
      return get.str.n_strs_by_extracted_onig(id, "^[^:]+:(.*)$")
    end,
    citable_object_indicator = function(id)
      return get.str.str_arr_by_split_w_ascii_char(id, ":")[1]
    end,
    filename_safe_indicated_citable_object_id = function(id)
      return transf.str.encoded_query_param_value(id)
    end,
    csl_table_by_online = function(id)
      return transf[
        transf.indicated_citable_object_id.citable_object_indicator(id)
      ].csl_table_by_online(
        transf.indicated_citable_object_id.citable_object_id(id)
      )
    end,
    mpapers_citable_object_file = function(id)
      return transf.filename_safe_indicated_citable_object_id.mpapers_citable_object_file_or_nil(
        transf.str.encoded_query_param_value(id)
      )
    end,
    mpapernotes_citable_object_notes_file = function(id)
      return transf.filename_safe_indicated_citable_object_id.mpapernotes_citable_object_notes_file_or_nil(
        transf.str.encoded_query_param_value(id)
      )
    end,
    citations_file_line = function(id)
      return transf.csl_table.citations_file_line(
        transf.indicated_citable_object_id.local_csl_table(id)
      )
    end

  },
  filename_safe_indicated_citable_object_id = {
    indicated_citable_object_id = function(id)
      return transf.str.str_by_percent_decoded_also_plus(
        id
      )
    end,
    mcitations_csl_file_or_nil = function(id)
      return get.extant_path.absolute_path_or_nil_by_descendant_with_filename_ending(env.MCITATIONS, id)
    end,
    csl_table_or_nil = function(id)
      local path = transf.filename_safe_indicated_citable_object_id.mcitations_csl_file_or_nil(id)
      if path then
        return transf.json_file.not_userdata_or_function(
          path
        )
      else
        return nil
      end
    end,
    mpapers_citable_object_file_or_nil = function(id)
      return get.extant_path.absolute_path_or_nil_by_descendant_with_filename_ending(env.MPAPERS, id)
    end,
    mpapernotes_citable_object_notes_file_or_nil = function(id)
      return get.extant_path.absolute_path_or_nil_by_descendant_with_filename_ending(env.MPAPERNOTES, id)
    end,
  },
  citable_filename = {
    filename_safe_indicated_citable_object_id = function(filename)
      return get.str.str_arr_by_split_w_string(filename, "!citid:")[2]
    end,
    indicated_citable_object_id = function(filename)
      return transf.str.str_by_percent_decoded_also_plus(transf.citable_filename.filename_safe_indicated_citable_object_id(filename))
    end,
    csl_table = function(filename)
      return transf.indicated_citable_object_id.local_csl_table(
        transf.citable_filename.indicated_citable_object_id(filename)
      )
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
    csl_table = function(path)
      return transf.citable_filename.csl_table(
        transf.path.filename(path)
      )
    end,
  },
  citable_path_arr = {
    csl_table_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(arr, transf.citable_path.csl_table)
    end,
    indicated_citable_object_id_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(arr, transf.citable_path.indicated_citable_object_id)
    end,
  },
  citable_object_file ={ -- file with a citable_filename containing the data (e.g. pdf) of a citable object

  },
  citations_file = { -- plaintext file containing one indicated_citable_object_id per line
    indicated_citable_object_id_arr = function(file)
      return transf.plaintext_file.nocomment_noindent_content_lines(file)
    end,
    local_csl_table_arr = function(file)
      return transf.indicated_citable_object_id_arr.local_csl_table_arr(
        transf.citations_file.indicated_citable_object_id_arr(file)
      )
    end,
    bib_str = function(file)
      return transf.indicated_citable_object_id_arr.bib_str(
        transf.citations_file.indicated_citable_object_id_arr(file)
      )
    end,
    json_str = function(file)
      return transf.indicated_citable_object_id_arr.json_str(
        transf.citations_file.indicated_citable_object_id_arr(file)
      )
    end,
  },
  indicated_citable_object_id_arr = {
    local_csl_table_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.indicated_citable_object_id.local_csl_table
      )
    end,
    bib_str = function(arr)
      return transf.csl_table_arr.bib_str(
        transf.indicated_citable_object_id_arr.local_csl_table_arr(
          arr
        )
      )
    end,
    json_str = function(arr)
      return transf.csl_table_arr.json_str(
        transf.indicated_citable_object_id_arr.local_csl_table_arr(
          arr
        )
      )
    end,
    citations_file_line_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        transf.indicated_citable_object_id_arr.local_csl_table_arr(arr),
        transf.csl_table.citations_file_line
      )
    end,
    citations_file_str = function(arr)
      return get.str_or_number_arr.str_by_joined(
        transf.indicated_citable_object_id_arr.citations_file_line_arr(arr), 
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
    indicated_citable_object_id_arr_from_citations = function(dir)
      return transf.citations_file.indicated_citable_object_id_arr(
        transf.latex_project_dir.citations_file(dir)
      )
    end,
    local_csl_table_arr_from_citations = function(dir)
      return transf.citations_file.local_csl_table_arr(
        transf.latex_project_dir.citations_file(dir)
      )
    end,
    bib_str_from_citations = function(dir)
      return transf.citations_file.bib_str(
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
    creator_bank_details_str = function(dir)
      return get.contact_table.bank_details_str(
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
        transf["nil"].date_by_current():fmt("%Y") .. "-" ..
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
      return transf.dir.absolute_path_arr_by_children(
        transf.omegat_project_dir.source_dir(dir)
      )
    end,
    target_files = function(dir)
      return transf.dir.absolute_path_arr_by_children(
        transf.omegat_project_dir.target_dir(dir)
      )
    end,
    local_resultant_tm = function(dir)
      return transf.omegat_project_dir.tm_dir(dir) .. "/" .. transf.path.leaf(dir) .. "-omegat.tmx"
    end,
    rechnung_filename = function(dir)
      return get.timestamp_s.str_by_date_format_indicator(
        os.time(),
        tblmap.date_component_name.rfc3339like_dt_format_str["day"]
      ) .. "--" .. transf.omegat_project_dir.client_name(dir) .. "_" .. transf.omegat_project_dir.rechnung_number(dir)
    end,
    rechnung_pdf_path = function(dir)
      return transf.path.ending_with_slash(dir) .. transf.omegat_project_dir.rechnung_filename(dir) .. ".pdf"
    end,
    rechnung_md_path = function(dir)
      return transf.path.ending_with_slash(dir) .. transf.omegat_project_dir.rechnung_filename(dir) .. ".md"
    end,
    target_file_num_chars_arr = function(dir)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        transf.dir.absolute_path_arr_by_children(
          transf.omegat_project_dir.target_txt_dir(dir)
        ),
        transf.plaintext_file.utf8_char_arr
      )
    end,
    translation_price_specifier_arr = function(dir)
      local num_chars_arr = transf.omegat_project_dir.target_file_num_char_arr(dir)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        num_chars_arr,
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
      return transf.translation_price_specifier_arr.translation_price_specifier(
        transf.omegat_project_dir.translation_price_specifier_arr(dir)
      )
    end,
    translation_price_block_german = function(dir)
      return transf.translation_price_specifier.translation_price_block_german(
        transf.omegat_project_dir.translation_price_specifier(dir)
      )
    end,
    rechnung_email_specifier = function(dir)
      return {
        body = get.str.str_by_evaled_as_template(lemap.translation.rechnung_email_de, dir),
        non_inline_attachment_local_file_arr = {
          transf.omegat_project_dir.rechnung_pdf_path(dir)
        }
      }
    end,
    raw_rechnung = function(dir)
      return get.str.str_by_evaled_as_template(lemap.translation.rechnung_de, dir)
    end,

  },
  translation_price_specifier_arr = {
    translation_price_specifier = function(arr)
      return {
        translation_price_specifier_arr = arr,
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
        get.str_or_number_arr.str_by_joined(
          get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
            spec.translation_price_specifier_arr,
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
  number_arr = {

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
    window_arr = function(app)
      return app:allWindows()
    end,
    window_filter = function(app)
      return hs.window.filter.new(nil):setAppFilter(app)
    end,
    window_arr_via_window_filter = function(app)
      return transf.running_application.window_filter(app):getWindows()
    end,
    mac_application_name = function(app)
      return app:name()
    end,
    bundle_id = function(app)
      return app:bundleID()
    end,
    menu_item_table_arr = function(app)
      local arr = get.n_any_assoc_arr_arr.assoc_leaf_labels_with_title_path_arr(
        get.tree_node_like_arr.tree_node_arr(
          app:getMenuItems(),
          { levels_of_nesting_to_skip = 1}
        ),
        "AXTitle"
      )
      local filtered = get.arr.arr_by_filtered(arr, function (v) return v.AXTitle ~= "" end)
      for k, v in transf.table.kt_vt_stateless_iter(filtered) do
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
      return get.str.str_by_formatted_w_n_anys(
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
      local window_arr = transf.running_application.window_arr(running_application)
      return get.arr.pos_int_or_nil_by_first_match_w_fn(
        window_arr,
        function(v)
          return v:id() == window:id()
        end
      )
    end,
    jxa_window_index = function(window)
      return get.str.evaled_js_osa(
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
    window_arr = function(window_filter)
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
      return get.str.evaled_js_osa( 
        "Application('" .. window_spec.application_name .. "')" ..
          ".windows().[" ..
            window_spec.window_index ..
          "].tabs().length"
      )
    end,
    jxa_tab_specifier_arr = function(window_spec)
      local tab_spec_arr = {}
      for i = 0, transf.tabbable_jxa_window_specifier.amount_of_tabs(window_spec) - 1 do
        dothis.arr.insert_at_index(tab_spec_arr, {
          application_name = window_spec.application_name,
          window_index = window_spec.window_index,
          tab_index = i
        })
      end
      return tab_spec_arr
    end,
    active_tab_index = function(window_spec)
      return get.str.evaled_js_osa( 
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
    bool_by_running_application = function(app_name)
      return transf.mac_application_name.running_application(app_name) ~= nil
    end,
    ensure_running_application = function(app_name)
      local app = transf.mac_application_name.running_application(app_name)
      if app == nil then
        return hs.application.open(app_name, 5)
      end
      return app
    end,
    menu_item_table_arr = function(app_name)
      return transf.running_application.menu_item_table_arr(transf.mac_application_name.running_application(app_name))
    end,
    
  },
  chat_mac_application_name = {
    chat_storage_dir = function(app_name)
      return env.MCHATS .. "/" .. transf.str.str_by_all_eutf8_lower(app_name)
    end,
    chat_media_dir = function(app_name)
      return transf.chat_mac_application_name.chat_storage_dir(app_name) .. "/media"
    end,
    chat_chats_dir = function(app_name)
      return transf.chat_mac_application_name.chat_storage_dir(app_name) .. "/chats"
    end,
  },
  bib_str = {
    csl_table_arr = function(str)
      return transf.str.table_or_err_by_evaled_env_bash_parsed_json("pandoc -f biblatex -t csljson" .. transf.str.here_str(str))
    end,
    urls = function(str)
      return transf.csl_table_arr.url_arr(
        transf.bib_str.csl_table_arr(str)
      )
    end
  },
  csl_table_arr = {
    bib_str_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.csl_table.bib_str
      )
    end,
    bib_str = function(arr)
      return get.str_or_number_arr.str_by_joined(
        transf.csl_table_arr.bib_str_arr(arr),
        "\n"
      )
    end,
    json_str = transf.not_userdata_or_function.json_str,
    indicated_citable_object_id_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.csl_table.indicated_citable_object_id
      )
    end,
    citations_file_str = function(arr)
      return transf.indicated_citable_object_id_arr.citations_file_str(
        transf.csl_table_arr.indicated_citable_object_id_arr(arr)
      )
    end,
    url_arr = function(csl_table_arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(csl_table_arr, transf.csl_table.url)
    end,

  },
  csl_table_or_csl_table_arr = {
    url_arr = function(csl_table_or_csl_table_arr)
      if is.any.arr(csl_table_or_csl_table_arr) then
        return transf.csl_table_arr.url_arr(csl_table_or_csl_table_arr)
      else
        return {transf.csl_table.url(csl_table_or_csl_table_arr)}
      end
    end,
  },
  csl_table = {
    main_title = function(csl_table)
      return get.assoc.vt_by_first_match_w_kv_arr(csl_table, ls.csl_title_keys)
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
    issued_prefix_partial_date_component_name_value_assoc_force_first = function(csl_table)
      return transf.date_parts_single_or_range.prefix_partial_date_component_name_value_assoc_force_first(
        transf.csl_table.issued_date_parts_single_or_range(csl_table)
      )
    end,
    issued_year_force_first = function(csl_table)
      return transf.csl_table.issued_prefix_partial_date_component_name_value_assoc_force_first(csl_table).year
    end,
    author_arr = function(csl_table)
      return csl_table.author
    end,
    naive_author_summary = function(csl_table)
      return get.str_or_number_arr.str_by_joined(
        get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
          transf.csl_table.author_arr(csl_table),
          transf.csl_person.naive_name
        ),
        ", "
      )
    end,
    author_last_name_arr = function(csl_table)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        transf.csl_table.author_arr(csl_table),
        transf.csl_person.family
      )
    end,
    authors_et_al_arr = function(csl_table)
      return get.arr.arr_by_slice_removed_indicator_and_flatten_w_slice_spec(
        transf.csl_table.author_last_name_arr(csl_table),
        { stop = 5 },
        "et_al"
      )
    end,
    authors_et_al_str = function(csl_table)
      return get.str_or_number_arr.str_by_joined(
        transf.csl_table.authors_et_al_arr(csl_table),
        ", "
      )
    end,
    main_title_filenamized = function(csl_table)
      return transf.str.upper_camel_snake_case(
        transf.csl_table.main_title(csl_table)
      )
    end,
    filename = function(csl_table)
      return get.str.str_by_sub_lua(
        get.str_or_number_arr.str_by_joined(
          {
            transf.csl_table.authors_et_al_str(csl_table),
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
    indicated_volume_str = function(csl_table)
      local volume = transf.csl_table.volume(csl_table)
      if volume then
        return "vol. " .. volume
      end
    end,
    jssue = function(csl_table)
      return csl_table.issue
    end,
    indicated_issue_str = function(csl_table)
      local issue = transf.csl_table.issue(csl_table)
      if issue then
        return "no. " .. issue
      end
    end,
    page = function(csl_table)
      return csl_table.page
    end,
    page_interal_specifier = function(csl_table)
      return transf.single_value_or_basic_interval_str.interval_specifier(
        transf.csl_table.page(csl_table)
      )
    end,
    page_sequence_specifier = function(csl_table)
      return get.interval_specifier.sequence_specifier(
        transf.csl_table.page_interal_specifier(csl_table),
        1 -- afaik there is never a case where pages don't increase by 1 (there is no notation that says 'every other page', for example)
      )
    end,
    indicated_page_str = function(csl_table)
      local page = transf.csl_table.page(csl_table)
      if page then
        if get.str.bool_by_contains_w_ascii_str(page, "-") then
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
    indicated_doi = function(csl_table)
      local doi = transf.csl_table.doi(csl_table)
      if doi then
        return "doi:" .. doi
      end
    end,
    isbn = function(csl_table)
      return csl_table.isbn
    end,
    indicated_isbn = function(csl_table)
      local isbn = transf.csl_table.isbn(csl_table)
      if isbn then
        return "isbn:" .. isbn
      end
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
    indicated_isbn_part_identifier = function(csl_table)
      local isbn_part_identifier = transf.csl_table.isbn_part_identifier(csl_table)
      if isbn_part_identifier then
        return "isbn_part:" .. isbn_part_identifier
      end
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
    indicated_issn_full_identifier = function(csl_table)
      local issn_full_identifier = transf.csl_table.issn_full_identifier(csl_table)
      if issn_full_identifier then
        return "issn_full:" .. issn_full_identifier
      end
    end,
    pmid = function(csl_table)
      return csl_table.pmid
    end,
    indicated_pmid = function(csl_table)
      local pmid = transf.csl_table.pmid(csl_table)
      if pmid then
        return "pmid:" .. pmid
      end
    end,
    pmcid = function(csl_table)
      return csl_table.pmcid
    end,
    indicated_pmcid = function(csl_table)
      local pmcid = transf.csl_table.pmcid(csl_table)
      if pmcid then
        return "pmcid:" .. pmcid
      end
    end,
    url = function(csl_table)
      return csl_table.URL
    end,
    urlmd5 = function(csl_table)
      return transf.not_userdata_or_function.md5_hex_str(transf.csl_table.url(csl_table))
    end,
    indicated_urlmd5 = function(csl_table)
      local urlmd5 = transf.csl_table.urlmd5(csl_table)
      if urlmd5 then
        return "urlmd5:" .. urlmd5
      end
    end,
    accession = function(csl_table)
      return csl_table.accession
    end,
    indicated_accession = function(csl_table)
      local accession = transf.csl_table.accession(csl_table)
      if accession then
        return "accession:" .. accession
      end
    end,
    citable_object_id = function(csl_table)
      if csl_table.doi then
        return csl_table.doi
      elseif csl_table.isbn and is.csl_table.whole_book_csl_table(csl_table) then
        return csl_table.isbn
      elseif csl_table.isbn and not is.csl_table.whole_book_csl_table(csl_table) then
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
        return transf.csl_table.indicated_doi(csl_table)
      elseif csl_table.isbn and is.csl_table.whole_book_csl_table(csl_table) then
        return transf.csl_table.indicated_isbn(csl_table)
      elseif csl_table.isbn and not is.csl_table.whole_book_csl_table(csl_table) then
        return transf.csl_table.indicated_isbn_part_identifier(csl_table)
      elseif csl_table.pmid then
        return transf.csl_table.indicated_pmid(csl_table)
      elseif csl_table.pmcid then
        return transf.csl_table.indicated_pmcid(csl_table)
      elseif csl_table.accession then
        return transf.csl_table.indicated_accession(csl_table)
      elseif transf.csl_table.issn_full_identifier(csl_table) then
        return transf.csl_table.indicated_issn_full_identifier(csl_table)
      elseif csl_table.url then
        return transf.csl_table.indicated_urlmd5(csl_table)
      else
        return nil
      end
    end,
    citations_file_line = function(csl_table)
      return transf.csl_table.indicated_citable_object_id(csl_table) 
      .. " # " .. transf.csl_table.apa_str(csl_table)
    end,
    filename_safe_citable_object_id = function(csl_table)
      return transf.str.encoded_query_param_value(transf.csl_table.citable_object_id(csl_table))
    end,
    filename_safe_indicated_citable_object_id = function(csl_table)
      return transf.indicated_citable_object_id.filename_safe_indicated_citable_object_id(transf.csl_table.indicated_citable_object_id(csl_table))
    end,
    citable_filename = function(csl_table)
      return 
        transf.csl_table.filename(csl_table) ..
        "!citid:" .. transf.csl_table.filename_safe_indicated_citable_object_id(csl_table)
    end,
    bib_str = function(csl_table)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "pandoc -f csljson -t biblatex" .. transf.str.here_str(transf.not_userdata_or_function.json_str(csl_table))
      )
    end,
    apa_str = function(csl_table)
      return get.csl_table_or_csl_table_arr.raw_citations(csl_table, "apa-6th-edition")
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
      return get.str_or_number_arr.str_by_joined(
        transf.hole_y_arrlike.arr({
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
      return get.str_or_number_arr.str_by_joined(date_parts, "-")
    end,
    prefix_partial_date_component_name_value_assoc = function(date_parts)
      return { year = date_parts[1], month = date_parts[2], day = date_parts[3] }
    end,
    full_full_date_component_name_value_assoc = function(date_parts)
      return transf.date_component_name_value_assoc.min_full_date_component_name_value_assoc(
        transf.date_parts_single.prefix_partial_date_component_name_value_assoc(date_parts)
      )
    end,
    date = function(date_parts)
      return transf.full_date_component_name_value_assoc.date(
        transf.date_parts_single.full_full_date_component_name_value_assoc(date_parts)
      )
    end,
  },
  date_parts_range = {
    rfc3339like_interval = function(date_parts_range)
      return transf.date_parts.rfc3339like_dt(date_parts_range[1]) .. "_to_" .. transf.date_parts.rfc3339like_dt(date_parts_range[2])
    end,
    date_interval_specifier = function(date_parts_range)
      return {
        start = transf.date_parts_single.full_full_date_component_name_value_assoc(date_parts_range[1]),
        stop = transf.date_parts_single.full_full_date_component_name_value_assoc(date_parts_range[2])
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
    prefix_partial_date_component_name_value_assoc_force_first = function(date_parts)
      return transf.date_parts_single.prefix_partial_date_component_name_value_assoc(date_parts[1])
    end,
    full_full_date_component_name_value_assoc_force_first = function(date_parts)
      return transf.date_parts_single.full_full_date_component_name_value_assoc(date_parts[1])
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
      return get.fn.rt_or_nil_by_memoized_invalidate_1_day(transf.str.str_or_nil_by_evaled_env_bash_stripped, "run")
          "curl -L" .. transf.str.str_by_single_quoted_escaped(url)
    end,
    in_cache_dir = function(url)
      return transf.not_userdata_or_function.in_cache_dir(transf.url.url_by_ensure_scheme(url), "url")
    end,
    url_table = function(url)
      return get.fn.rt_or_nil_by_memoized(
        transf.str.table_or_nil_by_evaled_env_bash_parsed_json,
        {},
        "transf.str.table_or_nil_by_evaled_env_bash_parsed_json"
      )(
        "url_parser_cli --json" .. transf.str.str_by_single_quoted_escaped(url)
      )
    end,
    scheme = function(url)
      return transf.url.url_table(url).scheme
    end,
    host = function(url)
      return transf.url.url_table(url).host
    end,
    sld_and_tld = function(url)
      return get.str.n_strs_by_extracted_eutf8(transf.url.host(url), "(%w+%.%w+)$")
    end,
    sld = function(url)
      return get.str.n_strs_by_extracted_eutf8(transf.url.host(url), "(%w+)%.%w+$") 
    end,
    tld = function(url)
      return get.str.n_strs_by_extracted_eutf8(transf.url.host(url), "%w+%.(%w+)$")
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
      return transf.url.url_table(url).username
    end,
    password = function(url)
      return transf.url.url_table(url).password
    end,
    param_table = function(url)
      local params = {}
      local url_parts = get.str.str_arr_by_split_w_ascii_char(url, "?")
      if #url_parts > 1 then
        local param_parts = get.str.str_arr_by_split_w_ascii_char(url_parts[2], "&")
        for _, param_part in transf.arr.index_value_stateless_iter(param_parts) do
          local param_parts = get.str.str_arr_by_split_w_ascii_char(param_part, "=")
          local key = param_parts[1]
          local value = param_parts[2]
          params[key] = transf.str.str_by_percent_decoded_also_plus(value)
        end
      end
      return params
    end,
    no_scheme = function(url)
      local parts = get.str.str_arr_by_split_w_ascii_char(url, ":")
      act.arr.shift(parts)
      local rejoined = get.str_or_number_arr.str_by_joined(parts, ":")
      return get.str.no_prefix_str(rejoined, "//")
    end,
    str_by_webcal_name = function(url)
      return "webcal_readonly_" .. transf.not_userdata_or_function.md5_hex_str(url)
    end,
    vdirsyncer_pair_specifier = function(url)
      local name = transf.url.str_by_webcal_name(url)
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
      return env.XDG_STATE_HOME .. "/vdirsyncer/" .. transf.url.str_by_webcal_name(url)
    end,
    ini_str_by_khal_config_section = function(url)
      return transf.assoc_of_str_value_assocs.ini_str({
        ["[ro:".. transf.url.sld(url) .. "]"] = {
          path = transf.url.absolute_path_by_webcal_storage_location(url),
          priority = 0,
        }
      })
    end,
    url_potentially_with_title_comment = function(url)
      local title = transf.sgml_url.str_or_nil_by_title(url)
      if title and title ~= "" then
        return url .. " # " .. title
      else
        return url
      end
    end,
    title_or_url_as_filename = function(url)
      local title = transf.sgml_url.str_or_nil_by_title(url)
      if title and title ~= "" then
        return transf.str.safe_filename(title) .. ".url2"
      else
        return transf.str.safe_filename(url) .. ".url2"
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
    sgml_str = transf.url.default_negotiation_url_contents, -- ideally we would reject non-html responses, but currently, that's too much work
    str_or_nil_by_title = function(url)
      return get.sgml_url.str_or_nil_by_query_selector_all(url, "title")
    end,
    str_or_nil_by_description = function(url)
      return get.sgml_url.str_or_nil_by_query_selector_all(url, "meta[name=description]")
    end,
    sgml_url_with_title_comment = function(url)
      return url .. " # " .. transf.sgml_url.str_or_nil_by_title(url)
    end
  },
  owner_item_url = {
    owner_item = function(url)
      return get.path.path_component_arr_by_slice_w_slice_spec(transf.url.path(url), "1:2")
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
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "saucenao --url" ..
        transf.str.str_by_single_quoted_escaped(url)
        .. "--output-properties booru-url"
      )
    end,
    hs_image = function(url)
      return get.fn.rt_or_nil_by_memoized_invalidate_1_week(hs.image.imageFromURL, "hs.image.imageFromURL")(url)
    end,
    qr_data = function(url)
      local path = transf.url.in_cache_dir(url)
      dothis.url.download_to(url, path)
      return transf.local_image_file.qr_data(path)
    end,
    data_url = function(url)
      local ext = transf.path.extension(url)
      return get.fn.rt_or_nil_by_memoized(hs.image.encodeAsURLstr)(transf.image_url.hs_image(url), ext)
    end,
  },
  gelbooru_style_post_url = {
    nonindicated_number_str_by_booru_post_id = function(url)
      return transf.url.param_table(url).id
    end,
    pos_int_by_booru_post_id = function(url)
      return transf.nonindicated_number_str.number_by_base_10(transf.gelbooru_style_post_url.nonindicated_number_str_by_booru_post_id(url))
    end,
  },
  yandere_style_post_url = {
    nonindicated_number_str_by_booru_post_id = function(url)
      return get.str.n_strs_by_extracted_eutf8(transf.url.path(url), "/post/show/(%d+)")
    end
  },
  danbooru_style_post_url = {
    nonindicated_number_str_by_booru_post_id = function(url)
      return get.str.n_strs_by_extracted_eutf8(transf.url.path(url), "/posts/(%d+)")
    end
  },
  gpt_response_table = {
    response_text = function(result)
      local first_choice = result.choices[1]
      local response = first_choice.text or first_choice.message.content
      return transf.str.not_starting_or_ending_with_whitespace_str(response)
    end
  },
  not_userdata_or_function = {
    md5_hex_str = function(thing)
      if is.any.not_str(thing) then 
        thing = json.encode(thing) 
      end
      local md5 = hashings("md5")
      md5:update(thing)
      return md5:hexdigest()
    end,
    md5_base32_crock_str = function(thing)
      if is.any.not_str(thing) then 
        thing = json.encode(thing) 
      end
      local md5 = hashings("md5")
      md5:update(thing)
      return transf.str.base32_crock_str_by_utf8(md5:digest())
    end,
    in_cache_dir = function(data, type)
      return transf.str.in_cache_dir(
        transf.not_userdata_or_function.md5_hex_str(data),
        type
      )
    end,
    in_tmp_dir = function(data, type)
      return transf.str.in_tmp_dir(
        transf.not_userdata_or_function.md5_hex_str(data),
        type
      )
    end,
    single_quoted_escaped_json = function(t)
      return transf.str.str_by_single_quoted_escaped(json.encode(t))
    end,
    json_str = json.encode,
    json_str_pretty = function(t)
      if is.any.table(t) then
        return transf.table.json_str_by_pretty(t)
      else
        return transf.not_userdata_or_function.json_str(t)
      end
    end,
    --- wraps yaml.dump into a more intuitive form which always encodes a single document
    --- @param tbl any
    --- @return str
    yaml_str = function(tbl)
      local raw_yaml = yaml.dump({tbl})
      local lines = get.str.str_arr_by_split_w_ascii_char(raw_yaml, "\n")
      return get.str_or_number_arr.str_by_joined(lines, "\n", 2, #lines - 2)
    end,
    json_here_str = function(t)
      return transf.str.here_str(json.encode(t))
    end,
  },
  any = {
    str_by_inspect = function(thing)
      return hs.inspect(thing, {depth = 5})
    end,
    str = tostring,
    --- avoids the use of memory addresses except for functions and userdata, where it is unavoidable. Therefore it is replicable in the sense that it should produce the same string for the same input even between different lua instances.
    str_by_replicable = function(strable)
      if is.any.str(strable) then
        return strable
      elseif is.any.not_table(strable) then
        return transf.any.str(strable)
      else
        local succ, json = pcall(transf.not_userdata_or_function.json_str, strable)
        if succ then
          return json
        else
          return transf.any.str_by_inspect(strable)
        end
      end
    end,
    self_and_empty_str = function(any)
      return any, ""
    end,
    t_by_self = function(any)
      return any
    end,
    bool = function(any)
      return not not any
    end,
    n_anys_if_table = function(any)
      if is.any.table(any) then
        return transf.arr.n_anys(any)
      else
        return any
      end
    end,
    applicable_thing_name_hierarchy = function(any)
      return get.any.applicable_thing_name_hierarchy(any)
    end,
    applicable_thing_name_arr = function(any)
      return transf.thing_name_hierarchy.thing_name_arr(transf.any.applicable_thing_name_hierarchy(any))
    end,
    applicable_action_specifier_arr = function(any)
      return transf.thing_name_arr.action_specifier_arr(transf.any.applicable_thing_name_arr(any))
    end,
    applicable_action_chooser_item_specifier_arr = function(any)
      return transf.action_specifier_arr.action_chooser_item_specifier_arr(transf.any.applicable_action_specifier_arr(any))
    end,
    applicable_action_with_index_chooser_item_specifier_arr = function(any)
      return transf.assoc_arr.assoc_with_index_as_key_arr(transf.any.applicable_action_chooser_item_specifier_arr(any))
    end,
    placeholder_text = function(any)
      return "Choose action on: " .. (
        get.thing_name_arr.placeholder_text(transf.any.applicable_thing_name_arr(any), any) or
        get.thing_name_arr.chooser_text(transf.any.applicable_thing_name_arr(any), any)
      )
    end,
    hschooser_specifier = function(any)
      return {
        chooser_item_specifier_arr = transf.any.applicable_action_with_index_chooser_item_specifier_arr(any),
        placeholder_text = transf.any.placeholder_text(any),
      }
    end,
    choosing_hschooser_specifier = function(any)
      return get.hschooser_specifier.choosing_hschooser_specifier(transf.any.hschooser_specifier(any), "index", any)
    end,
    any_and_applicable_thing_name_arr_specifier = function(any)
      return {
        any = any,
        applicable_thing_name_arr = transf.any.applicable_thing_name_arr(any)
      }
    end,
    item_chooser_item_specifier = function(any)
      local applicable_thing_name_arr = transf.any.applicable_thing_name_arr(any)
      return {
        text = transf.str.with_styled_start_end_markers(get.thing_name_arr.chooser_text(applicable_thing_name_arr, any)),
        subText = get.thing_name_arr.chooser_subtext(applicable_thing_name_arr, any),
        image = get.thing_name_arr.chooser_image(applicable_thing_name_arr, any),
      }
    end,
    t_by_with_1_added_if_number = function(any)
      if is.any.number(any) then
        return any + 1
      else
        return any
      end
    end,
    t_by_with_1_subtracted_if_number = function(any)
      if is.any.number(any) then
        return any - 1
      else
        return any
      end
    end,
    t_arr = function(any)
      return {any}
    end
  },
  item_chooser_item_specifier = {
    truncated_text_item_chooser_item_specifier = function(item_chooser_item_specifier)
      local copied_spec = get.table.table_by_copy(item_chooser_item_specifier)
      local rawstr =  transf.styledtext.str(
        copied_spec.text
      )
      local truncated = get.str.str_by_shortened_start_ellipsis(rawstr, 250)
      copied_spec.text = transf.str.with_styled_start_end_markers(truncated)
      return copied_spec
    end
  },
  n_anys = {
    arr = function(...)
      return {...}
    end,
    n_anys = function(...)
      return ...
    end,
    int_by_amount = function(...)
      return select("#", ...)
    end,
  },
  str_and_n_anys = {
    str_and_n_anys_by_stripped = function(...)
      local arg1 = select(1, ...)
      return transf.str.not_starting_or_ending_with_whitespace_str(arg1), select(2, ...)
    end
  },
  n_bool_functions = {
    and_bool_function = function(...)
      local functions = {...}
      return function(arg)
        for _, fn in transf.arr.index_value_stateless_iter(functions) do
          if not fn(arg) then
            return false
          end
        end
        return true
      end
    end,
    or_bool_function = function(...)
      local functions = {...}
      return function(arg)
        for _, fn in transf.arr.index_value_stateless_iter(functions) do
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
      local emails_part = get.str.str_arr_by_split_w_ascii_char(no_scheme, "?")[1]
      local emails = get.str.str_arr_by_split_w_ascii_char(emails_part, ",")
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(emails, transf.str.not_starting_or_ending_with_whitespace_str)
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
      return get.str.str_arr_by_split_w_ascii_char(transf.url.no_scheme(otpauth_url), "/")[1]
    end,
    label = function(otpauth_url)
      local part = get.str.str_arr_by_split_w_ascii_char(transf.url.no_scheme(otpauth_url), "/")[2]
      return get.str.str_arr_by_split_w_ascii_char(part, "?")[1]
    end,
    
  },
  data_url = {
    raw_type = function(data_url)
      return get.str.str_arr_by_split_w_ascii_char(transf.url.no_scheme(data_url), ";")[1]
    end,
    header_part = function(data_url) -- the non-data part will either be separated from the rest of the url by `;,` or `;base64,`, so we need to split on `,`, then find the first part that ends `;` or `base64;`, and then join and return all parts before that part
      local parts = get.str.str_arr_by_split_w_ascii_char(transf.url.no_scheme(data_url), ",")
      local non_data_part = ""
      for _, part in transf.arr.index_value_stateless_iter(parts) do
        non_data_part = non_data_part .. part
        if get.str.bool_by_endswith(part, ";") or get.str.bool_by_endswith(part, "base64;") then
          break
        else
          non_data_part = non_data_part .. ","
        end
      end
      return non_data_part
    end,
    payload_part = function(data_url)
      return get.str.no_prefix_str(transf.url.no_scheme(data_url), transf.data_url.header_part(data_url))
    end,
      
    raw_type_param_table = function(data_url)
      local parts = get.str.str_arr_by_split_w_ascii_char(transf.data_url.header_part(data_url), ";")
      act.arr.shift(parts) -- this is the content type
      act.arr.pop(parts) -- this is the base64, or ""
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(parts, function(part)
        local kv = get.str.str_arr_by_split_w_ascii_char(part, "=")
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
      return get.arr.arr_by_slice_w_3_pos_int_any_or_nils(get.str.str_arr_by_split_w_ascii_char(source_id, "."), -1, -1)[1]
    end,
  },
  source_id_arr = {
    source_id_by_next_to_be_activated = function(source_id_arr)
      return get.arr.next_by_fn_wrapping(source_id_arr, is.source_id.active_source_id)
    end,
  },
  -- for future reference, since I'll forget: mod is a hypernym of mod_name, mod_symbol, and mod_char. Via the implementation in `normalize` we can be sure that no matter what we provide when we use tblmap, we will get the desired thing back.
  menu_item_table = {
    mod_name_arr = function(menu_item_table)
      return menu_item_table.AXMenuItemCmdModifiers
    end,
    mod_symbol_arr = function(menu_item_table)
      return transf.mod_name_arr.mod_symbol_arr(transf.menu_item_table.mod_name_arr(menu_item_table))
    end,
    hotkey = function(menu_item_table)
      return menu_item_table.AXMenuItemCmdChar
    end,
    shortcut_str = function(menu_item_table)
      return transf.shortcut_specifier.shortcut_str({
        mod_arr = transf.menu_item_table.mod_name_arr(menu_item_table),
        key = transf.menu_item_table.hotkey(menu_item_table)
      } )
    end,
    str_by_title = function(menu_item_table)
      return menu_item_table.AXTitle
    end,
    full_action_path = function(menu_item_table)
      return transf.arr_and_any.arr(menu_item_table.path, menu_item_table.AXTitle)
    end,
    full_action_path_str = function(menu_item_table)
      return transf.str_arr.action_path_str(transf.menu_item_table.full_action_path(menu_item_table))
    end,
    running_application = function(menu_item_table)
      return menu_item_table.application
    end,
    str_by_summary = function(menu_item_table)
      if transf.menu_item_table.hotkey(menu_item_table) then
        return transf.menu_item_table.full_action_path_str(menu_item_table) .. " (" .. transf.menu_item_table.shortcut_str(menu_item_table) .. ")"
      else
        return transf.menu_item_table.full_action_path_str(menu_item_table)
      end
    end
  },
  mod_name_arr = {
    mod_symbol_arr = function(mod_arr)
      return get.arr.arr_by_mapped_w_t_key_assoc(mod_arr, transf.mod.mod_symbol)
    end,
    mod_char_arr = function(mod_arr)
      return get.arr.arr_by_mapped_w_t_key_assoc(mod_arr, transf.mod.mod_char)
    end,
  },
  shortcut_specifier = {
    mod_name_arr = function(shortcut_specifier)
      return shortcut_specifier.mod_name_arr
    end,
    key = function(shortcut_specifier)
      return shortcut_specifier.key
    end,
    shortcut_arr = function(shortcut_specifier)
      return transf.arr_and_any.arr(
        shortcut_specifier.mod_name_arr,
        shortcut_specifier.key
      )
    end,
    shortcut_str = function(shortcut_specifier)
      local modstr = get.str_or_number_arr.str_by_joined(get.arr.arr_by_mapped_w_t_key_assoc(shortcut_specifier.mod_name_arr, tblmap.mod_name.mod_symbol), "")
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
  audiodevice_specifier_arr = {
    active_audiodevice_specifier_index = function(arr)
      return get.arr.pos_int_or_nil_by_first_match_w_fn(arr, is.audiodevice_specifier.active_audiodevice_specifier)
    end,
  },
  audiodevice = {
    name = function(audiodevice)
      return audiodevice:name()
    end,
  },
  env_var_name_env_node_assoc = {
    env_str = function(env_var_name_env_node_assoc)
      return transf.env_var_name_value_assoc.env_str(
        get.env_var_name_env_node_assoc.env_var_name_value_assoc(env_var_name_env_node_assoc)
      )
    end

  },
  env_yaml_file_container = {
    env_str = function(env_yaml_file_container)
      local files = transf.extant_path.file_arr_by_descendants(env_yaml_file_container)
      local yaml_files = get.path_arr.path_arr_by_filter_to_same_extension(files, "yaml")
      local env_var_name_env_node_assoc_arr = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        yaml_files,
        transf.yaml_file.not_userdata_or_function
      )
      local env_var_name_env_node_assoc = transf.table_arr.table_by_take_new(env_var_name_env_node_assoc_arr)
      return transf.env_var_name_env_node_assoc.env_str(env_var_name_env_node_assoc)
    end,
  },
  country_identifier_str = {
    iso_3366_1_alpha_2_country_code = function(country_identifier)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_str({
        input = country_identifier, 
        query = "Suppose the following identifies a country. Return its ISO 3166-1 Alpha-2 country code."
      }):lower()
    end,
  },
  language_identifier_str = {
    bcp_47_language_tag = function(country_identifier)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_str({
        input = country_identifier, 
        query = "Suppose the following identifies a language or variety. Return its BCP 47 language tag. Be conservative and only add information that is present in the input, or is necessary to make it into a valid BCP 47 language tag."
      })
    end,
  },
  bcp_47_language_tag = {
    summary = function(bcp_47_language_tag)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_str({
        input = bcp_47_language_tag, 
        query = "Suppose the following is a BCP 47 language tag. Return a natural language description of it."
      })
    end,
  },
  iso_3366_1_alpha_2_country_code = {
    iso_3366_1_full_name = function(iso_3366_1_alpha_2)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_str({
        input = iso_3366_1_alpha_2, 
        query = "Get the ISO 3366-1 full name of the country identified by the following ISO 3366-1 Alpha-2 country code."
      })
    end,
    iso_3366_1_short_name = function(iso_3366_1_alpha_2)
      return get.n_shot_llm_spec.n_shot_api_query_llm_response_str({
        input = iso_3366_1_alpha_2, 
        query = "Get the ISO 3366-1 short name of the country identified by the following ISO 3366-1 Alpha-2 country code."
      })
    end,
  },
  bool = {
    negated = function(bool)
      return not bool
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
    empty_str = function()
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
          error("poisoned " .. transf.any.str(returnfn))
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
    random_bool = function()
      return math.random() < 0.5
    end,
    all_applications = function()
      return transf.dir.children_filename_arr("/Applications")
    end,
    sox_is_recording = function()
      return transf.str.bool_by_evaled_env_bash_success("pgrep -x rec")
    end,
    pandoc_full_md_extension_set = function()
      return transf.arr_value_assoc.arr_by_flatten(
        ls.markdown_extensions
      )
    end,
    passw_pass_item_name_arr = function()
      return transf.dir.children_filename_arr(env.MPASSPASSW)
    end,
    otp_pass_item_name_arr = function()
      return transf.dir.children_filename_arr(env.MPASSOTP)
    end,
    date_by_current = function()
      return transf["nil"].date_by_current()
    end,
    timestamp_s_last_midnight = function()
      return transf.date.timestamp_s(
        get.date.precision_date(
          transf["nil"].date_by_current(),
          "day"
        )
      )
    end,
    package_manager_name_arr = function()
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg list-package-managers"))
    end,
    package_manager_name_arr_with_missing_packages = function()
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg missing-package-manager"))
    end,
    semver_str_arr_by_installed_package_managers = function ()
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg package-manager-version"))
    end,
    absolute_path_arr_by_installed_package_managers = function()
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg which-package-manager"))
    end,
    mullvad_status_str = function()
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("mullvad status")
    end,
    mullvad_bool_connected = function()
      return get.str.bool_by_startswith(transf["nil"].mullvad_status_str(),"Connected")
    end,
    mullvad_relay_list_str = function()
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)("mullvad relay list")
    end,
    mullvad_relay_identifier_arr = function()
      return 
        transf.table.arr_by_nested_value_primitive_and_arrlike_is_leaf(
          transf.multiline_str.iso_3366_1_alpha_2_country_code_key_mullvad_city_code_key_mullvad_relay_identifier_str_arr_value_assoc_value_assoc(
            transf["nil"].mullvad_relay_list_str()
          )
      )
    end,
    active_mullvad_relay_identifier = function()
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("mullvad relay get"):match("hostname ([^ ]+)")
    end,
    volume_local_extant_path_arr = function()
      return get.arr.arr_by_filtered(
        transf.table_or_nil.kt_arr(hs.fs.volume.allVolumes()),
        is.local_absolute_path.root_local_absolute_path
      )
    end,
    calendar_name_arr = function()
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("khal printcalendars"))
    end,
    writeable_calendar_name_arr = function()
      return get.arr.arr_by_filtered(
        transf["nil"].calendar_name_arr(),
        is.calendar_name.writeable_calendar_name
      )
    end,
    str_by_khard_list_output = function()
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)(
        "khard list --parsable"
      )
    end,
    contact_uuid_arr = function()
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        get.str.str_arr_by_split_w_ascii_char(transf["nil"].str_by_khard_list_output(), "\n"), 
        function (line)
          return get.str.str_arr_by_split_w_ascii_char(line, "\t")[1]
        end
      )
    end,
    contact_table_arr = function()
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        transf["nil"].contact_uuid_arr(),
        function(uid)
          return transf.uuid.contact_table(uid)
        end
      )
    end,
    telegram_raw_export_dir_by_current = function()
      return env.DOWNLOADS .. "/Telegram Desktop/DataExport_" .. get.date.str_w_date_format_indicator(
        transf["nil"].date_by_current(),
        "%Y-%m-%d"
      )
    end,
    running_application_by_frontmost = hs.application.frontmostApplication,
    menu_item_table_arr_by_frontmost_application = function()
      return transf.menu_item_table_arr.menu_item_table_arr_by_application(
        transf["nil"].running_application_by_frontmost()
      )
    end,
    installed_app_dir_arr = function()
      return transf.local_dir.local_extant_path_arr_by_descendants(env.APPLICATIONS)
    end,
    mac_application_name_arr = function()
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        transf["nil"].installed_app_dir_arr(),
        transf.path.filename
      )
    end,

  },
  audiodevice_type = {
    default_audiodevice = function(type)
      return hs.audiodevice["default" .. transf.str.str_by_first_eutf8_upper(type) .. "Device"]()
    end,
    audiodevice_specifier_arr = function(type)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        hs.audiodevice["all" .. transf.str.str_by_first_eutf8_upper(type) .. "Devices"](),
        function (device)
          return get.audiodevice.audiodevice_specifier(device, type)
        end
      )
    end,
  },
  package_manager_name = {
    semver_str = function(mgr)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. mgr .. " package-manager-version")
    end,
    absolute_path = function(mgr)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. mgr .. " which-package-manager")
    end,
  },
  package_manager_name_or_nil = {
    backed_up_package_name_arr = function(mgr)
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " read-backup"))
    end,
    missing_package_name_arr = function(mgr)
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " missing"))
    end,
    added_package_name_arr = function(mgr)
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " added"))
    end,
    difference_package_name_arr = function(mgr)
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " difference"))
    end,
    package_name_or_package_name_semver_compound_str_arr = function(mgr) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list ")) end,
    package_name_semver_compound_str_arr = function(mgr) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list-version ")) end,
    package_name_arr = function(mgr) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list-no-version ")) end,
    package_name_semver_package_manager_name_compound_str_arr = function(mgr) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list-version-package-manager ")) end,
    package_name_package_manager_name_compound_str = function(mgr) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list-with-package-manager ")) end,
    nonindicated_dec_str_arr_installed = function(mgr) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " count ")) end,
    calendar_template_table_by_empty = function()
      CALENDAR_TEMPLATE_SPECIFIER = {}
      CALENDAR_TEMPLATE_SPECIFIER.calendar = { 
        comment = 'one of: {{[ transf["nil"].writeable_calendar_str() ]}}' ,
        value = "default"
      }
      CALENDAR_TEMPLATE_SPECIFIER.start = {
        value = transf["nil"].date_by_current():fmt("%Y-%m-%dT%H:%M"),
      }
      CALENDAR_TEMPLATE_SPECIFIER.title = {}
      CALENDAR_TEMPLATE_SPECIFIER.description = {}
      CALENDAR_TEMPLATE_SPECIFIER.location = {}
      CALENDAR_TEMPLATE_SPECIFIER["end"] = {
        comment = 'end of the event, either as a date, or as a delta in the form of [<n>d][<n>h][<n>m][<n>s]'
      }
      CALENDAR_TEMPLATE_SPECIFIER.alarms = {
        comment = 'arr of alarms as deltas'
      }
      CALENDAR_TEMPLATE_SPECIFIER.url = {}
      CALENDAR_TEMPLATE_SPECIFIER.timezone = {
        comment = 'leave empty for local timezone'
      }
      CALENDAR_TEMPLATE_SPECIFIER["repeat"] = {}
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
        comment = 'valid values: valid values: arr of [sign]<integer><weekday>; meaning: occurrences to repeat on within freq'
      }
      CALENDAR_TEMPLATE_SPECIFIER["repeat"].bymonthday = {
        comment = 'only if freq is m[onthly]; valid values: arr of [sign]<integer>; meaning: days of month to repeat on'
      }
      CALENDAR_TEMPLATE_SPECIFIER["repeat"].bymonth = {
        comment = 'only if freq is y[early]; valid values: arr of [sign]<integer>; meaning: months to repeat on'
      }
      CALENDAR_TEMPLATE_SPECIFIER["repeat"].byyearday = {
        comment = 'only if freq is y[early]; valid values: arr of [sign]<integer>; meaning: days of year to repeat on'
      }
      return CALENDAR_TEMPLATE_SPECIFIER
    end
  },
  package_name = {
    installed_package_manager = function(pkg) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg installed_package_manager " .. pkg)) end,
  },
  action_specifier = {
    action_chooser_item_specifier = function(action_specifier)
      if action_specifier.text then error("old action_specifier format, contains action_specifier.text") end
      local str = get.str.str_by_with_suffix(action_specifier.d, ".")
      str = str .. " #" .. get.not_userdata_or_function.md5_base32_crock_str_of_length(action_specifier.d, 3) -- shortcode for easy use
      return {text = str}
    end
  },
  action_specifier_arr = {
    action_chooser_item_specifier_arr = function(action_specifier_arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        action_specifier_arr,
        transf.action_specifier.action_chooser_item_specifier
      )
    end,
    action_with_index_choose_item_specifier_arr = function(action_specifier_arr)
      return transf.assoc_arr.assoc_with_index_as_key_arr(
        transf.action_specifier.action_chooser_item_specifier_arr(action_specifier_arr)
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
    transf_action_specifier_arr = function(thing_name)
      return get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
        transf[thing_name],
        function(thing_name2, fn)
          return {
            d = "transf." .. thing_name .. "." .. thing_name2,
            getfn = fn
          }
        end
      )
    end,
    act_action_specifier_arr = function(thing_name)
      return get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
        act[thing_name],
        function(action, fn)
          return {
            d = "act." .. thing_name .. "." .. action,
            getfn = fn
          }
        end
      )
    end,
    action_specifier_arr = function(thing_name)
      return transf.two_arrs.arr_by_appended(
        transf.thing_name.act_action_specifier_arr[thing_name],
        transf.thing_name.transf_action_specifier_arr[thing_name]
      )
    end,
  },
  thing_name_hierarchy = {
    thing_name_arr = function(thing_name_hierarchy)
      return transf.table.arr_by_nested_final_key_label_by_primitive_and_arrlike_is_leaf(thing_name_hierarchy)
    end
  },
  thing_name_arr = {
    action_specifier_arr_arr = function(thing_name_arr)
      return get.arr.arr_by_mapped_w_t_key_assoc(
        thing_name_arr,
        tblmap.thing_name.action_specifier_arr
      )
    end,
    action_specifier_arr = function(thing_name_arr)
      return transf.arr_arr.arr_by_flatten(
        transf.thing_name_arr.action_specifier_arr_arr(thing_name_arr)
      )
    end,
    chooser_image_retriever_specifier_arr = function(thing_name_arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        thing_name_arr,
        function(thing_name)
          local spec = tblmap.thing_name.chooser_image_partial_retriever_specifier(thing_name)
          local newspec = {}
          newspec.thing_name = spec.thing_name
          newspec.precedence = spec.precedence or 1
          return newspec
        end
      )
    end,
    chooser_text_retriever_specifier_arr = function(thing_name_arr)
      return hs.fnutils.map(
        thing_name_arr,
        function(thing_name)
          local spec = tblmap.thing_name.chooser_text_partial_retriever_specifier(thing_name)
          local newspec = {}
          newspec.thing_name = spec.thing_name
          newspec.precedence = spec.precedence or 1
          return newspec
        end
      )
    end,
    placeholder_text_retriever_specifier_arr = function(thing_name_arr)
      return hs.fnutils.map(
        thing_name_arr,
        function(thing_name)
          local spec = tblmap.thing_name.placeholder_text_partial_retriever_specifier(thing_name)
          local newspec = {}
          newspec.thing_name = spec.thing_name
          newspec.precedence = spec.precedence or 1
          return newspec
        end
      )
    end,
    chooser_subtext_retriever_specifier_arr = function(thing_name_arr)
      return hs.fnutils.map(
        thing_name_arr,
        function(thing_name)
          local spec = tblmap.thing_name.chooser_subtext_partial_retriever_specifier(thing_name)
          local newspec = {}
          newspec.thing_name = spec.thing_name
          newspec.precedence = spec.precedence or 1
          return newspec
        end
      )
    end,
    chooser_initial_selected_index_retriever_specifier_arr = function(thing_name_arr)
      return hs.fnutils.map(
        thing_name_arr,
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
  retriever_specifier_arr = {
    highest_precedence_retriever_specifier = function(retriever_specifier_arr)
      return hs.fnutils.reduce(
        retriever_specifier_arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(get.table_and_table.larger_table_by_key {a_use, a_use, "precedence"})
      )
    end,
    precedence_ordered_retriever_specifier_arr = function(retriever_specifier_arr)
      return get.arr.arr_by_sorted(
        retriever_specifier_arr,
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
      return get.mpv_ipc_socket_id.str(mpv_ipc_socket_id, "stream-open-filename")
    end,
    title = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.str(mpv_ipc_socket_id, "media-title")
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
    playback_str = function(mpv_ipc_socket_id)
      return get.str.str_by_formatted_w_n_anys(
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
    playlist_progress_str = function(mpv_ipc_socket_id)
      return get.str.str_by_formatted_w_n_anys(
        "[%i/%i]",
        get.mpv_ipc_socket_id.playlist_position_int(mpv_ipc_socket_id) or -1,
        get.mpv_ipc_socket_id.playlist_length_int(mpv_ipc_socket_id) or -1
      )
    end,
    summary_line_basics = function(mpv_ipc_socket_id)
      return get.str.str_by_formatted_w_n_anys(
        "%s %s %s",
        transf.mpv_ipc_socket_id.playback_str(mpv_ipc_socket_id),
        transf.mpv_ipc_socket_id.playlist_progress_str(mpv_ipc_socket_id),
        get.mpv_ipc_socket_id.title(mpv_ipc_socket_id) or "<no title>"
      )
    end,
    summary_line_emoji = function(mpv_ipc_socket_id)
      return get.str_or_number_arr.str_by_joined(
        get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
          {"pause", "loop", "shuffle", "video"},
          get.fn.first_n_args_bound_fn(get.mpv_ipc_socket_id.bool_emoji, mpv_ipc_socket_id)
        ),
        ""
      )
    end,
    summary_line = function(mpv_ipc_socket_id)
      return get.str.str_by_formatted_w_n_anys(
        "%s %s",
        transf.mpv_ipc_socket_id.summary_line_emoji(mpv_ipc_socket_id),
        transf.mpv_ipc_socket_id.summary_line_basics(mpv_ipc_socket_id)
      )
    end,
    is_running = function(mpv_ipc_socket_id)
      return transf.any.bool(
        get.mpv_ipc_socket_id.str(mpv_ipc_socket_id, "pause")
      )
    end,
        
  },
  stream_creation_specifier = {
    flag_assoc_by_with_default = function(stream_creation_specifier)
      return transf.two_tables.table_by_take_new(
        tblmap.stream_creation_specifier_flag_profile_name.stream_creation_specifier_flag_profile[stream_creation_specifier.flag_profile_name or "foreground"],
        stream_creation_specifier.flags 
      )
    end,
    flags_str = function(stream_creation_specifier)
      return transf.str_bool_assoc.truthy_long_flag_str(get.stream_creation_specifier.flags_with_default(stream_creation_specifier))
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
    bool_by_is_running = function(stream_created_item_specifier)
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
    mnemonic_str = function(hotkey_created_item_specifier)
      return transf.hotkey_created_item_specifier.mnemonic(hotkey_created_item_specifier) and get.str.str_by_formatted_w_n_anys("[%s] ", transf.hotkey_created_item_specifier.mnemonic(hotkey_created_item_specifier)) or ""
    end,
    shortcut_specifier = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.shortcut_specifier
    end,
    shortcut_str = function(hotkey_created_item_specifier)
      return transf.shortcut_specifier.shortcut_str(transf.hotkey_created_item_specifier.shortcut_specifier(hotkey_created_item_specifier))
    end,
    mod_arr = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.shortcut_specifier.mod_arr
    end,
    key = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.shortcut_specifier.key
    end,
    fn = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.fn
    end,
    summary = function(hotkey_created_item_specifier)
      return get.str.str_by_formatted_w_n_anys(
        "%s%s: %s",
        transf.hotkey_created_item_specifier.shortcut_str(hotkey_created_item_specifier),
        transf.hotkey_created_item_specifier.mnemonic_str(hotkey_created_item_specifier),
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
      return transf.watcher_creation_specifier.watcher_type(watcher_creation_specifier).new
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
  created_item_specifier_arr = {
    
  },
  stream_created_item_specifier_arr = {
    stream_created_item_specifier_by_first_running = function(stream_created_item_specifier_arr)
      return get.arr.pos_int_or_nil_by_first_match_w_fn(
        stream_created_item_specifier_arr,
        transf.stream_created_item_specifier.bool_by_is_running
      )
    end,
  },
  two_sets = {
    set_by_union = function(set1, set2)
      return transf.two_arrs.set_by_union(set1, set2)
    end,
    set_by_intersection = function(set1, set2)
      return transf.two_arrs.set_by_intersection(set1, set2)
    end,
    bool_by_is_subset = function(set1, set2)
      for _, v in transf.arr.index_value_stateless_iter(set1) do
        if not get.arr.bool_by_contains(set2, v) then
          return false
        end
      end
    end,
    bool_by_is_superset = function(set1, set2)
      return transf.two_arrs.is_subset(set2, set1)
    end,
    bool_by_equals = function(set1, set2)
      return transf.two_sets.bool_by_is_subset(set1, set2) and transf.two_sets.bool_by_is_superset(set1, set2)
    end,
  },
  cronspec_str = {
    timestamp_s_str_by_next = function(cronspec_str)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("ncron" .. transf.str.str_by_single_quoted_escaped(cronspec_str))
    end,
    timestamp_s_by_next = function(cronspec_str)
      return get.str_or_number.number_or_nil(transf.cronspec_str.timestamp_s_str_by_next(cronspec_str))
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
    arr = function(start, stop, step, unit)
      start = get.any.default_if_nil(start, 1)
    
      local mode
      if is.any.number(start) then
        mode = "number"
      elseif is.any.table(start) then
        if start.adddays then
          mode = "date"
        elseif start.xy then
          mode = "point"
        end
      elseif is.any.str(start) then
        mode = "string"
      end
    
      local addmethod = function(a, b) 
        return a + b 
      end
    
      if mode == "number" then
        stop = get.any.default_if_nil(stop, 10)
        step = get.any.default_if_nil(step, 1)
      elseif mode == "date" then
        if start then start = start:copy() else start = transf["nil"].date_by_current() end
        if stop then stop = stop:copy() else stop = transf["nil"].date_by_current():addays(10) end
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
          return transf.eight_bit_pos_int.ascii_char(transf.ascii_char.eight_bit_pos_int(a) + b)
        end
      end
    
      local range = {}
      local current = start
      while current <= stop do
        dothis.arr.insert_at_index(range, current)
        current = addmethod(current, step)
      end
    
      return range
    end
    
  },
  form_filling_specifier = {
    --- @class form_field_specifier  
    --- @field value str The field to fill, as we want GPT to see it (i.e. chosing a name that GPT will understand)
    --- @field alias? str The field to fill, as we want the user to see it (i.e. chosing a name that the user will understand). May often be unset, in which case the value field is used.
    --- @field explanation? str The explanation to show to GPT for the field. May be unset if the field is self-explanatory.

    --- @class form_filling_specifier
    --- @field in_fields {[str]: str} The fields to take the data from
    --- @field form_field_specifier_arr form_field_specifier[] The fields (i.e. the template) to fill
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
    ---     form_field_specifier_arr = {
    ---       {value = "artist"},
    ---       {value = "song_title"},
    ---     }
    ---   }, ...
    --- )
    --- ```
    filled_str_assoc = function(spec)
      local query = get.str.str_by_evaled_as_template(lemap.gpt.fill_template, spec)
      local res = gpt(query,  { temperature = 0})
      return get.form_field_specifier_arr.filled_str_assoc_from_str(spec.form_field_specifier_arr, res)
    end,
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
        transf.declared_position_change_input_spec.duration(declared_position_change_input_spec) / POLLING_INTERVAL
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
        tblmap.mouse_button_str.mouse_button_function_name[spec.mouse_button_str]
      ]
    end,
  },

  -- <input_spec_str> ::= <click_spec_str> | <key_spec_str> | <move_scroll_spec_str>
  -- <click_spec_str> ::= "." <mouse_button>
  -- <mouse_button> ::= "l" | "r" | "m" | ... -- l for left, r for right, m for middle, etc.
  -- <key_spec_str> ::= ":" <keys>
  -- <keys> ::= <key> | <key> "+" <keys>
  -- <key> ::= <any_valid_key_representation>
  -- <move_scroll_spec_str> ::= <mode> <target_point> [<relative_position_spec_str>]
  -- <mode> ::= "m" | "s" -- m for move, s for scroll
  -- <target_point> ::= <coordinate> "," <coordinate>
  -- <coordinate> ::= <number>
  -- <relative_position_spec_str> ::= " " <relative_position>
  -- <relative_position> ::= "tl" | "tr" | "bl" | "br" | "c" | "curpos" -- tl for top-left, tr for top-right, bl for bottom-left, br for bottom-right, c for center, curpos for current position.
  input_spec_str = {
    input_spec = function(str)
      local input_spec = {}
      if get.str.bool_by_startswith(str, ".") then
        input_spec.mode = "click"
        if #str == 1 then
          input_spec.mouse_button_str = "l"
        else
          input_spec.mouse_button_str = get.str.str_by_sub_lua(str, 2, 2)
        end
      elseif get.str.bool_by_startswith(str, ":") then
        input_spec.mode = "key"
        local parts = transf.hole_y_arrlike.arr(get.str.str_arr_by_split_w_ascii_char(get.str.str_by_sub_lua(str, 2), "+")) -- separating modifier keys with `+`
        if #parts > 1 then
          input_spec.key = act.arr.pop(parts)
          input_spec.mods = parts
        else
          input_spec.key = parts[1]
        end
      else
        local mode_char, x, y, optional_relative_specifier = get.str.n_strs_by_extracted_onig(str, "^(.)"..r.g.syntax.point.."( %[a-zA-Z]+)?$")
        if not mode_char or not x or not y then
          error("Tried to parse str series_specifier, but it didn't match any known format:\n\n" .. str)
        end
        if mode_char == "m" then
          input_spec.mode = "move"
        elseif mode_char == "s" then
          input_spec.mode = "scroll"
        else
          error("doInput: invalid mode character `" .. mode_char .. "` in series specifier:\n\n" .. str)
        end
        input_spec.target_point = hs.geometry.new({
          x = get.str_or_number.number_or_nil(x),
          y = get.str_or_number.number_or_nil(y)
        })
        if optional_relative_specifier and #optional_relative_specifier > 0 then
          input_spec.relative_to = get.str.str_by_sub_lua(optional_relative_specifier, 3)
        end
      end
      return input_spec
    end
  },
  input_spec_str_arr = {
    input_spec_arr = function(str_arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        str_arr,
        transf.input_spec_str.input_spec
      )
    end,
  },
  input_spec_series_str = {
    input_spec_str_arr = function(str)
      return transf.hole_y_arrlike.arr(get.str.str_arr_split_single_char_stripped(str, "\n"))
    end,
    input_spec_arr = function(str)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        transf.input_spec_series_str.input_spec_str_arr(str),
        transf.input_spec_str.input_spec
      )
    end,
  },
  prompt_args_str = {
    --- @class prompt_args
    --- @field message? any Message to display in the prompt.
    --- @field default? any Default value for the prompt.

    --- @class prompt_args_str : prompt_args
    --- @field informative_text? any Additional text to display in the prompt.
    --- @field buttonA? any Label for the first button.
    --- @field buttonB? any Label for the second button.

    --- @param prompt_args? prompt_args_str
    --- @return (str|nil), boolean
    str_or_nil_and_bool = function(prompt_args)

      -- set up default values, make sure provided values are strs

      prompt_args = prompt_args or {}
      prompt_args.message = transf.not_nil.str(prompt_args.message) or "Enter a str."
      prompt_args.informative_text = transf.not_nil.str(prompt_args.informative_text) or ""
      prompt_args.default = transf.not_nil.str(prompt_args.default) or ""
      prompt_args.buttonA = transf.not_nil.str(prompt_args.buttonA) or "OK"
      prompt_args.buttonB = transf.not_nil.str(prompt_args.buttonB) or "Cancel"

      -- show prompt

      dothis.mac_application_name.activate("Hammerspoon")
      --- @type str, str|nil
      local button_pressed, raw_return = hs.dialog.textPrompt(prompt_args.message, prompt_args.informative_text, prompt_args.default,
      prompt_args.buttonA, prompt_args.buttonB)

      -- process result

      local ok_button_pressed = button_pressed == prompt_args.buttonA

      if get.str.bool_by_startswith(raw_return, " ") then -- space triggers lua eval mode
        raw_return = get.str.evaled_as_lua(raw_return)
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
    --- @field allowed_file_types? str[]
    --- @field resolves_aliases? boolean

    --- @param prompt_args prompt_args_path
    --- @return (str|str[]|nil), boolean
    local_absolute_path_or_local_absolute_path_arr_and_bool = function(prompt_args)

      -- set up default values, make sure message and default are strs
  
      prompt_args                        = prompt_args or {}
      prompt_args.message                = get.any.default_if_nil(transf.not_nil.str(prompt_args.message), "Choose a file or folder.")
      prompt_args.default                = get.any.default_if_nil(transf.not_nil.str(prompt_args.default), env.HOME)
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
      local list_return = transf.table_or_nil.vt_arr(raw_return)
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
    local_absolute_path_and_bool = function(prompt_args)
      prompt_args.multiple = false
      return transf.prompt_args_path.local_absolute_path_or_local_absolute_path_arr_and_bool(prompt_args)
    end,
    local_absolute_path_arr_and_bool = function(prompt_args)
      prompt_args.multiple = true
      return transf.prompt_args_path.local_absolute_path_or_local_absolute_path_arr_and_bool(prompt_args)
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
      prompt_spec.prompter = prompt_spec.prompter or transf.prompt_args_str.str_or_nil_and_bool
      prompt_spec.transformer = prompt_spec.transformer or function(x) return x end
      prompt_spec.raw_validator = prompt_spec.raw_validator or function(x) return x ~= nil end
      prompt_spec.transformed_validator = prompt_spec.transformed_validator or function(x) return x ~= nil end
      prompt_spec.on_cancel = prompt_spec.on_cancel or "error"
      prompt_spec.on_raw_invalid = prompt_spec.on_raw_invalid or "return_nil"
      prompt_spec.on_transformed_invalid = prompt_spec.on_transformed_invalid or "reprompt"
      prompt_spec.prompt_args = prompt_spec.prompt_args or {}
      prompt_spec.prompt_args.message = prompt_spec.prompt_args.message or "Enter a value."

      -- generate some informative text mainly used when prompter is promptstrInner, though other prompters can consume this too
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
                local has_str_eqviv, str_eqviv = pcall(tostr, raw_return)
                local transformed_has_str_eqviv, transformed_str_eqviv = pcall(tostr, transformed_return)
                validation_extra =
                    "Invalid input:\n" ..
                    "  Original: " .. (has_str_eqviv and str_eqviv or "<not tostrable>") .. "\n" ..
                    "  Transformed: " .. (transformed_has_str_eqviv and transformed_str_eqviv or "<not tostrable>")
              end
            end
          else -- raw input was invalid, handle according to prompt_spec.on_raw_invalid
            if prompt_spec.on_raw_invalid == "error" then
              error("WARN: User input was invalid (before transformation).", 0)
            elseif prompt_spec.on_raw_invalid == "return_nil" then
              return nil
            elseif prompt_spec.on_raw_invalid == "reprompt" then
              local has_str_eqviv, str_eqviv = pcall(tostr, raw_return)
              validation_extra = "Invalid input: " .. (has_str_eqviv and str_eqviv or "<not tostrable>")
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
    any_arr = function(prompt_spec)
      local res = {}
      prompt_spec.prompt_args = prompt_spec.prompt_args or {}
      prompt_spec.prompt_args.message = prompt_spec.prompt_args.message or "Enter a value."
      prompt_spec.prompt_args.message = prompt_spec.prompt_args.message .. " Enter an empty value to stop."
      while true do
        local x = transf.prompt_spec.any(prompt_spec)
        if x == nil then
          return res
        else
          dothis.arr.push(res, x)
        end
      end
      return res
    end,
  },
  role_content_message_spec = {

  },
  role_content_message_spec_arr = {
    api_role_content_message_spec_arr = function(arr)
      return transf.any_and_arr.arr({
        role = "system",
        content = "You are a helpful assistant being queried through an API. Your output will be parsed, so adhere to any instructions given as to the format or content of the output. Only output the result."
      }, arr)
    end,
  },
  --- like a role_content_message_spec_arr, but alternating user/assistant role_content_message_specs, where a two_anys_arr of user/assistant role_content_message_specs is a shot
  n_shot_role_content_message_spec_arr = {

  },
  n_shot_llm_spec = {
    n_shot_api_query_role_content_message_spec_arr = function(spec)
      return transf.role_content_message_spec_arr.api_role_content_message_spec_arr(
        transf.arr_arr.arr_by_flatten({
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
          transf.two_strs_arr_arr.n_shot_role_content_message_spec_arr(spec.shots), 
          {
            {
              role = "user",
              content = spec.input
            }
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
    str_by_waiting_message  = function(qspec)
      return "Waiting to proceed (" .. #qspec.fn_arr .. " waiting in queue) ... (Press " .. transf.hotkey_created_item_specifier.shortcut_str(qspec.hotkey_created_item_specifier) .. " to continue.)"
    end,
      
  },
  n_anys_or_err_ret_fn = {
    n_anys_or_nil_ret_fn_by_pcall = function(fn)
      --- @generic T
      --- @param ... `T`
      --- @return T|nil
      return function(...)
        local rets = {pcall(fn, ...)}
        local succ = act.arr.shift(rets)
        if succ then
          return transf.arr.n_anys(rets)
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
          return transf.arr.n_anys(rets)
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
  str_and_number_or_nil = {
    str_or_nil_by_number = function(str, num)
      if num then
        return nil
      else
        return str
      end
    end,
  },
  fnid = {
    
  },
  fnname = {
    local_absolute_path_by_in_cache = function(fnname)
      return transf.str.in_cache_dir(fnname, "fsmemoize")
    end,
    
  },
  discord_export_dir = {
    export_chat_main_object_and_media_dir_arr = function(dir)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        transf.dir.dir_arr_by_children(dir),
        transf.discord_export_child_dir.discord_export_chat_main_object_media_dir_pair
      )
    end,
    
  },
  discord_export_child_dir = {
    discord_export_chat_main_object_media_dir_pair = function(dir)
      local json_file = get.dir.extant_path_by_child_having_extension(dir, "json")
      local media_dir = get.dir.extant_path_by_child_having_extension(dir, "_Files")
      if not json_file or not media_dir then error("Could not find json or media dir in " .. dir) end
      return {transf.json_file.not_userdata_or_function(json_file), media_dir}
    end,
  },
  discord_export_chat_main_object = {
    discord_export_chat_message_arr = function(main_object)
      return main_object.messages
    end,
    str_by_author = function(main_object)
      return main_object.channel.name
    end,
    str_by_id = function(main_object)
      return main_object.channel.id
    end,
  },
  discord_export_chat_message  = {
    timestamp_ms = function(msg)
      return transf.date.timestamp_ms(
        date(msg.timestamp)
      )
    end,
    str_by_author = function(msg)
      error("The code I'm migrating still assumed #discriminators, but discord has since migrated to handles. I'll need to update this code to reflect that.")
      return
    end,
    str_by_content = function(msg)
      return msg.content
    end,
    reaction_spec_arr = function(msg)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        msg.reactions or {},
        function(reaction)
          return {
            emoji = reaction.emoji.name,
            count = reaction.count,
          }
        end
      )
    end,
    int_or_nil_by_call_duration = function(msg)
      if msg.callEndedTimestamp then
        return msg.callEndedTimestamp - transf.discord_export_chat_message.timestamp_ms(msg)
      end
    end,
    str_or_nil_by_sticker_emoji = function(msg)
      return nil
    end
  },
  facebook_export_dir = {
    export_chat_main_object_and_media_dir_arr = function(dir)
      local chat_dirs = transf.dir.dir_arr_by_children(dir)
      local arr = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        chat_dirs,
        function(chat_dir)
          local media_dir = transf.path.ending_with_slash(chat_dir) .. "media"
          local main_obj = transf.json_file.not_userdata_or_function(
            transf.path.ending_with_slash(chat_dir) .. "message_1.json"
          )
          return {
            main_obj,
            media_dir
          }
        end
      )
    end
  },
  facebook_export_chat_main_object = {
    facebook_export_chat_message_arr = function(main_object)
      return main_object.messages
    end,
    str_by_author = function(main_object)
      return main_object.title
    end,
    str_by_id = function(main_object)
      return main_object.thread_path:match("_(%d+)$")
    end,
  },
  facebook_export_chat_message  = {
    timestamp_ms = function(msg)
      return msg.timestamp_ms
    end,
    str_by_author = function(msg)
      return msg.sender_name
    end,
    str_by_content = function(msg)
      return msg.content
    end,
    reaction_spec_arr = function(msg)
      local tally = {}
      for _, reaction in ipairs(msg.reactions or {}) do
        tally[reaction.reaction] = (tally[reaction.reaction] or 0) + 1
      end
      return get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
        tally,
        function(emoji, count)
          return {
            emoji = emoji,
            count = count,
          }
        end
      )
    end,
    int_or_nil_by_call_duration = function(msg)
      if msg.call_log then
        return msg.call_log.duration 
      end
    end,
    str_or_nil_by_sticker_emoji = function(msg)
      return nil
    end
  },
  signal_export_dir = {
    export_chat_main_object_and_media_dir_arr = function(dir)
      local chat_json_files = transf.dir.absolute_path_arr_by_children(dir .. "/chats")
      local arr = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        chat_json_files,
        function(chat_json_file)
          local filename = transf.path.filename(chat_json_file)
          local author = filename:match("^([^(]+)")
          local media_dir = dir .. "/media/" .. filename
          local messages = transf.json_file.not_userdata_or_function(chat_json_file)
          return {
            {
              author = author,
              messages = messages,
            },
            media_dir
          }
        end
      )
      return arr
    end,
  },
  signal_export_chat_main_object = {
    signal_export_chat_message_arr = function(main_object)
      return main_object.messages
    end,
    str_by_author = function(main_object)
      return main_object.author
    end,
    str_by_id = function(main_object)
      return main_object[1].conversationId
    end,
  },
  signal_export_chat_message  = {
    timestamp_ms = function(msg)
      return msg.sent_at
    end,
    str_by_author = function(msg)
      if msg.type == "outgoing" then
        return "me"
      else
        return msg.global_author
      end
    end,
    str_by_content = function(msg)
      return msg.body
    end,
    reaction_spec_arr = function(msg)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        msg.reactions or {},
        function(emoji)
          return {
            emoji = emoji,
            count = 1,
          }
        end
      )
    end,
    int_or_nil_by_call_duration = function(msg)
      if msg.callHistoryDetails then
        return msg.callHistoryDetails.endedTime - transf.signal_export_chat_message.timestamp_ms(msg)
      end 
    end,
    str_or_nil_by_sticker_emoji = function(msg)
      return nil
    end
  },
  telegram_export_dir = {
    export_chat_main_object_and_media_dir_arr = function(dir)
      local json_file = get.dir.extant_path_by_child_having_leaf(dir, "result.json")
      local export_json = transf.json_file.not_userdata_or_function(json_file)

      local chats = export_json.chats.list

      return get.arr.arr_by_mapped_w_pos_int_t_arg_t_ret_fn(
        chats,
        function(index, chat)
          return {
            chat,
            dir .. "/chats/chat_" .. index .. "/media"
          }
        end
      )

    end,
    
  },
  telegram_export_chat_main_object = {
    telegram_export_chat_message_arr = function(main_object)
      return main_object.messages
    end,
    str_by_author = function(main_object)
      return main_object.name
    end,
    str_by_id = function(main_object)
      return main_object.id
    end,
  },
  telegram_export_chat_message  = {
    timestamp_ms = function(msg)
      return msg.date_unixtime * 1000
    end,
    str_by_author = function(msg)
      return msg.from
    end,
    str_by_content = function(msg)
      return msg.text
    end,
    reaction_spec_arr = function(msg)
      local tally = {}
      for _, reaction in ipairs(msg.reactions or {}) do
        tally[reaction.reaction] = (tally[reaction.reaction] or 0) + 1
      end
      return get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
        tally,
        function(emoji, count)
          return {
            emoji = emoji,
            count = count,
          }
        end
      )
    end,
    int_or_nil_by_call_duration = function(msg)
      error("TODO")
    end,
    str_or_nil_by_sticker_emoji = function(msg)
      return msg.sticker_emoji
    end

  },
  
  
}

transf.any.pos_int_by_unique_id_primitives_equal = transf["nil"].any_arg_pos_int_ret_fn_by_unique_id_primitives_equal()
transf.fn.fnid = transf["nil"].any_arg_pos_int_ret_fn_by_unique_id_primitives_equal() -- functionally the same, but I'll limit it to functions 'by hand'