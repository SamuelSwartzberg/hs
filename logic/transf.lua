--- maps one thing_name to another thing_name
--- so transf.<thing_name1>.<thing_name2>(<thing1>) -> <thing2>
transf = {
  full_userdata = {
    str_by_classname = function(userdata)
      return getmetatable(userdata).__name
    end
  },
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
      return get.nonindicated_number_str.number(num, 2)
    end,
    number_by_base_8 = function(num)
      return get.nonindicated_number_str.number(num, 8)
    end,
    number_by_base_10 = function(num)
      return get.nonindicated_number_str.number(num, 10)
    end,
    number_by_base_16 = function(num)
      return get.nonindicated_number_str.number(num, 16)
    end,
  },
  indicated_number_str = {
    nonindicated_number_str = function(indicated_number)
      return get.str.str_by_replaced_onig_w_regex_str(
        indicated_number,
        "^(-?)0[boxd](.+)$",
        "$1$2"
      )
    end,
    base_letter = function(indicated_number)
      return get.str.n_strs_by_extracted_onig(
        indicated_number,
        "^-?0([dbox])"
      )
    end,
    pos_int_by_base = function(indicated_number)
      return tblmap.base_letter.pos_int_by_base[
        transf.indicated_number_str.base_letter(indicated_number)
        ]
    end,
    number = function(indicated_number)
      return get.nonindicated_number_str.number(
        transf.indicated_number_str.nonindicated_number_str(indicated_number),
        transf.indicated_number_str.pos_int_by_base(indicated_number)
      )
    end,
  },
  percent_encoded_octet = {
    ascii_char = function(percent)
      local num = percent:sub(2, 3)
      return transf.halfbyte_pos_int.ascii_char(get.str_or_number.number_or_nil(num, 16))
    end,
  },
  unicode_codepoint_str = { -- U+X...`
    number = function(codepoint)
      return get.nonindicated_number_str.number(transf.unicode_codepoint_str.nonindicated_hex_number_str(codepoint), 16)
    end,
    nonindicated_hex_number_str = function(codepoint)
      return codepoint:sub(3)
    end,
    unicode_prop_table = function(codepoint)
      return get.fn.rt_or_nil_by_memoized(transf.str.not_userdata_or_fn_or_err_by_evaled_env_bash_parsed_json)(
        "uni print -compact -format=all -as=json" 
        .. transf.str.str_by_single_quoted_escaped(
          codepoint
        )
      )[1]
    end
  },
  indicated_utf8_hex_str = {
    unicode_prop_table = function(str)
      return get.fn.rt_or_nil_by_memoized(transf.str.not_userdata_or_fn_or_err_by_evaled_env_bash_parsed_json)(
        "uni print -compact -format=all -as=json" 
        .. transf.str.str_by_single_quoted_escaped(
          str
        )
      )[1]
    end
  },
  unicode_prop_table = {
    indicated_bin_number_str_by_codepoint = function(unicode_prop_table)
      return "0b" .. unicode_prop_table.bin
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
    unicode_codepoint_str = function(unicode_prop_table)
      return unicode_prop_table.cpoint
    end,
    indicated_dec_number_str_by_codepoint = function(unicode_prop_table)
      return "0d" .. unicode_prop_table.dec
    end,
    indicated_hex_number_str_by_codepoint = function(unicode_prop_table)
      return "0x" .. unicode_prop_table.hex
    end,
    indicated_oct_number_str_by_codepoint = function(unicode_prop_table)
      return "0o" .. unicode_prop_table.oct
    end,
    html_entity = function(unicode_prop_table)
      return unicode_prop_table.html
    end,
    unicode_character_name = function(unicode_prop_table)
      return unicode_prop_table.name
    end,
    unicode_plane_name = function(unicode_prop_table)
      return unicode_prop_table.plane
    end,
    indicated_utf8_hex_str = function(unicode_prop_table)
      return transf.str.not_whitespace_str(unicode_prop_table.utf8)
    end,
    str_by_summary = function(unicode_prop_table)
      return transf.unicode_prop_table.utf8_char(unicode_prop_table) .. ": "
        .. transf.unicode_prop_table.unicode_codepoint_str(unicode_prop_table) .. " "
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
    byte_nonindicated_hex_number_str_arr = function(num)
      return  get.str.str_arr_by_grouped_ascii_from_end(
        transf.number.nonindicated_hex_number_str(num),
        2
      )
    end,
    two_byte_nonindicated_hex_number_str_arr = function(num)
      return  get.str.str_arr_by_grouped_ascii_from_end(
        transf.number.nonindicated_hex_number_str(num),
        4
      )
    end,
    
    nonindicated_oct_number_str = function(num)
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
    int_by_floor = math.floor,
    int_by_ceil = math.ceil,
    pos_int_by_abs_int_part = function(num)
      return transf.number.int_by_floor(
        transf.number.pos_number(num)
      )
    end,
    pos_float_by_abs_float_part = function(num)
      return transf.number.pos_number(num) - transf.number.pos_int_by_abs_int_part(num)
    end,
    pos_int_by_float_part = function(num)
      return transf.nonindicated_number_str.number_by_base_10(
        transf.number.nonindicated_dec_number_str(
          transf.number.pos_float_by_abs_float_part(num)
        ):sub(3)
      )
    end,
    number_by_1_added = function(num)
      return num + 1
    end,
    number_by_1_subtracted = function(num)
      return num - 1
    end,
  },
  pos_number = { 
    nonindicated_dec_number_str = function(num)
      return 
        transf.pos_int.digit_str(
          transf.number.pos_int_by_abs_int_part(num)
        ) .. 
        (
          transf.number.pos_float_by_abs_float_part(num) == 0 and "" or 
          (
            "." .. transf.pos_int.digit_str(
              transf.number.pos_int_by_float_part(num)
            )
          )
        )
      end,
    separated_nonindicated_dec_number_str = function(num)
      return 
        transf.pos_int.separated_nonindicated_dec_number_str(
          transf.number.pos_int_by_abs_int_part(num)
        ) .. 
        (
          transf.number.pos_float_by_abs_float_part(num) == 0 and "" or 
          (
            "." .. transf.pos_int.separated_nonindicated_dec_number_str(
              transf.number.pos_int_by_float_part(num)
            )
          )
        )
      end,
    nonindicated_hex_number_str = function(num)
      return transf.pos_int.hex_str(
        transf.number.pos_int_by_abs_int_part(num)
      ) .. 
      (
        transf.number.pos_float_by_abs_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.hex_str(
            transf.number.pos_int_by_float_part(num)
          )
        )
      )
    end,
    separated_nonindicated_hex_number_str = function(num)
      return transf.pos_int.separated_nonindicated_hex_number_str(
        transf.number.pos_int_by_abs_int_part(num)
      ) .. 
      (
        transf.number.pos_float_by_abs_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.separated_nonindicated_hex_number_str(
            transf.number.pos_int_by_float_part(num)
          )
        )
      )
    end,
    noninciated_oct_number_str = function(num)
      return transf.pos_int.oct_str(
        transf.number.pos_int_by_abs_int_part(num)
      ) .. 
      (
        transf.number.pos_float_by_abs_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.oct_str(
            transf.number.pos_int_by_float_part(num)
          )
        )
      )
    end,
    separated_nonindicated_oct_number_str = function(num)
      return transf.pos_int.separated_nonindicated_oct_number_str(
        transf.number.pos_int_by_abs_int_part(num)
      ) .. 
      (
        transf.number.pos_float_by_abs_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.separated_nonindicated_oct_number_str(
            transf.number.pos_int_by_float_part(num)
          )
        )
      )
    end,
    nonindicated_bin_number_str = function(num)
      return transf.pos_int.bin_str(
        transf.number.pos_int_by_abs_int_part(num)
      ) .. 
      (
        transf.number.pos_float_by_abs_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.bin_str(
            transf.number.pos_int_by_float_part(num)
          )
        )
      )
    end,
    separated_nonindicated_bin_number_str = function(num)
      return transf.pos_int.separated_nonindicated_bin_number_str(
        transf.number.pos_int_by_abs_int_part(num)
      ) .. 
      (
        transf.number.pos_float_by_abs_float_part(num) == 0 and "" or 
        (
          "." .. transf.pos_int.separated_nonindicated_bin_number_str(
            transf.number.pos_int_by_float_part(num)
          )
        )
      )
    end,
  },
  neg_number = {

  },
  int = {
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
    int_by_random_of_length = function(int)
      return math.random(
        transf.pos_int.int_by_smallest_of_length(int),
        transf.pos_int.int_by_largest_of_length(int)
      )
    end,
  },
  pos_int = {
    pos_int_by_dec_length = function(int)
      return #transf.pos_int.digit_str(int)
    end,
    pos_int_by_normzeilen = function(pos_int)
      return transf.number.int_by_rounded(
        pos_int / 55
      )
    end,
    base64_gen_str_by_random_of_length = function(int)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("openssl rand -base64 " .. transf.any.str(transf.number.int_by_rounded(int * 3/4))) -- 3/4 because base64 takes the int to be the input length, but we want to specify the output length (which is 4/3 the input length in case of base64)
    end,
    digit_str = function(num)
      return transf.any.str(num)
    end,
    separated_nonindicated_dec_number_str = function(num)
      return get.str.str_by_separator_grouped_ascii_from_end(
        transf.pos_int.digit_str(num),
        3,
        " "
      )
    end,
    hex_str = function(num)
      return get.str.str_by_formatted_w_n_anys("%X", num)
    end,
    separated_nonindicated_hex_number_str = function(num)
      return get.str.str_by_separator_grouped_ascii_from_end(
        transf.pos_int.hex_str(num),
        2,
        " "
      )
    end,
    oct_str = function(num)
      return get.str.str_by_formatted_w_n_anys("%o", num)
    end,
    separated_nonindicated_oct_number_str = function(num)
      return get.str.str_by_separator_grouped_ascii_from_end(
        transf.pos_int.oct_str(num),
        3,
        " "
      )
    end,
    bin_str = function(num)
      return get.str.str_by_formatted_w_n_anys("%b", num)
    end,
    separated_nonindicated_bin_number_str = function(num)
      return get.str.str_by_separator_grouped_ascii_from_end(
        transf.pos_int.bin_str(num),
        4,
        " "
      )
    end,
    indicated_utf8_hex_str = function(int)
      return "utf8:" .. transf.pos_int.hex_str(int)
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
      return "U+" .. transf.pos_int.hex_str(num)
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
  halfbyte_pos_int = {
    ascii_char = string.char,
  },
  pos_int_arr = {
    unicode_codepoint_str_arr = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.pos_int.unicode_codepoint_str
      )
    end,
    ascii_char_arr = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
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
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
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
      return arr[1], get.arr.arr_by_slice_w_3_int_any_or_nils(arr, 2)
    end,
    arr_by_nofirst = function(arr)
      return get.arr.arr_by_slice_w_3_int_any_or_nils(arr, 2)
    end,
    arr_by_nolast = function(arr)
      return get.arr.arr_by_slice_w_3_int_any_or_nils(arr, 1, -2)
    end,
    empty_str_value_assoc = function(arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        arr,
        transf.any.self_and_empty_str
      )
    end,
    str_arr = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.any.str_by_replicable
      )
    end,
    str_arr_by_mapped_single_quoted_escaped = function(arr)
      return get.str_arr.str_arr_by_mapped_single_quoted_escaped(
        transf.arr.str_arr(arr)
      )
    end,
    str_by_contents_summary = function(arr)
      return transf.str_arr.str_by_summary(
        transf.arr.str_arr(arr)
      )
    end,
    str_by_summary = function(arr)
      return "arr ("..#arr.."):" .. transf.arr.str_by_contents_summary(arr)
    end,
    str_by_alternative_summary = function(arr)
      return get.str_or_number_arr.str_by_joined(
        transf.arr.str_arr(arr),
        " | "
      )
    end,
    multiline_str = function(arr)
      return transf.str_arr.multiline_str(transf.arr.str_arr(arr))
    end,
    
    pos_int_vt_stateless_iter = ipairs,
    pos_int_vt_stateful_iter = get.stateless_generator.stateful_generator(transf.arr.pos_int_vt_stateless_iter),
    pos_int_stateful_iter = get.stateless_generator.stateful_generator(transf.arr.pos_int_vt_stateless_iter, 1, 1),
    vt_key_bool_value_assoc = function(arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(arr, function(v) return v, true end)
    end,
    set = function(arr)
      return transf.table.kt_arr(
        transf.arr.vt_key_bool_value_assoc(arr)
      )
    end,
    arr_arr_by_permutations = function(arr)
      if #arr == 0 then
        return {{}}
      else
        return get.any_stateful_generator.arr(combine.permute, arr)
      end
    end,
    --- this may not actually work as intended on arrays, and perhaps only on sets. may thus need refactoring
    set_set_by_powerset = function(arr)
      if #arr == 0 then
        return {{}}
      else
        local output = transf.arr_and_any.arr( get.any_stateful_generator.arr(combine.powerset, arr), {} )
        return output
      end
    end,
    n_anys = table.unpack,
    pos_int_by_initial_selected_index = function(arr)
      return get.thing_name_arr.pos_int_by_initial_selected_index(
        transf.any.thing_name_arr_by_applicable(arr)
      ) or 1 
    end,
    hydrus_file_hash_arr_by_search = function(arr)
      return rest({
        api_name = "hydrus",
        endpoint = "get_files/search_files",
        params = {
          tags = transf.not_userdata_or_fn.json_str(
            arr
          ),
          return_hashes = true,
        }
      }).hashes
    end,
    hydrus_file_hash_arr_by_search_motion_only = function(arr)
      return transf.arr.hydrus_file_hash_arr_by_search(
        transf.any_and_arr.arr(
          "system:filetype is animation, video",
          arr
        )
      )
    end,
    hydrus_file_id_arr_by_search = function(arr)
      return rest({
        api_name = "hydrus",
        endpoint = "get_files/search_files",
        params = {
          tags = transf.not_userdata_or_fn.json_str(
            arr
          ),
        }
      }).file_ids
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
  two_has_id_key_tables = {
    bool_by_equal = function(t1, t2)
      return t1.id == t2.id
    end,
  },
  assoc_arr = {
    has_index_key_table_arr = function(arr)
      local res = get.table.table_by_copy(arr, true)
      for i, v in transf.arr.pos_int_vt_stateless_iter(arr) do
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
    halfbyte_pos_int = string.byte,
    indicated_hex_number_str = function(char)
      return get.str.str_by_formatted_w_n_anys("0x%02X", transf.ascii_char.halfbyte_pos_int(char))
    end,
    percent_encoded_octet = function(char)
      return get.str.str_by_formatted_w_n_anys("%%%02X", transf.ascii_char.halfbyte_pos_int(char))
    end,
  },
  leaflike = {
    rfc3339like_dt_or_interval_general_name_fs_tag_str_or_nil = function(leaf)
      return get.str.n_strs_by_extracted_onig(
        leaf,
        ("^(%s(?:_to_%s)?--)([a-z0-9_]*)(%%[-a-z0-9_%%]+)?$"):format(
          r.g.rfc3339like_dt,
          r.g.rfc3339like_dt
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
      if path == "/" then
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
    path_component_arr_by_split_ext = function(path)
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
      local psegments = transf.path.path_component_arr_by_split_ext(path)
     ---@diagnostic disable-next-line: need-check-nil -- path_segments always returns a table with at least two elements for any valid path
      return psegments[#psegments]
    end,
    extension_by_normalized = function(path)
      local ext = transf.path.extension(path)
      return tblmap.extension.normalized_extension[
        ext
      ] or ext
    end,
    path_by_without_extension = function(path)
      return get.path.path_by_sliced_split_ext_path_component_arr(
        transf.path.path_component_arr_by_split_ext(path),
        {start = 1, stop = -2}
      )
    end,
    leaflike_by_filename = function(path)
      local psegments = transf.path.path_component_arr_by_split_ext(path)
      act.arr.pop(psegments)
      ---@diagnostic disable-next-line: need-check-nil -- path_segments always returns a table with at least two elements for any valid path
      return psegments[#psegments]
    end,
    path_by_ending_with_slash = function(path)
      return get.str.str_by_with_suffix(path or "", "/")
    end,
    path_component_by_initial = function(path)
      return transf.path.path_component_arr(path)[1]
    end,
    leaflike_by_leaf = function(path)
      local pcomponents = transf.path.path_component_arr(path)
      return pcomponents[#pcomponents]
    end,
    --- not technically always guaranteed to return a path, hence the weird name
    trimmed_noweirdwhitespace_line_by_parent_path = function(path)
      return get.path.path_by_sliced_path_component_arr(
        get.path.path_component_arr(path),
        {start = 1, stop = -2}
      )
    end,
    path_component_or_nil_by_parent_leaf = function(path)
      local pcomponents = transf.path.path_component_arr(path)
      act.arr.pop(pcomponents)
      return pcomponents[#pcomponents]
    end,
    path_component_arr_by_parent = function(path)
      return transf.path.path_component_arr(
        transf.path.trimmed_noweirdwhitespace_line_by_parent_path(path)
      )
    end,
    path_arr_by_path_component_arr_via_parent = function(path)
      return transf.path.path_arr_by_path_component_arr(
        transf.path.trimmed_noweirdwhitespace_line_by_parent_path(path)
      )
    end,
    path_leaf_specifier_or_nil = function(path)
      local rfc3339like_dt_or_interval, general_name, fs_tag_str = transf.leaflike.rfc3339like_dt_or_interval_general_name_fs_tag_str_or_nil(transf.path.leaflike_by_leaf(path))
      if rfc3339like_dt_or_interval then
        return {
          extension = transf.path.extension(path),
          path = transf.path.trimmed_noweirdwhitespace_line_by_parent_path(path),
          rfc3339like_dt_o_interval = rfc3339like_dt_or_interval,
          general_name = general_name,
          lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc = transf.fs_tag_str.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc(fs_tag_str),
        }
      end
    end,
    two_lines__arr_arr_or_nil_by_path_leaf_specifier_to_tag_pairs = function(path)
      local pspc = transf.path.path_leaf_specifier_or_nil(path)
      if pspc then
        local pspc_tags = transf.path_leaf_specifier.two_lines__arr_arr_by_fs_tags(
          pspc
        )
        return pspc_tags
      end
    end,
    rfc3339like_dt_or_nil_by_filename = function(path)
      local pspc = transf.path.path_leaf_specifier_or_nil(path)
      if pspc then
        return pspc.rfc3339like_dt_o_interval
      else
        return transf.str.rfc3339like_dt_or_nil_by_guess_gpt(
          transf.path.leaflike_by_filename(path)
        )
      end
    end,
    two_lines__arr_arr_by_filename_tags = function(path)
      local pspec_tags = transf.path.two_lines__arr_arr_or_nil_by_path_leaf_specifier_to_tag_pairs(path)
      if #pspec_tags == 1 and pspec_tags[1][1] == "title" then
        pspec_tags = nil -- if we parsed the entire filename as a title, the file didn't have any proper tags. In that case it's a better idea to use AI to extract tags.
      end
      if pspec_tags then
        return pspec_tags
      else -- extract tags from non-standartized filename (uses gpt)
        local filename = transf.path.leaflike_by_filename(path)
        -- 1. data for series
        local series_pairs = get.all_namespace_arr.two_lines__arr_arr(
          ls.series_namespace,
          filename,
          {
            {"Screenshot 2023-09-15 at 14.55.23", "[]"},
            {"Adachi to Shimamura - Ch.28 - Shimamura's Sword - 8", '[["series", "Adachi to Shimamura"], ["chapter_index", "28"], ["chapter_title", "Shimamura\'s Sword"], ["page_index", "8"]]'},
            {"Tatoe Todokanu Ito da to Shite mo - Chapter 01 - 32", '[["series", "Tatoe Todokanu Ito da to Shite mo"], ["chapter_index", "01"], ["page_index", "32"]]'},
            {"The Real Momoka - by Arai Sumiko - 17", '[["series", "The Real Momoka"], ["creator", "Arai Sumiko"], ["page_index", "17"]]'},
            {"__warrior_of_light_final_fantasy_and_1_more_drawn_by_d_rex__781a13c9a81ed223c83d9b65f4531b90", 'IMPOSSIBLE: Danbooru-like filename, should not be parsed because better solutions exist.'},
            {"2022-02-16--diary_2", 'IMPOSSIBLE'},
          }
        )
        local res = {}
        if #series_pairs > 0 then
          dothis.arr.push(res, {"general", "original"})
        end

        -- 3. data for metadata
      end
    end,
    two_lines__arr_arr_by_ancestor_path_tags = function(path)
      local res = {}
      local path_components =transf.path.path_component_arr_by_parent(path)
      -- I don't use spaces in my fs, but my tags do.
      path_components = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        path_components,
        function(leaflike)
          return get.str.str_by_continuous_replaced_onig_w_regex_quantifiable(
            leaflike,
            "_",
            " "
          )
        end
      )

      for _, path_component in transf.arr.pos_int_vt_stateless_iter(path_components) do
        local current_namespace
        if get.arr.bool_by_contains(ls.all_namespace, path_component) then -- all subdirs until we find the next namespace are assumed to be metadata in that namespace
          current_namespace = path_component
        elseif current_namespace then
          if get.arr.bool_by_contains(ls[current_namespace], path_component) then
            dothis.arr.push(res, {current_namespace, path_component})
          end
        end
      end
      if get.arr.bool_by_contains(path_components, "screenshots") then
        dothis.arr.push(res, {"meta", "screenshot"})
        for _, service in transf.arr.pos_int_vt_stateless_iter(ls.services) do
          if get.arr.bool_by_contains(path_components, service) then
            dothis.arr.push(res, {"service", service})
          end
        end
      end
      if get.arr.bool_by_contains(path_components, "chatgpt") or get.arr.bool_by_contains(path_components, "openai_playground") then
        dothis.arr.push(res, {"tcrea", "gpt"})
        dothis.arr.push(res, {"tcrea", "me"}) -- both of these are not guaranteed to be true, but they are likely enough to be true that I can just manually remove the tag if it's not true.
      end
      for _, series in transf.arr.pos_int_vt_stateless_iter(ls.series) do
        if get.arr.bool_by_contains(path_components, series) then
          dothis.arr.push(res, {"series", series})
        end
      end
      if get.arr.bool_by_contains(path_components, "lishogi") then
        dothis.arr.push(res, {"general", "shogi"}) -- not all lishogi screenshots are shogi, but most are. I can just manually remove the tag if it's not shogi.
      end
      if get.arr.bool_by_contains(path_components, "lichess") then
        dothis.arr.push(res, {"general", "chess"}) -- same as above
      end
      if get.arr.bool_by_contains(path_components, "i_made_this") then
        dothis.arr.push(res, {"creator", "me"})
      end
      if get.arr.bool_by_contains(path_components, "what made this") then
        for _, ai_creator in transf.arr.pos_int_vt_stateless_iter(ls.ai_creator) do
          if get.arr.bool_by_contains(path_components, ai_creator) then
            dothis.arr.push(res, {"creator", ai_creator})
          end
        end
        if get.arr.bool_by_contains(path_components, "pornpen") then
          dothis.arr.push(res, {"proximate_source", "pornpen"})
        end
      end
      if get.arr.bool_by_contains(path_components, "proximate_source") then
        for _, proximate_source in transf.arr.pos_int_vt_stateless_iter(ls.proximate_source) do
          if get.arr.bool_by_contains(path_components, proximate_source) then
            dothis.arr.push(res, {"proximate_source", proximate_source})
          end
        end
      end
      if get.arr.bool_by_contains(path_components, "photography") or get.arr.bool_by_contains(path_components, "photos") then
        dothis.arr.push(res, {"medium", "photography"})
      end
      if get.arr.bool_by_contains(path_components, "style_inspiration") then
        dothis.arr.push(res, {"use_as", "style_inspiration"})
      end
      for _, use_as in transf.arr.pos_int_vt_stateless_iter(ls.use_as) do
        if get.arr.bool_by_contains(path_components, use_as) then
          dothis.arr.push(res, {"use_as", use_as})
        end
      end
      error("the following may be problematic, temporary stop")
      for _, subject_matter in transf.arr.pos_int_vt_stateless_iter(ls.subject_matter) do
        if get.arr.bool_by_contains(path_components, subject_matter) then
          dothis.arr.push(res, {"subject_matter", subject_matter})
        end
      end
      if get.arr.bool_by_contains(path_components, "voice") then
        dothis.arr.push(res, {"medium", "voice_memo"})
      end
      if get.arr.bool_by_contains(path_components, "acquisition_context") then
        
        for _, acctx in transf.arr.pos_int_vt_stateless_iter(ls.acquisition_context) do
          if get.arr.bool_by_contains(path_components, acctx) then
            dothis.arr.push(res, {"acquisition_context", acctx})
          end
        end
        for _, acins in transf.arr.pos_int_vt_stateless_iter(ls.acquisition_institution) do
          if get.arr.bool_by_contains(path_components, acins) then
            dothis.arr.push(res, {"acquisition_institution", acins})
          end
        end
      end
     return res
    end,
    two_lines__arr_arr_by_path_tags = function(path)
      return transf.two_arrs.arr_by_appended(
        transf.path.two_lines__arr_arr_by_filename_tags(path),
        transf.path.two_lines__arr_arr_by_ancestor_path_tags(path)
      )
    end,
    window_by_with_leaf_as_title = function(path)
      return transf.str.window_or_nil_by_title(transf.path.leaflike_by_leaf(path))
    end,
    local_o_remote_str = function(path)
      if is.path.remote_path(path) then
        return "remote"
      else
        return "local"
      end
    end,
    path_by_parent_path_with_extension_if_any = function(path)
      local extension = transf.path.extension(path)
      local parent_path = transf.path.trimmed_noweirdwhitespace_line_by_parent_path(path)
      local new_path = parent_path .. extension
      return new_path
    end,

  },

  path_with_twod_locator = {
    intra_file_location_spec = function(path)
      local parts = get.str.str_arr_by_split_w_ascii_char(path, ":")
      local final_part = transf.nonindicated_number_str.number_by_base_10(act.arr.pop(parts))
      local specifier = {}
      if is.str.nonindicated_number_str(parts[#parts]) then
        specifier = {
          column = final_part,
          line = transf.nonindicated_number_str.number_by_base_10(act.arr.pop(parts)),
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
  intra_file_location_spec = {
    pos_int_by_line = function(specifier)
      return specifier.line
    end,
    digit_str_by_line = function(specifier)
      return transf.pos_int.digit_str(specifier.line)
    end,
    pos_int_or_nil_by_column = function(specifier)
      return specifier.column
    end,
    digit_str_or_nil_by_column = function(specifier)
      local column = specifier.column
      if column then
        return transf.pos_int.digit_str(column)
      else
        return nil
      end
    end,
    path = function(specifier)
      return specifier.path
    end,
    twod_locator = function(specifier)
      if specifier.column then
        return ":" .. specifier.digit_str_by_line .. ":" .. specifier.digit_str_or_nil_by_column
      else
        return ":" .. specifier.digit_str_by_line
      end
    end,
    input_spec_arr = function(specifier)
      return {
        {mode = "key", key = "g", mods = {"ctrl"} },
        {mode = "key", key = transf.intra_file_location_spec.twod_locator(specifier)},
        {mode = "key", key = "enter"},
      }
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
  str_or_nil = {
    line_or_nil_by_folded = function(str)
      if str then
        return transf.str.line_by_folded(str)
      end
    end,
    str_by_surrounded_with_brackets_if_str = function(str)
      if str then
        return transf.str.str_by_surrounded_with_brackets(str)
      else
        return ""
      end
    end,
    str_by_start_with_slash_if_str = function(str)
      if str then
        return transf.str.str_by_start_with_slash(str)
      else
        return ""
      end
    end,
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
    local_absolute_path_by_prompted_multiple_from_default = function(path)
      return transf.prompt_spec.any_arr({
        prompter = transf.str_prompt_args_spec.str_or_nil_and_bool,
        prompt_args = {
          message =  "Enter a subdirectory (or file, if last) (started with: " .. path .. ")",
        }
      })
    end,
    local_absolute_path_by_prompted_once_from_default = function(path)
      return transf.prompt_spec.any({
        prompter = transf.str_prompt_args_spec.str_or_nil_and_bool,
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
      return transf.dir.absolute_path_arr_by_children(transf.path.trimmed_noweirdwhitespace_line_by_parent_path(path))
    end,
    absolute_path_arr_by_descendants = function(path)
      return get.local_extant_path.absolute_path_arr(
        path,
        {recursion = true}
      )
    end,
    absolute_path_arr_by_descendants_depth_3 = function(path)
      return get.local_extant_path.absolute_path_arr(
        path,
        {recursion = 3}
      )
    end,
    file_arr_by_descendants = function(path)
      return get.local_extant_path.absolute_path_arr(
        path,
        {recursion = true, include_dirs = false}
      )
    end,
    plaintext_file_arr_by_descendants = function(path)
      return transf.file_arr.plaintext_file_arr_by_filter(
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
      return get.local_extant_path.absolute_path_arr(
        path,
        {recursion = true, include_files = false}
      )
    end,
    leaflike_arr_by_descendant_leaves = function(path)
      return transf.path_arr.leaflike_arr_by_leaves(transf.extant_path.absolute_path_arr_by_descendants(path))
    end,
    leaflike_arr_by_descendant_filenames = function(path)
      return transf.path_arr.leaflike_arr_by_filenames(transf.extant_path.absolute_path_arr_by_descendants(path))
    end,
    extension_arr_by_descendants = function(path)
      return transf.path_arr.extensions_arr(transf.extant_path.absolute_path_arr_by_descendants(path))
    end,

    dir_arr_by_descendants_depth_3 = function(path)
      return get.local_extant_path.absolute_path_arr(
        path,
        {recursion = 3, include_files = false}
      )
    end,
    git_root_dir_arr_by_descendants = function(dir)
      return transf.dir_arr.git_root_dir_arr_by_filter(transf.extant_path.absolute_path_arr_by_descendants(dir))
    end,
    yaml_file_arr_by_descendants = function(path)
      return transf.extant_path_arr.yaml_file_arr(
        transf.extant_path.file_arr_by_descendants(path)
      )
    end,
    plaintext_assoc_file_arr_by_descendants = function(path)
      return transf.extant_path_arr.plaintext_assoc_file_arr(
        transf.extant_path.file_arr_by_descendants(path)
      )
    end,
    not_userdata_or_fn_arr_by_descendants = function(path)
      return transf.plaintext_assoc_file_arr.not_userdata_or_fn_arr(
        transf.extant_path.plaintext_assoc_file_arr_by_descendants(path)
      )
    end,
  },
  local_extant_path = {
    int_by_size_bytes = function(path)
      return get.local_extant_path.attr(path, "size")
    end,
    timestamp_s_by_modification = function(path)
      return get.local_extant_path.attr(path, "modification")
    end,
    timestamp_s_by_creation = function(path)
      return get.local_extant_path.attr(path, "creation")
    end,
    full_rfc3339like_dt_by_creation = function(path)
      return transf.timestamp_s.rfc3339like_dt(transf.local_extant_path.timestamp_s_by_creation(path))
    end,
    timestamp_s_by_change = function(path)
      return get.local_extant_path.attr(path, "change")
    end,
    timestamp_s_by_access = function(path)
      return get.local_extant_path.attr(path, "access")
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
      return get.local_absolute_path.local_nonabsolute_path_by_from(path, env.HOME)
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
    leaflike_arr_by_leaves = function(path_arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(path_arr, transf.path.leaflike_by_leaf)
    end,
    leaflike_arr_by_filenames = function(path_arr)
      local filenames = get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(path_arr, transf.path.leaflike_by_filename)
      return transf.arr.set(filenames)
    end,
    extensions_arr = function(path_arr)
      local extensions = get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(path_arr, transf.path.extension)
      return transf.arr.set(extensions)
    end,
    extant_path_arr = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.path.extant_path)
    end,
    not_useless_file_leaf_path_arr_by_filtered = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.path.not_useless_file_leaf_path)
    end,
    path_leaf_specifier_arr = function(path_arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(path_arr, transf.path.path_leaf_specifier_or_nil)
    end,
    timestamp_s_interval_specifier_arr = function(path_arr)
      return transf.path_leaf_specifier_arr.timestamp_s_interval_specifier_arr(
        transf.path_arr.path_leaf_specifier_arr(path_arr)
      )
    end,
    rfc3339like_dt_o_interval_by_union = function(path_arr)
      return transf.path_leaf_specifier_arr.rfc3339like_dt_o_interval_by_union(
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
      return get.local_extant_path_arr.extant_by_largest_of_attr(path_arr, "creation")
    end,
    dir_arr_by_filter = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.extant_path.dir)
    end,
    file_arr_by_filter = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.extant_path.file)
    end,
    git_root_dir_arr_by_filter = function(path_arr)
      return transf.dir_arr.git_root_dir_arr_by_filter(transf.extant_path_arr.dir_arr_by_filter(path_arr))
    end,
    file_arr_by_descendants = function(path_arr)
      return get.arr_arr.arr_by_mapped_w_t_arg_t_ret_fn_and_flatten(
        path_arr,
        transf.extant_path.file_arr_by_descendants
      )
    end,
    plaintext_assoc_file_arr_by_filter = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.extant_path.plaintext_assoc_file)
    end,
    yaml_file_arr_by_filter = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.extant_path.yaml_file)
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
      return get.arr_arr.arr_by_mapped_w_t_arg_t_ret_fn_and_flatten(
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
    plaintext_file_arr_by_filter = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.file.plaintext_file)
    end,
    url_or_local_path_arr_by_m3u_file_content_lines = function(path_arr)
      return transf.plaintext_file_arr.url_or_local_path_arr_by_m3u_file_content_lines(
        transf.file_arr.plaintext_file_arr_by_filter(path_arr)
      )
    end,
  },
  labelled_remote_dir = {
    absolute_path_arr_by_children = function(remote_extant_path)
      local output = transf.str.str_or_nil_by_evaled_env_bash_stripped("rclone lsf" .. transf.str.str_by_single_quoted_escaped(remote_extant_path))
      if output then
        items = transf.str.noempty_line_arr(output)
        items = transf.str_arr.not_starting_o_ending_with_whitespace_str_arr(items)
      else
        items = {}
      end
      return items
    end,
    absolute_path_stateful_iter_by_children = function(remote_extant_path)
      return transf.table.vt_stateful_iter(
        transf.remote_dir.absolute_path_arr_by_children(remote_extant_path)
      )
    end,
  },
  remote_dir = {
    absolute_path_arr_by_children = function(remote_extant_path)
      return transf.labelled_remote_dir.absolute_path_arr_by_children(remote_extant_path)
    end,
    absolute_path_stateful_iter_by_children = function(remote_extant_path)
      return transf.labelled_remote_dir.absolute_path_stateful_iter_by_children(remote_extant_path)
    end,
  },
  dms_str = {
    three_nonindicated_number_strs = function(str)
      return get.str.n_strs_by_extracted_onig_str(str, "^(\\d+)[^\\d]+(\\d+)'[^\\d]+([\\d.]+)")
    end,
    three_numbers = function(str)
      local deg, min, sec = transf.dms_str.three_nonindicated_number_strs(str)
      return transf.nonindicated_number_str.number_by_base_10(deg), transf.nonindicated_number_str.number_by_base_10(min), transf.nonindicated_number_str.number_by_base_10(sec)
    end,
    number = function(str)
      local deg, min, sec = transf.dms_str.three_numbers(str)
      return deg + min/60 + sec/3600
    end,
  },
  location_log_spec = {
    geojson_feature_collection = function(spec)
      return rest({
        api_name = "osm",
        endpoint = "reverse",
        params = {
          lat = spec.lat,
          lon = spec.long,
          format = "geojson",
        }
      })
    end,
    geojson_feature_or_nil = function(spec)
      return transf.location_log_spec.geojson_feature_collection(spec).features[1]
    end,
    two_lines__arr_arr = function(spec)
      local res = {
        {"lat", spec.lat},
        {"long", spec.long},
      }
      if spec.ele then
        dothis.arr.push(res, {"ele", spec.ele})
      end
      local geojson_feature = transf.location_log_spec.geojson_feature_or_nil(spec)
      if geojson_feature then
        -- populate with value of various osm fields, bearing in mind that they may be nil
        -- instead of manually checking fields, we will instead just zero-out the fields we don't want
        geojson_feature["ISO3166-2-lvl4"] = nil
        geojson_feature.tourism = nil
        for k, v in transf.table.kt_vt_stateless_iter(geojson_feature.properties.address) do
          dothis.arr.push(res, {k, v})
        end
      end
      return res
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
    single_attachment_str = function(path)
      local mimetype = mimetypes.guess(path) or "text/plain"
      return "#" .. mimetype .. " " .. path
    end,
    email_specifier = function(path)
      return {
        non_inline_attachment_local_file_arr = {path}
      }
    end,
    assoc_by_exiftool_info = function(path)
      return transf.local_file_arr.assoc_arr_by_exiftool_info(
        {path}
      )[1]
    end,
    location_log_spec_by_exiftool = function(path)
      local exifassoc = transf.local_file.assoc_by_exiftool_info(path)
      local res = {}
      if exifassoc.GPSLatitude and exifassoc.GPSLongitude then
        res.lat = exifassoc.GPSLatitude
        res.long = exifassoc.GPSLongitude
        if exifassoc.GPSAltitude then
          res.ele = exifassoc.GPSAltitude
        end
        return res
      else
        return nil
      end
    end,
    full_rfc3339like_dt_by_metadata = function(path)
      local exifassoc = transf.local_file.assoc_by_exiftool_info(path)
      if exifassoc.CreationDate then
        local notz = get.str.n_strs_by_extracted_onig_str(exifassoc.CreationDate, "^(^\\+)+")
        notz = get.str.str_by_replaced_w_ascii_str(notz, " ", "T")
        return notz 
      else
        return transf.local_extant_path.full_rfc3339like_dt_by_creation(path)
      end
    end,
    rfc3339like_dt_by_any_source = function(path)
      local dt = transf.path.rfc3339like_dt_or_nil_by_filename(path)
      if dt then
        return dt
      else
        return transf.local_file.full_rfc3339like_dt_by_metadata(path)
      end
    end,
    two_lines__arr_arr_by_metadata = function(path)
      local exifassoc = transf.local_file.assoc_by_exiftool_info(path)
      local res = {}
      if exifassoc.Make then
        dothis.arr.push({"creation_ware", exifassoc.Make})
      end
      if exifassoc.DeviceManufacturer then
        dothis.arr.push({"creation_ware", exifassoc.DeviceManufacturer})
      end
      if exifassoc.Model then
        dothis.arr.push({"creation_ware", exifassoc.Model})
      end
      if exifassoc.DeviceModel then
        dothis.arr.push({"creation_ware", exifassoc.DeviceModel})
      end
      return res
    end,
    two_lines__arr_arr_by_file_tags = function(path)
      local arr = transf.two_arr_or_nils.arr(
        transf.local_file.two_lines__arr_arr_by_metadata(path),
        transf.path.two_lines__arr_arr_by_path_tags(path)
      )
      dothis.arr.push(arr, {"date", transf.local_file.rfc3339like_dt_by_any_source(path)})
      return arr
    end,
    line_arr_by_file_tags = function(path)
      return transf.two_lines_arr__arr.line_arr_by_booru_namespaced_tag_smart(
        transf.local_file.two_lines__arr_arr_by_file_tags(path)
      )
    end
  },
  local_file_arr = {
    single_attachment_str_arr = function(path_arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(path_arr, transf.local_file.single_attachment_str)
    end,
    str_by_joined_single_attachment_strs = function(path_arr)
      return get.str_or_number_arr.str_by_joined(transf.path_arr.attachment_arr(path_arr), "\n")
    end,
    email_specifier = function(path_arr)
      return {
        non_inline_attachment_local_file_arr = path_arr
      }
    end,
    assoc_arr_by_exiftool_info = function(path_arr)
      transf.str.table_or_err_by_evaled_env_bash_parsed_json(
        "exiftool -j -n --all " .. transf.str_arr.str_arr_by_mapped_single_quoted_escaped(path_arr) .. "| jq 'map(. |= with_entries(if .value == \"\" then .value = null else . end))'"
      )
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
      return get.local_extant_path.absolute_path_arr(dir)
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
        transf.path.trimmed_noweirdwhitespace_line_by_parent_path(dir)
      )
    end,
    file_arr_by_children = function(dir)
      return get.local_extant_path.absolute_path_arr(dir, {include_dirs = false})
    end,
    absolute_path_arr_by_file_children_or_self = function(dir)
      return transf.arr_and_any.arr(
        transf.dir.file_arr_by_children(dir),
        dir
      )
    end,
    dir_arr_by_children = function(dir)
      return get.local_extant_path.absolute_path_arr(dir, {include_files = false})
    end,
    dir_arr_by_children_or_self = function(dir)
      return transf.arr_and_any.arr(
        transf.dir.dir_arr_by_children(dir),
        dir
      )
    end,
    absolute_path_stateful_iter_by_children = function(dir)
      if is.path.remote_path(dir) then
        return transf.remote_dir.absolute_path_stateful_iter_by_children(dir)
      else
        return transf.local_dir.absolute_path_vt_stateful_iter_by_children(dir)
      end
    end,
    leaflike_arr_by_children_leaves = function(dir)
      return transf.path_arr.leaflike_arr_by_leaves(transf.dir.absolute_path_arr_by_children(dir))
    end,
    leaflike_arr_by_children_leaves_or_dot = function(dir)
      return transf.arr_and_any.arr(
        transf.dir.leaflike_arr_by_children_leaves(dir),
        "."
      )
    end,
    leaflike_arr_by_children_leaves_or_dotdot = function(dir)
      return transf.arr_and_any.arr(
        transf.dir.leaflike_arr_by_children_leaves(dir),
        ".."
      )
    end,
    leaflike_arr_by_children_filenames = function(dir)
      return transf.path_arr.leaflike_arr_by_filenames(transf.dir.absolute_path_arr_by_children(dir))
    end,
    extension_arr_by_children = function(dir)
      return transf.path_arr.extensions_arr(transf.dir.absolute_path_arr_by_children(dir))
    end,
    extant_path_by_newest_child = function(dir)
      return transf.extant_path_arr.extant_path_by_newest_creation(transf.dir.absolute_path_arr_by_children(dir))
    end,
    absolute_path_arr_by_grandchildren = function(dir)
      return get.arr_arr.arr_by_mapped_w_t_arg_t_ret_fn_and_flatten(transf.dir.absolute_path_arr_by_children(dir), transf.dir.absolute_path_arr_by_children)
    end,
    absolute_path_key_leaf_str_or_nested_value_assoc = function(path)
      local res = {}
      path = get.str.str_by_with_suffix(path, "/")
      for child_path in transf.dir.absolute_path_stateful_iter_by_children(path) do
        if is.absolute_path.dir(child_path) then
          res[child_path] = transf.dir.absolute_path_key_leaf_str_or_nested_value_assoc(child_path)
        else
          res[child_path] = "leaf"
        end
      end
      return res
    end,
    absolute_path_key_leaf_str_table_or_nested_assoc_by_read_plaintext_assoc_file = function(path)
      transf.absolute_path_key_leaf_str_or_nested_value_assoc.absolute_path_key_leaf_str_table_or_nested_assoc_by_read_plaintext_assoc_file(
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
    rfc3339like_dt_o_interval_by_union_of_children = function(path)
      return transf.path_leaf_specifier_arr.rfc3339like_dt_o_interval_by_union(
        transf.dir.path_leaf_specifier_arr_by_children(path)
      )
    end,
    path_leaf_specifier_by_using_union_rfc3339like_dt_or_interval = function(path)
      local path_leaf_specifier = transf.path.path_leaf_specifier_or_nil(path)
      local union_rfc3339like_dt_or_interval = transf.dir.rfc3339like_dt_o_interval_by_union_of_children(path)
      if union_rfc3339like_dt_or_interval then
        path_leaf_specifier.rfc3339like_dt_o_interval = union_rfc3339like_dt_or_interval
      end
      return path_leaf_specifier
    end,
    absolute_path_by_using_union_rfc3339like_dt_o_interval = function(path)
      local path_leaf_specifier = transf.dir.path_leaf_specifier_by_using_union_rfc3339like_dt_or_interval(path)
      return transf.path_leaf_specifier.absolute_path(path_leaf_specifier)
    end
  },
  absolute_path_key_leaf_str_or_nested_value_assoc = {
    leaflike_key_leaf_str_or_nested_value_assoc_by_extract_leaf = function(assoc)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(assoc) do
        local leaf = transf.path.leaflike_by_leaf(k)
        if is.any.table(v) then
          res[leaf] = transf.absolute_path_key_leaf_str_or_nested_value_assoc.leaflike_key_leaf_str_or_nested_value_assoc_by_extract_leaf(v)
        else
          res[leaf] = v
        end
      end
      return res
    end,
    absolute_path_key_leaf_str_table_or_nested_assoc_by_read_plaintext_assoc_file = function(assoc)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(assoc) do
        local filename = transf.path.leaflike_by_filename(k)
        if is.any.table(v) then
          res[filename] = transf.absolute_path_key_leaf_str_or_nested_value_assoc.absolute_path_key_leaf_str_table_or_nested_assoc_by_read_plaintext_assoc_file(v)
        else
          if is.file.plaintext_assoc_file(k) then
            res[filename] = transf.plaintext_assoc_file.not_userdata_or_fn(k)
          end
        end
      end
      return res
    end,
  },

  in_git_dir = {
    git_root_dir = function(path)
      return get.local_extant_path.extant_path_by_self_or_ancestor_w_fn(
        path,
        is.dir.git_root_dir
      )
    end,
    git_repository_dir = function(path)
      return transf.git_root_dir.git_repository_dir(transf.in_git_dir.git_root_dir(path))
    end,
    local_nonabsolute_path_by_from_git_root_dir = function(path)
      return get.local_absolute_path.local_nonabsolute_path_by_from(
        path,
        transf.in_git_dir.git_root_dir(path)
      )
    end,
    absolute_path_by_root_gitignore = function(path)
      return transf.path.path_by_ending_with_slash(transf.in_git_dir.git_root_dir(path)) .. ".gitignore"
    end,
    printable_ascii_not_whitespace_str_by_current_branch = function(path)
      return get.local_extant_path.str_or_nil_by_evaled_env_bash_stripped(
        path,
        "git rev-parse --abbrev-ref HEAD"
      )
    end,
    printable_ascii_not_whitespace_str_or_nil_by_likely_main_branch = function(path)
      return transf.git_repository_dir.printable_ascii_not_whitespace_str_or_nil_by_likely_main_branch(
        transf.in_git_dir.git_repository_dir(path)
      )
    end,
    path_url_by_remote_blob_current_branch = function(path)
      return get.in_git_dir.path_url_by_remote_blob(
        path,
        transf.in_git_dir.printable_ascii_not_whitespace_str_by_current_branch(path)
      )
    end,
    path_url_by_remote_raw_current_branch = function(path)
      return get.in_git_dir.path_url_by_remote_raw(
        path,
        transf.in_git_dir.printable_ascii_not_whitespace_str_by_current_branch(path)
      )
    end,
    path_url_by_remote_blob_main_branch = function(path)
      return get.in_git_dir.path_url_by_remote_blob(
        path,
        transf.in_git_dir.printable_ascii_not_whitespace_str_or_nil_by_likely_main_branch(path)
      )
    end,
    path_url_by_remote_raw_main_branch = function(path)
      return get.in_git_dir.path_url_by_remote_raw(
        path,
        transf.in_git_dir.printable_ascii_not_whitespace_str_or_nil_by_likely_main_branch(path)
      )
    end,
    dotgit_url_by_remote = function(path)
      return get.local_extant_path.str_or_nil_by_evaled_env_bash_stripped(
        path,
        "git config --get remote.origin.url"
      )
    end,
    base_url_by_remote_cleaned = function(path)
      local raw = transf.in_git_dir.dotgit_url_by_remote(path)
      raw = get.str.str_by_no_suffix(raw, ".git")
      raw = get.str.str_by_no_suffix(raw, "/")
      return raw
    end,
    two_strs_arr_or_nil_by_remote_owner_item = function(path)
      return transf.owner_item_url.two_strs__arr(transf.in_git_dir.base_url_by_remote_cleaned(path))
    end,
    host_by_remote = function(path)
      return transf.url.host(transf.in_git_dir.base_url_by_remote_cleaned(path))
    end,
    alphanum_minus_or_nil_by_remote_sld = function(path)
      return transf.url.alphanum_minus_or_nil_by_sld(transf.in_git_dir.base_url_by_remote_cleaned(path))
    end,
    git_remote_type = function(path)
      local git_remote_type = transf.in_git_dir.alphanum_minus_or_nil_by_remote_sld(path)
      if get.arr.bool_by_contains(ls.git_remote_types, git_remote_type ) then
        return git_remote_type
      else
        return tblmap.host.git_remote_type[transf.in_git_dir.host_by_remote(path)] -- we'll hardcode known hosts there
      end
    end,
    host_by_remote_blob_host = function(path)
      local git_remote_type = transf.in_git_dir.git_remote_type(path)
      local remote_host = transf.in_git_dir.host_by_remote(path)
      return tblmap.host.host_by_blob_default[remote_host] or tblmap.git_remote_type.host_by_blob_default[git_remote_type]
    end,
    host_by_remote_raw_host = function(path)
      local git_remote_type = transf.in_git_dir.git_remote_type(path)
      local remote_host = transf.in_git_dir.host_by_remote(path)
      return tblmap.host.host_by_raw_default[remote_host] or tblmap.git_remote_type.host_by_raw_default[git_remote_type]
    end,
    multiline_str_by_status = function(path)
      return get.local_extant_path.str_or_nil_by_evaled_env_bash_stripped(
        path,
        "git status"
      )
    end,
    short_sha1_hex_str_arr_by_unpushed_commits = function(path)
      local raw_hashes = get.local_extant_path.str_or_nil_by_evaled_env_bash_stripped(
        path,
        "git log --branches --not --remotes --pretty=format:'%h'"
      )
      return transf.str.noempty_line_arr(raw_hashes)
    end,


  },
  in_git_dir_arr = {
    in_has_changes_git_dir_arr_by_filtered = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.in_git_dir.in_has_changes_git_dir)
    end,
    in_has_unpushed_commits_git_dir_arr_by_filtered = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.in_git_dir.in_has_unpushed_commits_git_dir)
    end,
  },
  git_repository_dir = {
    in_git_dir_by_hooks_dir = function(git_repository_dir)
      return transf.path.path_by_ending_with_slash(git_repository_dir) .. "hooks"
    end,
    in_git_dir_by_refs_dir = function(git_repository_dir)
      return transf.path.path_by_ending_with_slash(git_repository_dir) .. "refs"
    end,
    in_git_dir_by_head_refs_dir = function(git_repository_dir)
      return transf.path.path_by_ending_with_slash(git_repository_dir) .. "refs/heads"
    end,
    printable_ascii_not_whitespace_str_or_nil_by_likely_main_branch = function(git_repository_dir)
      for _, bname in transf.arr.pos_int_vt_stateless_iter(ls.likely_main_branch_name) do
        if get.git_repository_dir.bool_by_branch_exists(git_repository_dir, bname) then
          return bname
        end
      end
      return nil
    end,
  },
  non_bare_git_root_dir = {
    git_repository_dir = function(git_root_dir)
      return transf.path.path_by_ending_with_slash(git_root_dir) .. ".git"
    end,
  },
  git_root_dir = {
    git_repository_dir = function(git_root_dir)
      if is.dir.non_bare_git_root_dir(git_root_dir) then
        return transf.non_bare_git_root_dir.git_repository_dir(git_root_dir)
      else
        return git_root_dir
      end
    end,
    in_git_dir_by_hooks_dir = function(git_root_dir)
      return transf.git_repository_dir.in_git_dir_by_hooks_dir(transf.git_root_dir.git_repository_dir(git_root_dir))
    end,
    in_git_dir_arr_by_hooks = function(git_root_dir)
      return transf.dir.absolute_path_arr_by_children(transf.git_root_dir.in_git_dir_by_hooks_dir(git_root_dir))
    end,
  },

  github_username = {
    github_user_url = function(github_username)
      return "https://github.com/" .. github_username
    end,
  },
  
  path_leaf_specifier = {
    alphanum_minus_underscore_by_general_name_part = function(path_leaf_specifier)
      if path_leaf_specifier.general_name then 
        return "--" .. path_leaf_specifier.general_name
      else
        return ""
      end
    end,
    leaflike_by_extension_part = function(path_leaf_specifier)
      if path_leaf_specifier.extension then 
        return "." .. path_leaf_specifier.extension
      else
        return ""
      end
    end,
    str_by_rfc3339like_dt_or_interval_part = function(path_leaf_specifier)
      return path_leaf_specifier.rfc3339like_dt_or_interval or ""
    end,
    timestamp_s_interval_specifier_or_nil = function(path_leaf_specifier)
      if path_leaf_specifier.rfc3339like_dt_or_interval then
        return transf.rfc3339like_dt_or_interval.timestamp_s_interval_specifier(path_leaf_specifier.rfc3339like_dt_or_interval)
      else
        return nil
      end
    end,
    absolute_path_by_path_part = function(path_leaf_specifier)
      return transf.path.path_by_ending_with_slash(path_leaf_specifier.path) 
    end,
    lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc = function(path_leaf_specifier)
      return path_leaf_specifier.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc
    end,
    lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc_by_supplemented = function(path_leaf_specifier)
      local assoc = transf.path_leaf_specifier.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc(path_leaf_specifier)
      assoc.title = assoc.title or path_leaf_specifier.general_name
    end,
    two_lines__arr_arr_by_fs_tags = function(path_leaf_specifier)
      return transf.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc.two_line__arr_arr_by_rename_filter_namespace(
        transf.path_leaf_specifier.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc_by_supplemented(path_leaf_specifier)
      )
    end,
    lower_alphanum_underscore_key_lower_alphanum_underscore_comma_value_assoc = function(path_leaf_specifier)
      return transf.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc.lower_alphanum_underscore_key_lower_alphanum_underscore_comma_value_assoc(path_leaf_specifier.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc)
    end,
    fs_tag_kv_arr = function(path_leaf_specifier)
      return transf.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc.fs_tag_kv_arr(path_leaf_specifier.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc)
    end,
    fs_tag_str = function(path_leaf_specifier)
      return transf.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc.fs_tag_str(path_leaf_specifier.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc)
    end,
    lower_alphanum_underscore_arr_by_fs_tag_keys = function(path_leaf_specifier)
      return transf.table_or_nil.kt_arr(path_leaf_specifier.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc)
    end,
    absolute_path = function(path_leaf_specifier)
      return transf.path.path_by_ending_with_slash(path_leaf_specifier.path) 
      .. transf.path_leaf_specifier.str_by_rfc3339like_dt_or_interval_part(path_leaf_specifier)
      .. transf.path_leaf_specifier.alphanum_minus_underscore_by_general_name_part(path_leaf_specifier)
      .. transf.path_leaf_specifier.fs_tag_str(path_leaf_specifier)
      .. transf.path_leaf_specifier.leaflike_by_extension_part(path_leaf_specifier)
    end
  },
  fs_tag_str = {
    fs_tag_kv_arr = function(fs_tag_str)
      return get.str.str_arr_by_split_w_ascii_char(
        fs_tag_str:sub(2),
        "%"
      )
    end,
    lower_alphanum_underscore_key_lower_alphanum_underscore_comma_value_assoc = function(fs_tag_str)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        transf.fs_tag_str.fs_tag_kv_arr(fs_tag_str),
        transf.fs_tag_kv.lower_alphanum_underscore_and_lower_alphanum_underscore_comma
      )
    end,
    lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc = function(fs_tag_str)
      transf.lower_alphanum_underscore_key_lower_alphanum_underscore_comma_value_assoc.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc(
        transf.fs_tag_str.lower_alphanum_underscore_key_lower_alphanum_underscore_comma_value_assoc(fs_tag_str)
      )
    end,
  },
  fs_tag_kv = {
    lower_alphanum_underscore_and_lower_alphanum_underscore_comma = function(fs_tag_kv)
      return get.str.n_strs_by_split_w_str(fs_tag_kv, "-", 2)
    end,
  },
  fs_tag_kv_arr = {
    lower_alphanum_underscore_key_lower_alphanum_underscore_comma_value_assoc = function(fs_tag_kv_arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        fs_tag_kv_arr,
        get.fn.fn_by_2nd_n_bound(get.str.two_strs_or_nil_by_split_w_str, "-")
      )
    end,
    lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc = function(fs_tag_kv_arr)
      transf.lower_alphanum_underscore_key_lower_alphanum_underscore_comma_value_assoc.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc(
        transf.fs_tag_kv_arr.lower_alphanum_underscore_key_lower_alphanum_underscore_comma_value_assoc(fs_tag_kv_arr)
      )
    end,
    fs_tag_str = function(fs_tag_kv_arr)
      return "%" .. get.str_or_number_arr.str_by_joined(fs_tag_kv_arr, "%")
    end,
  },
  lower_alphanum_underscore_key_lower_alphanum_underscore_comma_value_assoc = {
    lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc = function(assoc)
      return hs.fnutils.map(
        assoc,
        get.fn.fn_by_arbitrary_args_bound_or_ignored(get.str.str_arr_by_split_w_ascii_char, {a_use, ","})
      )
    end,
    fs_tag_kv_arr = function(assoc)
      return get.table.str_arr_by_mapped_w_fmt_str(
        assoc,
        "%s-%s"
      )
    end,
    fs_tag_str = function(assoc)
      return transf.fs_tag_kv_arr.fs_tag_str(
        transf.lower_alphanum_underscore_key_lower_alphanum_underscore_comma_value_assoc.fs_tag_kv_arr(assoc)
      )
    end,
  },
  lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc = {
    lower_alphanum_underscore_key_lower_alphanum_underscore_comma_value_assoc = function(assoc)
      return hs.fnutils.map(
        assoc,
        transf.any.join_if_arr
      )
    end,
    fs_tag_kv_arr = function(assoc)
      return transf.lower_alphanum_underscore_key_lower_alphanum_underscore_comma_value_assoc.fs_tag_kv_arr(
        transf.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc.lower_alphanum_underscore_key_lower_alphanum_underscore_comma_value_assoc(assoc)
      )
    end,
    fs_tag_str = function(assoc)
      return transf.fs_tag_kv_arr.fs_tag_str(
        transf.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc.fs_tag_kv_arr(assoc)
      )
    end,
    lower_alphanum_underscore_key_line_or_line_arr_value_assoc_by_rename_filter_namespace = function(assoc)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(assoc) do
        local namespace = tblmap.lower_strict_snake_case.line_by_namespace_and_potentially_subnamespace[k]
        if namespace then
          res[namespace] = v
        else
          local booru_equivalent = tblmap.lower_strict_snake_case.lower_strict_snake_case_key_line_value_assoc[k][v]
          if booru_equivalent then
            res.general = res.general or {}
            dothis.arr.push(res.general, booru_equivalent)
          end
        end
      end
    end,
    two_lower_alphanum_underscores__arr_arr = function(assoc)
      local res = {}
      for k, v in transf.table.stateless_key_value_iter(assoc) do
        if is.any.arr(v) then
          for _, v2 in transf.arr.pos_int_vt_stateless_iter(v) do
            v2 = get.str.str_by_replaced_w_ascii_str(v2, "_", " ")
            act.arr.push(res, {k, v2})
          end
        else
          v = get.str.str_by_replaced_w_ascii_str(v, "_", " ")
          act.arr.push(res, {k, v})
        end
      end
      return res
    end,
    two_line__arr_arr_by_rename_filter_namespace = function(assoc)
      return transf.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc.two_lower_alphanum_underscores__arr_arr(
        transf.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc.lower_alphanum_underscore_key_line_or_line_arr_value_assoc_by_rename_filter_namespace(assoc)
      )
    end,
    },
  path_leaf_specifier_arr = {
    path_leaf_specifier_key_timestamp_s_interval_specifier_value_assoc = function(arr)
      return get.table.table_by_mapped_w_kt_arg_kt_vt_ret_fn(
        arr,
        function(path_leaf_specifier)
          return 
            path_leaf_specifier,
            transf.path_leaf_specifier.timestamp_s_interval_specifier_or_nil(
              path_leaf_specifier
            )
        end
      )
    end,
    timestamp_s_interval_specifier_arr = function(arr)
      return get.table.arr_by_mapped_w_vt_arg_vt_ret_fn(
        arr,
        transf.path_leaf_specifier.timestamp_s_interval_specifier_or_nil
      )
    end,
    timestamp_s_interval_specifier_or_nil_by_earliest_start = function(arr)
      return transf.interval_specifier_arr.interval_specifier_by_earliest_start(
        transf.path_leaf_specifier_arr.timestamp_s_interval_specifier_arr(arr)
      )
    end,
    timestamp_s_by_earliest_start = function(arr)
      return transf.interval_specifier_arr.t_by_earliest_start(
        transf.path_leaf_specifier_arr.timestamp_s_interval_specifier_arr(arr)
      )
    end,
    timestamp_s_by_latest_end = function(arr)
      return transf.interval_specifier_arr.latest_end(
        transf.path_leaf_specifier_arr.timestamp_s_interval_specifier_arr(arr)
      )
    end,
    timestamp_s_interval_specifier_by_union = function(arr)
      return transf.interval_specifier_arr.interval_specifier_by_union(
        transf.path_leaf_specifier_arr.timestamp_s_interval_specifier_arr(arr)
      )
    end,
    rfc3339like_dt_o_interval_by_union = function(arr)
      return transf.timestamp_s_interval_specifier.rfc3339like_dt_or_interval(
        transf.path_leaf_specifier_arr.timestamp_s_interval_specifier_by_union(arr)
      )
    end,
    path_leaf_specifier_or_nil_by_earliest_start = function(arr)
      return get.assoc.kt_or_nil_by_first_match_w_vt(
        transf.path_leaf_specifier_arr.path_leaf_specifier_key_timestamp_s_interval_specifier_value_assoc(arr),
        transf.path_leaf_specifier_arr.timestamp_s_interval_specifier_or_nil_by_earliest_start(arr)
      )
    end,
  },
  whisper_file = {
    str_by_transcribed = function(path)
      return get.whisper_file.str_by_transcribed(path)
    end
  },
  local_image_file = {
    multiline_str_by_qr_data = function(path)
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
    image_data_url = function(path)
      local ext = transf.path.extension(path)
      return get.fn.rt_or_nil_by_memoized(hs.image.encodeAsURLString)(transf.local_image_file.hs_image(path), ext)
    end,
    multiline_str_by_local_ai_tags = function (path)
      local fetchpath = transf.str.str_by_single_quoted_escaped(path)
      if is.local_image_file.local_svg_file(path) then
        fetchpath = transf.local_svg_file.local_absolute_path_by_png_in_cache(path)
        if not is.local_absolute_path.local_extant_path(fetchpath) then
          act.local_svg_file.to_png_in_cache(path)
        end
      end
      return get.fn.rt_or_nil_by_memoized(
        transf.str.str_or_nil_by_evaled_env_bash_stripped,
        nil,
        "transf.str.str_or_nil_by_evaled_env_bash_stripped"
    )
      (
        "hydrus_get_tags " .. fetchpath
      )
    end,
    booru_rating_by_local_ai = function(path)
      return get.str.n_strs_by_extracted_onig(
        transf.local_image_file.multiline_str_by_local_ai_tags(path),
        "\nrating: ([^\n]+)\n"
      )
    end,
    line_by_local_ai_tags = function(path)
      return get.str.n_strs_by_extracted_onig(
        transf.local_image_file.multiline_str_by_local_ai_tags(path),
        "tags: ([^\n]+)\n"
      )
    end,
    line_arr_by_local_ai_tags = function(path)
      return get.str.str_arr_by_split_w_ascii_char(
        transf.local_image_file.line_by_local_ai_tags(path),
        ","
      )
    end,
    
  },
  local_image_file_arr = {

  },
  maildir_file = {
    decoded_email_header_block_by_all = function(path)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "mshow -qL" .. transf.str.str_by_single_quoted_escaped(path)
      )
    end,
    decoded_email_header_block_by_all_useful = function(path)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "mshow -q" .. transf.str.str_by_single_quoted_escaped(path)
      )
    end,
    line_key_line_value_assoc_by_useful_headers = function(path)
      error("TODO: currently the way the headers are rendered contains a bunch of stuff we wouldn't want in the assoc. In particular, emails without a name are rendered as <email>, which may not be what we want.")
      return transf.decoded_email_header_block.line_key_line_value_assoc(transf.maildir_file.decoded_email_header_block_by_all_useful(path))
    end,
    rendered_body = function(path)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)(
        "mshow -R" .. transf.str.str_by_single_quoted_escaped(path)
      )
    end,
    decoded_email_by_useful_headers = function(path)
      return transf.maildir_file.decoded_email_header_block_by_all_useful(path) .. "\n\n" .. transf.maildir_file.rendered_body(path)
    end,
    email_specifier = function(path)
      local specifier = transf.maildir_file.line_key_line_value_assoc_by_useful_headers(path)
      specifier.body = transf.maildir_file.rendered_body(path)
      return specifier
    end,
    email_specifier_by_reply = function(path)
      return transf.email_specifier.email_specifier_by_reply(transf.maildir_file.email_specifier(path))
    end,
    email_specifier_by_forward = function(path)
      return transf.email_specifier.email_specifier_by_forward(transf.maildir_file.email_specifier(path))
    end,
    str_by_quoted_body = function(path)
      transf.str.str_by_all_prepended_quotechar(transf.maildir_file.rendered_body(path))
    end,
    email_or_displayname_email_by_from = function(path)
      return get.maildir_file.str_by_header(path, "from")
    end,
    email_or_displayname_email_by_to = function(path)
      return get.maildir_file.str_by_header(path, "to")
    end,
    str_by_subject = function(path)
      return get.maildir_file.str_by_header(path, "subject")
    end,
    mime_part_block = function(path)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "mshow -t" .. transf.str.str_by_single_quoted_escaped(path)
      )
    end,
    leaflike_arr_by_attachments = function(path)
      return transf.mime_part_block.leaflike_arr_by_attachments(transf.maildir_file.mime_part_block(path))
    end,
    line_by_summary = function(path)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)("mscan -f %D **%f** %200s" .. transf.str.str_by_single_quoted_escaped(path))
    end,
    maildir_file_and_line_by_summary = function(path)
      return path, transf.maildir_file.line_by_summary(path)
    end,
    maildir_file_and_decoded_email = function(path)
      return path, transf.maildir_file.decoded_email_by_useful_headers(path)
    end,

  },
  decoded_email = {
    raw_email = function(decoded_email)
      return transf.str.str_or_err_by_evaled_env_bash_stripped_noempty(
        "mmime " .. transf.str.here_doc(decoded_email)
      )
    end,
  },
  email_specifier = {
    email_specifier_by_reply = function(specifier)
      return {
        to = specifier.from,
        subject = "Re: " .. specifier.subject,
        body = "\n\n" .. transf.str.str_by_all_prepended_quotechar(specifier.body)
      }
    end,
    email_specifier_by_forward = function(specifier)
      return {
        subject = "Fwd: " .. specifier.subject,
        body = "\n\n" .. transf.str.str_by_all_prepended_quotechar(specifier.body)
      }
    end,
    decoded_email = function(specifier)
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
      local mail = get.str.str_by_evaled_as_template(mail)
      return mail
    end,

    raw_email = function(specifier)
      return transf.decoded_email.raw_email(transf.email_specifier.decoded_email(specifier))
    end
  },
  mime_part_block = {
    leaflike_arr_by_attachments = function(mime_part_block)
      local attachments = {}
      for line in transf.str.line_arr(mime_part_block) do
        local name = line:match("name=\"(.-)\"")
        if name then
          dothis.arr.push(attachments, name)
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
    ical_spec = function(path)
      local temppath = transf.str.in_tmp_local_absolute_path(transf.path.leaflike_by_filename(path) .. ".ics")
      dothis.extant_path.copy_to_absolute_path(path, temppath)
      act.ics_file.generate_json_file(temppath)
      local jsonpath = transf.file.str_by_contents(get.path.path_by_with_different_extension(temppath, "json"))
      local res = json.decode(transf.file.str_by_contents(jsonpath))
      act.absolute_path.delete(temppath)
      act.absolute_path.delete(jsonpath)
      return res
    end,
  },
  json_file = {
    not_userdata_or_fn = function(path)
      return transf.json_str.not_userdata_or_fn(transf.file.str_by_contents(path))
    end,
    table_or_nil = function(path)
      return transf.json_str.table_or_nil(transf.file.str_by_contents(path))
    end,
  },
  ini_file = {
    str_key_str_or_nested_1_value_assoc = function(path)
      return transf.ini_str.str_key_str_or_str_key_str_value_assoc_value_assoc(transf.file.str_by_contents(path))
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
        transf.path.path_by_ending_with_slash(env.MLAST_BACKUP) .. identifier
      ) or 0
    end
  },
  -- a tree_node_like is a table with a key <ckey> which at some depth contains a tree_node_like_arr, and a key <lkey> which contains a thing of any type that can be seen as the label of the node (or use self), such the tree_node_like it can be transformed to a tree_node
  tree_node_like = {

  },
  tree_node_like_arr = {

  },
  tree_node = {
    arr_arr_by_root_to_leaf_path = function(node)
      return get.tree_node.arr_arr_by_root_path(node, nil, false)
    end,
    arr_arr_by_root_path = function(node)
      return get.tree_node.arr_arr_by_root_path(node, nil, true)
    end,
  },
  tree_node_arr = {
    arr_arr_by_root_to_leaf_path = function(arr)
      return get.tree_node_arr.arr_arr_by_root_path(arr, nil, false)
    end,
    arr_arr_by_root_path = function(arr)
      return get.tree_node_arr.arr_arr_by_root_path(arr, nil, true)
    end,
  },

  snake_case_key_str_value_assoc = {
    snake_case_key_val_dep_spec_value_assoc = function(assoc)
      return get.table.table_by_mapped_w_vt_arg_vt_ret_fn(assoc, function(value)
        return {
          value = value,
          dependencies = get.any_stateful_generator.arr(
            get.str.n_str_stateful_iter_by_extracted_eutf8(value, "%$([A-Z0-9_]+)"))
        }
      end)
    end,
    snake_case_and_str__arr_arr_by_ordered_dependencies = function(assoc)
      return transf.snake_case_key_val_dep_spec_value_assoc.snake_case_and_str__arr_arr_by_ordered_dependencies(
        transf.snake_case_key_val_dep_spec_value_assoc.snake_case_key_val_dep_spec_value_assoc(assoc)
      )
    end,
    envlike_str = function(assoc)
      transf.envlike_mapping_arr.envlike_str(
        get.arr_arr.arr_by_mapped_w_n_t_arg_t_ret_fn(
          transf.snake_case_key_str_value_assoc.snake_case_and_str__arr_arr_by_ordered_dependencies(assoc),
          transf.snake_case_and_str_arr.envlike_mapping
        )
      )
    end

  },
  snake_case_and_str = {
    envlike_mapping = function(snake_case, str)
      return "export " .. snake_case .. "=" .. transf.str.str_by_double_quoted_escaped(str)
    end
  },


  snake_case_key_val_dep_spec_value_assoc = {
    snake_case_and_str__arr_arr_by_ordered_dependencies = function(assoc)local result = {}  -- Table to store the sorted keys
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
              for _, dep in transf.arr.pos_int_vt_stateless_iter(assoc[key]['dependencies']) do
                  dfs(dep)
              end
  
              temp_stack[key] = nil  -- Remove key from temporary stack
              visited[key] = true  -- Mark key as visited
              dothis.arr.push(result, { key, assoc[key]['value'] })  -- Append {key, value} two_anys__arr to result
          end
      end
  
      -- Perform DFS traversal for each key in the graph
      for key, _ in transf.table.kt_vt_stateless_iter(assoc) do
          dfs(key)
      end
  
      return result
    end
  },

  shell_script_file = {
    str_or_nil_by_gcc_style_errors = function(path)
      return get.shell_script_file.str_or_nil_by_lint_gcc(path, "errors")
    end,
    str_or_nil_by_gcc_style_warnings = function(path)
      return get.shell_script_file.str_or_nil_by_lint_gcc(path, "warnings")
    end,
  },
  local_svg_file = {
    local_absolute_path_by_png_in_cache = function(path)
      return transf.str.in_cache_local_absolute_path(
        transf.path.leaflike_by_filename(path) .. ".png",
        "svgconv"
      )
    end,
  },
  plaintext_file = {
    str_by_contents = function(path)
      return transf.file.str_by_contents(path)
    end,
    line_arr = function(path)
      return transf.str.line_arr(transf.plaintext_file.str_by_contents(path))
    end,
    noempty_line_arr = function(path)
      return transf.str.noempty_line_arr(transf.plaintext_file.str_by_contents(path))
    end,
    noempty_noindent_line_arr = function(path)
      return transf.str.noempty_noindent_line_arr(transf.plaintext_file.str_by_contents(path))
    end,
    noempty_noindent_nohashcomment_line_arr = function(path)
      return transf.str.noempty_noindent_nohashcomment_line_arr(transf.plaintext_file.str_by_contents(path))
    end,
    line_by_first = function(path)
      return transf.str.line_by_first(transf.plaintext_file.str_by_contents(path))
    end,
    line_by_last = function(path)
      return transf.str.line_by_last(transf.plaintext_file.str_by_contents(path))
    end,
    utf8_char_arr = function(path)
      return transf.str.utf8_char_arr(transf.plaintext_file.str_by_contents(path))
    end,
    str_by_no_final_newlines = function(path)
      return transf.str.str_by_no_final_newlines(transf.plaintext_file.str_by_contents(path))
    end,
    str_by_one_final_newline = function(path)
      return transf.str.str_by_one_final_newline(transf.plaintext_file.str_by_contents(path))
    end,
    pos_int_by_len_lines = function(path)
      return transf.str.pos_int_by_len_lines(transf.plaintext_file.str_by_contents(path))
    end,
    pos_int_by_len_utf8_chars = function(path)
      return transf.str.pos_int_by_len_utf8_chars(transf.plaintext_file.str_by_contents(path))
    end,
    pos_int_by_normzeilen = function(path)
      return transf.pos_int.pos_int_by_normzeilen(
        transf.plaintext_file.pos_int_by_len_utf8_chars(path)
      )
    end,
    pos_int_by_len_ascii_chars = function(path)
      return transf.str.pos_int_by_len_ascii_chars(transf.plaintext_file.str_by_contents(path))
    end,

    
  },

  plaintext_table_file = {
    utf8_char_by_field_separator = function(path)
      return tblmap.extension.utf8_char_by_likely_field_separator[transf.path.extension(path)]
    end,
    utf8_char_record_separator = function(path)
      return tblmap.extension.utf8_char_by_likely_record_separator[transf.path.extension(path)]
    end,
    str_arr_arr = function(path)
      return ftcsv.parse(path, transf.plaintext_table_file.utf8_char_by_field_separator(path), {
        headers = false
      })
    end,
    str_arr_iter = function(path)
      local iter = ftcsv.parseLine(path, transf.plaintext_table_file.utf8_char_by_field_separator(path), {
        headers = false
      })
      iter() -- skip header, seems to be a bug in ftcsv
      return iter
    end,
    str_key_str_value_assoc_arr = function(path)
      return select(1, ftcsv.parse(path, transf.plaintext_table_file.utf8_char_by_field_separator(path)))
    end,
    str_key_str_value_assoc_iter = function(path)
      return ftcsv.parseLine(path, transf.plaintext_table_file.utf8_char_by_field_separator(path))
    end,
  },
  old_media_logs_proc_dir = {
    timestamp_ms_key_media_log_spec_value_assoc = function(path)
      local files = transf.extant_path.file_arr_by_descendants(path)
      local res = {}
      for _, file in transf.arr.pos_int_vt_stateless_iter(files) do
        local str_arr_ar = transf.plaintext_table_file.str_arr_arr(file)
        local rfc3339like_ymd = transf.path.leaflike_by_filename(file)
        dothis.arr.each(str_arr_ar, function(str_arr)
          local ts = transf.full_rfc3339like_dt.timestamp_ms(
            rfc3339like_ymd .. "T" .. str_arr[1]
          )
          res[ts] = {
            title = str_arr[2],
            url = str_arr[3],
            timestamp_ms = ts
          }
        end)
      end
      return res
    end,
  },
  git_tmp_log_dir = {
    timestamp_ms_key_assoc_value_assoc = function(path)
      local files = transf.dir.file_arr_by_children(path)
      local res = {}
      for _, file in transf.arr.pos_int_vt_stateless_iter(files) do
        local unproc_arr = transf.json_file.table_or_nil(file)
        if unproc_arr then
          local assoc = unproc_arr[1] -- uselessly wrapped in an array
          local ts = assoc.epoch_utc * 1000
          assoc.epoch_utc = nil
          assoc.timestamp_ms = ts
          res[ts] = assoc
        end
      end
      return res
    end,
  },
  mpv_tmp_log_dir = {
    timestamp_ms_key_media_log_spec_value_assoc = function(path)
      local files = transf.dir.file_arr_by_children(path)
      local res = {}
      for _, file in transf.arr.pos_int_vt_stateless_iter(files) do
        local lines = transf.plaintext_file.line_arr(file)
        local ts = transf.nonindicated_number_str.number_by_base_10(
          lines[1]
        )
        res[ts] = {
          timestamp_s = ts,
          title = lines[2],
          url = lines[3],
          length = transf.nonindicated_number_str.number_by_base_10(
            lines[4]
          ),
          stop = transf.nonindicated_number_str.number_by_base_10(
            lines[5]
          ),
          start = transf.nonindicated_number_str.number_by_base_10(
            lines[6]
          ),
        }
      end
      return res
    end,
  },
  logging_dir = {
   
  },
  old_location_logs_proc_dir = {
    old_location_log_spec_arr = function(path)
      return transf.plaintext_assoc_file_arr.not_userdata_or_fn_arr(
        transf.dir.absolute_path_arr_by_grandchildren(path)
      )
    end,
    timestamp_ms_key_location_log_spec_value_assoc = function(path)
      return transf.old_location_log_spec_arr.timestamp_ms_key_location_log_spec_value_assoc(
        transf.old_location_logs_proc_dir.old_location_log_spec_arr(path)
      )
    end,
  },
  old_location_log_spec_arr = {
    timestamp_ms_key_location_log_spec_value_assoc = function(arr)
      local res = {}
      for _, spec in ipairs(arr) do
        res[
          transf.full_rfc3339like_dt.timestamp_ms(
            spec.dt
          )
        ] = spec
      end
      return res
    end,
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
        major = transf.nonindicated_number_str.number_by_base_10(major),
        minor = transf.nonindicated_number_str.number_by_base_10(minor),
        patch = transf.nonindicated_number_str.number_by_base_10(patch),
        prerelease = prerelease,
        build = build
      }
    end,
  },
  package_name_semver_compound_str = {
    package_name_and_semver_str__arr = function(str)
      return get.str.str_arr_by_split_noedge_w_str(str, "@")
    end,
    package_name = function(str)
      return transf.package_name_semver_compound_str.package_name_and_semver_str__arr(str)[1]
    end,
    semver_str = function(str)
      return transf.package_name_semver_compound_str.package_name_and_semver_str__arr(str)[2]
    end,
  },
  package_name_semver_package_manager_name_compound_str = {
    package_name_semver_compound_str = function(str)
      return get.str.str_arr_by_split_noedge_w_str(str, ":")[1]
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
      return get.str.str_arr_by_split_noedge_w_str(str, ":")[2]
    end,
  },
  package_name_package_manager_name_compound_str = {
    package_name = function(str)
      return get.str.str_arr_by_split_noedge_w_str(str, ":")[1]
    end,
    package_manager_name = function(str)
      return get.str.str_arr_by_split_noedge_w_str(str, ":")[2]
    end,
  },
  dice_notation = {
    nonindicated_dec_number_str_by_result = function(dice_notation)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("roll" .. transf.str.str_by_single_quoted_escaped(dice_notation))
    end,
    int_by_result = function(dice_notation)
      return transf.nonindicated_number_str.number_by_base_10(
        transf.dice_notation.nonindicated_dec_number_str_by_result(dice_notation)
      )
    end,
  },
  timestamp_s = {
    timestamp_ms = function(timestamp)
      return timestamp * 1000
    end,
    full_dcmp_spec = function(timestamp)
      return os.date("*t", timestamp)
    end,
    weekday_int_start_1 = function(timestamp)
      return os.date("*t", timestamp).wday
    end,
    weekday_int_start_0 = function(timestamp)
      return get.two_numbers.number_by_sum_modulo_n(
        transf.timestamp_s.weekday_int_start_1(timestamp),
        6,
        7
      )
    end,
    rfc3339like_y_and_rfc3339like_ym_and_rfc3339like_ymd__arr = function(timestamp)
      return  {
        get.timestamp_s.rfc3339like_dt_by_precison_w_dcmp_name(timestamp, "year"),
        get.timestamp_s.rfc3339like_dt_by_precison_w_dcmp_name(timestamp, "month"),
        get.timestamp_s.rfc3339like_dt_by_precison_w_dcmp_name(timestamp, "day")
      }
    end,
    triplex_local_nonabsolute_path_by_y_ym_ymd = function(date)
      return get.str_or_number_arr.str_by_joined(transf.timestamp_s.rfc3339like_y_and_rfc3339like_ym_and_rfc3339like_ymd__arr(date), "/")
    end,
    timestamp_s_sequence_specifier_by_quarter_hours = function(timestamp_s)
      return get.timestamp_s.timestamp_s_sequence_specifier_of_lower_component(timestamp_s, 15, "hour")
    end,
    timestamp_s_sequence_specifier_by_quarter_hours_of_day = function(timestamp_s)
      return get.timestamp_s.timestamp_s_sequence_specifier_of_lower_component(timestamp_s, 15, "day")
    end,
    full_rfc3339like_dt = function(timestamp_s)
      return get.timestamp_s.rfc3339like_dt_by_precison_w_dcmp_name(timestamp_s, "sec")
    end,
    rfc3339like_ymd = function(timestamp_s)
      return get.timestamp_s.rfc3339like_dt_by_precison_w_dcmp_name(timestamp_s, "day")
    end,
    hour_minute_second = function(timestamp_s)
      return get.timestamp_s.str_by_formatted(timestamp_s, "%H:%M:%S")
    end,
    urlcharset_str_by_email_dt = function(timestamp_s)
      return get.timestamp_s.str_by_formatted(timestamp_s, "%a, %d %b %Y %H:%M:%S %z")
    end,
    period_alphanum_minus_underscore_by_german_date = function(timestamp_s)
      return get.timestamp_s.str_by_formatted(timestamp_s, "%d.%m.%Y")
    end,
    colon_period_alphanum_minus_underscore_by_german_dt = function(timestamp_s)
      return get.timestamp_s.str_by_formatted(timestamp_s, "%d.%m.%Y %H:%M:%S")
    end,
    urlcharset_str_by_american_date = function(timestamp_s)
      return get.timestamp_s.str_by_formatted(timestamp_s, "%m/%d/%Y")
    end,
    urlcharset_str_by_american_dt = function(timestamp_s)
      return get.timestamp_s.str_by_formatted(timestamp_s, "%m/%d/%Y %I:%M:%S %p")
    end,
    urlcharset_str_by_american_time = function(timestamp_s)
      return get.timestamp_s.str_by_formatted(timestamp_s, "%I:%M:%S %p")
    end,
    urlcharset_str_by_detailed_summary = function(timestamp_s)
      return get.timestamp_s.str_by_formatted(timestamp_s, "%A, %Y-%m-%d %H:%M:%S")
    end
  },
  timestamp_ms = {
    timestamp_s = function(timestamp)
      return timestamp / 1000
    end,
    full_dcmp_spec = function(timestamp)
      return transf.timestamp_s.full_dcmp_spec(transf.timestamp_ms.timestamp_s(timestamp))
    end
  },
  dcmp_name = {
    prefix_dcmp_name_seq_by_larger_or_same = function(dcmp_name)
      return get.arr.arr_by_slice_w_3_int_any_or_nils(ls.dcmp_names, 1, dcmp_name)
    end,
    suffix_dcmp_name_seq_by_same_or_smaller = function(dcmp_name)
      return get.arr.arr_by_slice_w_3_int_any_or_nils(ls.dcmp_names, dcmp_name)
    end,
    date_component_index = function(dcmp_name)
      return tblmap.dcmp_name.date_component_index[dcmp_name]
    end,
    timestamp_s = function(dcmp_name)
      return tblmap.dcmp_name.timestamp_s[dcmp_name]
    end,
    timestamp_ms = function(dcmp_name)
      return tblmap.dcmp_name.timestamp_ms[dcmp_name]
    end,
    dcmp_name_by_next = function(dcmp_name)
      return get.dcmp_name.dcmp_name_by_next(dcmp_name, 1)
    end,
    dcmp_name_by_previous = function(dcmp_name)
      return get.dcmp_name.dcmp_name_by_previous(dcmp_name, 1)
    end,
    
  },
  dcmp_name_arr = {
    dcmp_spec_by_min = function(arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        arr,
        function(component)
          return component, tblmap.dcmp_name.int_by_min_dcmp_val[component]
        end
      )
    end,
    dcmp_spec_by_max = function(arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        arr,
        function(component)
          return component, tblmap.dcmp_name.pos_int_by_max_dcmp_val[component]
        end
      )
    end,
    dcmp_name_seq = function(arr)
      return get.arr.arr_by_sorted(arr, transf.two_dcmp_names.bool_by_first_larger)
    end,
    dcmp_name_by_largest = function(arr)
      return transf.dcmp_name_arr.dcmp_name_seq(
        arr
      )[1]
    end,
    dcmp_name_by_smallest = function(arr)
      return transf.dcmp_name_arr.dcmp_name_seq(
        arr
      )[#arr]
    end,
    dcmp_name_arr_by_inverse = function(arr)
      return transf.two_arrs.set_by_difference(ls.dcmp_names, arr)
    end,
    rfc3339like_dt_separator_arr  = function(arr)
      return get.arr.arr_by_mapped_w_t_key_assoc(
        arr,
        tblmap.dcmp_name.rfc3339like_dt_separator
      )
    end,
    rfc3339like_dt_str_format_part_arr = function(arr)
      return get.arr.arr_by_mapped_w_t_key_assoc(
        arr,
        tblmap.dcmp_name.rfc3339like_dt_str_format_part
      )
    end,
  },
  dcmp_name_seq = {
    dcmp_name_by_largest = function(list)
      return list[1]
    end,
    dcmp_name_by_smallest = function(list)
      return list[#list]
    end,
  },
  rfc3339like_dt = {
    dcmp_spec = function(str)
      local comps = {get.str.n_strs_by_extracted_onig(str, r.g.rfc3339like_dt)}
      return get.table.table_by_mapped_w_kt_vt_arg_kt_vt_ret_fn(ls.dcmp_names, function(k, v)
        return v and get.str_or_number.number_or_nil(comps[k]) or nil
      end)
    end,
    timestamp_s_interval_specifier = function(str)
      return transf.dcmp_spec.timestamp_s_interval_specifier(transf.rfc3339like_dt.dcmp_spec(str))
    end,
    full_dcmp_spec_by_min = function(str)
      return transf.dcmp_spec.full_dcmp_spec_by_min(
        transf.rfc3339like_dt.dcmp_spec(str)
      )
    end,
    full_dcmp_spec_by_max = function(str)
      return transf.dcmp_spec.full_dcmp_spec_by_max(
        transf.rfc3339like_dt.dcmp_spec(str)
      )
    end,
    timestamp_s_by_min = function(str)
      return transf.full_dcmp_spec.timestamp_s(
        transf.rfc3339like_dt.full_dcmp_spec_by_min(str)
      )
    end,
    timestamp_s_by_max = function(str)
      return transf.full_dcmp_spec.timestamp_s(
        transf.rfc3339like_dt.full_dcmp_spec_by_max(str)
      )
    end,
    

  },
  full_rfc3339like_dt = {
    timestamp_s = function(str)
      return transf.full_dcmp_spec.timestamp_s(
        transf.rfc3339like_dt.dcmp_spec(str)
      )
    end,
    timestamp_ms = function(str)
      return transf.full_dcmp_spec.timestamp_ms(
        transf.rfc3339like_dt.dcmp_spec(str)
      )
    end,
  },
  rfc3339like_interval = {
    rfc3339like_dt_by_start = function(str)
      return get.str.str_arr_by_split_w_str(str, "_to_")[1]
    end,
    dcmp_spec_by_start = function(str)
      return transf.rfc3339like_dt.dcmp_spec(
        transf.rfc3339like_interval.rfc3339like_dt_by_start(str)
      )
    end,
    full_dcmp_spec_by_start_min = function(str)
      return transf.dcmp_spec.full_dcmp_spec_by_min(
        transf.rfc3339like_interval.dcmp_spec_by_start(str)
      )
    end,
    timestamp_s_by_start_min = function(str)
      return transf.full_dcmp_spec.timestamp_s(
        transf.rfc3339like_interval.full_dcmp_spec_by_start_min(str)
      )
    end,
    rfc3339like_dt_by_end = function(str)
      return get.str.str_arr_by_split_w_str(str, "_to_")[2]
    end,
    dcmp_spec_by_end = function(str)
      return transf.rfc3339like_dt.dcmp_spec(
        transf.rfc3339like_interval.rfc3339like_dt_by_end(str)
      )
    end,
    full_dcmp_spec_by_end_max = function(str)
      return transf.dcmp_spec.full_dcmp_spec_by_max(
        transf.rfc3339like_interval.dcmp_spec_by_end(str)
      )
    end,
    full_dcmp_spec_by_end_min = function(str)
      return transf.dcmp_spec.full_dcmp_spec_by_min(
        transf.rfc3339like_interval.dcmp_spec_by_end(str)
      )
    end,
    timestamp_s_by_end_max = function(str)
      return transf.full_dcmp_spec.timestamp_s(
        transf.rfc3339like_interval.full_dcmp_spec_by_end_max(str)
      )
    end,
    timestamp_s_by_end_min = function(str)
      return transf.full_dcmp_spec.timestamp_s(
        transf.rfc3339like_interval.full_dcmp_spec_by_end_min(str)
      )
    end,
    dcmp_name_by_smallest_start_set = function(str)
      return transf.dcmp_spec.dcmp_name_by_smallest_set(
        transf.rfc3339like_interval.dcmp_spec_by_start(str)
      )
    end,
    dcmp_name_by_smallest_end_set = function(str)
      return transf.dcmp_spec.dcmp_name_by_smallest_set(
        transf.rfc3339like_interval.dcmp_spec_by_end(str)
      )
    end,
    dcmp_name_by_smallest_both_set = function(str)
      return transf.two_dcmp_names.dcmp_name_by_larger(
        transf.rfc3339like_interval.dcmp_name_by_smallest_start_set(str),
        transf.rfc3339like_interval.dcmp_name_by_smallest_end_set(str)
      )
    end,
    timestamp_s_interval_specifier = function(str)
      return {
        start = transf.rfc3339like_interval.timestamp_s_by_start_min(str),
        stop = transf.rfc3339like_interval.timestamp_s_by_end_max(str),
      }
    end,
    number_sequence_specifier = function(str)
      return {
        start = transf.rfc3339like_interval.timestamp_s_by_start_min(str),
        stop = transf.rfc3339like_interval.timestamp_s_by_end_max(str),
        step = transf.dcmp_name.timestamp_s(
          transf.rfc3339like_interval.dcmp_name_by_smallest_both_set(str)
        ),
      }
    end,
    timestamp_s_by_min = function(str)
      return transf.rfc3339like_interval.timestamp_s_by_start_min(str)
    end,
    timestamp_s_by_max = function(str)
      return transf.rfc3339like_interval.timestamp_s_by_end_max(str)
    end,
  },
  rfc3339like_dt_or_interval = {
    dt_or_interval = function(str)
      if get.str.bool_by_contains_w_str(str, "_to_") then
        return "rfc3339like_interval"
      else
        return "rfc3339like_dt"
      end
    end,
    timestamp_s_by_max = function(str)
      return transf[
        transf.rfc3339like_dt_or_interval.dt_or_interval(str)
      ].timestamp_s_by_max(str)
    end,
    timestamp_s_by_min = function(str)
      return transf[
        transf.rfc3339like_dt_or_interval.dt_or_interval(str)
      ].timestamp_s_by_min(str)
    end,
    timestamp_s_interval_specifier = function(str)
      return transf[
        transf.rfc3339like_dt_or_interval.dt_or_interval(str)
      ].timestamp_s_interval_specifier_or_nil(str)
    end,
  },
  rfc3339like_dt_or_interval_arr = {
    timestamp_s_interval_specifier_arr = function(rfc3339like_dt_or_interval_arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(rfc3339like_dt_or_interval_arr, transf.rfc3339like_dt_or_interval.timestamp_s_interval_specifier)
    end,
  },
  digit_interval_str = {
    two_digit_strs = function(str)
      return get.str.str_arr_by_split_w_ascii_char(str, "-")
    end,
    two_pos_ints = function(str)
      local s1, s2 = transf.digit_interval_str.two_digit_strs(str)
      return {
        transf.nonindicated_number_str.number_by_base_10(s1),
        transf.nonindicated_number_str.number_by_base_10(s2), 
      }
    end,
    int_interval_specifier = function(str)
      local start, stop = transf.digit_interval_str.two_pos_ints(str)
      return {
        start = start,
        stop = stop,
      }
    end,
  },
  digit_str_or_digit_interval_str = {
    int_interval_specifier = function(str)
      if get.str.bool_by_contains_w_str(str, "-") then
        return transf.digit_interval_str.int_interval_specifier(str)
      else
        local int = transf.nonindicated_number_str.number_by_base_10(str)
        return {
          start = int,
          stop = int,
        }
      end
    end,
  },
  --- interval specifier: table of start, stop
  --- both inclusive
  interval_specifier = {
    t_by_diff = function(interval)
      return interval.stop - interval.start
    end,
  },
  int_interval_specifier = {
    int_by_random = function(interval)
      return math.random(interval.start, interval.stop)
    end,
  },
  number_interval_specifier = {
    number_by_random = function(interval)
      return math.random() * (interval.stop - interval.start) + interval.start
    end,
  },
  --- sequence specifier: table of start, stop, step
  --- sequence specifiers can use all methods of interval specifiers 
  sequence_specifier = {
    arr = function(sequence)
      return transf.three_operational_addcompable_or_nils.operational_addcompable_arr(sequence.start, sequence.stop, sequence.step)
    end,
    interval_specifier = function(sequence)
      return {
        start = sequence.start,
        stop = sequence.stop,
      }
    end,
  },
  interval_specifier_arr = {
    interval_specifier_by_earliest_start = function(interval_specifier_arr)
      return hs.fnutils.reduce(
        interval_specifier_arr,
        get.fn.fn_by_arbitrary_args_bound_or_ignored(get.table_and_table.table_by_smaller_key, {a_use, a_use, "start"})
      )
    end,
    t_by_earliest_start = function(interval_specifier_arr)
      return transf.interval_specifier_arr.interval_specifier_by_earliest_start(
          interval_specifier_arr
        ).start
    end,
    interval_specifier_by_latest_start = function(interval_specifier_arr)
      return hs.fnutils.reduce(
        interval_specifier_arr,
        get.fn.fn_by_arbitrary_args_bound_or_ignored(get.table_and_table.table_by_larger_key, {a_use, a_use, "start"})
      )
    end,
    t_by_latest_start = function(interval_specifier_arr)
      return transf.interval_specifier_arr.interval_specifier_by_latest_start(
          interval_specifier_arr
        ).start
    end,
    interval_specifier_by_latest_stop = function(interval_specifier_arr)
      return hs.fnutils.reduce(
        interval_specifier_arr,
        get.fn.fn_by_arbitrary_args_bound_or_ignored(get.table_and_table.table_by_larger_key, {a_use, a_use, "stop"})
      )
    end,
    t_by_latest_stop = function(interval_specifier_arr)
      return transf.interval_specifier_arr.interval_specifier_by_latest_stop(
          interval_specifier_arr
        ).stop
    end,
    interval_specifier_by_earliest_stop = function(interval_specifier_arr)
      return hs.fnutils.reduce(
        interval_specifier_arr,
        get.fn.fn_by_arbitrary_args_bound_or_ignored(get.table_and_table.table_by_smaller_key, {a_use, a_use, "stop"})
      )
    end,
    t_by_earliest_stop = function(interval_specifier_arr)
      return transf.interval_specifier_arr.interval_specifier_by_earliest_stop(
          interval_specifier_arr
        ).stop
    end,
    interval_specifier_by_intersection = function(interval_specifier_arr)
      return {
        start = transf.interval_specifier_arr.t_by_latest_start(interval_specifier_arr),
        stop = transf.interval_specifier_arr.t_by_earliest_stop(interval_specifier_arr),
      }
    end,
    interval_specifier_by_union = function(interval_specifier_arr)
      return {
        start = transf.interval_specifier_arr.t_by_earliest_start(interval_specifier_arr),
        stop = transf.interval_specifier_arr.t_by_latest_stop(interval_specifier_arr),
      }
    end,
  },
  timestamp_s_interval_specifier = {
    full_rfc3339like_dt_by_start = function(ivspec)
      return transf.timestamp_s.full_rfc3339like_dt(ivspec.start)
    end,
    full_rfc3339like_dt_by_end = function(ivspec)
      return transf.timestamp_s.full_rfc3339like_dt(ivspec.stop)
    end,
    full_dcmp_spec_by_start = function(ivspec)
      return transf.timestamp_s.full_dcmp_spec(ivspec.start)
    end,
    full_dcmp_spec_by_end = function(ivspec)
      return transf.timestamp_s.full_dcmp_spec(ivspec.stop)
    end,
    prefix_dcmp_spec_by_start_filtered_not_min = function(ivspec)
      return transf.dcmp_spec.prefix_dcmp_spec_by_filtered_not_min_or_not_prefix(
        transf.timestamp_s_interval_specifier.full_dcmp_spec_by_start(ivspec)
      )
    end,
    prefix_dcmp_spec_by_end_filtered_not_max = function(ivspec)
      return transf.dcmp_spec.prefix_dcmp_spec_by_filtered_not_max_or_not_prefix(
        transf.timestamp_s_interval_specifier.full_dcmp_spec_by_end(ivspec)
      )
    end,
    rfc3339like_dt_by_start_filtered_not_max_or_not_prefix = function(ivspec)
      return transf.prefix_dcmp_spec.rfc3339like_dt(
        transf.timestamp_s_interval_specifier.prefix_dcmp_spec_by_start_filtered_not_min(ivspec)
      )
    end,
    rfc3339like_dt_by_end_filtered_not_max_or_not_prefix = function(ivspec)
      return transf.prefix_dcmp_spec.rfc3339like_dt(
        transf.timestamp_s_interval_specifier.prefix_dcmp_spec_by_end_filtered_not_max(ivspec)
      )
    end,
    rfc3339like_dt = function(ivspec)
      local start_rfc3339like_dt = transf.timestamp_s_interval_specifier.rfc3339like_dt_by_start_filtered_not_max_or_not_prefix(ivspec)
      local end_rfc3339like_dt = transf.timestamp_s_interval_specifier.rfc3339like_dt_by_end_filtered_not_max_or_not_prefix(ivspec)
      if start_rfc3339like_dt == end_rfc3339like_dt then
        return start_rfc3339like_dt
      end
    end,
    rfc3339like_interval_where_dcmp_val_is_not_max_dcmp_val = function(ivspec)
      local start_rfc3339like_dt = transf.timestamp_s_interval_specifier.rfc3339like_dt_by_start_filtered_not_max_or_not_prefix(ivspec)
      local end_rfc3339like_dt = transf.timestamp_s_interval_specifier.rfc3339like_dt_by_end_filtered_not_max_or_not_prefix(ivspec)
      return start_rfc3339like_dt .. "_to_" .. end_rfc3339like_dt
    end,
    rfc3339like_dt_or_interval = function(ivspec)
      local rfc3339like_dt = transf.timestamp_s_interval_specifier.rfc3339like_dt(ivspec)
      return rfc3339like_dt or transf.timestamp_s_interval_specifier.rfc3339like_interval_where_dcmp_val_is_not_max_dcmp_val(ivspec)
    end,
  },
  dcmp_spec = {
    dcmp_name_arr_by_set = function(dcmp_spec)
      return transf.table_or_nil.kt_arr(dcmp_spec)
    end,
    dcmp_name_arr_by_not_set = function(dcmp_spec)
      return transf.dcmp_name_arr.dcmp_name_arr_by_inverse(transf.dcmp_spec.dcmp_name_arr_by_set(dcmp_spec))
    end,
    dcmp_name_seq_by_set = function(dcmp_spec)
      return transf.dcmp_name_arr.dcmp_name_seq(transf.dcmp_spec.dcmp_name_arr_by_set(dcmp_spec))
    end,
    dcmp_name_seq_by_not_set = function(dcmp_spec)
      return transf.dcmp_name_arr.dcmp_name_seq(transf.dcmp_spec.dcmp_name_arr_by_not_set(dcmp_spec))
    end,
    dcmp_name_by_largest_set = function(dcmp_spec)
      return transf.dcmp_name_arr.dcmp_name_by_largest(transf.dcmp_spec.dcmp_name_arr_by_set(dcmp_spec))
    end,
    dcmp_name_by_smallest_set = function(dcmp_spec)
      return transf.dcmp_name_arr.dcmp_name_by_smallest(transf.dcmp_spec.dcmp_name_arr_by_set(dcmp_spec))
    end,
    dcmp_name_by_largest_not_set = function(dcmp_spec)
      return transf.dcmp_name_arr.dcmp_name_by_largest(transf.dcmp_spec.dcmp_name_arr_by_not_set(dcmp_spec))
    end,
    dcmp_name_by_smallest_not_set = function(dcmp_spec)
      return transf.dcmp_name_arr.dcmp_name_by_smallest(transf.dcmp_spec.dcmp_name_arr_by_not_set(dcmp_spec))
    end,
    dcmp_spec_by_not_set_min = function(dcmp_spec)
      return transf.dcmp_name_arr.dcmp_spec_by_min(transf.dcmp_spec.dcmp_name_arr_by_not_set(dcmp_spec))
    end,
    dcmp_spec_by_not_set_max = function(dcmp_spec)
      return transf.dcmp_name_arr.dcmp_spec_by_max(transf.dcmp_spec.dcmp_name_arr_by_not_set(dcmp_spec))
    end,
    full_dcmp_spec_by_min = function(dcmp_spec)
      return transf.two_tables.table_by_take_old(
        dcmp_spec,
        transf.dcmp_spec.dcmp_spec_by_not_set_min(dcmp_spec)
      )
    end,
    full_dcmp_spec_by_max = function(dcmp_spec)
      return transf.two_tables.table_by_take_old(
        dcmp_spec,
        transf.dcmp_spec.dcmp_spec_by_not_set_max(dcmp_spec)
      )
    end,
    timestamp_s_by_full_min = function(dcmp_spec)
      return transf.full_dcmp_spec.timestamp_s(
        transf.dcmp_spec.full_dcmp_spec_by_min(dcmp_spec)
      )
    end,
    timestamp_s_by_full_max = function(dcmp_spec)
      return transf.full_dcmp_spec.timestamp_s(
        transf.dcmp_spec.full_dcmp_spec_by_max(dcmp_spec)
      )
    end,
    timestamp_s_interval_specifier = function(dcmp_spec)
      return {
        start = transf.dcmp_spec.timestamp_s_by_full_min(dcmp_spec),
        stop = transf.dcmp_spec.timestamp_s_by_full_max(dcmp_spec),
      }
    end, 
    prefix_dcmp_spec_by_filter = function(dcmp_spec)
      local res = {}
      for _, dcmp_name in transf.arr.pos_int_vt_stateless_iter(ls.dcmp_names) do
        if dcmp_spec[dcmp_name] == nil then
          return res
        end
        res[dcmp_name] = dcmp_spec[dcmp_name]
      end
      return res
    end,
    prefix_dcmp_name_seq_by_set = function(dcmp_spec)
      return transf.dcmp_name_arr.dcmp_name_seq_set(
        transf.dcmp_spec.prefix_dcmp_spec_by_filter(dcmp_spec)
      )
    end,
    --- gets a dcmp_name_seq which has all dcmp_names where there is a dcmp_name within the dcmp_spec that is smaller or equal that is not nil
    --- i.e. { month = 02, hour = 12 } will return { "year", "month", "day", "hour" }
    --- this should be equal to prefix_dcmp_name_spec_by_set if dcmp_spec is a prefix_dcmp_spec since prefix_ is defined as having no nil values before potential trailing nil values
    dcmp_name_seq_by_no_trailing_nil = function(dcmp_spec)
      local ol = get.table.table_by_copy(ls.dcmp_names)
      while(dcmp_spec[
        ol[#ol]
      ] == nil) do
        ol[#ol] = nil
      end
      return ol
    end,
    str_format_part_specifier_arr_by_for_rfc3339like_dt = function(dcmp_spec)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        transf.dcmp_spec.dcmp_name_seq_by_no_trailing_nil(dcmp_spec),
        function(dcmp_name)
          return {
            fallback = tblmap.dcmp_name.rfc3339like_dt_str_format_part_fallback[dcmp_name],
            value = dcmp_spec[dcmp_name],
            str_format_part = tblmap.dcmp_name.rfc3339like_dt_str_format_part[dcmp_name]
          }
        end
      )
    end,
    printable_ascii_not_whitespace_str_by_rfc3339like_dt_but_potentially_with_qmarks = function(dcmp_spec)
      local res = transf.str_format_part_specifier_arr.str(
        transf.dcmp_spec.str_format_part_specifier_arr_by_for_rfc3339like_dt(dcmp_spec)
      )
      if res:sub(-1) == "Z" then
        return res
      else
        return res:sub(1, -2) -- not full rfc3339like_dt, thus the trailing sep will be something like - or : and must be removed
      end
    end,
    dcmp_spec_by_filtered_max = function(dcmp_spec)
      return get.table.table_by_filtered_w_kt_vt_fn(
        dcmp_spec,
        function(k, v) return v == tblmap.dcmp_name.pos_int_by_max_dcmp_val[k] end
      )
    end,
    dcmp_spec_by_filtered_min = function(dcmp_spec)
      return get.table.table_by_filtered_w_kt_vt_fn(
        dcmp_spec,
        function(k, v) return v == tblmap.dcmp_name.int_by_min_dcmp_val[k] end
      )
    end,
    dcmp_spec_by_filtered_not_max = function(dcmp_spec)
      return get.table.table_by_filtered_w_kt_vt_fn(
        dcmp_spec,
        function(k, v) return v ~= tblmap.dcmp_name.pos_int_by_max_dcmp_val[k] end
      )
    end,
    dcmp_spec_by_filtered_not_min = function(dcmp_spec)
      return get.table.table_by_filtered_w_kt_vt_fn(
        dcmp_spec,
        function(k, v) return v ~= tblmap.dcmp_name.int_by_min_dcmp_val[k] end
      )
    end,
    prefix_dcmp_spec_by_filtered_not_max_or_not_prefix = function(dcmp_spec)
      local dcmp_spec_not_max = transf.dcmp_spec.dcmp_spec_by_filtered_not_max(dcmp_spec)
      return transf.dcmp_spec.prefix_dcmp_spec_by_filter(dcmp_spec_not_max)
    end,
    prefix_dcmp_spec_by_filtered_not_min_or_not_prefix = function(dcmp_spec)
      local dcmp_spec_not_max = transf.dcmp_spec.dcmp_spec_by_filtered_not_min(dcmp_spec)
      return transf.dcmp_spec.prefix_dcmp_spec_by_filter(dcmp_spec_not_max)
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
        get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
          str_format_part_specifier_arr,
          transf.str_format_part_specifier.str
        ),
        ""
      )
    end
  },
  prefix_dcmp_spec = {
    
    rfc3339like_dt = function(prefix_dcmp_spec)
      return transf.dcmp_spec.printable_ascii_not_whitespace_str_by_rfc3339like_dt_but_potentially_with_qmarks(prefix_dcmp_spec)
    end,
  },
  suffix_dcmp_spec = {

  },
  partial_dcmp_spec = {

  },
  -- date components are full if all components are set
  full_dcmp_spec = {
    timestamp_s = function(full_dcmp_spec)
      return os.time(full_dcmp_spec)
    end,
    timestamp_ms = function(full_dcmp_spec)
      return transf.full_dcmp_spec.timestamp_s(full_dcmp_spec) * 1000
    end,
    full_rfc3339like_dt = function(full_dcmp_spec)
      return transf.timestamp_s.full_rfc3339like_dt(
        transf.full_dcmp_spec.timestamp_s(full_dcmp_spec)
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
    str_by_bank_name = function(iban)
      return transf.cleaned_iban.str_by_bank_name(transf.iban.cleaned_iban(iban))
    end,
    three_str__arr_by_iban_bic_bank_name = function(iban)
      return {iban, transf.iban.bic(iban), transf.iban.str_by_bank_name(iban)}
    end,
    multiline_str_by_bank_details = function(iban)
      return get.str_or_number_arr.str_by_joined(
        transf.iban.three_str__arr_by_iban_bic_bank_name(iban),
        "\n"
      )
    end,
    iban_by_separated = function(iban)
      return transf.cleaned_iban.iban_by_separated(transf.iban.cleaned_iban(iban))
    end,
  },
  cleaned_iban = {
    iban_data_spec = function(iban)
      local res = get.fn.rt_or_nil_by_memoized_invalidate_1_month(rest, "rest")({
        host = "openiban.com/",
        endpoint = "validate/" .. iban,
        params = { getBIC = "true" },
      })
      local data = res.bankData
      data.valid = res.valid
      return data
    end,
    bic = function(iban)
      return transf.cleaned_iban.iban_data_spec(iban).bic
    end,
    str_by_bank_name = function(iban)
      return transf.cleaned_iban.iban_data_spec(iban).bankName
    end,
    iban_by_separated = function(iban)
      return get.str_or_number_arr.str_by_joined(
        get.str.str_arr_by_grouped_utf8_from_end(
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
      local contact_table = transf.yaml_str.not_userdata_or_fn(raw_contact)

      -- In the vCard standard, some properties can have vcard_types. 
      -- For example, a phone number can be 'work' or 'home'. 
      -- Here, we're iterating over the keys in the contact data that have associated vcard_types.
      for _, vcard_key in transf.arr.pos_int_vt_stateless_iter(ls.vcard.keys_with_vcard_type) do
      
          -- We iterate over each of these keys. Each key can have multiple vcard_types, 
          -- which we get as a comma-separated str (type_list). 
          -- We also get the corresponding value for these vcard_types.
          for type_list, value in transf.arr.pos_int_vt_stateless_iter(contact_table[vcard_key]) do
          
              -- We split the type_list into individual vcard_types. This is done because 
              -- each vcard_type might need to be processed independently in the future. 
              -- It also makes the data more structured and easier to handle.
              local vcard_types = get.str.str_arr_by_split_w_str(type_list, ", ")
        
              -- For each vcard_type, we create a new key-value two_anys__arr in the contact_table. 
              -- This way, we can access the value directly by vcard_type, 
              -- without needing to parse the type_list each time.
              for _, vcard_type in transf.arr.pos_int_vt_stateless_iter(vcard_types) do
                  contact_table[vcard_key][vcard_type] = value
              end
          end
      end

      -- Here, we're handling the 'Addresses' key separately. Each address is a table itself,
      -- and we're adding a 'contact' field to each of these tables. 
      -- This 'contact' field holds the complete contact information.
      -- This could be useful in scenarios where address tables are processed individually,
      -- and there's a need to reference back to the full contact details.
      for _, address_table in transf.arr.pos_int_vt_stateless_iter(contact_table["Addresses"]) do
          address_table.contact = contact_table
      end
      
      -- Finally, we return the contact_table, which now has a more structured and accessible format.
      return contact_table
    end

  },
  uuid = {
    raw_contact_or_nil = function(uuid)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)( "khard show --format=yaml uid:" .. uuid)
    end,
    contact_table_or_nil = function(uuid)
      local raw_contact = transf.uuid.raw_contact_or_nil(uuid)
      if raw_contact then
        local contact_table = transf.raw_contact.contact_table(raw_contact)
        contact_table.uid = uuid
        return contact_table
      end
    end,
  },
  contact_table = {
    contact_uuid = function (contact_table)
      return contact_table.uid
    end,
    line_or_nil_by_pref_name = function(contact_table) return transf.str_or_nil.line_by_folded(contact_table["Formatted name"]) end,
    line_or_nil_by_name_pre = function(contact_table) return transf.str_or_nil.line_by_folded(contact_table["Prefix"]) end,
    line_or_nil_by_first_name = function(contact_table) return transf.str_or_nil.line_by_folded(contact_table["First name"]) end,
    line_or_nil_by_middle_name = function(contact_table) return transf.str_or_nil.line_by_folded(contact_table["Additional"]) end,
    line_or_nil_by_last_name = function(contact_table) return transf.str_or_nil.line_by_folded(contact_table["Last name"]) end,
    line_or_nil_by_name_suf = function(contact_table) return transf.str_or_nil.line_by_folded(contact_table["Suffix"]) end,
    line_or_nil_by_nickname = function(contact_table) return transf.str_or_nil.line_by_folded(contact_table["Nickname"]) end,
    rfc3339like_dt_or_nil_by_anniversary = function(contact_table) return contact_table["Anniversary"] end,
    rfc3339like_dt_or_nil_by_birthday = function(contact_table) return contact_table["Birthday"] end,
    line_or_nil_by_organization = function(contact_table) return transf.str_or_nil.line_by_folded(contact_table["Organization"]) end,
    line_or_nil_by_title = function(contact_table) return transf.str_or_nil.line_by_folded(contact_table["Title"]) end,
    line_or_nil_by_role = function(contact_table) return transf.str_or_nil.line_by_folded(contact_table["Role"]) end,
    line_or_nil_by_homepage_raw = function(contact_table) return transf.str_or_nil.line_by_folded(contact_table["Webpage"]) end,
    url_arr_by_homepages = function(contact_table) 
      if is.any.table(contact_table.homepage_raw) then
        return contact_table.homepage_raw
      else
        return {contact_table.homepage_raw}
      end
    end,
    github_username_or_nil = function(contact_table)
      return contact_table.Private["github-username"]
    end,
    github_user_url_or_nil = function(contact_table)
      local github_username = transf.contact_table.github_username_or_nil(contact_table)
      if github_username then
        return transf.github_username.github_user_url(
          github_username
        )
      end
    end,
    iban_or_nil = function (contact_table)
      return get.contact_table.not_userdata_or_fn_by_encrypted_data(contact_table, "iban")
    end,
    bic_or_nil = function (contact_table)
      local iban = transf.contact_table.iban_or_nil(contact_table)
      if iban then
        return transf.iban.bic(iban)
      end
    end,
    str_or_nil_by_bank_name = function (contact_table)
      local iban = transf.contact_table.iban_or_nil(contact_table)
      if iban then
        return transf.iban.str_by_bank_name(iban)
      end
    end,
    multiline_str_or_nil_by_bank_details = function (contact_table)
      local iban = transf.contact_table.iban_or_nil(contact_table)
      if iban then
        return transf.iban.multiline_str_by_bank_details(iban)
      end
    end,
    str_or_nil_by_personal_tax_number = function (contact_table)
      return get.contact_table.line_or_nil_by_tax_number(contact_table, "personal")
    end,
    line_arr_by_full_name_western = function(contact_table)
      return transf.hole_y_arrlike.arr({ 
        transf.contact_table.line_or_nil_by_name_pre(contact_table),
        transf.contact_table.line_or_nil_by_first_name(contact_table),
        transf.contact_table.line_or_nil_by_middle_name(contact_table),
        transf.contact_table.line_or_nil_by_last_name(contact_table),
        transf.contact_table.line_or_nil_by_name_suf(contact_table)
      })
    end,
    line_by_full_name_western = function(contact_table)
      return get.str_or_number_arr.str_by_joined(
        transf.contact_table.line_arr_by_full_name_western(contact_table),
        " "
      )
    end,
    line_arr_by_normal_name_western = function(contact_table)
      return transf.hole_y_arrlike.arr({ 
        transf.contact_table.line_or_nil_by_first_name(contact_table),
        transf.contact_table.line_or_nil_by_last_name(contact_table),
      })
    end,
    line_by_normal_name_western = function(contact_table)
      return get.str_or_number_arr.str_by_joined(
        transf.contact_table.line_arr_by_normal_name_western(contact_table),
        " "
      )
    end,
    line_by_main_name = function(contact_table)
      return transf.contact_table.line_or_nil_by_pref_name(contact_table) or transf.contact_table.line_by_normal_name_western(contact_table)
    end,
    line_arr_by_full_name_eastern = function(contact_table)
      return transf.hole_y_arrlike.arr({ 
        transf.contact_table.line_or_nil_by_name_pre(contact_table),
        transf.contact_table.line_or_nil_by_last_name(contact_table),
        transf.contact_table.line_or_nil_by_first_name(contact_table),
        transf.contact_table.line_or_nil_by_name_suf(contact_table)
      })
    end,
    line_by_full_name_eastern = function(contact_table)
      return get.str_or_number_arr.str_by_joined(
        transf.contact_table.line_arr_by_full_name_eastern(contact_table),
        " "
      )
    end,
    line_arr_by_normal_name_eastern = function(contact_table)
      return transf.hole_y_arrlike.arr({ 
        transf.contact_table.line_or_nil_by_last_name(contact_table),
        transf.contact_table.line_or_nil_by_first_name(contact_table),
      })
    end,
    line_by_normal_name_eastern = function(contact_table)
      return get.str_or_number_arr.str_by_joined(
        transf.contact_table.line_arr_by_normal_name_eastern(contact_table),
        " "
      )
    end,
    line_arr_by_name_additions = function(contact_table)
      return transf.hole_y_arrlike.arr({ 
        transf.contact_table.line_or_nil_by_title(contact_table),
        transf.contact_table.line_or_nil_by_role(contact_table),
        transf.contact_table.line_or_nil_by_organization(contact_table),
      })
    end,
    line_by_name_additions = function(contact_table)
      return get.str_or_number_arr.str_by_joined(
        transf.contact_table.line_arr_by_name_additions(contact_table),
        ", "
      )
    end,
    line_or_nil_by_indicated_nickname = function(contact_table)
      local nickname = transf.contact_table.line_or_nil_by_nickname(contact_table)
      if nickname then
        return '"' .. nickname .. '"'
      end
    end,
    line_arr_by_main_name_iban_bic_bank_name = function(contact_table)
      return {
        transf.contact_table.line_by_main_name(contact_table),
        transf.contact_table.iban_or_nil(contact_table),
        transf.contact_table.bic_or_nil(contact_table),
        transf.contact_table.str_or_nil_by_bank_name(contact_table),
      }
    end,
    multiline_str_by_name_bank_details = function(contact_table)
      return get.str_or_number_arr.str_by_joined(
        transf.contact_table.line_arr_by_main_name_iban_bic_bank_name(contact_table),
        "\n"
      )
    end,
    vcard_phone_type_key_phone_number_value_assoc = function (contact_table)
      return contact_table.Phone
    end,
    phone_number_arr = function (contact_table)
      return transf.table.vt_set(transf.contact_table.vcard_phone_type_key_phone_number_value_assoc(contact_table))
    end,
    printable_ascii_no_nonspace_whitespace_str_by_phone_numbers_joined = function (contact_table)
      return get.str_or_number_arr.str_by_joined(transf.contact_table.phone_number_arr(contact_table), ", ")
    end,
    vcard_email_type_key_email_value_assoc = function (contact_table)
      return contact_table.Email
    end,
    email_arr = function (contact_table)
      return transf.table.vt_set(transf.contact_table.vcard_email_type_key_email_value_assoc(contact_table))
    end,
    printable_ascii_not_whitespace_str_by_emails_joined = function (contact_table)
      return get.str_or_number_arr.str_by_joined(transf.contact_table.email_arr(contact_table), ", ")
    end,
    vcard_address_type_key_address_table_value_assoc = function (contact_table)
      return contact_table.Addresses
    end,
    address_table_arr = function (contact_table)
      return transf.table.vt_set(transf.contact_table.vcard_address_type_key_address_table_value_assoc(contact_table))
    end,
    str_by_summary = function (contact_table)
      local sumstr = transf.contact_table.line_by_full_name_western(contact_table)
      if transf.contact_table.line_or_nil_by_nickname(contact_table) then
        sumstr = sumstr .. " " .. transf.contact_table.line_or_nil_by_indicated_nickname(contact_table)
      end
      if transf.contact_table.line_by_name_additions(contact_table) then
        sumstr = sumstr .. " (" .. transf.contact_table.line_by_name_additions(contact_table) .. ")"
      end
      if transf.contact_table.printable_ascii_no_nonspace_whitespace_str_by_phone_numbers_joined(contact_table) ~= "" then
        sumstr = sumstr .. " [" .. transf.contact_table.printable_ascii_no_nonspace_whitespace_str_by_phone_numbers_joined(contact_table) .. "]"
      end
      if transf.contact_table.printable_ascii_not_whitespace_str_by_emails_joined(contact_table) ~= "" then
        sumstr = sumstr .. " <" .. transf.contact_table.printable_ascii_not_whitespace_str_by_emails_joined(contact_table) .. ">"
      end
    end,
    email_or_nil_by_main = function (contact_table)
      return get.contact_table.email(contact_table, "pref") or transf.contact_table.email_arr(contact_table)[1]
    end,
    phone_number_or_nil_by_main = function (contact_table)
      return get.contact_table.phone_number(contact_table, "pref") or transf.contact_table.phone_number_arr(contact_table)[1]
    end,
    address_table_or_nil_by_main = function (contact_table)
      return get.contact_table.address_table(contact_table, "pref") or transf.contact_table.address_table_arr(contact_table)[1]
    end,
    multiline_str_by_relevant_address_label = function (contact_table)
      local addr_table = transf.contact_table.address_table_or_nil_by_main(contact_table)
      if addr_table then
        return transf.address_table.multiline_str_by_relevant_address_label(
          addr_table
        )
      end
    end,
    yaml_str_or_nil_by_note = function (contact_table)
      return contact_table.Note
    end,
    contact_note_spec_by_note = function (contact_table)
      return transf.yaml_str.not_userdata_or_fn(
        transf.contact_table.yaml_str_or_nil_by_note(contact_table) or "{}"
      )
    end,
    line_or_nil_by_met_context = function (contact_table)
      return transf.contact_table.contact_note_spec_by_note(contact_table).met_context
    end,
    rfc3339like_dt_or_nil_by_met_dt = function (contact_table)
      return transf.contact_table.contact_note_spec_by_note(contact_table).met_dt
    end,
    line_or_nil_by_met_location = function (contact_table)
      return transf.contact_table.contact_note_spec_by_note(contact_table).met_location
    end,

  },
  address_table = {
    contact_table = function(single_address_table)
      return single_address_table.contact
    end,
    line_by_extended = function(single_address_table)
      return transf.str_or_nil.line_or_nil_by_folded(single_address_table.Extended)
    end,
    line_by_postal_code = function(single_address_table)
      return transf.str_or_nil.line_or_nil_by_folded(single_address_table.Code)
    end,
    line_by_region = function(single_address_table)
      return transf.str_or_nil.line_or_nil_by_folded(single_address_table.Region)
    end,
    country_identifier_str = function(single_address_table)
      return transf.str_or_nil.line_or_nil_by_folded(single_address_table.Country)
    end,
    iso_3366_1_alpha_2_country_code = function(single_address_table)
      return transf.country_identifier_str.iso_3366_1_alpha_2_country_code(
        transf.address_table.country_identifier_str(single_address_table)
      )
    end,
    line_by_street = function(single_address_table)
      return transf.str_or_nil.line_or_nil_by_folded(single_address_table.Street)
    end,
    line_by_city = function(single_address_table)
      return transf.str_or_nil.line_or_nil_by_folded(single_address_table.City)
    end,
    line_by_postal_code_city = function(single_address_table)
      return get.str_or_number_arr.str_by_joined(
        transf.hole_y_arrlike.arr({
          transf.address_table.line_by_postal_code(single_address_table),
          transf.address_table.line_by_city(single_address_table)
        }),
        " "
      )
    end,
    line_by_region_country = function(single_address_table)
      return 
        get.str_or_number_arr.str_by_joined(
          transf.hole_y_arrlike.arr({
            transf.address_table.line_by_region(single_address_table),
            transf.address_table.country_identifier_str(single_address_table)
          }),
          ", "
        )
    end,
    line_arr_by_addressee = function(single_address_table)
      return transf.hole_y_arrlike.arr({
        transf.contact_table.line_by_main_name(single_address_table.contact),
        transf.address_table.line_by_extended(single_address_table)
      })
    end,
    line_arr_by_in_country_location = function(single_address_table)
      return transf.hole_y_arrlike.arr({
        transf.address_table.line_by_street(single_address_table),
        transf.address_table.line_by_postal_code(single_address_table),
        transf.address_table.line_by_city(single_address_table),
      })
    end,
    line_arr_by_international_location = function(single_address_table)
      return transf.hole_y_arrlike.arr({
        transf.address_table.line_by_street(single_address_table),
        transf.address_table.line_by_postal_code(single_address_table),
        transf.address_table.line_by_city(single_address_table),
        transf.address_table.line_by_region(single_address_table),
        transf.address_table.country_identifier(single_address_table),
      })
    end,
    line_arr_by_relevant_location = function(single_address_table)
      if transf.address_table.iso_3366_1_alpha_2_country_code(single_address_table) == "de" then
        return transf.address_table.line_arr_by_in_country_location(single_address_table)
      else
        return transf.address_table.line_arr_by_international_location(single_address_table)
      end
    end,
    line_arry_by_country_address = function(single_address_table)
      return transf.two_arrs.arr_by_appended(
        transf.address_table.line_arr_by_addressee(single_address_table),
        transf.address_table.line_arr_by_in_country_location(single_address_table)
      )
    end,
    line_arr_by_international_address = function(single_address_table)
      return transf.two_arrs.arr_by_appended(
        transf.address_table.line_arr_by_addressee(single_address_table),
        transf.address_table.line_arr_by_international_location(single_address_table)
      )
    end,
    line_arr_by_relevant_address = function(single_address_table)
      if transf.address_table.iso_3366_1_alpha_2_country_code(single_address_table) == "de" then
        return transf.address_table.line_arry_by_country_address(single_address_table)
      else
        return transf.address_table.line_arr_by_international_address(single_address_table)
      end
    end,
    multiline_str_by_in_country_address_label = function(single_address_table)
      return 
        get.str_or_number_arr.str_by_joined(transf.address_table.line_arr_by_addressee(single_address_table), "\n") .. "\n" ..
        transf.address_table.line_by_street(single_address_table) .. "\n" ..
        transf.address_table.line_by_postal_code_city(single_address_table)
    end,
    multiline_str_by_international_address_label = function(single_address_table)
      return 
        get.str_or_number_arr.str_by_joined(transf.address_table.line_arr_by_addressee(single_address_table), "\n") .. "\n" ..
        transf.address_table.line_by_street(single_address_table) .. "\n" ..
        transf.address_table.line_by_postal_code_city(single_address_table) .. "\n" ..
        transf.address_table.line_by_region_country(single_address_table)
    end,
    multiline_str_by_relevant_address_label = function(single_address_table)
      if transf.address_table.iso_3366_1_alpha_2_country_code(single_address_table) == "de" then
        return transf.address_table.multiline_str_by_in_country_address_label(single_address_table)
      else
        return transf.address_table.multiline_str_by_international_address_label(single_address_table)
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
    line_by_title = function(id)
      return transf.youtube_video_id.youtube_video_item(id).snippet.title
    end,
    line_by_channel_title = function(id)
      return transf.youtube_video_id.youtube_video_item(id).snippet.channelTitle
    end,
    youtube_channel_id = function(id)
      return transf.youtube_video_id.youtube_video_item(id).snippet.channelId
    end,
    str_by_description = function(id)
      return transf.youtube_video_id.youtube_video_item(id).snippet.description
    end,
    youtube_upload_status = function(id)
      return transf.youtube_video_id.youtube_video_item(id).status.uploadStatus
    end,
    youtube_privacy_status = function(id)
      return transf.youtube_video_id.youtube_video_item(id).status.privacyStatus
    end,
    youtube_video_url = function(id)
      return "https://www.youtube.com/watch?v=" .. id
    end,
    youtube_caption_item_arr = function(id)
      return get.fn.rt_or_nil_by_memoized_invalidate_1_month(rest)({
        api_name = "youtube",
        endpoint = "captions",
        params = {
          videoId = id,
          part = "snippet",
        },
      }).items
    end,
    lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc = function(id)
      local assoc = transf.form_filling_specifier.str_key_str_value_assoc_by_filled({
        in_fields = {
          title = transf.youtube_video_id.line_by_title(id),
          channel_title = transf.youtube_video_id.line_by_channel_title(id),
          description = get.str.str_by_shortened_eutf8_start(transf.youtube_video_id.str_by_description(id)),
        },
        form_fields = {"tcrea", "title", "srs", "srsrel", "srsrelindex"},
        explanations = {
          tcrea = "Artist",
          title = "Title",
          srs = "Series",
          srsrel = "Relation to series",
          srsrelindex = "Index in the relation to series",
        }
      })
      return get.table.table_by_mapped_w_vt_arg_vt_ret_fn(
        assoc,
        transf.str.strict_snake_case_str_by_romanized
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
    line_by_title = function(id)
      return transf.youtube_playlist_id.youtube_playlist_item(id).snippet.title
    end,
    line_by_uploader = function(id)
      return transf.youtube_playlist_id.youtube_playlist_item(id).snippet.channelTitle
    end,
    youtube_playlist_url = function(id)
      return "https://www.youtube.com/playlist?list=" .. id
    end,
  },
  youtube_playlist_url = {
    youtube_playlist_id = function(url)
      return transf.url.str_key_str_value_assoc_by_decoded_param_table(url).list
    end,
    line_by_title = function(url)
      return transf.youtube_playlist_id.line_by_title(transf.youtube_playlist_url.youtube_playlist_id(url))
    end,
    line_by_uploader = function(url)
      return transf.youtube_playlist_id.line_by_uploader(transf.youtube_playlist_url.youtube_playlist_id(url))
    end,
  },
  youtube_video_url = {
    youtube_video_id = function(url)
      return transf.url.str_key_str_value_assoc_by_decoded_param_table(url).v
    end,
    line_by_title = function(url)
      return transf.youtube_video_id.line_by_title(transf.youtube_video_url.youtube_video_id(url))
    end,
    line_by_channel_title = function(url)
      return transf.youtube_video_id.line_by_channel_title(transf.youtube_video_url.youtube_video_id(url))
    end,
    lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc = function(url)
      return transf.youtube_video_id.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc(transf.youtube_video_url.youtube_video_id(url))
    end,
  },
  youtube_channel_id = {
    youtube_channel_video_feed_url = function(id)
      return "https://www.youtube.com/feeds/videos.xml?channel_id=" .. id
    end,
    youtube_channel_url = function(id)
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
    line_by_channel_title = function(id)
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
    line_by_channel_title = function(handle)
      return transf.youtube_channel_id.line_by_channel_title(transf.handle.youtube_channel_id(handle))
    end,
    youtube_channel_video_feed_url = function(handle)
      return transf.youtube_channel_id.youtube_channel_video_feed_url(transf.handle.youtube_channel_id(handle))
    end,
    printable_ascii_not_whitespace_str_by_raw_handle = function(handle)
      return get.str.str_by_sub_eutf8(handle, 2)
    end,
  },
  youtube_channel_url = {
    handle = function(url)
      return get.str.str_by_no_adfix(
        transf.url.local_absolute_path_or_nil_by_path(url),
        "/"
      )
    end,
    youtube_channel_id = function(url)
      return transf.handle.youtube_channel_id(transf.youtube_channel_url.handle(url))
    end,
  },
  str = {
    str_or_nil_by_raw_syn_output = function(str)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)( "syn -p" .. transf.str.str_by_single_quoted_escaped(str) )
    end,
    str_key_syn_specifier_value_assoc = function(str)
      local synonym_parts = get.str.str_arr_by_split_w_str(transf.str.str_or_nil_by_raw_syn_output(str), "\n\n")
      local synonym_tables = get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        synonym_parts,
        function (synonym_part)
          local synonym_part_lines = get.str.str_arr_by_split_w_ascii_char(synonym_part, "\n")
          local synonym_term = get.str.str_by_sub_eutf8(synonym_part_lines[1], 2) -- syntax: ❯<term>
          local synonyms_raw = get.str.str_by_sub_eutf8(synonym_part_lines[2], 12) -- syntax:  ⬤synonyms: <term>{, <term>}
          local antonyms_raw = get.str.str_by_sub_eutf8(synonym_part_lines[3], 12) -- syntax:  ⬤antonyms: <term>{, <term>}
          local synonyms = get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(get.str.str_arr_by_split_w_ascii_char(synonyms_raw, ", "), transf.str.not_starting_o_ending_with_whitespace_str)
          local antonyms = get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(get.str.str_arr_by_split_w_ascii_char(antonyms_raw, ", "), transf.str.not_starting_o_ending_with_whitespace_str)
          return synonym_term, {
            synonyms = synonyms,
            antonyms = antonyms,
          }
        end
      )
      return synonym_tables
    end,
    str_or_nil_by_raw_av_output = function (str)
      get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)(
        "synonym" .. transf.str.str_by_single_quoted_escaped(str)
      )
    end,
    str_by_title_case_policy = function(word)
      if get.arr.bool_by_contains(ls.small_words, word) then
        return word
      elseif eutf8.find(word, "%u") then -- words with uppercase letters are presumed to already be correctly title cased (acronyms, brands, the like)
        return word
      else
        return transf.str.str_by_first_eutf8_upper(word)
      end
    end,
    str_by_long_flag = function(word)
      return "--" .. word
    end,
    bool_by_starts_2underscore = function(word)
      return get.str.bool_by_startswith(word, "__") and not get.str.bool_by_startswith(word, "___")
    end,
    bool_by_starts_underscore = function(word)
      return get.str.bool_by_startswith(word, "_") and not get.str.bool_by_startswith(word, "__")
    end,
    noempty_trimmed_line_arr_by_synonyms = function(str)
      local items = get.str.str_arr_by_split_w_ascii_char_arr(transf.str.str_or_nil_by_raw_av_output(str), {"\t", "\n"})
      items = transf.str_arr.not_starting_o_ending_with_whitespace_str_arr(items)
      return transf.str_arr.not_empty_str_arr_by_filtered(items)
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
      res = transf.str.not_starting_o_ending_with_whitespace_str(res)
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
      res = transf.str.not_starting_o_ending_with_whitespace_str(res)
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
    not_userdata_or_fn_or_err_by_evaled_env_bash_parsed_json = function(str)
      local res = transf.str.str_or_err_by_evaled_env_bash_stripped_noempty(str)
      return transf.json_str.not_userdata_or_fn(res)
    end,
    not_userdata_or_fn_or_nil_by_evaled_env_bash_parsed_json = function(str)
      return transf.n_anys_or_err_ret_fn.n_anys_or_nil_ret_fn_by_pcall(
        transf.str.not_userdata_or_fn_or_err_by_evaled_env_bash_parsed_json
      )(str)
    end,
    table_or_err_by_evaled_env_bash_parsed_json = function(str)
      local res = transf.str.not_userdata_or_fn_or_err_by_evaled_env_bash_parsed_json(str)
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
        error("Error for command " .. str .. ":\n\n" .. transf.not_userdata_or_fn.json_str_by_pretty(res.error))
      else
        return res
      end
    end,
    table_or_nil_by_evaled_env_bash_parsed_json_nil_error_key = function(str)
      return transf.n_anys_or_err_ret_fn.n_anys_or_nil_ret_fn_by_pcall(
        transf.str.table_or_err_by_evaled_env_bash_parsed_json_err_error_key
      )(str)
    end,
    str_by_escaped_lua_regex = function(str)
      return get.str.str_by_prepended_all_w_ascii_str_arr(
        str,
        ls.lua_regex_metacharacters,
        "%"
      )
    end,
    str_by_escaped_general_regex = function(str)
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
    in_cache_local_absolute_path = function(data, type)
      return env.XDG_CACHE_HOME .. "/hs/" .. (type or "default") .. "/" .. transf.str.leaflike_by_safe_filename(data)
    end,
    in_tmp_local_absolute_path = function(data, type) -- in contrast to the above method, we also ensure that it's unique by using a timestamp
      return env.TMPDIR .. "/hs/" .. (type or "default") .. "/" .. os.time() .. "-" .. transf.str.leaflike_by_safe_filename(data)
    end,
    multiline_str_by_qr_utf8_image_bow = function(data)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)("qrencode -l M -m 2 -t UTF8 " .. transf.str.str_by_single_quoted_escaped(data))
    end,
    multiline_str_by_qr_utf8_image_wob = function(data)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_err_by_evaled_env_bash, {
        strify_table_params = true,
        table_param_subset = "json"
      })("qrencode -l M -m 2 -t UTF8i " .. transf.str.str_by_single_quoted_escaped(data))
    end,
    multiline_str_by_qr_png_in_cache = function(data)
      local path = transf.str.in_cache_local_absolute_path(data, "qr")
      dothis.str.generate_qr_png(data, path)
      return path
    end,
    --- does the minimum to make a str safe for use as a filename, but doesn't impose any policy
    leaflike_by_safe_filename  = function(filename)
      -- Replace forward slash ("/") with underscore
      filename = get.str.str_and_int_by_replaced_eutf8_w_regex_str(filename, "/", "_")

      -- Replace control characters (ASCII values 0 - 31 and 127)
      for i = 0, 31 do
        filename = get.str.str_and_int_by_replaced_eutf8_w_regex_str(filename, transf.halfbyte_pos_int.ascii_char(i), "_")
      end
      filename = get.str.str_and_int_by_replaced_eutf8_w_regex_str(filename, transf.halfbyte_pos_int.ascii_char(127), "_")

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
    strict_snake_case_by_replace_others_underscore = function(str)
      local naive_alphanum_underscore = get.str.str_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "[^%w%d]+", "_")
      local multi_cleaned_alphanum_underscore = get.str.str_by_continuous_collapsed_eutf8_w_regex_quantifiable(naive_alphanum_underscore, "_")
      return get.str.str_by_no_adfix(multi_cleaned_alphanum_underscore, "_")
    end,
    lower_strict_snake_case = function(str)
      return transf.str.str_by_all_eutf8_lower(transf.str.strict_snake_case_by_replace_others_underscore(str))
    end,
    upper_strict_snake_case = function(str)
      return transf.str.str_by_all_eutf8_upper(transf.str.strict_snake_case_by_replace_others_underscore(str))
    end,
    alphanum_arr_by_split_on_others = function(str) -- word separation is notoriously tricky. For now, we'll just use the same logic as in the snake_case function
      return get.str.str_arr_by_split_w_ascii_char(transf.str.strict_snake_case_by_replace_others_underscore(str), "_")
    end,
    upper_camel_strict_snake_case = function(str)
      local parts = transf.str.alphanum_arr_by_split_on_others(str)
      local upper_parts = get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(parts, transf.str.str_by_first_eutf8_upper)
      return get.str_or_number_arr.str_by_joined(upper_parts, "_")
    end,
    lower_camel_strict_snake_case = function(str)
      return transf.str.str_by_all_eutf8_lower(transf.str.upper_camel_strict_snake_case(str))
    end,
    upper_camel_case = function(str)
      local parts = transf.str.alphanum_arr_by_split_on_others(str)
      local upper_parts = get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(parts, transf.str.str_by_first_eutf8_upper)
      return get.str_or_number_arr.str_by_joined(upper_parts, "")
    end,
    lower_camel_case = function(str)
      return transf.str.str_by_all_eutf8_lower(transf.str.upper_camel_case(str))
    end,
    strict_kebap_case = function(str)
      local naive_kebap_case = get.str.str_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "[^%w%d]+", "-")
      local multi_cleaned_kebap_case = get.str.str_by_continuous_collapsed_eutf8_w_regex_quantifiable(naive_kebap_case, "-")
      return get.str.str_by_no_adfix(multi_cleaned_kebap_case, "-")
    end,
    lower_strict_kebap_case = function(str)
      return transf.str.str_by_all_eutf8_lower(transf.str.strict_kebap_case(str))
    end,
    upper_strict_kebap_case = function(str)
      return transf.str.str_by_all_eutf8_upper(transf.str.strict_kebap_case(str))
    end,
    str_by_all_eutf8_lower = eutf8.lower,
    str_by_all_eutf8_upper = eutf8.upper,
    str_by_first_eutf8_upper = function(str)
      return transf.str.str_by_all_eutf8_upper(get.str.str_by_sub_eutf8(str, 1, 1)) .. get.str.str_by_sub_eutf8(str, 2)
    end,
    str_by_first_eutf8_lower = function(str)
      return transf.str.str_by_all_eutf8_lower(get.str.str_by_sub_eutf8(str, 1, 1)) .. get.str.str_by_sub_eutf8(str, 2)
    end,
    alphanum_by_remove = function(str)
      return get.str.str_by_removed_eutf8_w_regex_quantifiable(str, "[^%w%d]")
    end,
    urlcharset_str_by_encoded_query_param_part = function(str)
      return plurl.quote(str, true)
    end,
    urlcharset_str_by_encoded_query_param_value_folded = function(str)
      local folded = transf.str.line_by_folded(str)
      return transf.str.urlcharset_str_by_encoded_query_param_part(folded)
    end,
    str_by_percent_decoded_also_plus = plurl.unquote,
    str_by_percent_decoded_no_plus = function(str)
      return transf.str.str_by_percent_decoded_also_plus(
        get.str.str_and_int_by_replaced_eutf8_w_regex_str(str, "%+", "%%2B") -- encode plus sign as %2B, so that it then gets decoded as a plus sign
      )
    end,
    unicode_prop_table_arr = function(str)
      return get.fn.rt_or_nil_by_memoized(transf.str.table_or_err_by_evaled_env_bash_parsed_json)("uni identify -compact -format=all -as=json".. transf.str.str_by_single_quoted_escaped(str))
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
    bin_str_by_utf8 = basexx.to_bit,
    hex_str_by_utf8 = basexx.to_hex,
    base64_gen_str_by_utf8 = basexx.to_base64,
    base64_url_str_by_utf8 = basexx.to_url64,
    base32_gen_str_by_utf8 = basexx.to_base32,
    base32_crock_str_by_utf8 = basexx.to_crockford,
    printable_ascii_str_by_html_entities_encoded = function(str)
      return transf.str.str_or_err_by_evaled_env_bash_stripped(
        "he --encode --use-named-refs" .. transf.str.here_doc(str)
      )
    end,
    str_by_html_entities_decoded = function(str)
      return transf.str.str_or_err_by_evaled_env_bash_stripped(
        "he --decode" .. transf.str.here_doc(str)
      )
    end,
    str_by_title_case = function(str)
      local words, removed = get.str.two_str_arrs_by_onig_regex_match_nomatch(str, "[ :–\\—\\-\\t\\n]")
      local title_cased_words = get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(words, transf.str.str_by_title_case_policy)
      title_cased_words[1] = transf.str.str_by_first_eutf8_upper(title_cased_words[1])
      title_cased_words[#title_cased_words] = transf.str.str_by_first_eutf8_upper(title_cased_words[#title_cased_words])
      local arr = transf.two_arrs.arr_by_interleaved_stop_a1(title_cased_words, removed)
      return get.str_or_number_arr.str_by_joined(arr, "")
    end, 
    strict_snake_case_str_by_romanized = function(str)
      str = get.str.str_by_removed_eutf8_w_regex_quantifiable(str, "[%^']")
      str = transf.str.str_by_romanized_wapuro_gpt/(str)
      str = transf.str.str_by_all_eutf8_lower(str)
      str = transf.str.strict_snake_case_by_replace_others_underscore(str)
      return str
    end,
    str_by_romanized_wapuro_gpt = function(str)
      return get.n_shot_llm_spec.str_or_nil_by_response({input = str, query =  "Please romanize the following text with wapuro-like romanization, where:\n\nっ -> duplicated letter (e.g. っち -> cchi)\nlong vowel mark -> duplicated letter (e.g. ローマ -> roomaji)\nづ -> du\nんま -> nma\nじ -> ji\nを -> wo\nち -> chi\nparticles are separated by spaces (e.g. これに -> kore ni)\nbut morphemes aren't (真っ赤 -> makka)", shots = {
        {"こっち", "kocchi"}
      }})
    end,
    line_by_folded = function(str)
      return get.str.str_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "[\n\r\v\f]", " ")
    end,
    trimmed_line_by_folded = function(str)
      return transf.str.not_starting_o_ending_with_whitespace_str(transf.str.line_by_folded(str))
    end,
    not_empty_str_by_default = function (str)
      if #str == 0 then
        return "default"
      else
        return str
      end
    end,
    noempty_trimmed_line_by_folded_or_default = function(str)
      return transf.str.not_empty_str_by_default(transf.str.trimmed_line_by_folded(str))
    end,
    line_by_all_whitespace_collapsed = function(str)
      return get.str.str_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "%s", " ")
    end,
    not_whitespace_str = function(str)
      return get.str.str_by_continuous_replaced_eutf8_w_regex_quantifiable(str, "%s", "")
    end,
    line_by_all_whitespace_single_underscore = function(str)
      return get.str.str_by_replaced_w_ascii_str(
        transf.str.line_by_all_whitespace_collapsed(str),
        " ",
        "_"
      )
    end,
    str_by_underscore_to_space = function(str)
      return get.str.str_by_replaced_w_ascii_str(
        str,
        "_",
        " "
      )
    end,
    pos_int_by_len_ascii_chars = string.len,


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
        transf.str.not_starting_o_ending_with_whitespace_str(str),
        "\n"
      )
    end,

    pos_int_by_len_lines = function(str)
      return #transf.str.line_arr(str)
    end,


    noempty_line_arr = function(str)
      return transf.str_arr.not_empty_str_arr_by_filtered(
        transf.str.line_arr(str)
      )
    end,
    noempty_noindent_line_arr = function(str)
      return transf.line_arr.noindent_line_arr(transf.str.noempty_line_arr(str))
    end,
    noempty_noindent_nohashcomment_line_arr = function(str)
      return transf.line_arr.nohashcomment_noindent_line_arr(transf.str.noempty_line_arr(str))
    end,

    line_by_first = function(str)
      return transf.str.line_arr(str)[1]
    end,
    noempty_line_by_first = function(str)
      return transf.str.noempty_line_arr(str)[1]
    end,
    line_by_last = function(str)
      local lines = transf.str.line_arr(str)
      return lines[#lines]
    end,
    noempty_line_by_last = function(str)
      local lines = transf.str.noempty_line_arr(str)
      return lines[#lines]
    end,
    utf8_char_by_first = function(str)
      return get.str.str_by_sub_eutf8(str, 1, 1)
    end,
    utf8_char_by_last = function(str)
      return get.str.str_by_sub_eutf8(str, -1)
    end,
    str_by_no_final_newlines = function(str)
      return get.str.str_by_final_removed_eutf8_w_regex_quantifiable(str, "\n")
    end,
    str_by_one_final_newline = function(str)
      return get.str.str_by_final_continuous_collapsed_eutf8_w_regex_quantifiable(str, "\n")
    end,
    here_doc = function(str)
      return " <<EOF\n" .. str .. "\nEOF"
    end,
    rfc3339like_dt_or_nil_by_guess_gpt = function(str)
      return get.n_shot_llm_spec.str_or_nil_by_response({
        input = str, 
        query = "Please transform the following thing indicating a date(time) into the corresponding RFC3339-like date(time) (UTC). Leave out elements that are not specified.", 
        shots = {
          {"IMG_20221115_183659759_HDR", "2022-21-15T18:36:59"},
          {"Screenshot_20081130-230925", "2008-11-30T23:09:25"},
          {"Screen Recording 2022-01-31 at 13.42.51", "2022-01-31T13:42:51"},
          {"2019--art_drafts.md", "2019"},
          {"20020803034034875", "2002-08-03T03:40:34"},
          {"2016111518_O7N1BEKrNTWTIgr33xRS5xCT", "2016-11-15T18"},
          {"com.apple.finder__20150218.324_manifest", "2015-02-18T03:24"},
          {"Yotsuba&! - 13 - 08 - 10", "IMPOSSIBLE"}

        }
      })
    end,
    raw_contact_or_nil = function(searchstr)
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)("khard show --format=yaml " .. searchstr )
    end,
    contact_table = function(searchstr)
      local raw_contact = transf.str.raw_contact_or_nil(searchstr)
      local contact = transf.raw_contact.contact_table(raw_contact)
      return contact
    end,
    str_by_hiraganaify_romanized = function(str)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("kana --vowel-shortener x" .. transf.str.here_doc(str))
    end,
    str_by_katakanaify_romanized = function(str)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("kana --vowel-shortener x --katakana --extended" .. transf.str.here_doc(str))
    end,
    str_by_hiraganaify_romanized_and_punct = function(str)
      return get.str.str_by_removed_eutf8_w_regex_quantifiable(transf.str.str_or_nil_by_evaled_env_bash_stripped("kana --vowel-shortener x --punctuation" .. transf.str.here_doc(str)), " ")
    end,
    str_by_katakanaify_romanized_and_punct = function(str)
      return get.str.str_by_removed_eutf8_w_regex_quantifiable(transf.str.str_or_nil_by_evaled_env_bash_stripped("kana --vowel-shortener x --katakana --extended --punctuation" .. transf.str.here_doc(str)), " ")
    end,
    str_by_kanaify_mixed_romanized_and_punct = function(str)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("kana --vowel-shortener x --extended --punctuation --kana-toggle 'Δ' --raw-toggle '†'" .. transf.str.here_doc(str))
    end,
    str_by_ime_general = function(str)
      return get.n_shot_llm_spec.str_or_nil_by_response({input = str, query =  "You're a dropin IME for already written text. Please transform the following into its Japanese writing system equivalent:"})
    end,
    str_by_hiraganaify_everything = function(str)
      return get.n_shot_llm_spec.str_or_nil_by_response({input = str, query =  "Transform the following into hiragana:"})
    end,
    str_by_katakananaify_everything = function(str)
      return get.n_shot_llm_spec.str_or_nil_by_response({input = str, query =  "Transform the following into katakana:"})
    end,
    ruby_annotated_kana = function(str)
      return get.n_shot_llm_spec.str_or_nil_by_response({input = str, query =  "Add kana readings to this text as <ruby> annotations, including <rp> fallback:"})
    end,
    --- @param str str
    --- @return hs.styledtext
    styledtext_by_with_styled_start_end_markers = function(str)
      local res =  hs.styledtext.new("^" .. str .. "$")
      res = get.styledtext.styledtext_by_slice_styled(res, "light", 1, 1)
      res = get.styledtext.styledtext_by_slice_styled(res, "light", #res, #res)
      return res
    end,
    not_starting_o_ending_with_whitespace_str = stringy.strip,  -- this is not unicode-aware, but seems to work regardless, probably because no 8-bit (0-beginning) ascii char is a valid utf8 char. Here's an alternative but slower implementation if we ever need it: function(str) return get.str.n_strs_by_extracted_eutf8(str, "^%s*(.-)%s*$") end,
    str_by_all_prepended_quotechar = function(str)
      return get.str_or_number_arr.str_by_joined(
        get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
          transf.str.line_arr(
            transf.str.not_starting_o_ending_with_whitespace_str(str)
          ),
          transf.str.str_by_prepend_quotechar
        ),
        "\n"
      )
    end,
    str_by_prepend_quotechar = function(v)
      if get.str.bool_by_startswith(v, ">") then
        return ">" .. v
      else
        return ">" .. " " .. v
      end
    end,
    url_arr_by_one_per_line = function(str)
      return transf.str_arr.url_arr_by_cleaned_indent_hashcomment_and_filtered(
        transf.str.line_arr(str)
      )
    end,
    str_by_whole_regex = function(str)
      return "^" .. str .. "$"
    end,
    two_strs__arr_or_nil_by_split_minus = function(str)
      return get.str.two_strs__arr_or_nil_by_split_w_str(str, "-")
    end,
    two_strs__arr_by_prompted_once = function(str)
      return transf.prompt_spec.any({
        prompter = transf.str_prompt_args_spec.str_or_nil_and_bool,
        transformer = transf.str.two_strs__arr_or_nil_by_split_minus,
        prompt_args = {
          message = "Please enter a pair for " .. str .. " (e.g. 'foo-bar')",
        }
      })
    end,
    two_strs__arr_ar_by_prompted_multiple = function(str)
      return transf.prompt_spec.any_arr({
        prompter = transf.str_prompt_args_spec.str_or_nil_and_bool,
        transformer = transf.str.two_strs__arr_or_nil_by_split_minus,
        prompt_args = {
          message = "Please enter a pair for " .. str .. " (e.g. 'foo-bar')",
        }
      })
    end,
    str_by_prompted_once_from_default = function(str)
      return get.str.str_by_prompted_once_from_default(str, "Enter a str...")
    end,
    alphanum_minus_underscore_str_by_prompted_once_from_default = function(str)
      return get.str.alphanum_minus_underscore_str_by_prompted_once_from_default(str, "Enter a str (alphanum, minus, underscore)...")
    end,
    not_whitespace_str_arr = function(str)
      return get.str.not_starting_o_ending_with_whitespace_str_arr_by_split_w_str(
        transf.str.line_by_all_whitespace_collapsed(str),
        " "
      )
    end,
    str_by_surrounded_with_brackets = function(str)
      return "[" .. str .. "]"
    end,
    str_by_start_with_slash = function(str)
      return "/" .. str
    end,
    nonindicated_number_str_by_clean = function(str)
      local res = str
      res = get.str.str_and_int_by_replaced_eutf8_w_regex_str(res, ",", ".")
      res = get.str.str_and_int_by_replaced_eutf8_w_regex_str(str, "^[0-9a-zA-Z]+", "")
      return res
    end,
    line_by_initial_space_indent = function(str)
      return get.str.n_strs_by_extracted_onig(str, "^ *")
    end,
    pos_int_by_initial_space_indent_len = function(str)
      return #transf.str.line_by_initial_space_indent(str)
    end,
    pos_int_by_initial_indent_2 = function(str)
      return get.str.pos_int_by_indent(str, 2)
    end,
    pos_int_by_initial_indent_4 = function(str)
      return get.str.pos_int_by_indent(str, 4)
    end,
    hydrus_file_hash_arr_by_search = function(str)
      local parts = get.str.not_starting_o_ending_with_whitespace_str_arr_by_split_w_str(str, "&&")
      return transf.arr.hydrus_file_hash_arr_by_search(parts)
    end,
    three_str_or_nils_by_namespace_inference_val = function(str)
      local noinference, inference  = get.str.n_strs_by_split_w_str(str, "/") -- get everything before '/' - after is a potential modifier
      local namespace, val = get.str.two_strs_or_nil_by_split_w_str(noinference, ":")
      return namespace, inference, val
    end,
    two_str_or_nils_and_str_arr_by_namespace_inference_val = function(str)
      local namespace, inference, val = transf.str.three_str_or_nils_by_namespace_inference_val(str)
      local valparts = get.str.str_arr_by_split_noedge_w_str(val, "+")
      return namespace, inference, valparts
    end,
    two_strs__arr_arr_by_deduce_from_parts = function(str)
      local res = {}
      -- example: str = thing:thing:bodypartlike:hand[thing:quantification:plural] +thing:spatial relation:circumtangent+ thing:bodypartlike:waist /thing:targeting another
      local namespace, inference, valparts = transf.str.three_str_or_nils_by_namespace_inference_val(str)
      local val = get.str_or_number_arr.str_by_joined_w_after_ticktock(valparts, "+")
      local noinference = namespace .. ":" .. val
      if inference then
        dothis.arr.push(
          res,
          { inference, str }
        ) -- e.g. thing:targeting another is a parent to thing:thing:bodypartlike:hand[thing:quantification:plural] +thing:spatial relation:circumtangent+ thing:bodypartlike:waist /thing:targeting another
        dothis.arr.push(
          res,
          { noinference, str}
        ) -- e.g. thing:thing:bodypartlike:hand[thing:quantification:plural] +thing:spatial relation:circumtangent+ thing:bodypartlike:waist is a parent to thing:thing:bodypartlike:hand[thing:quantification:plural] +thing:spatial relation:circumtangent+ thing:bodypartlike:waist /thing:targeting another
      end
      local valparts = get.str.not_starting_o_ending_with_whitespace_str_arr_by_split_w_str(val, "+")
      local consumable_valparts = get.table.table_by_copy(valparts)

      while #consumable_valparts > 0 do
        local valpart = act.arr.pop(consumable_valparts)
        if #valpart > 0 then
          local unmodified, modifier = get.str.n_strs_by_extracted_onig(valpart, "^([^\\[]+)\\[([^\\]])\\] *" ) -- e.g. thing:bodypartlike:hand[thing:quantification:plural]
          if unmodified and modifier then
            dothis.arr.push(res, {modifier, valpart}) -- e.g. thing:bodypartlike:hand[plural] implies thing:quantification:plural (or more precisely, thing:quantification:plural is a parent to thing:bodypartlike:hand[plural])
            dothis.arr.push(res, {unmodified, valpart}) -- e.g. thing:bodypartlike:hand[plural] implies thing:bodypartlike:hand (or more precisely, thing:bodypartlike:hand is a parent to thing:bodypartlike:hand[plural])
          end

          if #consumable_valparts > 1 then -- in the #valparts == 1 case, the later code results in the same thing as this, so we can skip it
            dothis.arr.push(
              res,
              { valpart, noinference }
            ) -- e.g. thing:bodypartlike:hand[plural]  is a parent to thing:thing:bodypartlike:hand[thing:quantification:plural] +thing:spatial relation:circumtangent+ thing:bodypartlike:waist
          end

          if #consumable_valparts ~= #valparts then
            local remaining_val = get.str_or_number_arr.str_by_joined_w_after_ticktock(valparts, "+")
          dothis.arr.push(
              res,
              { remaining_val, noinference }
            ) 
          end
          -- for our example:
          -- - #valparts = 3: do nothing
          -- - #valparts = 2: thing:bodypartlike:hand[thing:quantification:plural] +thing:spatial relation:circumtangent+ is a parent to thing:bodypartlike:hand[thing:quantification:plural] +thing:spatial relation:circumtangent+ thing:bodypartlike:waist
          -- - #valparts = 1: see above
        end
      end
      return res
    end,
    danbooru_tag_record_arr = function(str)
      return rest({
        api_name = "danbooru",
        endpoint = "tags.json",
        params = {
          ["search[name_matches]"] = transf.str.line_by_all_whitespace_single_underscore(str),
          ["search[order]"] = "count",
          ["search[hide_empty]"] = "true",
          limit = 999
        },
      })
    end,

  },
  danbooru_tag_record = {
    pos_int_by_id = function(tag_record)
      return tag_record.id
    end,
    printable_ascii_by_name = function(tag_record)
      return tag_record.name
    end,
    printable_ascii_by_name_with_spaces = function(tag_record)
      return transf.str.str_by_underscore_to_space(transf.str.danbooru_tag_record.printable_ascii_by_name(tag_record))
    end,
    sme_5_pos_int_by_category = function(tag_record)
      return tag_record.category
    end,
    danbooru_category_name = function(tag_record)
      return tblmap.sme_5_pos_int.danbooru_category_name[tag_record.category]
    end,
    printable_ascii_by_name_prefixed_namespace = function(tag_record)
      return  transf.danbooru_tag_record.danbooru_category_name(tag_record) .. ":" .. transf.danbooru_tag_record.printable_ascii_by_name(tag_record)
    end,
    danbooru_tag_implication_record_arr_by_name_as_antecedent = function(tag_record)
      return rest({
        api_name = "danbooru",
        endpoint = "tag_implications.json",
        params = {
          ["search[antecedent_name]"] = tag_record.name,
          limit = 999
        },
      })
    end,
    danbooru_tag_implication_record_arr_by_name_as_consequent = function(tag_record)
      return rest({
        api_name = "danbooru",
        endpoint = "tag_implications.json",
        params = {
          ["search[consequent_name]"] = tag_record.name,
          limit = 999
        },
      })
    end,

  },
  danbooru_tag_record_arr = {
    printable_ascii_arr_by_name = function(tag_record_arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(tag_record_arr, transf.danbooru_tag_record.printable_ascii_by_name)
    end,
    printable_ascii_arr_by_name_prefixed_namespace = function(tag_record_arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(tag_record_arr, transf.danbooru_tag_record.printable_ascii_by_name_prefixed_namespace)
    end,
  },
  str_or_nil_and_str_or_nil_and_str_arr = {
    str_by_namespace_inference_valparts = function(str1, str2, str_arr)
      local res = ""
      if str1 and #str1 > 0 then
        res = res .. str1 .. ":"
      end
      res = res .. get.str_or_number_arr.str_by_joined(str_arr, "+")
      if str2 and #str2 > 0 then
        res = res .. "/" .. str2
      end
      return res
    end,
  },
  line = {
    noindent_line_by_extract = function(str)
      return get.str.n_strs_by_extracted_eutf8(str, "^%s*(.*)$")
    end,
    nohashcomment_line_by_extract = function(str)
      return get.str.str_arr_by_split_w_str(str, " # ")[1]
    end,
    noempty_nohashcomment_line_by_extract = function(str)
      return transf.line.noindent_line_by_extract(transf.line.nohashcomment_line_by_extract(str))
    end,
    line_by_extract_comment = function(str)
      return get.str.str_arr_by_split_w_str(str, " # ")[2]
    end,
  },
  alphanum_minus = {
    alphanum_by_remove = function(str)
      return get.str.str_by_removed_onig_w_regex_quantifiable(str, "-")
    end,
  },
  snake_case = {
    str_or_nil_by_shell_var_evaled = function(str)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("echo $" .. str)
    end,
  },
  alphanum_minus_underscore = {
    
  },
  passw_pass_item_name = {
    line_by_password = function(auth_pass_item_name)
      return get.auth_pass_item_name.str_or_nil_by_fetch_value(auth_pass_item_name, "passw")
    end,
  },
  recovery_pass_item_name = {
    str_by_recovery_key = function(auth_pass_item_name)
      return get.auth_pass_item_name.str_or_nil_by_fetch_value(auth_pass_item_name, "recovery")
    end,
  },
  secq_pass_item_name = {
    str_by_security_question = function(auth_pass_item_name)
      return get.auth_pass_item_name.str_or_nil_by_fetch_value(auth_pass_item_name, "security_question")
    end,
  },
  otp_pass_item_name = {
    digit_string_by_otp = function(item)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("pass otp p/otp/" .. item)
    end,
    otpauth_url = function(item)
      return get.auth_pass_item_name.str_or_nil_by_fetch_value(item, "otp")
    end,
  },
  auth_pass_item_name = {
    local_absolute_path_by_passw = function(auth_pass_item_name)
      return get.auth_pass_item_name.local_absolute_path(auth_pass_item_name, "passw")
    end,
    local_absolute_path_by_recovery_key = function(auth_pass_item_name)
      return get.auth_pass_item_name.local_absolute_path(auth_pass_item_name, "recovery")
    end,
    local_absolute_path_by_security_question = function(auth_pass_item_name)
      return get.auth_pass_item_name.local_absolute_path(auth_pass_item_name, "security_question")
    end,
    line_by_username_or_default = function(auth_pass_item_name)
      return transf.auth_pass_item_name.line_by_username(auth_pass_item_name) or env.MAIN_EMAIL
    end,
    line_by_username = function(auth_pass_item_name)
      local path = transf.auth_pass_item_name.local_absolute_path_by_username(auth_pass_item_name)
      if is.local_absolute_path.local_extant_path(path) then
        return transf.plaintext_file.str_by_no_final_newlines(
          path
        )
      end
    end,
    local_absolute_path_by_username = function(auth_pass_item_name)
      return get.auth_pass_item_name.local_absolute_path(auth_pass_item_name, "username", "txt")
    end,
    local_absolute_path_by_otp = function(item)
      return get.auth_pass_item_name.local_absolute_path(item, "otp")
    end,
  },
  cc_pass_item_name = {
    cleaned_payment_card_number = function(cc_pass_item_name)
      return get.pass_item_name.str_or_nil_by_fetch_value(cc_pass_item_name, "cc/nr")
    end,
    my_slash_date_by_expiry = function(cc_pass_item_name)
      return get.pass_item_name.str_or_nil_by_fetch_value(cc_pass_item_name, "cc/exp")
    end,
  },
  three_str_or_nils = {
    str_by_namespace_inference_val = function(ns, inference, val)
      return 
        get.str_or_nil.str_by_apply_format_str_or_empty_str(ns, "%s:") ..
        val ..
        get.str_or_nil.str_by_apply_format_str_or_empty_str(inference, "/%s")
    end,
  },
  two_str_or_nils_and_str_arr = {
    str_by_namespace_inference_valparts = function(ns, inference, valparts)
      return transf.three_str_or_nils.str_by_namespace_inference_valparts(ns, inference, get.str_or_number_arr.str_by_joined_w_after_ticktock(valparts, "+"))
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
  lyaml_not_userdata_or_fn = {
    not_userdata_or_fn = function(t)
      if not is.any.table(t) then
        return t
      end
      for k, v in transf.table.kt_vt_stateless_iter(t) do
        if v == yaml.null then
          t[k] = nil
        elseif is.any.table(v) then
          t[k] = transf.lyaml_not_userdata_or_fn.not_userdata_or_fn(v)
        end
      end
    end
  },
  yaml_str = {
    not_userdata_or_fn = function(str)
      local res = yaml.load(str)
      res = transf.lyaml_not_userdata_or_fn.not_userdata_or_fn(res)
      return res
    end,
    json_str = function(str)
      return transf.not_userdata_or_fn.json_str(
        transf.yaml_str.not_userdata_or_fn(str)
      )
    end,
  },
  json_str = {
    not_userdata_or_fn = function(str)
      return transf.fn.rt_or_nil_ret_fn_by_pcall(json.decode)(str)
    end,
    table_or_nil = function(str)
      local res =  transf.not_userdata_or_fn.json_str(str)
      if is.any.table(res) then
        return res
      else
        return nil
      end
    end,
    yaml_str = function(str)
      return transf.not_userdata_or_fn.yaml_str(
        transf.json_str.not_userdata_or_fn(str)
      )
    end,
  },
  toml_str = {
    assoc = toml.decode
  },
  yaml_file = {
    not_userdata_or_fn = function(path)
      return transf.yaml_str.not_userdata_or_fn(transf.plaintext_file.str_by_contents(path))
    end
  },
  
  ini_str = {
    str_key_str_or_str_key_str_value_assoc_value_assoc = function(str)
      return transf.str.table_or_err_by_evaled_env_bash_parsed_json(
        "jc --ini " .. transf.str.here_doc(str)
      )
    end,
  },
  plaintext_assoc_file = {
    not_userdata_or_fn = function(file)
      if is.plaintext_assoc_file.yaml_file(file) then
        return transf.yaml_file.not_userdata_or_fn(file)
      elseif is.plaintext_assoc_file.json_file(file) then
        return transf.json_file.not_userdata_or_fn(file)
      elseif is.plaintext_assoc_file.ini_file(file) then
        return transf.ini_file.str_key_str_or_nested_1_value_assoc(file)
      elseif is.plaintext_assoc_file.toml_file(file) then
        return transf.toml_file.assoc(file)
      elseif is.plaintext_assoc_file.ics_file(file) then
        return transf.ics_file.ical_spec(file) 
      end
    end
  },
  plaintext_assoc_file_arr ={
    not_userdata_or_fn_arr = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.plaintext_assoc_file.not_userdata_or_fn
      )
    end
  },
  decoded_email_header_line = {
    two_lines_by_split = function(str)
      return get.str.n_strs_by_extracted_eutf8(str, "^([^:]+):%s*(.+)$")
    end,
    two_lines_by_split_lower_first = function(str)
      local k,v = transf.decoded_email_header_line.two_lines_by_split(str)
      return transf.str.str_by_all_eutf8_lower(k), v
    end,
  },
  decoded_email_header_block = {
    line_key_line_value_assoc = function(str)
      local lines = transf.str.line_arr(str)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        lines,
        transf.str.two_strs_by_split_header
      )

    end
  },
  base64_gen_str = {
    str_by_decode_to_utf8 = basexx.from_base64,
  },
  base64_url_str = {
    str_by_decode_to_utf8 = basexx.from_url64,
  },
  base32_gen_str = {
    str_by_decode_to_utf8 = basexx.from_base32,
  },
  base32_crock_str = {
    str_by_decode_to_utf8 = basexx.from_crockford,
  },
  multiline_str = {
    multiline_str_by_trimmed_lines = function(str)
      local lines = get.str.str_arr_by_split_w_str(str, "\n")
      local trimmed_lines = get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(lines, transf.str.not_starting_o_ending_with_whitespace_str)
      return get.str_or_number_arr.str_by_joined(trimmed_lines, "\n")
    end,
    iso_3366_1_alpha_2_country_code_key_mullvad_city_code_key_relay_identifier_arr_value_assoc_value_assoc = function(raw)
      local raw_countries = get.str.not_empty_str_arr_by_split_w_str(raw, "\n\n")
      local countries = {}
      for _, raw_country in transf.arr.pos_int_vt_stateless_iter(raw_countries) do
        local raw_country_lines = get.str.not_empty_str_arr_by_split_w_ascii_char(raw_country, "\n")
        local country_header = raw_country_lines[1]
        local country_code = get.str.n_strs_by_extracted_onig(country_header, "\\(([^\\)]+\\)")
        if country_code == nil then error("could not find country code in header. header was " .. country_header) end
        local payload_lines = transf.arr.arr_by_nofirst(raw_country_lines)
        countries[country_code] = {}
        local city_code
        for _, payload_line in transf.arr.pos_int_vt_stateless_iter(payload_lines) do
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
  danbooru_hydrus_inference_specifier = {
    str_arr_arr_by_danbooru_prts = function(spec)
      if spec.danbooru_tags.prts then
        return spec.danbooru_tags.prts
      else
        local tag_records = transf.str.danbooru_tag_record_arr(
          spec.danbooru_tags.fetch
        )
        local namespaced_tags = transf.danbooru_tag_record_arr.printable_ascii_arr_by_name_prefixed_namespace(tag_records)
        local arr_arr_by_extraction = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
          namespaced_tags,
          spec.danbooru_tags.prts_extractor
        )
        local unproc_prts = transf.arr_arr.arr_arr_by_swap_row_column(arr_arr_by_extraction)
        local prts = transf.arr_arr.set_arr(unproc_prts)
        return prts
      end
    end,
    str_arr_arr_by_danbooru_cartesian_product = function(spec)
      return transf.arr_arr.arr_arr_by_cartesian_product(
        transf.danbooru_hydrus_inference_specifier.str_arr_arr_by_danbooru_prts(spec)
      )
    end,
    str_arr_by_danbooru_tag = function(spec)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        transf.danbooru_hydrus_inference_specifier.str_arr_arr_by_danbooru_cartesian_product(spec),
        function(arr)
          return get.str.str_by_evaled_as_template(
            spec.danbooru_tags.combine,
            {prts=arr}
          )
        end
      )
    end,
  },
  two_hydrus_rel_specs = {
    hydrus_rel_spec = function(spec1, spec2)
      return {
        sib = transf.two_arrs.arr_by_appended(spec1.sib, spec2.sib),
        parent = transf.two_arrs.arr_by_appended(spec1.parent, spec2.parent),
      }
    end,
  },
  hydrus_tag_hierarchy = {
    hydrus_rel_spec = function(hierarchy)
      local basic_rel_spec = get.hydrus_tag_hierarchy_node.hydrus_rel_spec("global", hierarchy, nil, nil, ls.global_namespace_taking_key_name_arr)
      local tag_map = transf.two_tables.table_by_take_new(
        transf.two_anys__arr_arr.assoc_by_reverse_nested(basic_rel_spec.sib),
        transf.two_anys__arr_arr.assoc_by_reverse_nested(ls.two_strs__arr_arr_by_siblings)
      ) -- add the reverse of the simple siblings to the tag map
      local generated_hydrus_rel_spec = get.danbooru_hydrus_inference_specifier_arr.hydrus_rel_spec_by_danbooru_tag_my_tag_implications(
        ls.danbooru_hydrus_inference_specifier_arr,
        tag_map
      )
      basic_rel_spec = transf.two_hydrus_rel_specs.hydrus_rel_spec(basic_rel_spec, generated_hydrus_rel_spec)
      local all_current_tags = transf.hydrus_rel_spec.str_arr_by_to_be_derived(basic_rel_spec)
      local further_parents = transf.str_arr.two_strs__arr_arr_by_deduce_from_parts(
        all_current_tags
      )
      basic_rel_spec.parent = transf.two_arrs.arr_by_appended(basic_rel_spec.parent, further_parents)
      return basic_rel_spec
    end,
  },
  hydrus_rel_spec = {
    str_arr_by_to_be_derived = function(hydrus_rel_spec)
      return transf.arr.set(
        transf.two_arrs.arr_by_appended(
          transf.arr_arr.arr_by_flatten(hydrus_rel_spec.sib),
          transf.arr_arr.arr_by_flatten(hydrus_rel_spec.parent)  
        )
      )
    end,
    input_spec_arr = function(hydrus_rel_spec)
      local arr = {}
      error("todo implies")
      for _, sib in transf.arr.pos_int_vt_stateless_iter(hydrus_rel_spec.sib) do
        -- to add an alias, we need to focus the source text field, type the source, focus the target text field, type the target, and press enter to stage, and then click the add button to add it
        arr = transf.two_arrs.arr_by_appended(arr, {
          {
            x = 150,
            y = -670,
            relative_to = "tl",
            mode = "move",
          }, {
            mode = "click",
            mouse_button_str =  "l"
          }, {
            mode = "key",
            key = sib[2]
          }, {
            x = 450,
            y = -670,
            relative_to = "tl",
            mode = "move",
          }, {
            mode = "click",
            mouse_button_str =  "l"
          }, {
            mode = "key",
            key = sib[1]
          }, {
            mode = "key",
            key = "enter"
          }, {
            x = 410,
            y = -425,
            relative_to = "tl",
            mode = "move",
          }, {
            mode = "click",
            mouse_button_str =  "l"
          }
        })

      end
      return res
    end,
  },
  multirecord_str = {
    record_str_arr = function(str)
      return get.str.not_empty_str_arr_by_split_w_str(
        str,
        consts.unique_record_separator
      )
    end,
  },
  record_str = {
  },
  syn_specifier = {
    str_arr_by_synonyms = function (syn_specifier)
      return syn_specifier.synonyms
    end,
    str_arr_by_antonyms = function (syn_specifier)
      return syn_specifier.antonyms
    end,
    multiline_str_by_summary = function (syn_specifier)
      return 
        "synonyms: " ..
        get.arr.arr_by_slice_removed_indicator_and_flatten_w_cut_specifier(syn_specifier.synonyms, { stop = 2}, "...") ..
        "\n" ..
        "antonyms: " ..
        get.arr.arr_by_slice_removed_indicator_and_flatten_w_cut_specifier(syn_specifier.antonyms, { stop = 2}, "...")
    end,
  },
  two_anys__arr = {
    two_ts = function(two_anys__arr)
      return two_anys__arr[1], two_anys__arr[2]
    end,
    t_by_first = function(two_anys__arr)
      return two_anys__arr[1]
    end,
    t_by_second = function(two_anys__arr)
      return two_anys__arr[2]
    end,
  },
  two_anys = {
    bool_by_and = function(a, b)
      return a and b
    end,
    bool_by_or = function(a, b)
      return a or b
    end,
    t_by_first = function(a, b)
      return a
    end,
    t_by_second = function(a, b)
      return b
    end,    
    str_by_assoc_entry = function(a, b)
      return "[" .. transf.any.str_by_replicable(a) .. "] = " .. transf.any.str_by_replicable(b)
    end,
    query_mapping = function(a,b)
      local s1 = transf.any.str_by_replicable(a)
      local s2 = transf.any.str_by_replicable(b)
      return 
        transf.two_strs.query_mapping(s1, s2)
    end,
    decoded_email_header_line = function(a, b)
      local s1 = transf.any.str_by_replicable(a)
      local s2 = transf.any.str_by_replicable(b)
      return 
        transf.two_strs.decoded_email_header_line(s1, s2)
    end,
    curl_form_field_args = function(a, b)
      local s1 = transf.any.str_by_replicable(a)
      local s2 = transf.any.str_by_replicable(b)
      return 
        transf.two_strs.curl_form_field_args(s1, s2)
    end,
    ini_kv_line = function(a, b)
      local s1 = transf.any.str_by_replicable(a)
      local s2 = transf.any.str_by_replicable(b)
      return 
        transf.two_strs.ini_kv_line(s1, s2)
    end,
  },
  two_strs = {
    query_mapping = function(s1, s2)
      return
        transf.str.urlcharset_str_by_encoded_query_param_part(s1) ..
        "=" ..
        transf.str.urlcharset_str_by_encoded_query_param_part(s2)
    end,
    decoded_email_header_line = function(s1, s2)
      local l1 = transf.str.noempty_trimmed_line_by_folded_or_default(s1)
      local l2 = transf.str.line_by_folded(s2)
      return transf.noempty_trimmed_line_and_line.decoded_email_header_line(l1, l2)
    end,
    curl_form_field_args = function(s1, s2)
      return {
        "-F",
        s1 .. "=" .. s2,
      }
    end,
    ini_kv_line = function(s1, s2)
      -- while trimming isn't necessary for ini, since the whitespace will be ignored, it's still a good idea to trim it
      local l1 = transf.str.noempty_trimmed_line_by_folded_or_default(s1)
      local l2 = transf.str.line_by_folded(s2)
      return transf.noempty_trimmed_line_and_line.ini_kv_line(l1, l2)
    end,
  },
  noempty_trimmed_line_and_line = {
    decoded_email_header_line = function(l1, l2)
      return transf.str.str_by_first_eutf8_upper(l1) .. ": " .. l2
    end,
    ini_kv_line = function(l1, l2)
      return l1 .. " = " .. l2
    end,
  },
  two_lines = {
    line_by_booru_namespaced_tag_every = function(s1, s2)
      return s1 .. ":" .. s2
    end,
    line_by_booru_namespaced_tag_smart = function(s1, s2)
      if s1 == "global" then
        return s2
      else
        return s1 .. ":" .. s2
      end
    end,
  },
  two_lines_arr__arr = {
    line_arr_by_booru_namespaced_tag_smart = function(arr)
      return get.arr.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
        arr,
        function(arr)
          return transf.two_lines.line_by_booru_namespaced_tag_smart(arr[1], arr[2])
        end
      )
    end,
  },
  str_key_str_value_assoc = {
    ini_kv_line_arr = function(str_key_str_value_assoc)
      return get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
        str_key_str_value_assoc,
        transf.two_strs.ini_kv_line
      )
    end,
    ini_section_contents_str = function(str_key_str_value_assoc)
      return get.str_or_number_arr.str_by_joined(
        transf.str_key_str_value_assoc.ini_kv_line_arr(str_key_str_value_assoc),
        "\n"
      )
    end,
    tag_d_spec =  function(assoc)
      return  {
        decorate_if_ext = get.str_or_nil.str_by_apply_format_str_or_empty_str,
        bracket = transf.str_or_nil.str_by_surrounded_with_brackets_if_str,
        slash = transf.str_or_nil.str_by_start_with_slash_if_str,
        modify = get.two_strs.str_by_modified_at_position,
        my = function(danbooru_tag)
          local res = assoc["general:" .. danbooru_tag]
          if res == nil then 
            print("WARN: No hydrus tag for danbooru tag " .. danbooru_tag)
          end
          return res
        end,
      }
    end,

  },
  two_operational_comparables = {
    operational_comparable_by_larger = function(a, b)
      if a > b then
        return a
      else
        return b
      end
    end,
    operational_comparable_by_smaller = function(a, b)
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
  two_dcmp_names = {
    bool_by_first_larger = function(a, b)
      return tblmap.dcmp_name.date_component_index[a] > tblmap.ddcmp_name.date_component_index[b]
    end,
    dcmp_name_by_larger = function(a, b)
      if tblmap.dcmp_name.date_component_index[a] > tblmap.dcmp_name.date_component_index[b] then
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
      return get.str.n_strs_by_extracted_eutf8(str, " <(.*)>$")
    end,
    trimmed_line_by_displayname = function(str)
      return get.str.n_strs_by_extracted_eutf8(str, "^(.*) <")
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
    trimmed_line_by_displayname = function(str)
      return transf.displayname_email.trimmed_line_by_displayname(str) or nil
    end,
  },
  phone_number = {

  },
  str_arr = {
    str_arr_by_mapped_single_quoted_escaped = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.str.str_by_single_quoted_escaped
      )
    end,
    str_by_single_quoted_escaped_joined = function(arr)
      return get.str_or_number_arr.str_by_joined(
        transf.str_arr.str_arr_by_mapped_single_quoted_escaped(arr),
        " "
      )
    end,
    str_by_action_path = function(arr)
      return get.str_or_number_arr.str_by_joined(arr, " > ")
    end,
    path_by_joined = function(arr)
      return get.str_or_number_arr.str_by_joined(
        get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(arr, transf.str.leaflike_by_safe_filename), 
        "/"
      )
    end,
    not_empty_str_arr_by_filtered = function(arr)
      return get.arr.arr_by_filtered(arr, is.str.not_empty_str)
    end,
    url_arr_by_filtered = function(arr)
      return get.arr.arr_by_filtered(arr, is.str.url)
    end,
    url_arr_by_cleaned_indent_hashcomment_and_filtered = function(arr)
      return transf.str_arr.url_arr_by_filtered(
        transf.line_arr.nohashcomment_noindent_line_arr(arr)
      )
    end,
    not_starting_o_ending_with_whitespace_str_arr = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(arr, transf.str.not_starting_o_ending_with_whitespace_str)
    end,
    multiline_str = function(arr)
      return get.str_or_number_arr.str_by_joined(arr, "\n")
    end,
    str_by_summary = function(arr)
      return get.str_or_number_arr.str_by_joined(
        get.arr.arr_by_slice_removed_indicator_and_flatten_w_cut_specifier(arr, {
          start = 1,
          stop = 10,
        }, "..."),
        ", "
      )
    end,
    str_arr_by_percent_decoded_no_plus = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(arr, transf.str.str_by_percent_decoded_no_plus)
    end,
    two_strs__arr_arr_by_split_colon = function(arr)
      local res = {}
      for _, v in transf.arr.pos_int_vt_stateless_iter(arr) do
        local k, v = get.str.n_strs_by_split_w_str(v, ":")
        if not v then
          v = k
          k = ""
        end
        dothis.arr.push(res, {k, v})
      end
    end,
    two_strs__arr_arr_by_deduce_from_parts = function(arr)
      return transf.arr_arr.arr_by_flatten(
        get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
          arr,
          transf.str.two_strs__arr_arr_by_deduce_from_parts
        )
      )
    end
    
  },
  line_arr = {
    noindent_line_arr = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(arr, transf.line.noindent_line_by_extract)
    end,
    nohashcomment_line_arr = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        transf.line_arr.nohashcomment_line_filtered_line_arr(arr),
        transf.line.nohashcomment_line_by_extract
      )
    end,
    nohashcomment_line_filtered_line_arr = function(arr)
      return get.arr.arr_by_filtered(
        arr,
        is.str.nohashcomment_line
      )
    end,
    nohashcomment_line_filtered_noindent_line_arr = function(arr)
      return transf.line_arr.noindent_line_arr(
        transf.line_arr.nohashcomment_line_filtered_line_arr(arr)
      )
    end,
    nohashcomment_noindent_line_arr = function(arr)
      return transf.line_arr.noindent_line_arr(
        transf.line_arr.nohashcomment_line_arr(arr)
      )
    end,
  },
  envlike_mapping_arr = {
    envlike_str = function(arr)
      local envlike_str_inner = get.str_or_number_arr.str_by_joined(arr, "\n")
      return "#!/usr/bin/env bash\n\n" ..
          "set -u\n\n" .. 
          envlike_str_inner .. 
          "\n\nset +u\n"
    end,
  },
  slice_notation = {
    three_pos_int_or_nils = function(notation)
      local stripped_str = transf.str.not_starting_o_ending_with_whitespace_str(notation)
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
    two_ts_by_first = function(arr1, arr2)
      return arr1[1], arr2[1]
    end,
    bool_by_larger_first_item = function(arr1, arr2)
      return transf.two_operational_comparables.bool_by_larger(arr1[1], arr2[1])
    end,
    bool_by_smaller_first_item = function(arr1, arr2)
      return transf.two_operational_comparables.bool_by_smaller(arr1[1], arr2[1])
    end,
    arr_by_appended = function(arr1, arr2)
      local res = get.table.table_by_copy(arr1)
      for _, v in transf.arr.pos_int_vt_stateless_iter(arr2) do
        res[#res + 1] = v
      end
      return res
    end,
    two_ts__arr_arr_by_zip_stop_a1 = function(arr1, arr2)
      local res = {}
      for i = 1, #arr1 do
        res[#res + 1] = {arr1[i], arr2[i]}
      end
      return res
    end,
    two_ts__arr_arr_by_zip_stop_a2 = function(arr1, arr2)
      local res = {}
      for i = 1, #arr2 do
        res[#res + 1] = {arr1[i], arr2[i]}
      end
      return res
    end,
    two_ts__arr_arr_by_zip_stop_shortest = function(arr1, arr2)
      local res = {}
      local shortest = transf.two_operational_comparables.operational_comparable_by_smaller(#arr1, #arr2)
      for i = 1, shortest do
        res[#res + 1] = {arr1[i], arr2[i]}
      end
      return res
    end,
    two_ts__arr_arr_by_zip_error_not_same_length = function(arr1, arr2)
      if #arr1 ~= #arr2 then
        error("arrays not same length")
      end
      return transf.two_ts__arr_arr.two_ts__arr_arr_by_zip_stop_shortest(arr1, arr2)
    end,
    assoc_by_zip_stop_shortest = function(arr1, arr2)
      return transf.two_anys__arr_arr.assoc(
        transf.two_arrs.two_ts__arr_arr_by_zip_stop_shortest(arr1, arr2)
      )
    end,
    two_ts__arr_arr_by_zip_stop_longest = function(arr1, arr2)
      local res = {}
      local longest = transf.two_operational_comparables.operational_comparable_by_larger(#arr1, #arr2)
      for i = 1, longest do
        res[#res + 1] = {arr1[i], arr2[i]}
      end
      return res
    end,
    arr_by_interleaved_stop_a1 = function(arr1, arr2)
      local res = {}
      for i, v in transf.arr.pos_int_vt_stateless_iter(arr1) do
        res[#res + 1] = v
        res[#res + 1] = arr2[i]
      end
      return res
    end,
    arr_by_interleaved_stop_a2 = function(arr1, arr2)
      local res = {}
      for i, v in transf.arr.pos_int_vt_stateless_iter(arr2) do
        res[#res + 1] = arr1[i]
        res[#res + 1] = v
      end
      return res
    end,
    arr_by_interleaved_stop_shortest = function(arr1, arr2)
      local res = {}
      local shortest = transf.two_operational_comparables.operational_comparable_by_smaller(#arr1, #arr2)
      for i = 1, shortest do
        res[#res + 1] = arr1[i]
        res[#res + 1] = arr2[i]
      end
      return res
    end,
    arr_by_interleaved_stop_longest = function(arr1, arr2)
      local res = {}
      local longest = transf.two_operational_comparables.operational_comparable_by_larger(#arr1, #arr2)
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
      for _, v in transf.arr.pos_int_vt_stateless_iter(arr1) do
        if get.arr.bool_by_contains(arr2, v) then
          new_arr[#new_arr + 1] = v
        end
      end
      return transf.arr.set(new_arr)
    end,
    set_by_difference = function(arr1, arr2)
      local new_arr = {}
      for _, v in transf.arr.pos_int_vt_stateless_iter(arr1) do
        if not get.arr.bool_by_contains(arr2, v) then
          new_arr[#new_arr + 1] = v
        end
      end
      return transf.arr.set(new_arr)
    end,
    set_by_symmetric_difference = function(arr1, arr2)
      local new_arr = {}
      for _, v in transf.arr.pos_int_vt_stateless_iter(arr1) do
        if not get.arr.bool_by_contains(arr2, v) then
          new_arr[#new_arr + 1] = v
        end
      end
      for _, v in transf.arr.pos_int_vt_stateless_iter(arr2) do
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
    line_arr_by_url_potentially_with_title_comment_arr = function(sgml_url_arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        sgml_url_arr,
        transf.url.line_by_url_potentially_with_title_comment
      )
    end,
    str_by_urls_potentially_with_comments = function(sgml_url_arr)
      return get.str_or_number_arr.str_by_joined(
        transf.url.url_potentially_with_title_comment_arr(sgml_url_arr),
        "\n"
      )
    end,
    leaflike_key_url_value_assoc = function(url_arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        url_arr,
        function(url)
          return 
            transf.url.leaflike_by_title_or_url_as_filename(url),
            url
        end
      )
    end,
  },
  plaintext_url_or_local_path_file = {

  },
  plaintext_file_arr = {
    str_arr_by_contents = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(arr, transf.plaintext_file.str_by_contents)
    end,
    line_arr = function(arr)
      return get.arr_arr.arr_by_mapped_w_t_arg_t_ret_fn_and_flatten(arr, transf.plaintext_file.line_arr)
    end,
    noempty_line_arr = function(arr)
      return get.arr_arr.arr_by_mapped_w_t_arg_t_ret_fn_and_flatten(arr, transf.plaintext_file.noempty_line_arr)
    end,
    m3u_file_arr = function(path_arr)
      return get.arr.arr_by_filtered(path_arr, is.plaintext_file.m3u_file)
    end,
    url_or_local_path_arr_by_m3u_file_content_lines = function(arr)
      return transf.plaintext_file_arr.noempty_line_arr(
        transf.plaintext_file_arr.m3u_file_arr(arr)
      )
    end,
    
  },
  event_table_arr = {
  },
  maildir_file_arr = {
    maildir_file_key_line_value_assoc_by_summary = function(maildir_file_arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        maildir_file_arr,
        transf.maildir_file.maildir_file_and_line_by_summary
      )
    end,
    maildir_file_key_decoded_email_value_assoc = function(maildir_file_arr)
      return get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        maildir_file_arr,
        transf.maildir_file.maildir_file_and_decoded_email
      )
    end,
  },
  stateless_iter = {
    arr_by_pack_individual = function(...)
      local res = {}
      for a1, a2, a3, a4, a5, a6, a7, a8, a9 in ... do
        dothis.arr.push(
          res,
          {a1, a2, a3, a4, a5, a6, a7, a8, a9}
        )
      end
      return res
    end,
    arr_by_take_first = function(...)
      local res = {}
      for a in ... do
        dothis.arr.push(
          res,
          a
        )
      end
      return res
    end,
  },
  stateful_iter = {
    arr_by_pack_individual = function(iter)
      local res = {}
      while true do
        local singleres = {iter()}
        if #singleres == 0 then
          break
        end
        dothis.arr.push(
          res,
          singleres
        )
      end
      return res
    end,
    arr_by_take_first = function(iter)
      local res = {}
      while true do
        local singleres = {iter()}
        if #singleres == 0 then
          break
        end
        dothis.arr.push(
          res,
          singleres[1]
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
    two_anys__arr = function(t)
      return get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
        t,
        transf.n_anys.arr
      )
    end,
    two_anys__arr_by_sorted_larger_key_first = function(t)
      return transf.arr_arr.arr_arr_by_sorted_larger_first_item(
        transf.table.two_anys__arr(t)
      )
    end,
    two_anys__arr_by_sorted_smaller_key_first = function(t)
      return transf.arr_arr.arr_arr_by_sorted_smaller_first_item(
        transf.table.two_anys__arr(t)
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
    kt_or_vt_arr = function(t)
      local res = {}
      for k, v in transf.table.kt_vt_stateless_iter(t) do
        res[#res + 1] = k
        res[#res + 1] = v
      end
      return res
    end,
    kt_arr_by_sorted_smaller_first = function(t)
      return get.table.kt_arr_by_sorted(t, transf.two_operational_comparables.bool_by_smaller)
    end,
    kt_arr_by_sorted_larger_first = function(t)
      return get.table.kt_arr_by_sorted(t, transf.two_operational_comparables.bool_by_larger)
    end,
    vt_arr_by_sorted_smaller_first = function(t)
      return get.table.vt_arr_by_sorted(t, transf.two_operational_comparables.bool_by_smaller)
    end,
    vt_arr_by_sorted_larger_first = function(t)
      return get.table.vt_arr_by_sorted(t, transf.two_operational_comparables.bool_by_larger)
    end,
    kt_vt_stateless_iter = pairs,
    table_by_2underscore_private = function(t)
      return get.table.table_by_filtered_w_kt_fn(
        t,
        transf.any.bool_by_starts_2underscore
      )
    end,
    table_by_underscore_private = function(t)
      return get.table.table_by_filtered_w_kt_fn(
        t,
        transf.any.bool_by_starts_underscore
      )
    end,
    table_by_no_2underscore_private = function(t)
      return get.table.table_by_filtered_w_kt_fn(
        t,
        transf.bool_ret_fn.bool_ret_fn_by_invert(
          transf.any.bool_by_starts_2underscore
        )
      )
    end,
    table_by_no_underscore_private = function(t)
      return get.table.table_by_filtered_w_kt_fn(
        t,
        transf.bool_ret_fn.bool_ret_fn_by_invert(
          transf.any.bool_by_starts_underscore
        )
      )
    end,
    table_by_no_any_underscore_private = function(t)
      return get.table.table_by_filtered_w_kt_fn(
        t,
        function (k)
          return not get.str.bool_by_startswith(k, "_")
        end
      )
    end,
    kt_vt_stateless_iter_by_no_2underscore_private = function(t)
      return transf.table.kt_vt_stateless_iter(
        transf.table.table_by_no_2underscore_private(t)
      )
    end,
    kt_vt_stateless_iter_by_2underscore_private = function(t)
      return transf.table.kt_vt_stateless_iter(
        transf.table.table_by_2underscore_private(t)
      )
    end,
    kt_vt_stateless_iter_by_no_underscore_private = function(t)
      return transf.table.kt_vt_stateless_iter(
        transf.table.table_by_no_underscore_private(t)
      )
    end,
    kt_vt_stateless_iter_by_underscore_private = function(t)
      return transf.table.kt_vt_stateless_iter(
        transf.table.table_by_underscore_private(t)
      )
    end,
    kt_vt_stateless_iter_by_no_any_underscore_private = function(t)
      return transf.table.kt_vt_stateless_iter(
        transf.table.table_by_no_any_underscore_private(t)
      )
    end,
    kt_vt_stateful_iter = get.stateless_generator.stateful_generator(transf.table.kt_vt_stateless_iter),
    kt_stateful_iter = get.stateless_generator.stateful_generator(transf.table.kt_vt_stateful_iter, 1, 1),
    vt_stateful_iter = get.stateless_generator.stateful_generator(transf.table.kt_vt_stateful_iter, 2, 2),
    toml_str = toml.encode,
    yaml_str_by_aligned = function(tbl)
      local tmp = transf.str.in_tmp_local_absolute_path(
        transf.not_userdata_or_fn.yaml_str(tbl),
        "shell-input"
      )
      transf.str.str_or_nil_by_evaled_env_bash_stripped("align " .. transf.str.str_by_single_quoted_escaped(tmp))
      local res = transf.yaml_file.not_userdata_or_fn(tmp)
      act.local_extant_path.delete(tmp)
      return res
    end,
    multiline_str_by_yaml_metadata = function(t)
      local str_contents = transf.not_userdata_or_str.yaml_str(t)
      return "---\n" .. str_contents .. "\n---\n"
    end,
    
    ics_str = function(t)
      local tmpdir_ics_path = transf.not_userdata_or_fn.in_tmp_local_absolute_path(t) .. ".ics"
      dothis.table.write_ics_file(t, tmpdir_ics_path)
      local contents = transf.file.str_by_contents(tmpdir_ics_path)
      act.absolute_path.delete(tmpdir_ics_path)
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
        is.table.only_pos_int_key_table
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
        is.table.only_pos_int_key_table
      )
    end,
    local_nonabsolute_path_key_assoc_by_primitive_and_arrlike_is_leaf = function(t)
      return get.table.str_key_assoc_by_joined(
        t,
        is.table.only_pos_int_key_table,
        "/"
      )
    end,
    str_key_assoc_by_joined_dot_notation_primitive_and_arrlike_is_leaf = function(t)
      return get.table.str_key_assoc_by_joined(
        t,
        is.table.only_pos_int_key_table,
        "."
      )
    end,
    
    arr_by_nested_final_key_label_by_primitive_and_arrlike_is_leaf = function(t)
      return transf.arr_arr.arr_by_map_to_last(
        get.table.arr_arr_by_key_label(
          t,
          is.table.only_pos_int_key_table
        )
      )
    end,
    arr_by_nested_value_primitive_and_arrlike_is_leaf = function(t)
      return transf.arr.arr_by_map_to_last(
        get.table.arr_arr_by_label_root_to_leaf(
          t,
          is.table.only_pos_int_key_table
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
      return #transf.table.two_anys__arr(t)
    end,
    query_mapping_arr = function(t)
      return get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
        t,
        transf.two_anys.query_mapping
      )
    end,
    query_str = function(t)
      return get.str_or_number_arr.str_by_joined(transf.assoc.query_mapping_arr(t), "&")
    end,
    --- @param t { [str]: str }
    --- @return str
    email_header = function(t)
      local header_lines = {}
      local initial_headers = ls.initial_headers
      for _, header_name in transf.arr.pos_int_vt_stateless_iter(initial_headers) do
        local header_value = t[header_name]
        if header_value then
          dothis.arr.insert_at_index(header_lines, transf.two_anys.decoded_email_header_line(header_name, header_value))
          t[header_name] = nil
        end
      end
      header_lines = transf.two_arrs.arr_by_appended(
        header_lines,
        get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
          transf.table.two_anys__arr_by_sorted_larger_key_first(t),
          transf.two_anys__arr.email_header
        )
      )
      return get.str_or_number_arr.str_by_joined(header_lines, "\n")
    end,
    curl_form_field_arr = function(t)
      return transf.arr_arr.arr_by_flatten(
        get.tbl.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
          t, 
          transf.two_anys.curl_form_field_args
        )
      )
    end,
    
    assoc_entry_str_arr = function(t)
      return get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
        t,
        transf.two_anys.str_by_assoc_entry
      )
    end,
    str_by_summary = function(t)
      return transf.str_arr.str_by_summary(
        transf.assoc.assoc_entry_str_arr(t)
      )
    end,
    str_by_indicated_summary = function(t)
      return "assoc (" .. transf.assoc.int_by_length(t) .. "): " .. transf.assoc.str_by_summary(t)
    end,
    str_by_line_summary = function(t)
      return get.str_or_number_arr.str_by_joined(transf.assoc.assoc_entry_str_arr(t), "\n")
    end,
    kt_key_vt_value_assoc_by_truthy_values = function(t)
      return get.table.table_by_filtered_w_kt_vt_fn(
        t,
        transf.any.bool
      )
    end,
    kt_arr_by_truthy_values = function(t)
      return transf.table_or_nil.kt_arr(transf.assoc.kt_key_vt_value_assoc_by_truthy_values(t))
    end,
    ini_kv_line_arr = function(t)
      return get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
        t,
        transf.two_anys.ini_kv_line
      )
    end,
    ini_section_contents_str = function(t)
      return get.str_or_number_arr.str_by_joined(
        transf.assoc.ini_kv_line_arr(t),
        "\n"
      )
    end,
  },
  table_arr = {
    table_by_take_new = function(t)
      local res = {}
      for _, tbl in transf.arr.pos_int_vt_stateless_iter(t) do
        for k, v in transf.table.stateless_key_value_iter(tbl) do
          res[k] = v
        end
      end
      return res
    end,
    table_by_take_old = function(t)
      local res = {}
      for _, tbl in transf.arr.pos_int_vt_stateless_iter(t) do
        for k, v in transf.table.stateless_key_value_iter(tbl) do
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
    str_key_str_or_assoc_assoc_by_split_space = function(tbl)
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
  str_key_bool_value_assoc = {
    str_arr_by_long_flags_for_truthies = function(assoc)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        transf.assoc.kt_arr_by_truthy_values(assoc),
        transf.str.str_by_long_flag
      )
    end,
    str_by_long_flags_for_truthies = function(assoc)
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
    arr_arr_by_swap_row_column = function(arr)
      return transf.stateful_iter.arr_by_take_first(
        transf.arr_arr.arr_pos_int_stateful_iter_by_columns(arr)
      )
    end,
    arr_by_flatten = plarray2d.flatten,
    set_by_flatten = function(arr)
      return transf.arr.set(transf.arr_arr.arr_by_flatten(arr))
    end,
    arr_pos_int_stateful_iter_by_columns = plarray2d.columns,
    set_arr = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.arr.set
      )
    end,
    arr_by_map_to_last = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(arr, transf.arr.t_by_last)
    end,
    arr_by_map_to_first = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(arr, transf.arr.t_by_first)
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
      return get.arr.arr_by_slice_w_3_int_any_or_nils(a_o_a[1], 1, last_matching_index)
    end,
    arr_arr_by_reverse_nested = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(arr, transf.arr.arr_by_reverse)
    end,
    arr_by_longest_common_suffix = function(arr)
      local reversed_res = transf.arr.arr_by_longest_common_prefix(
        transf.arr.reverse_mapped(arr)
      )
      return transf.arr_by_reversed.arr(reversed_res)
    end,
    arr_arr_by_cartesian_product = function(arr)
      return get.arr_arr.arr_arr_by_cartesian_product(arr, 1)
    end,
  },
  two_anys__arr_arr = {
    assoc = function(arr)
      local res = {}
      for _, two_anys__arr in transf.arr.pos_int_vt_stateless_iter(arr) do
        res[two_anys__arr[1]] = two_anys__arr[2]
      end
      return res
    end,
    assoc_by_reverse_nested = function(arr)
      return transf.two_anys__arr_arr.assoc(
        transf.arr_arr.arr_arr_by_reverse_nested(arr)
      )
    end,
  },
  two_strs__arr_arr = {
    
    role_content_message_spec_arr_by_alternating_user_assistant = function(arr)
      local res = {}
      for _, two_strs__arr in transf.arr.pos_int_vt_stateless_iter(arr) do
        dothis.arr.push(res, {
          role = "user",
          content = two_strs__arr[1],
        })
        dothis.arr.push(res, {
          role = "assistant",
          content = two_strs__arr[2],
        })
      end
      return res
    end,
    two_two_strs__arr_arrs_by_sep_note_and_tag = function(arr)
      return get.arr_arr.two_arr_arrs_by_filtered_nonfiltered_first_element_w_arr(
        arr,
        ls.note_key
      )
    end,
  },
  noempty_line_and_assoc = {
    ini_section_str = function(l,assoc)
      return "[" .. l .. "]\n" .. transf.assoc.ini_section_contents_str(assoc)
    end
  },
  str_and_assoc = {
    ini_section_str = function(l,assoc)
      return transf.noempty_line_and_assoc.ini_section_str(
        transf.str.noempty_trimmed_line_by_folded_or_default(l), assoc
      )
    end
  },
  any_and_assoc = {
    ini_section_str = function(l,assoc)
      return transf.str_and_assoc.ini_section_str(
        transf.any.str_by_replicable(l), assoc
      )
    end
  }, 
  assoc_value_assoc = {
    ini_str = function(t)
      return get.str_or_number_arr.str_by_joined(get.table.arr_by_mapped_w_kt_vt_arg_vt_ret_fn(
        t,
        transf.any_and_assoc.ini_section_str
      ), "\n\n")
    end,
  },
  noempty_trimmed_line_key_noempty_trimmed_line_key_assoc_value_assoc_value_assoc = {
    noempty_trimmed_line_key_assoc_value_assoc = function(t)
      local res = {}
      for label, assoc in transf.table.stateless_key_value_iter(t) do
        for k, v in transf.table.stateless_key_value_iter(assoc) do
          res[label .. " " .. k] = v
        end
      end
      return res
    end,
  },
  
  arr_value_assoc = {
    t_arr_by_flatten = function(arr)
      return transf.arr_arr.arr_by_flatten(transf.table.vt_arr(arr))
    end,
        
  },
  arr_value_assoc_arr = {
    arr_value_assoc_by_merge = function(arr)
      local res = {}
      for _, assoc in transf.arr.pos_int_vt_stateless_iter(arr) do
        for k, v in transf.table.stateless_key_value_iter(assoc) do
          res[k] = transf.two_arr_or_nils.arr(
            res[k],
            v
          )
        end
      end
      return res
    end,
  },
  timestamp_ms_key_assoc_value_assoc = {
    local_nonabsolute_path_key_timestamp_ms_key_assoc_value_assoc_by_ymd = function(timestamp_key_table)
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
      for _, chapter in transf.arr.pos_int_vt_stateless_iter(manga.chapters) do
        chapter_map[chapter.url] = {
          chapterNumber = chapter.chapterNumber,
          name = chapter.name
        }
      end
      local history_assoc = {}
      for _, hist_item in transf.arr.pos_int_vt_stateless_iter(manga.history) do
        local chapter = chapter_map[hist_item.url]
        history_assoc[hist_item.lastRead] = {
          url = manga_url,
          title = manga_title,
          chapter_number = chapter.chapterNumber,
          chapter_title = chapter.name,
          timestamp_ms = hist_item.lastRead
        }
      end
      return history_assoc
    end,
  },
  vdirsyncer_pair_specifier = {
    noempty_trimmed_line_key_noempty_trimmed_line_key_assoc_value_assoc_value_assoc = function(specifier)
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
    ini_str = function(specifier)
      return transf.assoc_value_assoc.ini_str(
        transf.noempty_trimmed_line_key_noempty_trimmed_line_key_assoc_value_assoc_value_assoc.noempty_trimmed_line_key_assoc_value_assoc(
          transf.vdirsyncer_pair_specifier.noempty_trimmed_line_key_noempty_trimmed_line_key_assoc_value_assoc_value_assoc(specifier)
        )
      )
    end
  },
  url_components = {
    url = function(comps)
      local url
      if comps.url then
        url = comps.url
      else
        if comps.nofragment_url then
          url = comps.nofragment_url
        else
          if comps.clean_url then
            url = comps.clean_url
          else
            if comps.base_url then
              url = comps.base_url
            else
              if comps.scheme then
                url = comps.scheme
              else
                url = "https://"
              end
              if comps.host then
                url = url .. get.str.str_by_with_suffix(comps.host, "/")
              end
            end
            if comps.endpoint then
              url = url .. (get.str.no_prefix_str(comps.endpoint, "/") or "/")
            end
          end
          if comps.params then
            if is.any.table(comps.params) then
              url = url .. "?" .. transf.assoc.query_str(comps.params)
            else
              url = url .. get.str.str_by_with_prefix(comps.params, "?")
            end
          end
        end
        if comps.fragment then
          url = "#" .. comps.fragment
        end
      end
      return url
    end,
  },
  query_str = {
    str_key_str_value_assoc = function(query_str)
      local params = {}
      local param_parts = get.str.not_empty_str_arr_by_split_w_ascii_char(query_str, "&")
      for _, param_part in transf.arr.pos_int_vt_stateless_iter(param_parts) do
        local param_parts = get.str.str_arr_by_split_w_ascii_char(param_part, "=")
        local key = transf.str.str_by_percent_decoded_also_plus(param_parts[1])
        local value = transf.str.str_by_percent_decoded_also_plus(param_parts[2])
        params[key] = value
      end
      return params
    end,
  },
  doi_url = {
    doi = function(url)
      return get.str.str_by_no_suffix(transf.url.local_absolute_path_or_nil_by_path_decoded(url), "/")
    end,
    indicated_doi = function(url)
      return transf.doi.indicated_doi(transf.doi_url.doi(url))
    end,
    csl_table_by_online = function(doilike)
      local doi = transf.doi_url.doi(doilike)
      return transf.doi.csl_table_by_online(doi)
    end,
  },
  indicated_doi = {
    doi = function(urnlike)
      return transf.indicated_citable_object_id.urlcharset_str_by_citable_object_id(urnlike)
    end,
    doi_url = function(urnlike)
      return transf.doi.doi_url(transf.indicated_doi.doi(urnlike))
    end,
    csl_table_by_online = function(urnlike)
      return transf.doi.csl_table_by_online(transf.indicated_doi.doi(urnlike))
    end,
  },
  doi = {
    doi_url = function(doi)
      return "https://doi.org/" .. doi
    end,
    indicated_doi = function(doi)
      return "doi:" .. doi
    end,
    bib_str_by_online = function(doi)
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
  },
  indicated_isbn = {
    csl_table_by_online = function(isbn)
      return transf.isbn.csl_table_by_online(transf.indicated_citable_object_id.urlcharset_str_by_citable_object_id(isbn))
    end,
  },
  isbn = {
    bib_by_online = function(isbn)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "isbn_meta" .. transf.str.str_by_single_quoted_escaped(isbn) .. " bibtex"
      )
    end,
    csl_table_by_online = function(isbn)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "isbn_meta" .. transf.str.str_by_single_quoted_escaped(isbn) .. " csl"
      )
    end,
    indicated_isbn = function(isbn)
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
        transf.str.urlcharset_str_by_encoded_query_param_part(id)
      )
    end,
    csl_table_by_local = function(id)
      return transf.filename_safe_indicated_citable_object_id.csl_table_or_nil(
        transf.str.urlcharset_str_by_encoded_query_param_part(id)
      )
    end,
    urlcharset_str_by_citable_object_id = function(id)
      return get.str.n_strs_by_extracted_onig(id, "^[^:]+:(.*)$")
    end,
    citable_object_id_indication_name = function(id)
      return get.str.str_arr_by_split_w_ascii_char(id, ":")[1]
    end,
    filename_safe_indicated_citable_object_id = function(id)
      return transf.str.urlcharset_str_by_encoded_query_param_part(id)
    end,
    csl_table_by_online = function(id)
      return transf[
        "indicated_" .. transf.indicated_citable_object_id.citable_object_id_indication_name(id)
      ].csl_table_by_online(
        transf.indicated_citable_object_id.urlcharset_str_by_citable_object_id(id)
      )
    end,
    mpapers_citable_object_file = function(id)
      return transf.filename_safe_indicated_citable_object_id.mpapers_citable_object_file_or_nil(
        transf.str.urlcharset_str_by_encoded_query_param_part(id)
      )
    end,
    mpapernotes_citable_object_notes_file = function(id)
      return transf.filename_safe_indicated_citable_object_id.mpapernotes_citable_object_notes_file_or_nil(
        transf.str.urlcharset_str_by_encoded_query_param_part(id)
      )
    end,
    noempty_noindent_hashcomment_line_by_for_citations_file = function(id)
      return transf.csl_table.noempty_noindent_hashcomment_line_by_for_citations_file(
        transf.indicated_citable_object_id.csl_table_by_local(id)
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
      return get.local_extant_path.absolute_path_or_nil_by_descendant_with_filename_ending(env.MCITATIONS, id)
    end,
    csl_table_or_nil = function(id)
      local path = transf.filename_safe_indicated_citable_object_id.mcitations_csl_file_or_nil(id)
      if path then
        return transf.json_file.not_userdata_or_fn(
          path
        )
      else
        return nil
      end
    end,
    mpapers_citable_object_file_or_nil = function(id)
      return get.local_extant_path.absolute_path_or_nil_by_descendant_with_filename_ending(env.MPAPERS, id)
    end,
    mpapernotes_citable_object_notes_file_or_nil = function(id)
      return get.local_extant_path.absolute_path_or_nil_by_descendant_with_filename_ending(env.MPAPERNOTES, id)
    end,
  },
  citable_filename = {
    filename_safe_indicated_citable_object_id = function(filename)
      return get.str.str_arr_by_split_w_str(filename, "!citid:")[2]
    end,
    indicated_citable_object_id = function(filename)
      return transf.filename_safe_indicated_citable_object_id.indicated_citable_object_id(transf.citable_filename.filename_safe_indicated_citable_object_id(filename))
    end,
    csl_table_by_local = function(filename)
      return transf.indicated_citable_object_id.csl_table_by_local(
        transf.citable_filename.indicated_citable_object_id(filename)
      )
    end,
  },
  citable_path = {
    filename_safe_indicated_citable_object_id = function(path)
      return transf.citable_filename.filename_safe_indicated_citable_object_id(
        transf.path.leaflike_by_filename(path)
      )
    end,
    indicated_citable_object_id = function(path)
      return transf.citable_filename.indicated_citable_object_id(
        transf.path.leaflike_by_filename(path)
      )
    end,
    csl_table = function(path)
      return transf.citable_filename.csl_table_by_local(
        transf.path.leaflike_by_filename(path)
      )
    end,
  },
  citable_path_arr = {
    csl_table_arr = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(arr, transf.citable_path.csl_table)
    end,
    indicated_citable_object_id_arr = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(arr, transf.citable_path.indicated_citable_object_id)
    end,
  },
  mpapers_citable_object_file ={ -- file with a citable_filename containing the data (e.g. pdf) of a citable object

  },
  citations_file = { -- plaintext file containing one indicated_citable_object_id per line
    indicated_citable_object_id_arr = function(file)
      return transf.plaintext_file.noempty_noindent_nohashcomment_line_arr(file)
    end,
    csl_table_arr_by_local = function(file)
      return transf.indicated_citable_object_id_arr.csl_table_arr_by_local(
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
    csl_table_arr_by_local = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.indicated_citable_object_id.csl_table_by_local
      )
    end,
    bib_str = function(arr)
      return transf.csl_table_arr.bib_str(
        transf.indicated_citable_object_id_arr.csl_table_arr_by_local(
          arr
        )
      )
    end,
    json_str = function(arr)
      return transf.csl_table_arr.json_str(
        transf.indicated_citable_object_id_arr.csl_table_arr_by_local(
          arr
        )
      )
    end,
    noempty_noindent_hashcomment_line_arr_by_for_citations_file = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        transf.indicated_citable_object_id_arr.csl_table_arr_by_local(arr),
        transf.csl_table.noempty_noindent_hashcomment_line_by_for_citations_file
      )
    end,
    str_by_for_citations_file = function(arr)
      return get.str_or_number_arr.str_by_joined(
        transf.indicated_citable_object_id_arr.noempty_noindent_hashcomment_line_arr_by_for_citations_file(arr), 
        "\n"
      )
    end
  },
  latex_project_dir = {
    citations_file = function(dir)
      return transf.path.path_by_ending_with_slash(dir) .. "citations"
    end,
    local_absolute_path_by_main_tex_file = function(dir)
      return transf.path.path_by_ending_with_slash(dir) .. "main.tex"
    end,
    local_absolute_path_by_main_pdf_file = function(dir)
      return transf.path.path_by_ending_with_slash(dir) .. "main.pdf"
    end,
    local_absolute_path_by_main_bib_file = function(dir)
      return transf.path.path_by_ending_with_slash(dir) .. "main.bib"
    end,
    indicated_citable_object_id_arr_by_from_citations = function(dir)
      return transf.citations_file.indicated_citable_object_id_arr(
        transf.latex_project_dir.citations_file(dir)
      )
    end,
    csl_table_arr_by_from_citations = function(dir)
      return transf.citations_file.csl_table_arr_by_local(
        transf.latex_project_dir.citations_file(dir)
      )
    end,
    bib_str_by_from_citations = function(dir)
      return transf.citations_file.bib_str(
        transf.latex_project_dir.citations_file(dir)
      )
    end,
  },
  client_project_dir = {
    yaml_file_by_metadata_file = function(dir)
      return transf.path.path_by_ending_with_slash(dir) .. "client_project_data.yaml"
    end,
    assoc_by_metadata = function(dir)
      return transf.yaml_file.not_userdata_or_fn(
        transf.client_project_dir.yaml_file_by_metadata_file(dir)
      )
    end,
    client_id_by_client = function(dir)
      return transf.client_project_dir.assoc_by_metadata(dir).client
    end,
    contact_uuid_by_client = function(dir)
      return fstblmap.client_id.contact_uuid(
        transf.client_project_dir.client_id_by_client(dir)
      )
    end,
    contact_table_by_client = function(dir)
      return transf.uuid.contact_table_or_nil(
        transf.client_project_dir.contact_uuid_by_client(dir)
      )
    end,
    -- this will often be unset, since I'll default to my uuid within creator_contact_uuid
    client_id_by_creator = function(dir)
      return transf.client_project_dir.assoc_by_metadata(dir).creator
    end,
    contact_uuid_by_creator = function(dir)
      if transf.client_project_dir.client_id_by_creator(dir) then
        return fstblmap.client_id.contact_uuid(
          transf.client_project_dir.client_id_by_creator(dir)
        )
      else
        return env.SELF_UUID
      end
    end,
    line_by_main_name_client = function(dir)
      return transf.contact_table.line_by_main_name(
        transf.client_project_dir.contact_table_by_client(dir)
      )
    end,
    multiline_str_by_relevant_address_label_client = function(dir)
      return transf.contact_table.multiline_str_by_relevant_address_label(
        transf.client_project_dir.contact_table_by_client(dir)
      )
    end,
    line_by_main_name_creator = function(dir)
      return transf.contact_table.line_by_main_name(
        transf.client_project_dir.creator_contact_table(dir)
      )
    end,
    multiline_str_by_relevant_address_label_creator = function(dir)
      return transf.contact_table.multiline_str_by_relevant_address_label(
        transf.client_project_dir.creator_contact_table(dir)
      )
    end,
    multiline_str_by_name_bank_details_creator = function(dir)
      return transf.contact_table.multiline_str_by_name_bank_details(
        transf.client_project_dir.creator_contact_table(dir)
      )
    end,
    client_project_kind = function(dir)
      if is.project_dir.omegat_project_dir(dir) then
        return "translation"
      else
        error("unknown client project kind")
      end
    end,
    line_or_nil_by_tax_number = function(dir)
      return get.contact_table.line_or_nil_by_tax_number(
        transf.client_project_dir.creator_contact_table(dir),
        transf.client_project_dir.client_project_kind(dir)
      )
    end,
    number_or_nil_by_client_rate = function(dir)
      return get.contact_table.number_or_nil_by_rate(
        transf.client_project_dir.contact_table_by_client(dir),
        transf.client_project_dir.client_project_kind(dir)
      )
    end,
    number_or_nil_by_creator_rate = function(dir)
      return get.contact_table.number_or_nil_by_rate(
        transf.client_project_dir.creator_contact_table(dir),
        transf.client_project_dir.client_project_kind(dir)
      )
    end,
    number_or_nil_by_project_rate = function(dir)
      return 
      transf.client_project_dir.assoc_by_metadata(dir).rate 
    end,

    number_by_rate = function(dir)
      return 
      transf.client_project_dir.number_or_nil_by_project_rate(dir)
      or transf.client_project_dir.number_or_nil_by_client_rate(dir)
      or transf.client_project_dir.number_or_nil_by_creator_rate(dir)
      or 0
    end,
    alphanum_minus_underscore_by_rechnung_id = function(dir)
      return
      transf["nil"].rfc3339like_ymd_by_current() .. "--" ..
      transf.client_project_dir.client_id_by_client(dir):lower() .. "-" ..
      transf.client_project_dir.pos_int_by_rechnung_index(dir)
    end,
    pos_int_by_rechnung_index = function(dir)
      return transf.client_project_dir.assoc_by_metadata(dir).rechnung_index
    end,
    rfc3339like_ymd_by_delivery_date = function(dir)
      return transf.client_project_dir.assoc_by_metadata(dir).delivery_date
    end,
    local_absolute_path_by_rechnung_pdf = function(dir)
      return transf.path.path_by_ending_with_slash(dir) .. transf.client_project_dir.alphanum_minus_underscore_by_rechnung_id(dir) .. ".pdf"
    end,
    local_absolute_path_by_rechnung_md = function(dir)
      return transf.path.path_by_ending_with_slash(dir) .. transf.client_project_dir.alphanum_minus_underscore_by_rechnung_id(dir) .. ".md"
    end,
    line_by_kind_plaintext_name_de = function(dir)
      if #transf.client_project_dir.pos_int_arr_by_amount_billing_unit(dir) > 1 then
        return tblmap.client_project_kind.iso_639_1_language_code_key_line_value_assoc_by_plaintext_name_pl[
          transf.client_project_dir.client_project_kind(dir)
        ].de
      else 
        return tblmap.client_project_kind.iso_639_1_language_code_key_line_value_assoc_by_plaintext_name_sg[
          transf.client_project_dir.client_project_kind(dir)
        ].de
      end
    end,
    multiline_str_by_rechnung_email_de = function(dir)
      return get.str.str_by_evaled_as_template(lemap.rechnung_email.de, dir)
    end,
    email_specifier_by_rechnung_de = function(dir)
      return {
        body = transf.client_project_dir.multiline_str_by_rechnung_email_de(dir),
        non_inline_attachment_local_file_arr = {
          transf.client_project_dir.local_absolute_path_by_rechnung_pdf(dir)
        }
      }
    end,
    multiline_str_by_raw_rechnung_de = function(dir)
      return get.str.str_by_evaled_as_template(lemap.translation.rechnung_de, dir)
    end,
    billing_unit = function(dir)
      return tblmap.client_project_kind.billing_unit[
        transf.client_project_dir.client_project_kind(dir)
      ]
    end,
    pos_int_arr_by_amount_billing_unit = function(dir)
      return  transf[
        transf.client_project_dir.client_project_kind(dir) .. "_project_dir"
      ].pos_int_arr_by_amount_billing_unit(dir)
    end,
    price_specifier_arr = function(dir)
      local pos_int_arr = transf.client_project_dir.pos_int_arr_by_amount_billing_unit(dir)
      local rate = transf.client_project_dir.number_by_rate(dir)
      local unit = transf.client_project_dir.billing_unit(dir)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        pos_int_arr,
        function(pos_int)
          return {
            rate = rate,
            unit = unit,
            amount = pos_int,
            price = pos_int * rate,
          }
        end
      )
    end,
    total_cost_specifier = function(dir)
      return transf.price_specifier_arr.total_cost_specifier(
        transf.client_project_dir.price_specifier_arr(dir)
      )
    end,
    multiline_str_by_price_block_german = function(dir)
      return transf.total_cost_specifier.multiline_str_by_price_block_german(
        transf.client_project_dir.total_cost_specifier(dir)
      )
    end,

  },
  omegat_project_dir = {
   

    local_extant_path_by_dictionary_dir = function(dir)
      return transf.path.path_by_ending_with_slash(dir) .. "dictionary"
    end,
    local_extant_path_by_glossary_dir = function(dir)
      return transf.path.path_by_ending_with_slash(dir) .. "glossary"
    end,
    local_extant_path_by_omegat_dir = function(dir)
      return transf.path.path_by_ending_with_slash(dir) .. "omegat"
    end,
    local_extant_path_by_source_dir = function(dir)
      return transf.path.path_by_ending_with_slash(dir) .. "source"
    end,
    local_extant_path_by_target_dir = function(dir)
      return transf.path.path_by_ending_with_slash(dir) .. "target"
    end,
    local_extant_path_by_target_txt_dir = function(dir)
      return transf.path.path_by_ending_with_slash(dir) .. "target_txt"
    end,
    local_extant_path_by_tm_dir = function(dir)
      return transf.path.path_by_ending_with_slash(dir) .. "tm"
    end,
    file_arr_by_source = function(dir)
      return transf.dir.absolute_path_arr_by_children(
        transf.omegat_project_dir.local_extant_path_by_source_dir(dir)
      )
    end,
    file_arr_by_target = function(dir)
      return transf.dir.absolute_path_arr_by_children(
        transf.omegat_project_dir.local_extant_path_by_target_dir(dir)
      )
    end,
    local_absolute_path_by_resultant_tm = function(dir)
      return transf.omegat_project_dir.local_extant_path_by_tm_dir(dir) .. "/" .. transf.path.leaflike_by_leaf(dir) .. "-omegat.tmx"
    end,
    pos_int_arr_by_amount_billing_unit = function(dir)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        transf.dir.absolute_path_arr_by_children(
          transf.omegat_project_dir.local_extant_path_by_target_txt_dir(dir)
        ),
        transf.plaintext_file.pos_int_by_normzeilen
        
      )
    end,

  },
  price_specifier_arr = {
    total_cost_specifier = function(arr)
      return {
        price_specifier_arr = arr,
        total = hs.fnutils.reduce(
          arr,
          function(acc, v) return acc + v.price end,
          0
        )
      }
    end
  },
  total_cost_specifier = {
    multiline_str_by_price_block_german = function(spec)
      return 
        get.str_or_number_arr.str_by_joined(
          get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
            spec.price_specifier_arr,
            function(v)
              return ("%d %s @ %.2f€ = %d€"):format(
                v.amount,
                tblmap.billing_unit.iso_639_1_language_code_key_line_value_assoc[v.unit].de,
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
      local arr = get.assoc_arr_arr.path_key_haver_arr_by_take_last(
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
      return transf.bundle_id.hs_image_by_icon(
        transf.running_application.bundle_id(app)
      )
    end
  },
  window = {
    running_application = function(window)
      return window:application()
    end,
    line_by_title = function(window)
      return window:title()
    end,
    line_by_filtered_title = function(window)
      return transf.window.line_by_title(window):gsub(" - " .. transf.window.mac_application_name(window), "")
    end,
    mac_application_name = function(window)
      return transf.running_application.mac_application_name(
        transf.window.running_application(window)
      )
    end,
    hs_image_by_screenshot = function(window)
      return window:snapshot()
    end,
    ax_uielement = function(window)
      return hs.axuielement.windowElement(window)
    end,
    hs_geometry_rect = function(window)
      return window:frame()
    end,
    hs_geometry_point_by_tl = function(window)
      return window:topLeft()
    end,
    hs_geometry_point_by_tr = function(window)
      local rect = transf.window.hs_geometry_rect(window)
      rect.x = rect.x + rect.w -- move by width
      return rect.topleft -- new top left is old top right
    end,
    hs_geometry_point_by_bl = function(window)
      local rect = transf.window.hs_geometry_rect(window)
      rect.y = rect.y + rect.h -- move by height
      return rect.topleft -- new top left is old bottom left
    end,
    hs_geometry_point_by_br = function(window)
      return transf.window.hs_geometry_rect(window).bottomright
    end,
    hs_geometry_size = function(window)
      return window:size()
    end,
    hs_geometry_point_by_relative_center = function(window)
      return transf.window.hs_geometry_size(window).center
    end,
    hs_geometry_point_by_c = function(window)
      return transf.window.hs_geometry_rect(window).center
    end,
    line_by_summary = function(window)
      return get.str.str_by_formatted_w_n_anys(
        "%s (%s)",
        transf.window.line_by_title(window),
        transf.window.mac_application_name(window)
      )
    end,
    hs_screen = function(window)
      return window:screen()
    end,
    hs_image_by_app_icon = function(window)
      return transf.running_application.icon_hs_image(
        transf.window.running_application(window)
      )
    end,
    pos_int_by_native_window_index = function(window)
      local running_application = transf.window.running_application(window)
      local window_arr = transf.running_application.window_arr(running_application)
      return get.arr.pos_int_or_nil_by_first_match_w_fn(
        window_arr,
        function(v)
          return v:id() == window:id()
        end
      )
    end,
    pos_int_by_jxa_window_index = function(window)
      return get.str.any_by_evaled_js_osa(
        "Application('" .. transf.window.mac_application_name(window) .. "')" ..
          ".windows().findIndex(" ..
            "window => window.title() == '" .. transf.window.line_by_filtered_title(window) .. "'" ..
          ")"
      )
    end,
    jxa_window_specifier = function(window)
      return {
        application_name = transf.window.mac_application_name(window),
        window_index = transf.window.pos_int_by_jxa_window_index(window)
      }
    end,
  },
  window_filter = {
    window_arr = function(window_filter)
      return window_filter:getWindows()
    end,
  },
  jxa_windowlike_specifier = {
    line_by_title = function(window_spec)
      return get.jxa_windowlike_specifier.any_by_property(window_spec, "title")
    end,
    window = function(window_spec)
      return get.running_application.window_by_title(
        transf.jxa_windowlike_specifier.line_by_title(window_spec) .. " - " .. 
        window_spec.application_name
      )
    end,
    line_by_filtered_title = function(window_spec)
      return transf.window.line_by_filtered_title(
        transf.jxa_windowlike_specifier.window(window_spec)
      )
    end,
    mac_application_name = function(tab_spec)
      return tab_spec.application_name
    end,
    running_application = function(tab_spec)
      return transf.mac_application_name.running_application_or_nil(
        tab_spec.application_name
      )
    end,
    pos_int_by_window_index = function(tab_spec)
      return tab_spec.window_index
    end,
  },
  tabbable_jxa_windowlike_specifier = {
    pos_int_by_amount_of_tabs = function(window_spec)
      return get.str.any_by_evaled_js_osa( 
        "Application('" .. window_spec.application_name .. "')" ..
          ".windows().[" ..
            window_spec.window_index ..
          "].tabs().length"
      )
    end,
    jxa_tab_specifier_arr = function(window_spec)
      local tab_spec_arr = {}
      for i = 0, transf.tabbable_jxa_windowlike_specifier.pos_int_by_amount_of_tabs(window_spec) - 1 do
        dothis.arr.insert_at_index(tab_spec_arr, {
          application_name = window_spec.application_name,
          window_index = window_spec.window_index,
          tab_index = i
        })
      end
      return tab_spec_arr
    end,
    pos_int_by_active_tab_index = function(window_spec)
      return get.str.any_by_evaled_js_osa( 
        "Application('" .. window_spec.application_name .. "')" ..
          ".windows().[" ..
            window_spec.window_index ..
          "].activeTabIndex()"
      )
    end,
    jxa_tab_specifier_by_active = function(window_spec)
      return get.tabbable_jxa_window_specifier.jxa_tab_specifier(
        window_spec,
        transf.tabbable_jxa_windowlike_specifier.pos_int_by_active_tab_index(window_spec)
      )
    end,
  },
  browser_tabbable_jxa_window_specifier = {
    url = function(window_spec)
      return transf.browser_jxa_tab_specifier.url(
        transf.tabbable_jxa_windowlike_specifier.jxa_tab_specifier_by_active(window_spec)
      )
    end
  },
  jxa_tab_specifier = {
    pos_int_by_tab_index = function(tab_spec)
      return tab_spec.tab_index
    end,
    line_by_title = function(tab_spec)
      return get.jxa_tab_specifier.any_by_property(tab_spec, "title")
    end,
    tabbable_jxa_window_specifier = function(tab_spec)
      return {
        application_name = tab_spec.application_name,
        window_index = tab_spec.window_index
      }
    end,
  },
  browser_jxa_tab_specifier = {
    url = function(tab_spec)
      return get.jxa_tab_specifier.any_by_property(tab_spec, "url")
    end,
  },
  bundle_id = {
    hs_image_by_icon = function(bundle_id)
      return hs.image.imageFromAppBundle(bundle_id)
    end,
  },
  mac_application_name = {
    local_absolute_path_by_application_support_dir = function(app_name)
      return env.MAC_APPLICATION_SUPPORT .. "/" .. app_name
    end,
    installed_app_dir = function(app_name)
      return "/Applications/" .. app_name .. ".app"
    end,
    running_application_or_nil = function(app_name)
      return hs.application.get(app_name)
    end,
    bool_by_running_application = function(app_name)
      return transf.mac_application_name.running_application_or_nil(app_name) ~= nil
    end,
    running_application_by_ensure = function(app_name)
      local app = transf.mac_application_name.running_application_or_nil(app_name)
      if app == nil then
        return hs.application.open(app_name, 5)
      end
      return app
    end,
    menu_item_table_arr = function(app_name)
      return transf.running_application.menu_item_table_arr(transf.mac_application_name.running_application_or_nil(app_name))
    end,
    
  },
  bib_str = {
    csl_table_arr = function(str)
      return transf.str.table_or_err_by_evaled_env_bash_parsed_json("pandoc -f biblatex -t csljson" .. transf.str.here_doc(str))
    end,
    url_arr = function(str)
      return transf.csl_table_arr.url_arr(
        transf.bib_str.csl_table_arr(str)
      )
    end
  },
  csl_table_arr = {
    bib_str_arr = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
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
    json_str = transf.not_userdata_or_fn.json_str,
    indicated_citable_object_id_arr = function(arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        arr,
        transf.csl_table.indicated_citable_object_id
      )
    end,
    citations_file_str = function(arr)
      return transf.indicated_citable_object_id_arr.str_by_for_citations_file(
        transf.csl_table_arr.indicated_citable_object_id_arr(arr)
      )
    end,
    url_arr = function(csl_table_arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(csl_table_arr, transf.csl_table.url_or_nil)
    end,

  },
  csl_table_or_csl_table_arr = {
    url_arr = function(csl_table_or_csl_table_arr)
      if is.any.arr(csl_table_or_csl_table_arr) then
        return transf.csl_table_arr.url_arr(csl_table_or_csl_table_arr)
      else
        return {transf.csl_table.url_or_nil(csl_table_or_csl_table_arr)}
      end
    end,
  },
  csl_table = {
    str_or_nil_by_main_title = function(csl_table)
      return get.assoc.vt_by_first_match_w_kv_arr(csl_table, ls.csl_title_keys)
    end,
    dtprts__arr_arr_by_issued = function(csl_table)
      return csl_table.issued
    end,
    rfc3339like_dt_or_interval_by_issued = function(csl_table)
      return transf.dtprts__arr_arr.rfc3339like_dt_or_interval(
        transf.csl_table.dtprts__arr_arr_by_issued(csl_table)
      )
    end,
    rfc3339like_dt_by_issued_force_first = function(csl_table)
      return transf.dtprts__arr_arr.rfc3339like_dt_force_first(
        transf.csl_table.dtprts__arr_arr_by_issued(csl_table)
      )
    end,
    timestamp_s_by_issued_force_first = function(csl_table)
      return transf.dtprts__arr_arr.timestamp_s_by_force_first(
        transf.csl_table.dtprts__arr_arr_by_issued(csl_table)
      )
    end,
    issued_prefix_partial_dcmp_spec_force_first = function(csl_table)
      return transf.dtprts__arr_arr.prefix_partial_dcmp_spec_by_force_first(
        transf.csl_table.dtprts__arr_arr_by_issued(csl_table)
      )
    end,
    issued_year_force_first = function(csl_table)
      return transf.csl_table.issued_prefix_partial_dcmp_spec_force_first(csl_table).year
    end,
    csl_person_arr_by_author = function(csl_table)
      return csl_table.author
    end,
    line_by_naive_author_summary = function(csl_table)
      return get.str_or_number_arr.str_by_joined(
        get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
          transf.csl_table.csl_person_arr_by_author(csl_table),
          transf.csl_person.line_by_name_naive
        ),
        ", "
      )
    end,
    line_arr_by_author_family = function(csl_table)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        transf.csl_table.csl_person_arr_by_author(csl_table),
        transf.csl_person.line_or_nil_by_family
      )
    end,
    line_arr_by_author_family_et_al = function(csl_table)
      return get.arr.arr_by_slice_removed_indicator_and_flatten_w_cut_specifier(
        transf.csl_table.line_arr_by_author_family(csl_table),
        { stop = 5 },
        "et_al"
      )
    end,
    line_by_author_family_et_al = function(csl_table)
      return get.str_or_number_arr.str_by_joined(
        transf.csl_table.line_arr_by_author_family_et_al(csl_table),
        ", "
      )
    end,
    lower_strict_snake_case_by_main_title_filenamized = function(csl_table)
      return transf.str.lower_strict_snake_case(
        transf.csl_table.str_or_nil_by_main_title(csl_table) or "Untitled work"
      )
    end,
    leaflike_by_filename = function(csl_table)
      return get.str.str_by_sub_lua(
        get.str_or_number_arr.str_by_joined(
          {
            transf.csl_table.line_by_author_family_et_al(csl_table),
            get.csl_table.pos_int_by_key_year_force_first(csl_table, "issued"),
            transf.csl_table.lower_strict_snake_case_by_main_title_filenamized(csl_table)
          },
          "__"
        ),
        1,
        200 -- max filename length, with some space for other stuff
      )
    end,
    digit_str_or_nil_by_volume = function(csl_table)
      return csl_table.volume
    end,
    printable_ascii_no_nonspace_whitespace_str_or_nil_by_indicated_volume = function(csl_table)
      local volume = transf.csl_table.digit_str_or_nil_by_volume(csl_table)
      if volume then
        return "vol. " .. volume
      end
    end,
    digit_str_or_nil_by_issue = function(csl_table)
      return csl_table.issue
    end,
    printable_ascii_no_nonspace_whitespace_str_or_nil_by_indicated_issue = function(csl_table)
      local issue = transf.csl_table.issue(csl_table)
      if issue then
        return "no. " .. issue
      end
    end,
    digit_str_or_digit_interval_str_or_nil_by_page = function(csl_table)
      return csl_table.page
    end,
    int_interval_specifier_by_page = function(csl_table)
      return transf.digit_str_or_digit_interval_str.int_interval_specifier(
        transf.csl_table.digit_str_or_digit_interval_str_or_nil_by_page(csl_table)
      )
    end,
    int_sequence_specifier_by_page = function(csl_table)
      return get.interval_specifier.sequence_specifier(
        transf.csl_table.int_interval_specifier_by_page(csl_table),
        1 -- afaik there is never a case where pages don't increase by 1 (there is no notation that says 'every other page', for example)
      )
    end,
    indicated_page_str = function(csl_table)
      local page = transf.csl_table.digit_str_or_digit_interval_str_or_nil_by_page(csl_table)
      if page then
        if get.str.bool_by_contains_w_str(page, "-") then
          return "pp. " .. page
        else
          return "p. " .. page
        end
      end
    end,
    str_by_title = function(csl_table)
      return csl_table.title
    end,
    csl_type = function(csl_table)
      return csl_table.type
    end,
    doi_or_nil = function(csl_table)
      return csl_table.doi
    end,
    indicated_doi_or_nil = function(csl_table)
      local doi = transf.csl_table.doi_or_nil(csl_table)
      if doi then
        return "doi:" .. doi
      end
    end,
    isbn_or_nil = function(csl_table)
      return csl_table.isbn
    end,
    indicated_isbn_or_nil = function(csl_table)
      local isbn = transf.csl_table.isbn_or_nil(csl_table)
      if isbn then
        return "isbn:" .. isbn
      end
    end,
    digit_str_or_nil_by_chapter = function(csl_table)
      return csl_table.chapter
    end,
    line_by_publisher = function(csl_table)
      return transf.str_or_nil.line_or_nil_by_folded(csl_table.publisher)
    end,
    line_by_publisher_place = function(csl_table)
      return transf.str_or_nil.line_or_nil_by_folded(csl_table["publisher-place"])
    end,
    isbn_part_identifier = function(csl_table)
      local isbn_part_identifier = transf.csl_table.isbn_or_nil(csl_table)
      if csl_table.chapter then
        isbn_part_identifier = isbn_part_identifier .. "::c=" .. csl_table.chapter
      elseif csl_table.page then
        isbn_part_identifier = isbn_part_identifier .. "::p=" .. csl_table.page
      else
        return nil
      end
      return isbn_part_identifier
    end,
    indicated_isbn_part = function(csl_table)
      local isbn_part_identifier = transf.csl_table.isbn_part_identifier(csl_table)
      if isbn_part_identifier then
        return "isbn_part:" .. isbn_part_identifier
      end
    end,
    issn_or_nil = function(csl_table)
      return csl_table.ISSN
    end,
    issn_full_identifier_or_nil = function(csl_table)
      local issn_full_identifier = transf.csl_table.issn_or_nil(csl_table)
      if csl_table.volumen and csl_table.issue then
        return issn_full_identifier .. "::" .. csl_table.volume .. "::" .. csl_table.issue
      else
        return nil
      end
    end,
    indicated_issn_full_or_nil = function(csl_table)
      local issn_full_identifier = transf.csl_table.issn_full_identifier_or_nil(csl_table)
      if issn_full_identifier then
        return "issn_full:" .. issn_full_identifier
      end
    end,
    urlcharset_str_or_nil_by_pmid = function(csl_table)
      return csl_table.pmid
    end,
    indicated_pmid_or_nil = function(csl_table)
      local pmid = transf.csl_table.urlcharset_str_or_nil_by_pmid(csl_table)
      if pmid then
        return "pmid:" .. pmid
      end
    end,
    urlcharset_str_or_nil_by_pmcid = function(csl_table)
      return csl_table.pmcid
    end,
    indicated_pmcid_or_nil = function(csl_table)
      local pmcid = transf.csl_table.urlcharset_str_or_nil_by_pmcid(csl_table)
      if pmcid then
        return "pmcid:" .. pmcid
      end
    end,
    url_or_nil = function(csl_table)
      return csl_table.URL
    end,
    hex_str_or_nil_by_urlmd5 = function(csl_table)
      local url = transf.csl_table.url_or_nil(csl_table)
      if url then
        return transf.not_userdata_or_fn.hex_str_by_md5(url)
      end
    end,
    indicated_urlmd5_or_nil = function(csl_table)
      local urlmd5 = transf.csl_table.hex_str_or_nil_by_urlmd5(csl_table)
      if urlmd5 then
        return "urlmd5:" .. urlmd5
      end
    end,
    urlcharset_str_or_nil_by_accession = function(csl_table)
      return csl_table.accession
    end,
    indicated_accession_or_nil = function(csl_table)
      local accession = transf.csl_table.urlcharset_str_or_nil_by_accession(csl_table)
      if accession then
        return "accession:" .. accession
      end
    end,
    indicated_citable_object_id = function(csl_table)
      if csl_table.doi then
        return transf.csl_table.indicated_doi_or_nil(csl_table)
      elseif csl_table.isbn and is.csl_table.whole_book_csl_table(csl_table) then
        return transf.csl_table.indicated_isbn_or_nil(csl_table)
      elseif csl_table.isbn and not is.csl_table.whole_book_csl_table(csl_table) then
        return transf.csl_table.indicated_isbn_part(csl_table)
      elseif csl_table.pmid then
        return transf.csl_table.indicated_pmid_or_nil(csl_table)
      elseif csl_table.pmcid then
        return transf.csl_table.indicated_pmcid_or_nil(csl_table)
      elseif csl_table.accession then
        return transf.csl_table.indicated_accession_or_nil(csl_table)
      elseif transf.csl_table.issn_full_identifier_or_nil(csl_table) then
        return transf.csl_table.indicated_issn_full_or_nil(csl_table)
      elseif csl_table.url then
        return transf.csl_table.indicated_urlmd5_or_nil(csl_table)
      else
        return nil
      end
    end,
    noempty_noindent_hashcomment_line_by_for_citations_file = function(csl_table)
      return transf.csl_table.indicated_citable_object_id(csl_table) 
      .. " # " .. transf.csl_table.str_by_apa_citation(csl_table)
    end,
    filename_safe_indicated_citable_object_id = function(csl_table)
      return transf.indicated_citable_object_id.filename_safe_indicated_citable_object_id(transf.csl_table.indicated_citable_object_id(csl_table))
    end,
    citable_filename = function(csl_table)
      return 
        transf.csl_table.leaflike_by_filename(csl_table) ..
        "!citid:" .. transf.csl_table.filename_safe_indicated_citable_object_id(csl_table)
    end,
    bib_str = function(csl_table)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        "pandoc -f csljson -t biblatex" .. transf.str.here_doc(transf.not_userdata_or_fn.json_str(csl_table))
      )
    end,
    str_by_apa_citation = function(csl_table)
      return get.csl_table_or_csl_table_arr.str_by_raw_citation(csl_table, "apa-6th-edition")
    end,
  },
  csl_person = {
    line_or_nil_by_family = function(csl_person)
      return transf.str_or_nil.line_or_nil_by_folded(csl_person.family)
    end,
    line_or_nil_by_given = function(csl_person)
      return transf.str_or_nil.line_or_nil_by_folded(csl_person.given)
    end,
    line_or_nil_by_dropping_particle = function(csl_person)
      return transf.str_or_nil.line_or_nil_by_folded(csl_person["dropping-particle"])
    end,
    line_or_nil_by_non_dropping_particle = function(csl_person)
      return transf.str_or_nil.line_or_nil_by_folded(csl_person["non-dropping-particle"])
    end,
    line_or_nil_by_suffix = function(csl_person)
      return transf.str_or_nil.line_or_nil_by_folded(csl_person.suffix)
    end,
    str_or_nil_by_literal = function(csl_person)
      return csl_person.literal
    end,
    line_or_nil_by_literal = function(csl_person)
      return transf.str_or_nil.line_or_nil_by_folded(csl_person.literal)
    end,
    line_by_name_naive = function(csl_person)
      return get.str_or_number_arr.str_by_joined(
        transf.hole_y_arrlike.arr({
          transf.csl_person.given(csl_person),
          transf.csl_person.line_or_nil_by_dropping_particle(csl_person),
          transf.csl_person.line_or_nil_by_non_dropping_particle(csl_person),
          transf.csl_person.line_or_nil_by_family(csl_person),
          transf.csl_person.line_or_nil_by_suffix(csl_person),
          transf.csl_person.str_or_nil_by_literal(csl_person) and '"' .. transf.csl_person.line_or_nil_by_literal(csl_person) .. '"' or nil,
        }),
        " "
      )
    end,
  },
  lower_strict_snake_case = {
    local_absolute_path_by_csl_file = function(style)
      return env.GIT_PACKAGES .. "/citation-style-language/styles/" .. style .. ".csl"
    end,
  },
  dtprts__arr = {
    rfc3339like_dt = function(date_parts)
      return transf.prefix_dcmp_spec.rfc3339like_dt(
        transf.dtprts__arr.prefix_partial_dcmp_spec(date_parts)
      )
    end,
    prefix_partial_dcmp_spec = function(date_parts)
      return { year = date_parts[1], month = date_parts[2], day = date_parts[3] }
    end,
    full_dcmp_spec = function(date_parts)
      return transf.dcmp_spec.full_dcmp_spec_by_min(
        transf.dtprts__arr.prefix_partial_dcmp_spec(date_parts)
      )
    end,
    timestamp_s = function(date_parts)
      return transf.full_dcmp_spec.timestamp_s(
        transf.dtprts__arr.full_dcmp_spec(date_parts)
      )
    end,
  },
  date_parts_range = {
    rfc3339like_interval = function(date_parts_range)
      return transf.date_parts.rfc3339like_dt(date_parts_range[1]) .. "_to_" .. transf.date_parts.rfc3339like_dt(date_parts_range[2])
    end,
    timestamp_s_interval_specifier = function(date_parts_range)
      return {
        start = transf.dtprts__arr.timestamp_s(date_parts_range[1]),
        stop = transf.dtprts__arr.timestamp_s(date_parts_range[2])
      }
    end
  },
  dtprts__arr_arr = {
    rfc3339like_dt_or_interval = function(date_parts)
      if #date_parts == 1 then
        return transf.dtprts__arr.rfc3339like_dt(date_parts[1])
      else
        return transf.date_parts_range.rfc3339like_interval(date_parts)
      end
    end,
    --- will pick the first date if there is a range
    rfc3339like_dt_by_force_first = function(date_parts)
      return transf.dtprts__arr.rfc3339like_dt(date_parts[1])
    end,
    prefix_partial_dcmp_spec_by_force_first = function(date_parts)
      return transf.dtprts__arr.prefix_partial_dcmp_spec(date_parts[1])
    end,
    full_dcmp_spec_by_force_first = function(date_parts)
      return transf.dtprts__arr.full_dcmp_spec(date_parts[1])
    end,
    timestamp_s_by_force_first = function(date_parts)
      return transf.dtprts__arr.timestamp_s(date_parts[1])
    end,
  },
  urllike_with_no_scheme = {
    url_by_ensure_scheme = function(url)
      if is.url.scheme_url(url) then
        return url
      else
        return "https://" .. url
      end
    end,
    
  },
  url = {
    wayback_machine_url = function(url)
      return "https://web.archive.org/web/*/" .. url
    end,
    str_or_nil_by_default_negotiation_contents = function(url)
      return get.fn.rt_or_nil_by_memoized_invalidate_1_day(transf.str.str_or_nil_by_evaled_env_bash_stripped, "run")
          "curl -L" .. transf.str.str_by_single_quoted_escaped(url)
    end,
    str_or_nil_by_default_negotiation_contents_safer = function(url)
      return get.fn.rt_or_nil_by_memoized_invalidate_1_day(transf.str.str_or_nil_by_evaled_env_bash_stripped, "run")
          "curl -Lf" .. transf.str.str_by_single_quoted_escaped(url)
    end,
    sgml_document_or_nil = function(url)
      local raw = transf.url.str_or_nil_by_default_negotiation_contents_safer(url)
      if is.str.sgml_document(raw) then
        return raw
      end
    end,
    str_or_nil_by_title = function(url)
      return get.url.str_or_nil_by_query_selector_all(url, "title")
    end,
    str_or_nil_by_description = function(url)
      return get.url.str_or_nil_by_query_selector_all(url, "meta[name=description]")
    end,
    in_cache_local_absolute_path = function(url)
      return transf.not_userdata_or_fn.in_cache_local_absolute_path(transf.urllike_with_no_scheme.url_by_ensure_scheme(url), "url")
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
    url_scheme = function(url)
      return transf.url.url_table(url).scheme
    end,
    host = function(url)
      return transf.url.url_table(url).host
    end,
    domain_name_or_nil = function(url)
      local host = transf.url.host(url)
      if is.urlcharset_str.domain_name(host) then
        return host
      end
    end,
    domain_name_or_nil_by_sld_and_tld = function(url)
      local domain_name_or_nil = transf.url.domain_name_or_nil(url)
      if domain_name_or_nil then return get.str.n_strs_by_extracted_eutf8(transf.url.host(url), "(%w+%.%w+)$") end
    end,
    alphanum_minus_or_nil_by_sld = function(url)
      local domain_name_or_nil = transf.url.domain_name_or_nil(url)
      if domain_name_or_nil then  return get.str.n_strs_by_extracted_eutf8(transf.url.host(url), "(%w+)%.%w+$") end
    end,
    tld = function(url)
      local domain_name_or_nil = transf.url.domain_name_or_nil(url)
      if domain_name_or_nil then return get.str.n_strs_by_extracted_eutf8(transf.url.host(url), "%w+%.(%w+)$") end
    end,
    local_absolute_path_or_nil_by_path = function(url)
      return transf.url.url_table(url).path
    end,
    local_absolute_path_or_nil_by_path_decoded = function(url)
      local p_or_nil = transf.url.local_absolute_path_or_nil_by_path(url)
      if p_or_nil then
        return transf.str.str_by_percent_decoded_also_plus(p_or_nil)
      end
    end,
    local_nonabsolute_path_or_nil_by_path = function(url)
      local path = transf.url.local_absolute_path_or_nil_by_path(url)
      if path then
        return get.str.str_by_no_prefix(path, "/")
      end
    end,
    local_nonabsolute_path_or_nil_by_path_decoded = function(url)
      local path = transf.url.local_absolute_path_or_nil_by_path_decoded(url)
      if path then
        return get.str.str_by_no_prefix(path, "/")
      end
    end,
    query_str_or_nil = function(url)
      return transf.url.url_table(url).query
    end,
    urlcharset_str_or_nil_by_fragment = function(url)
      return transf.url.url_table(url).fragment
    end,
    digit_str_by_port = function(url)
      return transf.url.url_table(url).port
    end,
    urlcharset_str_or_nil_by_user = function(url)
      return transf.url.url_table(url).username
    end,
    urlcharset_str_or_nil_by_password = function(url)
      return transf.url.url_table(url).password
    end,
    urlcharset_str_or_nil_by_userinfo = function(url)
      local user = transf.url.urlcharset_str_or_nil_by_user(url)
      local password = transf.url.urlcharset_str_or_nil_by_password(url)
      if user and password then
        return user .. ":" .. password
      elseif user then
        return user
      else
        return nil
      end
    end,
    str_key_str_value_assoc_by_decoded_param_table = function(url)
      local query_str = transf.url.query_str_or_nil(url)
      if query_str then
        return transf.query_str.str_key_str_value_assoc(query_str)
      end
    end,
    urllike_with_no_scheme = function(url)
      local parts = get.str.str_arr_by_split_w_ascii_char(url, ":")
      act.arr.shift(parts)
      local rejoined = get.str_or_number_arr.str_by_joined(parts, ":")
      return get.str.no_prefix_str(rejoined, "//")
    end,
    calendar_name_by_for_webcal = function(url)
      return "webcal_readonly_" .. transf.not_userdata_or_fn.hex_str_by_md5(url)
    end,
    vdirsyncer_pair_specifier = function(url)
      local name = transf.url.calendar_name_by_for_webcal(url)
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
    local_absolute_path_by_webcal_storage_location = function(url)
      return env.XDG_STATE_HOME .. "/vdirsyncer/" .. transf.url.calendar_name_by_for_webcal(url)
    end,
    ini_str_by_khal_config_section = function(url)
      return transf.assoc_value_assoc.ini_str({
        ["[ro:".. transf.url.alphanum_minus_or_nil_by_sld(url) .. "]"] = {
          path = transf.url.local_absolute_path_by_webcal_storage_location(url),
          priority = 0,
        }
      })
    end,
    line_by_url_potentially_with_title_comment = function(url)
      local title = transf.url.str_or_nil_by_sgml_title(url)
      if title and title ~= "" then
        return url .. " # " .. title
      else
        return url
      end
    end,
    leaflike_by_title_or_url_as_filename = function(url)
      local title = transf.url.str_or_nil_by_sgml_title(url)
      if title and title ~= "" then
        return transf.str.leaflike_by_safe_filename(title) .. ".url2"
      else
        return transf.str.leaflike_by_safe_filename(url) .. ".url2"
      end
    end,
    assoc_by_hydrus_api_response_matching_files = function (url)
      return rest({
        api_name = "hydrus",
        endpoint = "/add_urls/get_url_files",
        method = "GET",
        params = {
          url = url,
        }
      })
    end,
    url_by_hydrus_normalized_url = function(url)
      return transf.url.assoc_by_hydrus_api_response_matching_files(url).normalized_url
    end,
    assoc_arr_by_hydrus_matching_files = function(url)
      return transf.url.assoc_by_hydrus_api_response_matching_files(url).url_file_statuses
    end,
    hydrus_file_hash_arr_by_hydrus_matching_files = function(url)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(transf.url.assoc_arr_by_hydrus_matching_files(url), function(url_file_status)
        return url_file_status.hash
      end)
    end,

  },
  path_url = {
    path_component_by_initial = function(url)
      return transf.path.path_component_by_initial(transf.url.local_absolute_path_or_nil_by_path(url))
    end,
    leaflike_by_leaf = function(url)
      return transf.path.leaflike_by_leaf(transf.url.local_absolute_path_or_nil_by_path(url))
    end,
  },
  owner_item_url = {
    two_strs__arr = function(url)
      return get.path.path_component_arr_by_slice_w_cut_specifier(transf.url.local_absolute_path_or_nil_by_path(url), "1:2")
    end,
  },
  whisper_url = {
    str_by_transcribed = function(url)
      local path = transf.url.in_cache_local_absolute_path(url)
      dothis.url.download_to(url, path)
      return transf.whisper_file.str_by_transcribed(path)

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
    multiline_str_by_qr_data = function(url)
      local path = transf.url.in_cache_local_absolute_path(url)
      dothis.url.download_to(url, path)
      return transf.local_image_file.multiline_str_by_qr_data(path)
    end,
    data_url = function(url)
      local ext = transf.path.extension(url)
      return get.fn.rt_or_nil_by_memoized(hs.image.encodeAsURLstr)(transf.image_url.hs_image(url), ext)
    end,
  },
  hs_image = {
    
  },
  gelbooru_style_post_url = {
    digit_str_by_booru_post_id = function(url)
      return transf.url.str_key_str_value_assoc_by_decoded_param_table(url).id
    end,
    pos_int_by_booru_post_id = function(url)
      return transf.nonindicated_number_str.number_by_base_10(transf.gelbooru_style_post_url.digit_str_by_booru_post_id(url))
    end,
  },
  yandere_style_post_url = {
    digit_str_by_booru_post_id = function(url)
      return get.str.n_strs_by_extracted_eutf8(transf.url.local_absolute_path_or_nil_by_path(url), "/post/show/(%d+)")
    end
  },
  danbooru_style_post_url = {
    digit_str_by_booru_post_id = function(url)
      return get.str.n_strs_by_extracted_eutf8(transf.url.local_absolute_path_or_nil_by_path(url), "/posts/(%d+)")
    end
  },
  gpt_response_table = {
    str_by_response = function(result)
      local first_choice = result.choices[1]
      local response = first_choice.text or first_choice.message.content
      return transf.str.not_starting_o_ending_with_whitespace_str(response)
    end
  },
  not_userdata_or_fn = {
    hex_str_by_md5 = function(thing)
      if is.any.not_str(thing) then 
        thing = json.encode(thing) 
      end
      local md5 = hashings("md5")
      md5:update(thing)
      return md5:hexdigest()
    end,
    base32_crock_str_by_md5 = function(thing)
      if is.any.not_str(thing) then 
        thing = json.encode(thing) 
      end
      local md5 = hashings("md5")
      md5:update(thing)
      return transf.str.base32_crock_str_by_utf8(md5:digest())
    end,
    in_cache_local_absolute_path = function(data, type)
      return transf.str.in_cache_local_absolute_path(
        transf.not_userdata_or_fn.hex_str_by_md5(data),
        type
      )
    end,
    in_tmp_local_absolute_path = function(data, type)
      return transf.str.in_tmp_local_absolute_path(
        transf.not_userdata_or_fn.hex_str_by_md5(data),
        type
      )
    end,
    str_by_single_quoted_escaped_json = function(t)
      return transf.str.str_by_single_quoted_escaped(json.encode(t))
    end,
    json_str = json.encode,
    json_str_by_pretty = function(t)
      if is.any.table(t) then
        return transf.table.json_str_by_pretty(t)
      else
        return transf.not_userdata_or_fn.json_str(t)
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
    here_doc_by_json = function(t)
      return transf.str.here_doc(json.encode(t))
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
        local succ, json = pcall(transf.not_userdata_or_fn.json_str, strable)
        if succ then
          return json
        else
          return transf.any.str_by_inspect(strable)
        end
      end
    end,
    type_name = type,
    mac_plist_type_name = function(any)
      local lua_type_name = transf.any.type_name(any)
      if lua_type_name == "string" then
        if is.str.rfc3339like_dt(any) then
          return "date"
        elseif is.str.hex_str(any) then
          return "data"
        else
          return "string"
        end
      elseif lua_type_name == "number" then
        if is.number.int(any) then
          return "integer"
        else
          return "float"
        end
      elseif lua_type_name == "table" then
        if is.table.array(any) then
          return "array"
        else
          return "dict"
        end
      elseif lua_type_name == "boolean" then
        return "boolean"
      else
        return "string"
      end
    end,
    self_and_empty_str = function(any)
      return any, ""
    end,
    str_or_nil = function(arg)
      if arg == nil then
        return nil
      else
        return transf.any.str_by_replicable(arg)
      end
    end,
    t_by_self = function(any)
      return any
    end,
    bool = function(any)
      return not not any
    end,
    bool_by_starts_underscore = function(any)
      return is.any.str(any) and transf.str.bool_by_starts_underscore(any)
    end,
    bool_by_starts_2underscore = function(any)
      return is.any.str(any) and transf.str.bool_by_starts_2underscore(any)
    end,
    n_anys_by_unpack_if_arr = function(any)
      if is.any.table(any) then
        return transf.arr.n_anys(any)
      else
        return any
      end
    end,
    assoc_by_applicable_thing_name_hierarchy = function(any)
      return get.any.assoc_by_applicable_thing_name_hierarchy(any)
    end,
    thing_name_arr_by_applicable = function(any)
      return transf.thing_name_hierarchy.thing_name_arr(transf.any.assoc_by_applicable_thing_name_hierarchy(any))
    end,
    action_specifier_arr_by_applicable = function(any)
      return transf.thing_name_arr.action_specifier_arr(transf.any.thing_name_arr_by_applicable(any))
    end,
    chooser_item_specifier_arr_by_applicable_for_action = function(any)
      return transf.action_specifier_arr.chooser_item_specifier_arr(transf.any.action_specifier_arr_by_applicable(any))
    end,
    index_chooser_item_specifier_arr_by_applicable_for_action = function(any)
      return transf.assoc_arr.has_index_key_table_arr(transf.any.chooser_item_specifier_arr_by_applicable_for_action(any))
    end,
    str_by_placeholder_text = function(any)
      return "Choose action on: " .. (
        get.thing_name_arr.str_or_nil_by_placeholder_text(transf.any.thing_name_arr_by_applicable(any), any) or
        get.thing_name_arr.str_or_nil_by_chooser_text(transf.any.thing_name_arr_by_applicable(any), any)
      )
    end,
    hschooser_specifier = function(any)
      return {
        chooser_item_specifier_arr = transf.any.index_chooser_item_specifier_arr_by_applicable_for_action(any),
        placeholder_text = transf.any.str_by_placeholder_text(any),
      }
    end,
    choosing_hschooser_specifier = function(any)
      return get.hschooser_specifier.choosing_hschooser_specifier(transf.any.hschooser_specifier(any), "index", any)
    end,
    any_and_applicable_thing_name_arr_specifier = function(any)
      return {
        any = any,
        applicable_thing_name_arr = transf.any.thing_name_arr_by_applicable(any)
      }
    end,
    chooser_item_specifier = function(any)
      local applicable_thing_name_arr = transf.any.thing_name_arr_by_applicable(any)
      return {
        text = transf.str.styledtext_by_with_styled_start_end_markers(get.thing_name_arr.str_or_nil_by_chooser_text(applicable_thing_name_arr, any)),
        subText = get.thing_name_arr.str_or_nil_by_chooser_subtext(applicable_thing_name_arr, any),
        image = get.thing_name_arr.hs_image_or_nil_by_chooser_image(applicable_thing_name_arr, any),
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
    end,
    arr_by_ensure = function(any)
      if is.any.arr(any) then
        return any
      else
        return {any}
      end
    end,
  },
  chooser_item_specifier = {
    chooser_item_specifier_by_truncated_text = function(item_chooser_item_specifier)
      local copied_spec = get.table.table_by_copy(item_chooser_item_specifier)
      local rawstr =  transf.styledtext.str(
        copied_spec.text
      )
      local truncated = get.str.str_by_shortened_eutf8_start(rawstr, 250)
      copied_spec.text = transf.str.styledtext_by_with_styled_start_end_markers(truncated)
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
    nt2 = function(...)
      return select(2, ...)
    end,
  },
  str_and_n_anys = {
    str_and_n_anys_by_stripped = function(...)
      local arg1 = select(1, ...)
      return transf.str.not_starting_o_ending_with_whitespace_str(arg1), select(2, ...)
    end
  },
  mailto_url = {
    line_by_emails = function(mailto_url)
      return transf.url.local_nonabsolute_path_or_nil_by_path_decoded(mailto_url)
    end,
    email_arr = function(mailto_url)
      local emails_part = transf.mailto_url.line_by_emails(mailto_url)
      local emails = get.str.str_arr_by_split_w_ascii_char(emails_part, ",")
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(emails, transf.str.not_starting_o_ending_with_whitespace_str)
    end,
    email_by_first = function(mailto_url)
      return transf.mailto_url.email_arr(mailto_url)[1]
    end,
    str_by_subject = function(mailto_url)
      return transf.url.str_key_str_value_assoc_by_decoded_param_table(mailto_url).subject 
    end,
    str_by_body = function(mailto_url)
      return transf.url.str_key_str_value_assoc_by_decoded_param_table(mailto_url).body 
    end,
    str_by_cc = function(mailto_url)
      return transf.url.str_key_str_value_assoc_by_decoded_param_table(mailto_url).cc 
    end,

  },
  tel_url = {
    phone_number = function(tel_url)
      return transf.url.urllike_with_no_scheme(tel_url)
    end,
    
  },
  otpauth_url = {
    otp_type = function(otpauth_url)
      return transf.url.host(otpauth_url)
    end,
    urlcharset_str_by_label = function(otpauth_url)
      return transf.url.local_absolute_path_or_nil_by_path_decoded(otpauth_url)
    end,
    
  },
  data_url = {
    media_type = function(data_url)
      return get.str.str_arr_by_split_w_ascii_char(transf.url.urllike_with_no_scheme(data_url), ";")[1]
    end,
    urlcharset_str_by_header_part = function(data_url) -- the non-data part will either be separated from the rest of the url by `;,` or `;base64,`, so we need to split on `,`, then find the first part that ends `;` or `base64;`, and then join and return all parts before that part
      local parts = get.str.str_arr_by_split_w_ascii_char(transf.url.urllike_with_no_scheme(data_url), ",")
      local non_data_part = ""
      for _, part in transf.arr.pos_int_vt_stateless_iter(parts) do
        non_data_part = non_data_part .. part
        if get.str.bool_by_endswith(part, ";") or get.str.bool_by_endswith(part, "base64;") then
          break
        else
          non_data_part = non_data_part .. ","
        end
      end
      return non_data_part
    end,
    urlcharset_str_by_payload_part = function(data_url)
      return get.str.no_prefix_str(transf.url.urllike_with_no_scheme(data_url), transf.data_url.urlcharset_str_by_header_part(data_url))
    end,
      
    urlcharset_str_key_urlcharset_str_value_assoc = function(data_url)
      local parts = get.str.str_arr_by_split_w_ascii_char(transf.data_url.urlcharset_str_by_header_part(data_url), ";")
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
    line_by_language = function(source_id)
      return get.arr.arr_by_slice_w_3_int_any_or_nils(get.str.str_arr_by_split_w_ascii_char(source_id, "."), -1, -1)[1]
    end,
  },
  hydrus_metadata_spec = {
    hydrus_service_key_key_hydrus_internal_tag_spec_value_assoc = function(spec)
      return spec.tags
    end,
    hydrus_file_hash = function(spec)
      return spec.hash
    end,
    url_arr_by_associated_urls = function(spec)
      return spec.known_urls
    end,
    two_strs_arr__arr_by_all_current_display_tags = function(spec)
      return transf.hydrus_service_key_key_hydrus_internal_tag_spec_value_assoc.two_strs_arr__arr_by_all_current_display_tags(transf.hydrus_metadata_spec.hydrus_service_key_key_hydrus_internal_tag_spec_value_assoc(spec))
    end,
    str_arr_by_all_current_display_tags = function(spec)
      return transf.hydrus_service_key_key_hydrus_internal_tag_spec_value_assoc.str_arr_by_all_current_display_tags(transf.hydrus_metadata_spec.hydrus_service_key_key_hydrus_internal_tag_spec_value_assoc(spec))
    end,
    assoc_by_stream_metadata = function(spec)
      return {
        creation_title = get.hydrus_metadata_spec.str_or_nil_by_tag_namespace(spec, "creation_title"),
        proximate_source_title = get.hydrus_metadata_spec.str_or_nil_by_tag_namespace(spec, "proximate_source_title"),
        tags = get.hydrus_metadata_spec.str_arr_by_all_current_display_tags(spec),
        hash = get.hydrus_metadata_spec.hydrus_file_hash(spec),
      }
    end,
  },
  hydrus_service_key_key_hydrus_internal_tag_spec_value_assoc = {
    hydrus_internal_tag_spec_arr = function(assoc)
      return transf.table.vt_arr(assoc)
    end,
    two_strs_arr__arr_by_all_current_display_tags = function(assoc)
      return transf.hydrus_internal_tag_spec_arr.two_strs_arr__arr_by_all_current_display_tags(transf.hydrus_service_key_key_hydrus_internal_tag_spec_value_assoc.hydrus_internal_tag_spec_arr(assoc))
    end,
    str_arr_by_all_current_display_tags = function(assoc)
      return transf.hydrus_internal_tag_spec_arr.str_arr_by_all_current_display_tags(transf.hydrus_service_key_key_hydrus_internal_tag_spec_value_assoc.hydrus_internal_tag_spec_arr(assoc))
    end,
  },
  hydrus_internal_tag_spec_arr = {
    two_strs_arr__arr_by_all_current_display_tags = function(spec_arr)
      return get.arr_arr.arr_by_mapped_w_t_arg_t_ret_fn_and_flatten(
        spec_arr,
        transf.hydrus_internal_tag_spec.two_strs_arr__arr_by_current_display_tags
      )
    end,
    str_arr_by_all_current_display_tags = function(spec_arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn_and_flatten(
        spec_arr,
        transf.hydrus_internal_tag_spec.str_arr_by_current_display_tags
      )
    end,
  },
  hydrus_internal_tag_spec = {
    digit_str_key_str_arr_value_assoc_by_storage_tags = function(spec)
      return spec.storage_tags
    end,
    digit_str_key_str_arr_value_assoc_by_display_tags = function(spec)
      return spec.display_tags
    end,
    str_arr_by_current_display_tags = function(spec)
      return spec.display_tags["0"]
    end,
    two_strs_arr__arr_by_current_display_tags = function(spec)
      return transf.str_arr.two_strs__arr_arr_by_split_colon(spec.display_tags["0"])
    end,
  },
  digit_str_key_str_arr_value_assoc = {
    str_arr_by_current = function(assoc)
      return assoc["0"]
    end,
    two_strs_arr__arr_by_current = function(assoc)
      return transf.str_arr.two_strs__arr_arr_by_split_colon(assoc["0"])
    end,

  },
  hydrus_style_file_url = {
    hydrus_file_hash = function(url)
      local params = transf.url.str_key_str_value_assoc_by_decoded_param_table(url)
      return params.hash
    end,
  },
  hydrus_file_hash = {
    local_hydrus_file_url = function(sha256_hex_str)
      return "http://" .. tblmap.api_name.host.hydrus .. "/get_files/file?hash=" .. sha256_hex_str "&Hydrus-Client-API-Access-Key=" .. transf.api_name.str_or_nil_by_api_key("hydrus")
    end,
    url_arr_by_associated_urls = function(sha256_hex_str)
      return transf.hydrus_metadata_spec.url_arr_by_associated_urls(transf.hydrus_file_hash.hydrus_metadata_spec(sha256_hex_str))
    end,
    hydrus_metadata_spec = function(sha256_hex_str)
      return transf.hydrus_file_hash_arr.hydrus_metadata_spec_arr({sha256_hex_str})[1]
    end,
    hydrus_service_key_key_hydrus_internal_tag_spec_value_assoc = function(sha256_hex_str)
      return transf.hydrus_metadata_spec.hydrus_service_key_key_hydrus_internal_tag_spec_value_assoc(transf.hydrus_file_hash.hydrus_metadata_spec(sha256_hex_str))
    end,
    assoc_by_stream_metadata = function(sha256_hex_str)
      return transf.hydrus_metadata_spec.assoc_by_stream_metadata(transf.hydrus_file_hash.hydrus_metadata_spec(sha256_hex_str))
    end,
  },
  hydrus_file_hash_arr = {
    local_hydrus_file_url_arr = function(sha256_hex_str_arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(sha256_hex_str_arr, transf.hydrus_file_hash.local_hydrus_file_url)
    end,
    assoc_by_hydrus_metadata_response = function(sha256_hex_str_arr)
      return rest({
        api_name = "hydrus",
        endpoint = "get_files/file_metadata",
        params = { 
          hashes = get.str_or_number_arr.str_by_joined(sha256_hex_str_arr, ",")
        },
        request_verb = "GET",
      })
    end,
    hydrus_metadata_spec_arr = function(sha256_hex_str_arr)
      return transf.hydrus_file_hash_arr.assoc_by_hydrus_metadata_response(sha256_hex_str_arr).metadata
    end,
    hydrus_service_key_key_hydrus_internal_tag_spec_value_assoc_arr = function(sha256_hex_str_arr)
      return get.arr.arr_by_mapped_w_t_arg_t_ret_fn(
        transf.hydrus_file_hash_arr.hydrus_metadata_spec_arr(sha256_hex_str_arr),
        transf.hydrus_metadata_spec.hydrus_service_key_key_hydrus_internal_tag_spec_value_assoc
      )
    end,

  },
  source_id_arr = {
    source_id_by_next_to_be_activated = function(source_id_arr)
      return get.arr.t_by_next_wrapping_w_fn(source_id_arr, is.source_id.active_source_id)
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
    utf8_char_by_hotkey = function(menu_item_table)
      return menu_item_table.AXMenuItemCmdChar
    end,
    key_input_spec = function(menu_item_table)
      return {
        mod_arr = transf.menu_item_table.mod_name_arr(menu_item_table),
        key = transf.menu_item_table.utf8_char_by_hotkey(menu_item_table)
      } 
    end,
    str_by_shortcut = function(menu_item_table)
      return transf.key_input_spec.str_by_shortcut(
        transf.menu_item_table.key_input_spec(menu_item_table)
      )
    end,
    str_by_title = function(menu_item_table)
      return menu_item_table.AXTitle
    end,
    str_arr_by_action_path = function(menu_item_table)
      return transf.arr_and_any.arr(menu_item_table.path, menu_item_table.AXTitle)
    end,
    str_by_action_path = function(menu_item_table)
      return transf.str_arr.str_by_action_path(transf.menu_item_table.str_arr_by_action_path(menu_item_table))
    end,
    running_application = function(menu_item_table)
      return menu_item_table.application
    end,
    str_by_summary = function(menu_item_table)
      if transf.menu_item_table.utf8_char_by_hotkey(menu_item_table) then
        return transf.menu_item_table.str_by_action_path(menu_item_table) .. " (" .. transf.menu_item_table.str_by_shortcut(menu_item_table) .. ")"
      else
        return transf.menu_item_table.str_by_action_path(menu_item_table)
      end
    end
  },
  mod_name_arr = {
    mod_symbol_arr = function(mod_arr)
      return get.arr.arr_by_mapped_w_t_key_assoc(mod_arr, transf.mod_name.mod_symbol)
    end,
    mod_char_arr = function(mod_arr)
      return get.arr.arr_by_mapped_w_t_key_assoc(mod_arr, transf.mod_name.mod_char)
    end,
  },
  key_input_spec = {
    mod_name_arr = function(spec)
      return spec.mod_name_arr
    end,
    str_by_key = function(spec)
      return spec.key
    end,
    str_arr_by_parts = function(spec)
      return transf.arr_and_any.arr(
        spec.mod_name_arr,
        spec.key
      )
    end,
    str_by_shortcut = function(spec)
      local modstr = get.str_or_number_arr.str_by_joined(get.arr.arr_by_mapped_w_t_key_assoc(spec.mod_name_arr, tblmap.mod_name.mod_symbol), "")
      if modstr == "" then
        return spec.key
      else
        return modstr .. " " .. spec.key
      end
    end,

  },
  audiodevice_specifier = {
    audiodevice = function(audiodevice_specifier)
      return audiodevice_specifier.device
    end,
    audiodevice_subtype = function(audiodevice_specifier)
      return audiodevice_specifier.subtype
    end,
    str_by_name = function(audiodevice_specifier)
      return transf.audiodevice.str_by_name(transf.audiodevice_specifier.audiodevice(audiodevice_specifier))
    end

  },
  audiodevice_specifier_arr = {
    pos_int_or_nil_by_active_audiodevice_specifier = function(arr)
      return get.arr.pos_int_or_nil_by_first_match_w_fn(arr, is.audiodevice_specifier.active_audiodevice_specifier)
    end,
  },
  audiodevice = {
    str_by_name = function(audiodevice)
      return audiodevice:name()
    end,
  },
  snake_case_key_detailed_env_node_or_str_value_assoc = {
    envlike_str = function(snake_case_key_detailed_env_node_or_str_value_assoc)
      return transf.snake_case_key_str_value_assoc.envlike_str(
        get.snake_case_key_detailed_env_node_or_str_value_assoc.snake_case_key_str_value_assoc(snake_case_key_detailed_env_node_or_str_value_assoc)
      )
    end

  },
  in_menv_absolute_path = {
    envlike_str = function(in_menv_absolute_path)
      local snake_case_key_detailed_env_node_or_str_value_assoc_arr = transf.extant_path.not_userdata_or_fn_arr_by_descendants(in_menv_absolute_path)
      local snake_case_key_detailed_env_node_or_str_value_assoc = transf.table_arr.table_by_take_new(snake_case_key_detailed_env_node_or_str_value_assoc_arr)
      return transf.snake_case_key_detailed_env_node_or_str_value_assoc.envlike_str(snake_case_key_detailed_env_node_or_str_value_assoc)
    end,
  },
  country_identifier_str = {
    iso_3366_1_alpha_2_country_code = function(country_identifier)
      return transf.str.str_by_all_eutf8_lower(get.n_shot_llm_spec.str_or_nil_by_response({
        input = country_identifier, 
        query = "Suppose the following identifies a country. Return its ISO 3166-1 Alpha-2 country code."
      }))
    end,
  },
  language_identifier_str = {
    bcp_47_language_tag = function(country_identifier)
      return get.n_shot_llm_spec.str_or_nil_by_response({
        input = country_identifier, 
        query = "Suppose the following identifies a language or variety. Return its BCP 47 language tag. Be conservative and only add information that is present in the input, or is necessary to make it into a valid BCP 47 language tag."
      })
    end,
  },
  bcp_47_language_tag = {
    language_identifier_str = function(bcp_47_language_tag)
      return get.n_shot_llm_spec.str_or_nil_by_response({
        input = bcp_47_language_tag, 
        query = "Suppose the following is a BCP 47 language tag. Return a natural language description of it."
      })
    end,
  },
  iso_3366_1_alpha_2_country_code = {
    noempty_noindent_nohashcomment_line_by_iso_3366_1_full_name = function(iso_3366_1_alpha_2)
      return get.n_shot_llm_spec.str_or_nil_by_response({
        input = iso_3366_1_alpha_2, 
        query = "Get the ISO 3366-1 full name of the country identified by the following ISO 3366-1 Alpha-2 country code."
      })
    end,
    noempty_noindent_nohashcomment_line_by_iso_3366_1_short_name = function(iso_3366_1_alpha_2)
      return get.n_shot_llm_spec.str_or_nil_by_response({
        input = iso_3366_1_alpha_2, 
        query = "Get the ISO 3366-1 short name of the country identified by the following ISO 3366-1 Alpha-2 country code."
      })
    end,
  },
  bool = {
    bool_by_negated = function(bool)
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
    n_anys_arg_n_anys_or_error_ret_fn_by_poisonable = function()
      local dirty = false
      local returnfn
      returnfn = function(...)
        if dirty then
          error("poisoned " .. transf.any.str(returnfn))
        end
        dirty = true
        return ...
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
    bool_by_random = function()
      return math.random() < 0.5
    end,
    bool_by_sox_is_recording = function()
      return transf.str.bool_by_evaled_env_bash_success("pgrep -x rec")
    end,
    passw_pass_item_name_arr = function()
      return transf.dir.leaflike_arr_by_children_filenames(env.MPASSPASSW)
    end,
    otp_pass_item_name_arr = function()
      return transf.dir.leaflike_arr_by_children_filenames(env.MPASSOTP)
    end,
    digit_str_by_next_free_port = function()
      return transf.str.str_or_err_by_evaled_env_bash_stripped_noempty("nextport")
    end,
    full_dcmp_spec_by_current = function()
      return os.date("*t")
    end,
    timestamp_s_by_current = function()
      return os.time()
    end,
    full_rfc3339like_dt_by_current = function()
      return transf.timestamp_s.full_rfc3339like_dt(transf["nil"].timestamp_s_by_current())
    end,
    rfc3339like_ymd_by_current = function()
      return transf.timestamp_s.rfc3339like_ymd(transf["nil"].timestamp_s_by_current())
    end,
    timestamp_s_by_last_midnight = function()
      return 
        get.full_dcmp_spec.timestamp_s_by_precision_w_dcmp_name(
          transf["nil"].full_dcmp_spec_by_current(),
          "day"
        )
    end,
    package_manager_name_arr = function()
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg list-package-managers"))
    end,
    package_manager_name_arr_by_with_missing_packages = function()
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg missing-package-manager"))
    end,
    semver_str_arr_by_installed_package_managers = function ()
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg package-manager-version"))
    end,
    local_absolute_path_arr_by_installed_package_managers = function()
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg which-package-manager"))
    end,
    line_by_mullvad_status = function()
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("mullvad status")
    end,
    bool_by_mullvad_connected = function()
      return get.str.bool_by_startswith(transf["nil"].line_by_mullvad_status(),"Connected")
    end,
    multiline_str_by_mullvad_relay_list = function()
      return get.fn.rt_or_nil_by_memoized(transf.str.str_or_nil_by_evaled_env_bash_stripped)("mullvad relay list")
    end,
    relay_identifier_arr = function()
      return 
        transf.table.arr_by_nested_value_primitive_and_arrlike_is_leaf(
          transf.multiline_str.iso_3366_1_alpha_2_country_code_key_mullvad_city_code_key_mullvad_relay_identifier_str_arr_value_assoc_value_assoc(
            transf["nil"].multiline_str_by_mullvad_relay_list()
          )
      )
    end,
    active_relay_identifier = function()
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
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        get.str.str_arr_by_split_w_ascii_char(transf["nil"].str_by_khard_list_output(), "\n"), 
        function (line)
          return get.str.str_arr_by_split_w_ascii_char(line, "\t")[1]
        end
      )
    end,
    contact_table_arr = function()
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        transf["nil"].contact_uuid_arr(),
        transf.uuid.contact_table_or_nil
      )
    end,
    telegram_raw_export_dir_by_current = function()
      return env.DOWNLOADS .. "/Telegram Desktop/DataExport_" .. transf.timestamp_s.rfc3339like_ymd(
        transf["nil"].timestamp_s_by_current()
      )
    end,
    running_application_by_frontmost = hs.application.frontmostApplication,
    menu_item_table_arr_by_frontmost_application = function()
      return transf.running_application.menu_item_table_arr(
        transf["nil"].running_application_by_frontmost()
      )
    end,
    installed_app_dir_arr = function()
      return transf.local_dir.local_extant_path_arr_by_descendants(env.APPLICATIONS)
    end,
    mac_application_name_arr = function()
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        transf["nil"].installed_app_dir_arr(),
        transf.path.leaflike_by_filename
      )
    end,
  },
  audiodevice_type = {
    audiodevice_by_default = function(type)
      return hs.audiodevice["default" .. transf.str.str_by_first_eutf8_upper(type) .. "Device"]()
    end,
    audiodevice_specifier_arr = function(type)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
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
    local_absolute_path = function(mgr)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. mgr .. " which-package-manager")
    end,
  },
  package_manager_name_or_nil = {
    package_name_arr_by_backed_up = function(mgr)
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " read-backup"))
    end,
    package_name_arr_by_missing = function(mgr)
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " missing"))
    end,
    installed_package_name_arr_by_added = function(mgr)
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " added"))
    end,
    package_name_arr_by_difference = function(mgr)
      return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " difference"))
    end,
    package_name_or_package_name_semver_compound_str_arr = function(mgr) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list ")) end,
    package_name_semver_compound_str_arr = function(mgr) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list-version ")) end,
    package_name_arr = function(mgr) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list-no-version ")) end,
    package_name_semver_package_manager_name_compound_str_arr = function(mgr) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list-version-package-manager ")) end,
    package_name_package_manager_name_compound_str = function(mgr) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " list-with-package-manager ")) end,
    digit_str_arr_by_installed = function(mgr) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg " .. (mgr or "") .. " count ")) end,
  },
  package_name = {
    installed_package_manager = function(pkg) return transf.str.line_arr(transf.str.str_or_nil_by_evaled_env_bash_stripped("upkg installed_package_manager " .. pkg)) end,
  },
  action_specifier = {
    chooser_item_specifier = function(action_specifier)
      local str = get.str.str_by_with_suffix(action_specifier.d, ".")
      str = str .. " #" .. get.not_userdata_or_fn.base32_crock_str_by_md5_w_pos_int(action_specifier.d, 3) -- shortcode for easy use
      return {text = str}
    end
  },
  action_specifier_arr = {
    chooser_item_specifier_arr = function(action_specifier_arr)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        action_specifier_arr,
        transf.action_specifier.chooser_item_specifier
      )
    end,
    index_chooser_item_specifier_arr = function(action_specifier_arr)
      return transf.assoc_arr.has_index_key_table_arr(
        transf.action_specifier_arr.chooser_item_specifier_arr(action_specifier_arr)
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
    action_specifier_arr_by_transf = function(thing_name)
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
    action_specifier_arr_by_act = function(thing_name)
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
    action_specifier_arr_by_transf_act = function(thing_name)
      return transf.two_arrs.arr_by_appended(
        transf.thing_name.action_specifier_arr_by_act[thing_name],
        transf.thing_name.action_specifier_arr_by_transf[thing_name]
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
    partial_retriever_specifier_arr_by_chooser_image = function(thing_name_arr)
      return get.thing_name_arr.partial_retriever_specifier_arr(
        thing_name_arr,
        "chooser_image"
      )
    end,
    partial_retriever_specifier_arr_by_chooser_text = function(thing_name_arr)
      return get.thing_name_arr.partial_retriever_specifier_arr(
        thing_name_arr,
        "chooser_text"
      )
    end,
    partial_retriever_specifier_arr_by_placeholder_text = function(thing_name_arr)
      return get.thing_name_arr.partial_retriever_specifier_arr(
        thing_name_arr,
        "placeholder_text"
      )
    end,
    partial_retriever_specifier_arr_by_chooser_subtext = function(thing_name_arr)
      return get.thing_name_arr.partial_retriever_specifier_arr(
        thing_name_arr,
        "chooser_subtext"
      )
    end,
    partial_retriever_specifier_arr_chooser_initial_selected_index = function(thing_name_arr)
      return get.thing_name_arr.partial_retriever_specifier_arr(
        thing_name_arr,
        "chooser_initial_selected_index"
      )
    end,
  },
  retriever_specifier = {

  },
  retriever_specifier_arr = {
    retriever_specifier_by_highest_precedence = function(retriever_specifier_arr)
      return hs.fnutils.reduce(
        retriever_specifier_arr,
        get.fn.fn_by_arbitrary_args_bound_or_ignored(get.table_and_table.table_by_larger_key {a_use, a_use, "precedence"})
      )
    end,
    retriever_specifier_arr_by_precedence_ordered = function(retriever_specifier_arr)
      return get.arr.arr_by_sorted(
        retriever_specifier_arr,
        get.fn.fn_by_arbitrary_args_bound_or_ignored(get.table_and_table.table_by_larger_key) {a_use, a_use, "precedence"})
    end
  },
  ipc_socket_id = {
    ipc_socket_path = function(ipc_socket_id)
      return "/tmp/sockets/" .. ipc_socket_id
    end,
  },
  mpv_ipc_socket_id = {
    url_or_local_path_by_current = function (mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.str(mpv_ipc_socket_id, "stream-open-filename")
    end,
    str_by_title = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.str(mpv_ipc_socket_id, "media-title")
    end,
    pos_int_by_playback_seconds = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.int(mpv_ipc_socket_id, "time-pos")
    end,
    pos_int_by_duration_seconds = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.int(mpv_ipc_socket_id, "duration")
    end,
    percentage_pos_int_by_playback_percent = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.int(mpv_ipc_socket_id, "percent-pos")
    end,
    pos_int_by_chapter = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.int(mpv_ipc_socket_id, "chapter")
    end,
    urlcharset_str_by_playback = function(mpv_ipc_socket_id)
      return get.str.str_by_formatted_w_n_anys(
        "(%i/%is - %s%%)",
        transf.mpv_ipc_socket_id.pos_int_by_playback_seconds(mpv_ipc_socket_id) or -1,
        transf.mpv_ipc_socket_id.pos_int_by_duration_seconds(mpv_ipc_socket_id) or -1,
        transf.mpv_ipc_socket_id.percentage_pos_int_by_playback_percent(mpv_ipc_socket_id) or -1
      )
    end,
    pos_int_by_playlist_index = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.int(mpv_ipc_socket_id, "playlist-pos")
    end,
    pos_int_by_playlist_length = function(mpv_ipc_socket_id)
      return get.mpv_ipc_socket_id.int(mpv_ipc_socket_id, "playlist-count")
    end,
    urlcharset_str_by_playlist = function(mpv_ipc_socket_id)
      return get.str.str_by_formatted_w_n_anys(
        "[%i/%i]",
        transf.mpv_ipc_socket_id.pos_int_by_playlist_index(mpv_ipc_socket_id) or -1,
        transf.mpv_ipc_socket_id.pos_int_by_playlist_length(mpv_ipc_socket_id) or -1
      )
    end,
    str_by_summary_basci = function(mpv_ipc_socket_id)
      return get.str.str_by_formatted_w_n_anys(
        "%s %s %s",
        transf.mpv_ipc_socket_id.urlcharset_str_by_playback(mpv_ipc_socket_id),
        transf.mpv_ipc_socket_id.urlcharset_str_by_playlist(mpv_ipc_socket_id),
        get.mpv_ipc_socket_id.title(mpv_ipc_socket_id) or "<no title>"
      )
    end,
    str_by_summary_emoji = function(mpv_ipc_socket_id)
      return get.str_or_number_arr.str_by_joined(
        get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
          {"pause", "loop", "shuffle", "video"},
          get.fn.fn_by_1st_n_bound(get.mpv_ipc_socket_id.line_by_emoji_for_key, mpv_ipc_socket_id)
        ),
        ""
      )
    end,
    str_by_summary = function(mpv_ipc_socket_id)
      return get.str.str_by_formatted_w_n_anys(
        "%s %s",
        transf.mpv_ipc_socket_id.str_by_summary_emoji(mpv_ipc_socket_id),
        transf.mpv_ipc_socket_id.str_by_summary_basci(mpv_ipc_socket_id)
      )
    end,
    bool_by_is_running = function(mpv_ipc_socket_id)
      return transf.any.bool(
        get.mpv_ipc_socket_id.str(mpv_ipc_socket_id, "pause")
      )
    end,
        
  },
  stream_creation_specifier = {
    lower_strict_kebap_case_key_bool_value_assoc_by_flags_with_default = function(stream_creation_specifier)
      return transf.two_tables.table_by_take_new(
        tblmap.flag_profile_name.lower_strict_kebap_case_key_bool_value_assoc[stream_creation_specifier.flag_profile_name or "foreground"],
        stream_creation_specifier.flags 
      )
    end,
    str_by_flags = function(stream_creation_specifier)
      return transf.str_key_bool_value_assoc.str_by_long_flags_for_truthies(get.stream_creation_specifier.flags_with_default(stream_creation_specifier))
    end,
    absolute_path_by_source = function(stream_created_item_specifier)
      return stream_created_item_specifier.source_path
    end,
  },
  stream_created_item_specifier = {
    stream_state = function(stream_created_item_specifier)
      return stream_created_item_specifier.inner_item.state
    end,
    stream_state_by_transitioned = function(stream_created_item_specifier)
      return tblmap.stream_state.bool_key_stream_state_value_assoc[
        transf.stream_created_item_specifier.stream_state(stream_created_item_specifier)
      ][
        is.stream_created_item_specifier.alive_stream_created_item_specifier(stream_created_item_specifier)
      ]
    end,
    bool_by_is_valid = function(stream_created_item_specifier)
      return stream_created_item_specifier.inner_item.state ~= "ended"
    end,
    absolute_path_by_source = function(stream_created_item_specifier)
      return transf.stream_creation_specifier.absolute_path_by_source(stream_created_item_specifier.creation_specifier)
    end,
    str_by_summary = function(stream_created_item_specifier)
      return transf.mpv_ipc_socket_id.str_by_summary(stream_created_item_specifier.mpv_ipc_socket_id)
    end,
    str_by_title = function(stream_created_item_specifier)
      return transf.mpv_ipc_socket_id.str_by_title(stream_created_item_specifier.mpv_ipc_socket_id)
    end,
    url_or_local_path_by_current = function(stream_created_item_specifier)
      return transf.mpv_ipc_socket_id.url_or_local_path_by_current(stream_created_item_specifier.mpv_ipc_socket_id)
    end,
    url_or_local_path_arr_by_creation = function(stream_created_item_specifier)
      return stream_created_item_specifier.creation_specifier.urls
    end,
    bool_by_is_running = function(stream_created_item_specifier)
      return transf.mpv_ipc_socket_id.bool_by_is_running(stream_created_item_specifier.mpv_ipc_socket_id)
    end,

  },
  hotkey_created_item_specifier = {
    hs_hotkey = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.inner_item
    end,
    str_by_explanation = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.explanation
    end,
    str_or_nil_by_mnemonic = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.mnemonic
    end,
    str_by_mnemonic = function(hotkey_created_item_specifier)
      local mnemonic = transf.hotkey_created_item_specifier.str_or_nil_by_mnemonic(hotkey_created_item_specifier)
      if mnemonic then
        return get.str.str_by_formatted_w_n_anys("[%s] ", mnemonic)
      else
        return ""
      end
    end,
    key_input_spec = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.key_input_spec
    end,
    str_by_shortcut = function(hotkey_created_item_specifier)
      return transf.key_input_spec.str_by_shortcut(transf.hotkey_created_item_specifier.key_input_spec(hotkey_created_item_specifier))
    end,
    mod_name_arr = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.key_input_spec.mod_arr
    end,
    str_by_key = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.key_input_spec.key
    end,
    fn = function(hotkey_created_item_specifier)
      return hotkey_created_item_specifier.creation_specifier.fn
    end,
    str_by_summary = function(hotkey_created_item_specifier)
      return get.str.str_by_formatted_w_n_anys(
        "%s%s: %s",
        transf.hotkey_created_item_specifier.str_by_shortcut(hotkey_created_item_specifier),
        transf.hotkey_created_item_specifier.str_by_mnemonic(hotkey_created_item_specifier),
        transf.hotkey_created_item_specifier.str_by_explanation(hotkey_created_item_specifier)
      )
    end,

  },
  watcher_created_item_specifier = {
    fn = function(watcher_created_item_specifier)
      return watcher_created_item_specifier.creation_specifier.fn
    end,
    watcher = function(watcher_created_item_specifier)
      return watcher_created_item_specifier.inner_item
    end,
    bool_by_running = function(watcher_created_item_specifier)
      return watcher_created_item_specifier.inner_item:running()
    end,
  },
  watcher_creation_specifier = {
    watcher_ret_fn = function(watcher_creation_specifier)
      return watcher_creation_specifier.watcher_container.new
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
  set = {
    --- this function is no different from transf.arr.arr_arr_by_permutations, but exists because I'm sure I'll otherwise forget that the permutations of a set are themselves a set, but the permutations of an array only an array (since there can be duplicates in the array, and thus also duplicates in the permutations)
    set_set_by_permutations = function(set)
      return transf.arr.arr_arr_by_permutations(set)
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
      for _, v in transf.arr.pos_int_vt_stateless_iter(set1) do
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
    digit_str_by_next = function(cronspec_str)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped("ncron" .. transf.str.str_by_single_quoted_escaped(cronspec_str))
    end,
    timestamp_s_by_next = function(cronspec_str)
      return transf.nonindicated_number_str.number_by_base_10(transf.cronspec_str.digit_str_by_next(cronspec_str))
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
  two_operational_addables = {
    operantional_addable_by_sum = function(addable1, addable2)
      return addable1 + addable2
    end,
  },
  operational_addcompable = {
    thing_name = function(functional_addable)
      if is.any.number(functional_addable) then
        return "number"
      elseif is.any.hs_geometry_point(functional_addable) then
        return "hs_geometry_point"
      end
    end,
  },
  hs_geometry_point_or_nil = {
    operational_addcompable_by_default_low = function(pt)
      return pt or hs.geometry.point(1, 1)
    end,
    operational_addcompable_by_default_high = function(pt)
      return pt or hs.geometry.point(10, 10)
    end,
    operational_addcompable_by_default_step = function(pt)
      return pt or hs.geometry.point(1, 1)
    end,
  },
  number_or_nil = {
    operational_addcompable_by_default_low = function(num)
      return num or 1
    end,
    operational_addcompable_by_default_high = function(num)
      return num or 10
    end,
    operational_addcompable_by_default_step = function(num)
      return num or 1
    end,
  },
  three_operational_addcompable_or_nils = {
    operational_addcompable_arr = function(start, stop, step)
      local thing_name = transf.operational_addcompable.thing_name(start)
      start = transf[thing_name].operational_addcompable_by_default_low(start)
      stop = transf[thing_name].operational_addcompable_by_default_high(stop)
      step = transf[thing_name].operational_addcompable_by_default_step(step)

      local range = {}
      local current = start
      while current <= stop do
        dothis.arr.push(range, current)
        current = current + step
      end
    
      return range
    end,
    
  },
  form_filling_specifier = {
    str_key_str_value_assoc_by_filled = function(spec)
      local res = get.role_content_message_spec_arr.str_by_llm_response_with_api_system_message({
        { 
          role = "user",
          content = "Return a json object. The field names will be those listed in the first message. The information is to be extracted from the dictionary in the third message. The second message contains explanations for what the fields mean/should contain, and may be empty. If there seems to be no data for a field, just leave it blank."
        }, {
          role = "user",
          content = transf.not_userdata_or_fn.json_str_by_pretty(
            spec.form_fields
          )
        }, {
          role = "user",
          content = transf.not_userdata_or_fn.json_str_by_pretty(
            spec.explanations
          )
        }, {
          role = "user",
          content = transf.not_userdata_or_fn.json_str_by_pretty(
            spec.in_fields
          )
        }
      })
      return transf.json_str.not_userdata_or_fn(res)
    end,
  },
  position_change_state_spec = {
    bool_by_should_continue = function(position_change_state_spec)
      return position_change_state_spec.num_steps > 0
        and (position_change_state_spec.delta_hs_geometry_point.x > 0.1
          or position_change_state_spec.delta_hs_geometry_point.y > 0.1)
    end,
    position_change_state_spec_by_next = function(position_change_state_spec)
      local next_position_change_state_spec  = {}
      next_position_change_state_spec.num_steps = position_change_state_spec.num_steps - 1
      next_position_change_state_spec.delta_hs_geometry_point = position_change_state_spec.delta_hs_geometry_point * position_change_state_spec.factor_of_deceleration
      next_position_change_state_spec.past_ideal_hs_geometry_point = position_change_state_spec.past_ideal_hs_geometry_point + position_change_state_spec.delta_hs_geometry_point
      local jittered_delta_hs_geometry_point = next_position_change_state_spec.delta_hs_geometry_point * transf.number_interval_specifier.number_by_random({
        start = -position_change_state_spec.jitter_factor,
        stop = position_change_state_spec.jitter_factor
      })
      next_position_change_state_spec.current_hs_geometry_point = next_position_change_state_spec.past_ideal_hs_geometry_point * jittered_delta_hs_geometry_point
      next_position_change_state_spec.jitter_factor = position_change_state_spec.jitter_factor
      return next_position_change_state_spec
    end,
  },
  declared_position_change_input_spec = {
    hs_geometry_point_by_start = function(declared_position_change_input_spec)
      local target_point = declared_position_change_input_spec.target_hs_geometry_point or hs.geometry.point(0, 0)
      if declared_position_change_input_spec.relative_to then
        if declared_position_change_input_spec.relative_to ~= "curpos" then
          local front_window = transf.running_application.main_window(hs.application.frontmostApplication())
          target_point = get.window.hs_geometry_point_by_with_offset(front_window, declared_position_change_input_spec.relative_to, target_point)
        else
          target_point = target_point + transf[
            declared_position_change_input_spec.mode .. "_input_spec"
          ].hs_geometry_point_by_start(declared_position_change_input_spec)
        end
      end
      return target_point
    end,
    inclusive_proper_fraction_by_jitter_factor = function(declared_position_change_input_spec)
      return declared_position_change_input_spec.jitter_factor or 0.1
    end,
    pos_number_by_duration = function(declared_position_change_input_spec)
      return declared_position_change_input_spec.duration or transf.number_interval_specifier.number_by_random({start=0.1, stop=0.3})
    end,
    inclusive_proper_fraction_by_factor_of_deceleration = function(declared_position_change_input_spec)
      return declared_position_change_input_spec.factor_of_deceleration or 0.95
    end,
    position_change_state_spec_by_start = function(declared_position_change_input_spec)
      local starting_point = transf[
        declared_position_change_input_spec.mode .. "_input_spec"
      ].hs_geometry_point_by_start(declared_position_change_input_spec)
      local total_delta = transf.declared_position_change_input_spec.hs_geometry_point_by_start(declared_position_change_input_spec) - starting_point
      local starting_position_change_state_spec = {}
      starting_position_change_state_spec.num_steps = math.ceil(
        transf.declared_position_change_input_spec.pos_number_by_duration(declared_position_change_input_spec) / POLLING_INTERVAL
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
        getStartingDelta(total_delta.x, transf.declared_position_change_input_spec.inclusive_proper_fraction_by_factor_of_deceleration(declared_position_change_input_spec), starting_position_change_state_spec.num_steps),
        getStartingDelta(total_delta.y, transf.declared_position_change_input_spec.inclusive_proper_fraction_by_factor_of_deceleration(declared_position_change_input_spec), starting_position_change_state_spec.num_steps)
      )
      starting_position_change_state_spec.jitter_factor = transf.declared_position_change_input_spec.inclusive_proper_fraction_by_jitter_factor(declared_position_change_input_spec)
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
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        str_arr,
        transf.input_spec_str.input_spec
      )
    end,
  },
  input_spec_series_str = {
    input_spec_str_arr = function(str)
      return transf.hole_y_arrlike.arr(get.str.not_starting_o_ending_with_whitespace_str_arr_by_split_w_str(str, "\n"))
    end,
    input_spec_arr = function(str)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        transf.input_spec_series_str.input_spec_str_arr(str),
        transf.input_spec_str.input_spec
      )
    end,
  },
  str_prompt_args_spec = {
    --- @class prompt_args
    --- @field message? any Message to display in the prompt.
    --- @field default? any Default value for the prompt.

    --- @class str_prompt_args_spec : prompt_args
    --- @field informative_text? any Additional text to display in the prompt.
    --- @field buttonA? any Label for the first button.
    --- @field buttonB? any Label for the second button.

    --- @param prompt_args? str_prompt_args_spec
    --- @return (str|nil), boolean
    str_or_nil_and_bool = function(prompt_args)

      -- set up default values, make sure provided values are strs

      prompt_args = prompt_args or {}
      prompt_args.message = transf.any.str_or_nil(prompt_args.message) or "Enter a str."
      prompt_args.informative_text = transf.any.str_or_nil(prompt_args.informative_text) or ""
      prompt_args.default = transf.any.str_or_nil(prompt_args.default) or ""
      prompt_args.buttonA = transf.any.str_or_nil(prompt_args.buttonA) or "OK"
      prompt_args.buttonB = transf.any.str_or_nil(prompt_args.buttonB) or "Cancel"

      -- show prompt

      dothis.mac_application_name.activate("Hammerspoon")
      --- @type str, str|nil
      local button_pressed, raw_return = hs.dialog.textPrompt(prompt_args.message, prompt_args.informative_text, prompt_args.default,
      prompt_args.buttonA, prompt_args.buttonB)

      -- process result

      local ok_button_pressed = button_pressed == prompt_args.buttonA

      if get.str.bool_by_startswith(raw_return, " ") then -- space triggers lua eval mode
        raw_return = get.str.any_by_evaled_as_lua(raw_return)
      end
      if raw_return == "" then
        raw_return = nil
      end

      -- return result

      return raw_return, ok_button_pressed
    end

  },
  path_prompt_args_spec = {

    --- @class path_prompt_args_spec : prompt_args
    --- @field can_choose_files? boolean 
    --- @field can_choose_directories? boolean
    --- @field multiple? boolean
    --- @field allowed_file_types? str[]
    --- @field resolves_aliases? boolean

    --- @param prompt_args path_prompt_args_spec
    --- @return (str|str[]|nil), boolean
    local_absolute_path_or_local_absolute_path_arr_and_bool = function(prompt_args)

      -- set up default values, make sure message and default are strs
  
      prompt_args                        = prompt_args or {}
      prompt_args.message                = get.any.default_if_nil(transf.any.str_or_nil(prompt_args.message), "Choose a file or folder.")
      prompt_args.default                = get.any.default_if_nil(transf.any.str_or_nil(prompt_args.default), env.HOME)
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
      return transf.path_prompt_args_spec.local_absolute_path_or_local_absolute_path_arr_and_bool(prompt_args)
    end,
    local_absolute_path_arr_and_bool = function(prompt_args)
      prompt_args.multiple = true
      return transf.path_prompt_args_spec.local_absolute_path_or_local_absolute_path_arr_and_bool(prompt_args)
    end,
  
  },
  prompt_spec = {

    --- @alias failure_action "error" | "return_nil" | "reprompt"

    --- @class prompt_spec
    --- @field prompter fun(prompt_args: table): any, boolean The function that implements prompting. Must return nil on the equivalent of an empty value.
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
    role_content_message_spec_arr_by_with_api_system_message = function(arr)
      return transf.any_and_arr.arr({
        role = "system",
        content = "You are a helpful assistant being queried through an API. Your output will be parsed, so adhere to any instructions given as to the format or content of the output. Only output the result."
      }, arr)
    end,
  },
  n_shot_llm_spec = {
    role_content_message_spec_arr_or_nil_by_shots = function(spec)
      if spec.shots then
        return transf.two_strs__arr_arr.role_content_message_spec_arr_by_alternating_user_assistant(spec.shots)
      end
    end,
    role_content_message_spec_arr_by_api_query = function(spec)
      return transf.role_content_message_spec_arr.role_content_message_spec_arr_by_with_api_system_message(
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
              content = "If you are unable to fulfill the request, return 'IMPOSSIBLE'. You may additionally return a message explaining why the request is impossible."
            }
          },
          transf.n_shot_llm_spec.role_content_message_spec_arr_or_nil_by_shots(spec) or {},
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
    rt_or_nil_ret_fn_by_pcall = function(fn)
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
      return "Waiting to proceed (" .. #qspec.fn_arr .. " waiting in queue) ... (Press " .. transf.hotkey_created_item_specifier.str_by_shortcut(qspec.hotkey_created_item_specifier) .. " to continue.)"
    end,
      
  },
  bool_ret_fn = {
    bool_ret_fn_by_invert = function(fn)
      return function(...)
        return not fn(...)
      end
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
      return transf.str.in_cache_local_absolute_path(fnname, "fsmemoize")
    end,
    
  },
  discord_export_dir = {
    export_chat_main_object_and_local_dir__arr_arr_by_media_dir = function(dir)
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        transf.dir.dir_arr_by_children(dir),
        transf.discord_export_child_dir.export_chat_main_object_and_local_dir__arr_by_media_dir
      )
    end,
    
  },
  discord_export_child_dir = {
    export_chat_main_object_and_local_dir__arr_by_media_dir = function(dir)
      local json_file = get.dir.extant_path_by_child_having_extension(dir, "json")
      local media_dir = get.dir.extant_path_by_child_having_extension(dir, "_Files")
      if not json_file or not media_dir then error("Could not find json or media dir in " .. dir) end
      return {transf.json_file.not_userdata_or_fn(json_file), media_dir}
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
      return transf.timestamp_s.timestamp_ms(
        msg.timestamp
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
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
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
    export_chat_main_object_and_local_dir__arr_arr_by_media_dir = function(dir)
      local chat_dirs = transf.dir.dir_arr_by_children(dir)
      local arr = get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        chat_dirs,
        function(chat_dir)
          local media_dir = transf.path.path_by_ending_with_slash(chat_dir) .. "media"
          local main_obj = transf.json_file.not_userdata_or_fn(
            transf.path.path_by_ending_with_slash(chat_dir) .. "message_1.json"
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
    export_chat_main_object_and_local_dir__arr_arr_by_media_dir = function(dir)
      local chat_json_files = transf.dir.absolute_path_arr_by_children(dir .. "/chats")
      local arr = get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
        chat_json_files,
        function(chat_json_file)
          local filename = transf.path.leaflike_by_filename(chat_json_file)
          local author = filename:match("^([^(]+)")
          local media_dir = dir .. "/media/" .. filename
          local messages = transf.json_file.not_userdata_or_fn(chat_json_file)
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
      return main_object.messages[1].conversationId
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
      return get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(
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
    export_chat_main_object_and_local_dir__arr_arr_by_media_dir = function(dir)
      local json_file = get.dir.extant_path_by_child_having_leaf(dir, "result.json")
      local export_json = transf.json_file.not_userdata_or_fn(json_file)

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
  str_or_number_arr = {
    str_by_joined_comma = function(arr)
      return get.str_or_number_arr.str_by_joined(arr, ", ")
    end,
  },
  plist_single_dk_spec = {
    plist_type_name_or_nil_by_read = function(spec)
      return transf.str.str_or_err_by_evaled_env_bash_stripped_noempty(
        "defaults read-type " .. transf.str.str_by_single_quoted_escaped(spec.domain) .. " " .. transf.str.str_by_single_quoted_escaped(spec.key)
      )
    end,
    str_or_nil_by_read_value = function(spec)
      return transf.str.str_or_err_by_evaled_env_bash_stripped_noempty(
        "defaults read " .. transf.str.str_by_single_quoted_escaped(spec.domain) .. " " .. transf.str.str_by_single_quoted_escaped(spec.key)
      )
    end,
  },
  plist_single_dkv_spec = {
    mac_plist_type_name = function(spec)
      if spec.type then -- manual
        return spec.type
      else -- inferred
        return transf.any.mac_plist_type_name(spec.value)
      end
    end,
    str_by_value_mac_plist_encoded = function(spec)
      local mac_plist_type_name = transf.any.mac_plist_type_name(spec)
      if is.any.table(spec.value) then
        if get.str.bool_by_startswith(mac_plist_type_name, "array") then
          if is.table.array(spec.value) then
            return transf.arr.str_arr_by_mapped_single_quoted_escaped(
              spec.value
            )
          else
            error("Please don't try to add an assoc as an array to a plist. It doesn't have any inherent order, so adding it would impose an arbitrary order.")
          end
        elseif get.str.bool_by_startswith(mac_plist_type_name, "dict") then
          return transf.arr.str_arr_by_mapped_single_quoted_escaped(
              transf.table.kt_or_vt_arr(spec.value)
            )
        else
          return transf.any.str(spec.value)
        end
      else 
        return transf.any.str(spec.value)
      end
    end,
    line_by_write_default_command = function(spec)
      return 
        "defaults write" ..
        transf.str.str_by_single_quoted_escaped(spec.domain) ..
        transf.str.str_by_single_quoted_escaped(spec.key) ..
        transf.str.str_by_single_quoted_escaped(
          transf.plist_single_dkv_spec.mac_plist_type_name(spec)
        ) ..
        transf.str.str_by_single_quoted_escaped(
          transf.plist_single_dkv_spec.str_by_value_mac_plist_encoded(spec)
        )
    end,
  },
  api_name = {
    local_absolute_path_by_api_details_location_dir = function(api_name)
      return env.MAPI .. "/" .. api_name .. "/"
    end,
    local_absolute_path_by_api_key_file = function(api_name)
      return transf.api_name.local_absolute_path_by_api_details_location_dir(api_name) .. "key"
    end,
    str_or_nil_by_api_key = function(api_name)
      local key_file = transf.api_name.local_absolute_path_by_api_key_file(api_name)
      return transf.absolute_path.str_or_nil_by_file_contents(key_file)
    end,
    local_absolute_path_by_access_token_file = function(api_name)
      return transf.api_name.local_absolute_path_by_api_details_location_dir(api_name) .. "access_token"
    end,
    str_or_nil_by_access_token = function(api_name)
      local access_token_file = transf.api_name.local_absolute_path_by_access_token_file(api_name)
      return transf.absolute_path.str_or_nil_by_file_contents(access_token_file)
    end,
    local_absolute_path_by_refresh_token_file = function(api_name)
      return transf.api_name.local_absolute_path_by_api_details_location_dir(api_name) .. "refresh_token"
    end,
    str_or_nil_by_refresh_token = function(api_name)
      local refresh_token_file = transf.api_name.local_absolute_path_by_refresh_token_file(api_name)
      return transf.absolute_path.str_or_nil_by_file_contents(refresh_token_file)
    end,
    local_absolute_path_by_client_id_file = function(api_name)
      return transf.api_name.local_absolute_path_by_api_details_location_dir(api_name) .. "client_id"
    end,
    str_or_nil_by_client_id = function(api_name)
      local client_id_file = transf.api_name.local_absolute_path_by_client_id_file(api_name)
      return transf.absolute_path.str_or_nil_by_file_contents(client_id_file)
    end,
    local_absolute_path_by_client_secret_file = function(api_name)
      return transf.api_name.local_absolute_path_by_api_details_location_dir(api_name) .. "client_secret"
    end,
    str_or_nil_by_client_secret = function(api_name)
      local client_secret_file = transf.api_name.local_absolute_path_by_client_secret_file(api_name)
      return transf.absolute_path.str_or_nil_by_file_contents(client_secret_file)
    end,
    local_absolute_path_by_authorization_code_file = function(api_name)
      return transf.api_name.local_absolute_path_by_api_details_location_dir(api_name) .. "authorization_code"
    end,
    str_or_nil_by_authorization_code = function(api_name)
      local authorization_code_file = transf.api_name.local_absolute_path_by_authorization_code_file(api_name)
      return transf.absolute_path.str_or_nil_by_file_contents(authorization_code_file)
    end,
  }
  
}

transf.any.pos_int_by_unique_id_primitives_equal = transf["nil"].any_arg_pos_int_ret_fn_by_unique_id_primitives_equal()
transf.fn.fnid = transf["nil"].any_arg_pos_int_ret_fn_by_unique_id_primitives_equal() -- functionally the same, but I'll limit it to functions 'by hand'