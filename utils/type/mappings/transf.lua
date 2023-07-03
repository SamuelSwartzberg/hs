--- @alias relay_table { [string]: { [string]: string[] } }


transf = {
  hex_string = { -- a hex string
    char = function(hex)
      return string.char(get.string_or_number.number(hex, 16))
    end,
    utf8_unicode_prop_table = function(hex)
      return memoize(runJSON)("uni print -compact -format=all -as=json".. transf.string.single_quoted_escaped("utf8:" .. transf.digit_string.canonical_digit_string(hex)))[1]
    end,
    unicode_codepoint = function(hex)
      return "U+"  .. transf.digit_string.canonical_digit_string(hex)
    end,
  },
  potentially_indicated_digit_string = {
    digit_string = function(indicated_number)
      return onig.match(indicated_number, "^(?:0[" .. table.concat(keys(tblmap.base_letter.base), "") .. "])?(.+)$")
    end,
  },
  digit_string = {
    canonical_digit_string = function(digit_string)
      local cleaned = eutf8.gsub(digit_string, "[_ ]", "")
      local seps_fixed = eutf8.gsub(cleaned, ",", ".")
      return seps_fixed
    end,
    nonfractional_fractional_part = function(digit_string)
      return onig.match(
        transf.digit_string.canonical_digit_string(digit_string), 
        "^(\\d*+)(\\.\\d+?)?$"
      )
    end,
    separated_canonical_digit_string = function(digit_string)
      local nonfractional, fractional = transf.digit_string.nonfractional_fractional_part(digit_string)
      local nonfractional_separated = table.concat(
        chunk(nonfractional, 3),
        "_"
      )
      return nonfractional_separated .. fractional
    end,

  },
  indicated_digit_string = {
    number_string = function(indicated_number)
      return indicated_number:sub(3)
    end,
    base = function(indicated_number)
      return tblmap.base_letter.base[
          indicated_number:sub(2, 2)
        ]
    end,
    number = function(indicated_number)
      return get.string_or_number.number(
        indicated_number:sub(3),
        transf.indicated_digit_string.base(indicated_number)
      )
    end,
  },
  potentially_indicated_binary_string = {
    indicated_binary_string = function(bin)
      return mustStart(bin, "0b")
    end,
    number = function(bin)
      return get.string_or_number.number(mustNotStart(bin, "0b"), 2)
    end
  },
  potentially_indicated_octal_string = {
    indicated_octal_string = function(oct)
      return mustStart(oct, "0o")
    end,
    number = function(oct)
      return get.string_or_number.number(mustNotStart(oct, "0o"), 8)
    end
  },
  potentially_indicated_decimal_string = {
    indicated_decimal_string = function(dec)
      return mustStart(dec, "0d")
    end,
    number = function(dec)
      return get.string_or_number.number(mustNotStart(dec, "0d"), 10)
    end
  },
  potentially_indicated_hex_string = {
    indicated_hex_string = function(hex)
      return mustStart(hex, "0x")
    end,
    number = function(hex)
      return get.string_or_number.number(mustNotStart(hex, "0x"), 16)
    end
  },

  percent = {
    char = function(percent)
      local num = percent:sub(2, 3)
      return string.char(get.string_or_number.number(num, 16))
    end,
  },
  unicode_codepoint = { -- U+X...
    number = function(codepoint)
      return get.potentially_indicated_hex_string.number(transf.unicode_codepoint.hex_string(codepoint))
    end,
    hex_string = function(codepoint)
      return codepoint:sub(3)
    end,
    unicode_prop_table = function(codepoint)
      return memoize(runJSON)(
        "uni print -compact -format=all -as=json" 
        .. transf.string.single_quoted_escaped(
          "U+" .. transf.digit_string.canonical_digit_string(
            transf.unicode_codepoint.hex_string(codepoint)
          )
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
      return transf.string.nowhitespace(unicode_prop_table.utf8)
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
    decimal_string = function(num)
      return tostring(num)
    end,
    indicated_decimal_string = function(num)
      return "0d" .. transf.number.decimal_string(num)
    end,
    hex_string = function(num)
      return string.format("%X", num)
    end,
    indicated_hex_string = function(num)
      return "0x" .. transf.number.hex_string(num)
    end,
    unicode_codepoint = function(num)
      return "U+" .. transf.number.hex_string(num)
    end,
    octal_string = function(num)
      return string.format("%o", num)
    end,
    indicated_octal_string = function(num)
      return "0o" .. transf.number.octal_string(num)
    end,
    binary_string = function(num)
      return string.format("%b", num)
    end,
    indicated_binary_string = function(num)
      return "0b" .. transf.number.binary_string(num)
    end,
    unicode_prop_table = function(num)
      return transf.unicode_codepoint.unicode_prop_table(transf.number.unicode_codepoint(num))
    end,
    utf8_unicode_prop_table = function(num)
      return transf.hex_string.utf8_unicode_prop_table(transf.number.hex_string(num))
    end,
    int = function(num)
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
    pos_int = function(num)
      return transf.int.pos_int(transf.number.int(num))
    end,
    neg_int = function(num)
      return transf.int.neg_int(transf.number.int(num))
    end,
    floor = math.floor,
    ceil = math.ceil,
  },
  num_chars = {
    normzeilen = function(num_chars)
      return transf.number.int(
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
    pos_int = function(int)
      return math.abs(int)
    end,
    neg_int = function(int)
      return -math.abs(int)
    end,
  },
  pos_int = {
    largest_int_of_length = function(int)
      return 10^int - 1
    end,
    smallest_int_of_length = function(int)
      return (transf.pos_int.largest_int_of_length(int)+1) / 10
    end,
    center_int_of_length = function(int)
      return (transf.pos_int.largest_int_of_length(int)+1) / 2
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
    first = function(arr)
      return arr[1]
    end,
    last = function(arr)
      return arr[#arr]
    end,
    length = function(arr)
      return #arr
    end,
    first_rest = function(arr)
      return arr[1], slice(arr, 2)
    end,
    empty_string_value_dict = function(arr)
      return map(
        arr,
        transf.any.self_and_empty_string,
        {"v", "kv"}
      )
    end,
  },
  hole_y_arraylike = {
    array = function(tbl)
      local new_tbl = list({})
      for i = 1, #tbl do
        if tbl[i] ~= nil then
          new_tbl[#new_tbl + 1] = tbl[i]
        end
      end
      return new_tbl
    end
  },
  char = {
    hex = function(char)
      return string.format("%02X", string.byte(char))
    end,
    percent = function(char)
      return string.format("%%%02X", string.byte(char))
    end,
    unicode_prop_table = function(char)
      return memoize(runJSON)("uni identify -compact -format=all -as=json".. transf.string.single_quoted_escaped(char))[1]
    end
  },
  leaf = {
    rf3339like_dt_or_range_general_name_fs_tag_string = function(leaf)
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
    attachment = function(path)
      local mimetype = mimetypes.guess(path) or "text/plain"
      return "#" .. mimetype .. " " .. path
    end,
    no_leading_following_slash_or_whitespace = function(item)
      item = stringy.strip(item)
      return item
    end,
    form_path = function(path)
      return "@" .. path
    end,
    extension = function(path)
      return pathSlice(path, "-1:-1", refstore.params.path_slice.opts.ext_sep)[1]
    end,
    standartized_extension = function(path)
      return pathSlice(path, "-1:-1", refstore.params.path_slice.opts.sep_standartize)[1]
    end,
    no_extension = function(path)
      return pathSlice(path, "1:-2", refstore.params.path_slice.opts.sep_rejoin)
    end,
    filename = function(path)
      return pathSlice(path, "-2:-2", refstore.params.path_slice.opts.ext_sep)[1]
    end,
    ending_with_slash = function(path)
      return mustEnd(path or "", "/")
    end,
    leaf = function(path)
      return pathSlice(path, "-1:-1")[1]
    end,
    parent_path = function(path)
      return pathSlice(path, "1:-2", refstore.params.path_slice.opts.sep_rejoin)
    end,
    parent_leaf = function(path)
      return pathSlice(path, "-2:-2", refstore.params.path_slice.opts.ext_sep)[1]
    end,
    ancestor_array = function(path)
      return pathSlice(path, "1:-2", {entire_path_for_each = true})
    end,
    path_leaf_parts = function(path)
      local rf3339like_dt_or_range, general_name, fs_tag_string = transf.leaf.rf3339like_dt_or_range_general_name_fs_tag_string(transf.path.leaf(path))
      return {
        extension = transf.path.extension(path),
        path = transf.path.parent_path(path),
        rfc3339like_dt_or_range = rf3339like_dt_or_range,
        general_name = general_name,
        fs_tag_assoc = transf.fs_tag_string.fs_tag_assoc(fs_tag_string),
      }
    end,
    window_array_with_leaf_as_title = function(path)
      return transf.string.window_array_by_title(transf.path.leaf(path))
    end
    

  },
  path_with_intra_file_locator = {
    path_with_intra_file_locator_specifier = function(path)
      local parts = stringy.split(path, ":")
      local final_part = pop(parts)
      local specifier = {}
      if is.string.number(parts[#parts]) then
        specifier = {
          column = final_part,
          line = pop(parts),
          path = table.concat(parts, ":")
        }
      else
        specifier = {
          line = final_part,
          path = table.concat(parts, ":")
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
    series_specifier = function(specifier)
      return ":ctrl+g,:+" .. transf.path_with_intra_file_locator_specifier.intra_file_locator(specifier) .. ",:+return"
    end,
     
  },
  absolute_path = {
    file_url = function(path)
      return "file://" .. path
    end,
  },
  extant_path = {
    size = function(path)
      return get.extant_path.attr(path, "size")
    end,
    m_date = function(path)
      return get.extant_path.date_attr(path, "modification")
    end,
    c_date = function(path)
      return get.extant_path.date_attr(path, "change")
    end,
    a_date = function(path)
      return get.extant_path.date_attr(path, "access")
    end,
    cr_date = function(path)
      return get.extant_path.date_attr(path, "creation")
    end,
    sibling_array = function(path)
      return transf.dir.children_array(transf.path.parent_path(path))
    end,
    contained_files_array = function(path)
      if is.path.dir(path) then
        return transf.dir.descendant_file_array(path)
      else
        return {path}
      end
    end,
    prompted_path_relative_to = function(path)
      return promptPipeline({
        {"dir", {prompt_args = {default = path}}},
        {"string", {prompt_args = {message = "Subdirectory name"}}, "pipeline"}
      }) --[[ @as string ]]
    end,
    prompted_file_relative_to = function(path)
      local path = transf.extant_path.prompted_path_relative_to(path)
      local filename = prompt("string", {prompt_args = {message = "file in " .. path}})
      return path .. "/" .. filename
    end
  },
  path_in_home = {
    local_http_server_url = function(path)
      return env.FS_HTTP_SERVER .. path
    end,
  },
  path_array = {
    leaves_array = function(path_array)
      return hs.fnutils.imap(path_array, transf.path.leaf)
    end,
    filenames_array = function(path_array)
      local filenames = hs.fnutils.imap(path_array, transf.path.filename)
      return toSet(filenames)
    end,
    extensions_array = function(path_array)
      local extensions = hs.fnutils.imap(path_array, transf.path.extension)
      return toSet(extensions)
    end,
    extant_path_array = function(path_array)
      return hs.fnutils.ifilter(path_array, is.path.exists)
    end,
    attachment_array = function(path_array)
      return hs.fnutils.imap(path_array, transf.path.attachment)
    end,
    attachment_string = function(path_array)
      return table.concat(transf.path_array.attachment_array(path_array), "\n")
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
    contained_files_array = function(path_array)
      return map(
        path_array,
        transf.extant_path.contained_files_array,
        {flatten = true}
      )
    end,
  },
  dir_array = {
    filter_git_root_dir_array = function(path_array)
      return hs.fnutils.ifilter(path_array, is.dir.git_root_dir)
    end,
  },
  dir = {
    children_array = function(dir)
      return itemsInPath(dir)
    end,
    children_leaves_array = function(dir)
      return transf.path_array.leaves_array(transf.dir.children_array(dir))
    end,
    children_filenames_array = function(dir)
      return transf.path_array.filenames_array(transf.dir.children_array(dir))
    end,
    children_extensions_array = function(dir)
      return transf.path_array.extensions_array(transf.dir.children_array(dir))
    end,
    newest_child = function(dir)
      return transf.extant_path_array.newest(transf.dir.children_array(dir))
    end,
    descendants_array = function(dir)
      return itemsInPath({
        path = dir,
        recursive = true,
      })
    end,
    descendant_file_array = function(dir)
      return itemsInPath({
        path = dir,
        recursive = true,
        include_dirs = false,
      })
    end,
    descendants_leaves_array = function(dir)
      return transf.path_array.leaves_array(transf.dir.descendants_array(dir))
    end,
    descendants_filenames_array = function(dir)
      return transf.path_array.filenames_array(transf.dir.descendants_array(dir))
    end,
    descendants_extensions_array = function(dir)
      return transf.path_array.extensions_array(transf.dir.descendants_array(dir))
    end,
    grandchildren_array = function(dir)
      return map(transf.dir.children_array(dir), transf.dir.children_array, { flatten = true })
    end,
    git_root_dir_descendants = function(dir)
      return transf.dir_array.filter_git_root_dir_array(transf.dir.descendants_array(dir))
    end,

  },

  in_git_dir = {
    git_root_dir = function(path)
      return get.extant_path.find_self_or_ancestor(
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
      raw = mustNotEnd(raw, ".git")
      raw = mustNotEnd(raw, "/")
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
      if listContains(mt._list.remote_types, transf.in_git_dir.remote_sld(path)) then
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
      local lines = transf.string.lines(raw_hashes)
      return filter(lines, true)
    end


  },

  git_root_dir = {
    dotgit_dir = function(git_root_dir)
      return transf.path.ending_with_slash(git_root_dir) .. ".git"
    end,
    hooks_dir = function(git_root_dir)
      return transf.path.ending_with_slash(git_root_dir) .. ".git/hooks"
    end,
    hooks = function(git_root_dir)
      return itemsInPath(transf.git_root_dir.hooks_dir(git_root_dir))
    end,
  },

  github_username = {
    github_url = function(github_username)
      return "https://github.com/" .. github_username
    end,
  },
  
  path_leaf_parts = {
    general_name_part = function(path_leaf_parts)
      if path_leaf_parts.general_name then 
        return "--" .. path_leaf_parts.general_name
      else
        return ""
      end
    end,
    extension_part = function(path_leaf_parts)
      if path_leaf_parts.extension then 
        return "." .. path_leaf_parts.extension
      else
        return ""
      end
    end,
    rf3339like_dt_or_range_part = function(path_leaf_parts)
      return path_leaf_parts.rf3339like_dt_or_range or ""
    end,
    path_part = function(path_leaf_parts)
      return transf.path.ending_with_slash(path_leaf_parts.path) 
    end,
    fs_tag_assoc = function(path_leaf_parts)
      return path_leaf_parts.fs_tag_assoc
    end,
    fs_tag_string_dict = function(path_leaf_parts)
      return transf.fs_tag_assoc.fs_tag_string_dict(path_leaf_parts.fs_tag_assoc)
    end,
    fs_tag_string_part_array = function(path_leaf_parts)
      return transf.fs_tag_assoc.fs_tag_string_part_array(path_leaf_parts.fs_tag_assoc)
    end,
    fs_tag_string = function(path_leaf_parts)
      return transf.fs_tag_assoc.fs_tag_string(path_leaf_parts.fs_tag_assoc)
    end,
    fs_tag_keys = function(path_leaf_parts)
      return keys(path_leaf_parts.fs_tag_assoc)
    end,
    path = function(path_leaf_parts)
      return transf.path.ending_with_slash(path_leaf_parts.path) 
      .. transf.path_leaf_parts.rf3339like_dt_or_range_part(path_leaf_parts)
      .. transf.path_leaf_parts.general_name_part(path_leaf_parts)
      .. transf.path_leaf_parts.fs_tag_string(path_leaf_parts)
      .. transf.path_leaf_parts.extension_part(path_leaf_parts)
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
      return map(
        transf.fs_tag_string.fs_tag_string_part_array(fs_tag_string),
        bind(get.string.split_unpacked, {a_use, "-", 2}),
        {"v", "kv"}
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
      return map(
        fs_tag_string_part_array,
        bind(get.string.split_unpacked, {a_use, "-", 2}),
        {"v", "kv"}
      )
    end,
    fs_tag_assoc = function(fs_tag_string_part_array)
      transf.fs_tag_string_dict.fs_tag_assoc(
        transf.fs_tag_string_part_array.fs_tag_string_dict(fs_tag_string_part_array)
      )
    end,
    fs_tag_string = function(fs_tag_string_part_array)
      return "%" .. table.concat(fs_tag_string_part_array, "%")
    end,
  },
  fs_tag_string_dict = {
    fs_tag_assoc = function(dict)
      return hs.fnutils.map(
        dict,
        bind(stringy.split, {a_use, ","})
      )
    end,
    fs_tag_string_part_array = function(dict)
      return map(
        dict,
        {_f = "%s-%s"},
        {
          args = "kv",
          ret = "v",
          tolist = true,
        }
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
  path_leaf_parts_array = {

  },
  audio_file = {
    transcribed = function(path)
      return memoize(rest, refstore.params.memoize.opts.invalidate_1_year_fs, "rest")({
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
  image_file = {
    qr_data = function(path)
      return run("zbarimg -q --raw " .. transf.string.single_quoted_escaped(path))
    end,
    hs_image = function(path)
      return memoize(hs.image.imageFromPath, refstore.params.memoize.opts.invalidate_1_week_fs, "hs.image.imageFromPath")(path)
    end,
    booru_url = function(path)
      return run(
        "saucenao --file" ..
        transf.string.single_quoted_escaped(path)
        .. "--output-properties booru-url"
      )
    end,
    data_url = function(path)
      local ext = transf.path.extension(path)
      return memoize(hs.image.encodeAsURLString)(transf.image_file.hs_image(path), ext)
    end,
  },
  email_file = {
    all_headers_raw = function(path)
      return run(
        "mshow -L" .. transf.string.single_quoted_escaped(path)
      )
    end,
    all_useful_headers_raw = function(path)
      return run(
        "mshow -q" .. transf.string.single_quoted_escaped(path)
      )
    end,
    useful_header_dict = function(path)
      error("TODO: currently the way the headers are rendered contains a bunch of stuff we wouldn't want in the dict. In particular, emails without a name are rendered as <email>, which may not be what we want.")
      return transf.header_string.dict(transf.email_file.all_useful_headers_raw(path))
    end,
    rendered_body = function(path)
      return memoize(run)(
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
      return run(
        "mshow -t" .. transf.string.single_quoted_escaped(path)
      )
    end,
    attachments = function(path)
      return transf.mime_parts_raw.attachments(transf.email_file.mime_parts_raw(path))
    end,
    summary = function(path)
      return memoize(run)("mscan -f %D **%f** %200s" .. transf.string.single_quoted_escaped(path))
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
      specifier = copy(specifier)
      local body = specifier.body or ""
      specifier.body = nil
      local non_inline_attachments = specifier.non_inline_attachments
      specifier.non_inline_attachments = nil
      local header = transf.stringable_value_dict.email_header(specifier)
      local mail = string.format("%s\n\n%s", header, body)
      if non_inline_attachments then
        mail = mail .. "\n" .. transf.path_array.attachment_string(non_inline_attachments)
      end
      return mail
    end,

    draft_email_file = function(specifier)
      

      local mail = join.string.table.email(body, specifier)
      local evaled_mail = le(mail)
      local temppath = transf.not_userdata_or_function.in_tmp_dir(evaled_mail)
      local outpath = temppath .. "_out"
      run("mmime < " .. transf.string.single_quoted_escaped(temppath) .. " > " .. transf.string.single_quoted_escaped(outpath))
      delete(temppath)
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
      return runJSON({
        "citation-js",
        "--input",
        {
          value = path,
          type = "quoted"
        },
        "--output-language", "json"
      })
    end,

  },

  ics_file = {
    array_of_tables = function(path)
      local temppath = transf.string.in_tmp_dir(transf.path.filename(path) .. ".ics")
      srctgt("copy", path, temppath)
      dothis.ics_file.generate_json_file(temppath)
      local jsonpath = readFile(get.path.with_different_extension(temppath, "json"))
      local res = json.decode(readFile(jsonpath))
      delete(jsonpath)
      delete(temppath)
      return res
    end,
  },
  json_file = {
    table = function(path)
      return transf.not_userdata_or_function.table(readFile(path))
    end,
  },
  ini_file = {
    table = function(path)
      return transf.ini_string.table(readFile(path))
    end,
  },
  toml_file = {
    table = function(path)
      return transf.toml_string.table(readFile(path))
    end,
  },
  xml_file = {
    tree = xml.parseFile
  },
  tree_node = {

  },
  inner_tree_node = {

  },
  leaf_tree_node = {

  },

  env_var_name_value_dict = {
    key_value_and_dependency_dict = function(dict)
      return hs.fnutils.imap(dict, function(value)
        return {
          value = value,
          dependencies = iterToTbl({tolist=true, ret="v"},eutf8.gmatch(value, "%$([A-Z0-9_]+)"))
        }
      end)
    end,
    dependency_ordered_key_value_pair_array = function(dict)
      return transf.key_value_and_dependency_dict.dependency_ordered_key_value_pair_array(
        transf.key_value_and_dependency_dict.key_value_and_dependency_dict(dict)
      )
    end,
    env_string = function(dict)
      transf.env_line_array.env_string(
        transf.pair_array.env_line_array(
          transf.env_var_name_value_dict.dependency_ordered_key_value_pair_array(dict)
        )
      )
    end

  },
  key_value_and_dependency_dict = {
    dependency_ordered_key_value_pair_array = function(dict)local result = {}  -- Table to store the sorted keys
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
              for _, dep in ipairs(dict[key]['dependencies']) do
                  dfs(dep)
              end
  
              temp_stack[key] = nil  -- Remove key from temporary stack
              visited[key] = true  -- Mark key as visited
              table.insert(result, { key, dict[key]['value'] })  -- Append {key, value} pair to result
          end
      end
  
      -- Perform DFS traversal for each key in the graph
      for key, _ in pairs(dict) do
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
    contents = function(path)
      return readFile(path)
    end,
    lines = function(path)
      return transf.string.lines(transf.plaintext_file.contents(path))
    end,
    content_lines = function(path)
      return transf.string.content_lines(transf.plaintext_file.contents(path))
    end,
    noindent_content_lines = function(path)
      return transf.string.noindent_content_lines(transf.plaintext_file.contents(path))
    end,
    nocomment_noindent_content_lines = function(path)
      return transf.string.nocomment_noindent_content_lines(transf.plaintext_file.contents(path))
    end,
    first_line = function(path)
      return transf.string.first_line(transf.plaintext_file.contents(path))
    end,
    last_line = function(path)
      return transf.string.last_line(transf.plaintext_file.contents(path))
    end,
    bytechars = function(path)
      return transf.string.bytechars(transf.plaintext_file.contents(path))
    end,
    chars = function(path)
      return transf.string.chars(transf.plaintext_file.contents(path))
    end,
    no_final_newlines = function(path)
      return transf.string.no_final_newlines(transf.plaintext_file.contents(path))
    end,
    one_final_newline = function(path)
      return transf.string.one_final_newline(transf.plaintext_file.contents(path))
    end,
    len_lines = function(path)
      return transf.string.len_lines(transf.plaintext_file.contents(path))
    end,
    len_chars = function(path)
      return transf.string.len_chars(transf.plaintext_file.contents(path))
    end,
    len_bytechars = function(path)
      return transf.string.len_bytechars(transf.plaintext_file.contents(path))
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
    array_of_dicts = function(path)
      return select(1, ftcsv.parse(path, transf.plaintext_table_file.field_separator(path)))
    end,
    iter_of_dicts = function(path)
      return ftcsv.parseLine(path, transf.plaintext_table_file.field_separator(path))
    end,
  },
  timestamp_first_column_plaintext_table_file = {
    last_accessed = function(path)
      return get.string_or_number.number(readFile(env.MLAST_BACKUP .. transf.path.filename(path)) or 0)
    end,
    --- gets the entries from a timestamp_first_column_plaintext_table_file that are newer than the timestamp stored in file storing the last backup time
    new_timestamp_key_array_value_dict = function(path)
      local last_access = transf.timestamp_first_column_plaintext_table_file.last_accessed(path)
      local new_timestamp = os.time()
      local new_timestamp_key_array_value_dict = get.timestamp_first_column_plaintext_table_file.timestamp_key_array_value_dict_newer_than_timestamp(path, last_access)
      if new_timestamp_key_array_value_dict then
        writeFile(env.MLAST_BACKUP .. transf.path.filename(path), new_timestamp)
      end
      return new_timestamp_key_array_value_dict
    end,

  },
  dated_children_dir = {

  },
  dated_named_item_dir = {

  },
  logging_dir = {
    header_file = function(path)
      return transf.path.ending_with_slash(path) .. "header"
    end,
    headers = function(path)
      return transf.plaintext_file.nocomment_noindent_content_lines(
        transf.logging_dir.header_file(path)
      )
    end,
    header_empty_string_dict = function(path)
      return transf.array.empty_string_value_dict(
        transf.logging_dir.headers(path)
      )
    end,
    header_empty_string_dict_with_timestamp = function(path)
      local header_empty_string_dict = transf.logging_dir.header_empty_string_dict(path)
      header_empty_string_dict.timestamp = ""
      return header_empty_string_dict
    end,
    header_empty_string_dict_now = function(path)
      local header_empty_string_dict = transf.logging_dir.header_empty_string_dict(path)
      header_empty_string_dict.timestamp = os.time()
      return header_empty_string_dict
    end,
    yaml_form = function(path)
      return transf.not_userdata_or_string.yaml_string(transf.logging_dir.header_empty_string_dict(path))
    end,
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
  semver = {
    semver_components = function(str)
      local major, minor, patch, prerelease, build = onig.match(str, mt._r.version.semver)
      return {
        major = get.string_or_number.number(major),
        minor = get.string_or_number.number(minor),
        patch = get.string_or_number.number(patch),
        prerelease = prerelease,
        build = build
      }
    end,
  },
  dice_notation = {
    result = function(dice_notation)
      return run("roll" .. transf.string.single_quoted_escaped(dice_notation))
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
      return table.concat(transf.date.y_ym_ymd_table(date), "/")
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
      local tbl = glue(
        date:getdate(),
        date:gettime()
      )
      tbl.ticks = nil
      return tbl
    end,
    quarter_hours_date_range_specifier = function(date)
      return get.date.date_range_specifier_of_lower_component(date, 15, "hour")
    end,
    quarter_hours_of_day_date_range_specifier = function(date)
      return get.date.date_range_specifier_of_lower_component(date, 15, "day")
    end,
    entry_in_diary = function(date)
      return get.logging_dir.log_path_for_date(env.MENTRY_LOGS, date)
    end,
    rfc3339like_dt = function(date)
      return get.date.formatted(date, tblmap.date_format_name.date_format["rfc3339-datetime"])
    end,
    rfc3339like_time = function(date)
      return get.date.formatted(date, tblmap.date_format_name.date_format["rfc3339-time"])
    end,
    timestamp_s = function(date)
      return transf.full_date_component_name_value_dict.timestamp_s(
        transf.date.full_date_component_name_value_dict(date)
      )
    end,
    timestamp_ms = function(date)
      return transf.date.timestamp_s(date) * 1000
    end,

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
    date_component_name_list_larger_or_same = function(component)
      return slice(mt._list.date.date_component_names, 1, {_exactly = component})
    end,
    date_component_name_list_same_or_smaller = function(component)
      return slice(mt._list.date.date_component_names, {_exactly = component})
    end,
    date_component_name_list_larger_all_same = function(component)
      return map(
        transf.date_component_name.date_component_name_list_larger_or_same(component),
        returnSame,
        {"v", "k"}
      )
    end,
    index = function(component)
      return tblmap.date_component_name.date_component_index[component]
    end,
    
  },
  date_component_name_list = {
    min_date_component_name_value_dict = function(list)
      return map(
        list,
        function(component)
          return component, tblmap.date_component_name.min_date_component_value[component]
        end,
        {"v", "kv"}
      )
    end,
    max_date_component_name_value_dict = function(list)
      return map(
        list,
        function(component)
          return component, tblmap.date_component_name.max_date_component_value[component]
        end,
        {"v", "kv"}
      )
    end,
    date_component_name_ordered_list = function(list)
      return get.array.sorted(list, join.date_component_name.date_component_name.larger)
    end,
    date_component_name_list_inverse = function(list)
      return setDifference(mt._list.date.date_component_names, list)
    end
  },
  rfc3339like_dt = {
    date_component_name_value_dict = function(str)
      local comps = {onig.match(str, mt._r.date.rfc3339like_dt)}
      return map(mt._list.date.date_component_names, function(k, v)
        return v and get.string_or_number.number(comps[k]) or nil
      end, {"kv", "kv"})
    end,
    date_range_specifier = function(str)
      return transf.date_component_name_value_dict.date_range_specifier(transf.rfc3339like_dt.date_component_name_value_dict(str))
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
  rfc3339like_range = {
    start_rfc3339like_dt = function(str)
      return stringx.split(str, "_to_")[1]
    end,
    start_date_component_name_value_dict = function(str)
      return transf.rfc3339like_dt.date_component_name_value_dict(
        transf.rfc3339like_range.start_rfc3339like_dt(str)
      )
    end,
    start_min_full_date_component_name_value_dict = function(str)
      return transf.date_component_name_value_dict.min_full_date_component_name_value_dict(
        transf.rfc3339like_range.start_date_component_name_value_dict(str)
      )
    end,
    end_rfc3339like_dt = function(str)
      return stringx.split(str, "_to_")[2]
    end,
    end_date_component_name_value_dict = function(str)
      return transf.rfc3339like_dt.date_component_name_value_dict(
        transf.rfc3339like_range.end_rfc3339like_dt(str)
      )
    end,
    end_max_full_date_component_name_value_dict = function(str)
      return transf.date_component_name_value_dict.max_full_date_component_name_value_dict(
        transf.rfc3339like_range.end_date_component_name_value_dict(str)
      )
    end,
    date_range_specifier = function(str)
    end,
  },
  rf3339like_dt_or_range = {

  },
  basic_range_string = {
    start_stop = function(str)
      return stringy.split(str, "-")
    end,
    range_specifier = function(str)
      local start, stop = transf.basic_range_string.start_stop(str)
      return {
        start = start,
        stop = stop,
        step = 1,
      }
    end,
  },
  single_value_or_basic_range_string = {
    range_specifier = function(str)
      if stringy.find(str, "-") then
        return transf.basic_range_string.range_specifier(str)
      else
        return {
          start = str,
          stop = str,
          step = 1,
        }
      end
    end,
  },
  -- range specifier: table of start, stop, step, unit?
  range_specifier = {
    seq = function(range)
      return seq(range.start, range.stop, range.step, range.unit)
    end,
    diff = function(range)
      return range.stop - range.start
    end,
  },
  date_range_specifier = {
    --- we can reduce a range to a single rfc3339like_dt if the first n components are the same, and for those that differ, start is min[component] and stop is max[component]
    rf3339like_dt_or_range = function(date_range_specifier)
      
    end,
    event_table = function(date_range_specifier)
      return {
        start = transf.date.rfc3339like_dt(date_range_specifier.start),
        ["end"] = transf.date.rfc3339like_dt(date_range_specifier.stop),
      }
    end,

  },
  date_component_name_value_dict = {
    date_component_name_list_set = function(date_component_name_value_dict)
      return keys(date_component_name_value_dict)
    end,
    date_component_name_list_not_set = function(date_component_name_value_dict)
      return transf.date_component_name_list.date_component_name_list_inverse(transf.date_component_name_value_dict.date_component_name_list_set(date_component_name_value_dict))
    end,
    date_component_ordered_list_set = function(date_component_name_value_dict)
      return transf.date_component_name_list.date_component_name_ordered_list(transf.date_component_name_value_dict.date_component_name_list_set(date_component_name_value_dict))
    end,
    date_component_ordered_list_not_set = function(date_component_name_value_dict)
      return transf.date_component_name_list.date_component_name_ordered_list(transf.date_component_name_value_dict.date_component_name_list_not_set(date_component_name_value_dict))
    end,
    min_date_component_name_value_dict_not_set = function(date_component_name_value_dict)
      return transf.date_component_name_list.min_date_component_name_value_dict(transf.date_component_name_value_dict.date_component_name_list_not_set(date_component_name_value_dict))
    end,
    max_date_component_name_value_dict_not_set = function(date_component_name_value_dict)
      return transf.date_component_name_list.max_date_component_name_value_dict(transf.date_component_name_value_dict.date_component_name_list_not_set(date_component_name_value_dict))
    end,
    min_full_date_component_name_value_dict = function(date_component_name_value_dict)
      return glue(
        date_component_name_value_dict,
        transf.date_component_name_value_dict.min_date_component_name_value_dict_not_set(date_component_name_value_dict)
      )
    end,
    max_full_date_component_name_value_dict = function(date_component_name_value_dict)
      return glue(
        date_component_name_value_dict,
        transf.date_component_name_value_dict.max_date_component_name_value_dict_not_set(date_component_name_value_dict)
      )
    end,
    date_range_specifier = function(date_component_name_value_dict)
      return get.date_component_name_value_dict.date_range_specifier(date_component_name_value_dict, 1, "min")
    end,

  },
  prefix_partial_date_component_name_value_dict = {
    
  },
  suffix_partial_date_component_name_value_dict = {

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
      return table.concat(
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
      local res = memoize(rest, refstore.params.memoize.opts.invalidate_1_month_fs, "rest")({
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
      return table.concat(
        chunk(iban, 4),
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
      for _, vcard_key in ipairs(mt._list.vcard.keys_with_vcard_type) do
      
          -- We iterate over each of these keys. Each key can have multiple vcard_types, 
          -- which we get as a comma-separated string (type_list). 
          -- We also get the corresponding value for these vcard_types.
          for type_list, value in ipairs(contact_table[vcard_key]) do
          
              -- We split the type_list into individual vcard_types. This is done because 
              -- each vcard_type might need to be processed independently in the future. 
              -- It also makes the data more structured and easier to handle.
              local vcard_types = stringx.split(type_list, ", ")
        
              -- For each vcard_type, we create a new key-value pair in the contact_table. 
              -- This way, we can access the value directly by vcard_type, 
              -- without needing to parse the type_list each time.
              for _, vcard_type in ipairs(vcard_types) do
                  contact_table[vcard_key][vcard_type] = value
              end
          end
      end

      -- Here, we're handling the 'Addresses' key separately. Each address is a table itself,
      -- and we're adding a 'contact' field to each of these tables. 
      -- This 'contact' field holds the complete contact information.
      -- This could be useful in scenarios where address tables are processed individually,
      -- and there's a need to reference back to the full contact details.
      for _, address_table in ipairs(contact_table["Addresses"]) do
          address_table.contact = contact_table
      end
      
      -- Finally, we return the contact_table, which now has a more structured and accessible format.
      return contact_table
    end

  },
  uuid = {
    raw_contact = function(uuid)
      return memoize(run)( "khard show --format=yaml uid:" .. uuid, {catch = true} )
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
      return get.string_or_number.number(contact_table.Private["translation-rate"])
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
      return table.concat(
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
      return table.concat(
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
      return table.concat(
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
      return table.concat(
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
      return table.concat(
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
      return table.concat(
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
      return table.concat(transf.contact_table.phone_number_array(contact_table), ", ")
    end,
    vcard_type_email_dict = function (contact_table)
      return contact_table.Email
    end,
    email_array = function (contact_table)
      return transf.table.value_set(transf.contact_table.vcard_type_email_dict(contact_table))
    end,
    email_string = function (contact_table)
      return table.concat(transf.contact_table.email_array(contact_table), ", ")
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
      return keys(vcard_type_dict)
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
    iso_3366_1_alpha_2 = function(single_address_table)
      return transf.country_identifier_string.iso_3366_1_alpha_2(
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
      if transf.address_table.iso_3366_1_alpha_2(single_address_table) == "de" then
        return transf.address_table.in_country_location_array(single_address_table)
      else
        return transf.address_table.international_location_array(single_address_table)
      end
    end,
    in_country_address_array = function(single_address_table)
      return glue(
        transf.address_table.addressee_array(single_address_table),
        transf.address_table.in_country_location_array(single_address_table)
      )
    end,
    international_address_array = function(single_address_table)
      return glue(
        transf.address_table.addressee_array(single_address_table),
        transf.address_table.international_location_array(single_address_table)
      )
    end,
    relevant_address_array = function(single_address_table)
      if transf.address_table.iso_3366_1_alpha_2(single_address_table) == "de" then
        return transf.address_table.in_country_address_array(single_address_table)
      else
        return transf.address_table.international_address_array(single_address_table)
      end
    end,
    in_country_address_label = function(single_address_table)
      return 
        table.concat(transf.address_table.addressee_array(single_address_table), "\n") .. "\n" ..
        transf.address_table.street(single_address_table) .. "\n" ..
        transf.address_table.postal_code_city_line(single_address_table)
    end,
    international_address_label = function(single_address_table)
      return 
        table.concat(transf.address_table.addressee_array(single_address_table), "\n") .. "\n" ..
        transf.address_table.street(single_address_table) .. "\n" ..
        transf.address_table.postal_code_city_line(single_address_table) .. "\n" ..
        transf.address_table.region_country_line(single_address_table)
    end,
    relevant_address_label = function(single_address_table)
      if transf.address_table.iso_3366_1_alpha_2(single_address_table) == "de" then
        return transf.address_table.in_country_address_label(single_address_table)
      else
        return transf.address_table.international_address_label(single_address_table)
      end
    end,

  },
  youtube_video_id = {
    youtube_video_item = function(id)
      return memoize(rest, refstore.params.memoize.opts.invalidate_1_month_fs)({
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
      return memoize(rest, refstore.params.memoize.opts.invalidate_1_month_fs)({
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
  },
  youtube_video_url = {
    youtube_video_id = function(url)
      return transf.url.param_table(url).v
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
      return memoize(rest, refstore.params.memoize.opts.invalidate_1_month_fs, "rest")({
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
        { cond = {_r = mt._r.text_bloat.youtube.vieo, _ignore_case = true}, mode="remove" },
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
      return memoize(rest, refstore.params.memoize.opts.invalidate_1_month_fs, "rest")({
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
  string = {
    consonants = function(str)
      error("todo")
    end,
    evaled_lua = singleLe,
    evaled_bash = run,
    evaled_template = le,
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
      return memoize(run)("qrencode -l M -m 2 -t UTF8 " .. transf.string.single_quoted_escaped(data))
    end,
    qr_utf8_image_wob = function(data)
      return memoize(run, refstore.params.memoize.opts.stringify_json)({
        args = "qrencode -l M -m 2 -t UTF8i " .. transf.string.single_quoted_escaped(data),
        dont_clean_output = true,
      })
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
      return replace(str, to.case.snake)
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
      local upper_parts = hs.fnutils.imap(parts, transf.word.capitalized)
      return table.concat(upper_parts, "_")
    end,
    lower_camel_snake_case = function(str)
      return eutf8.lower(transf.string.upper_camel_snake_case(str))
    end,
    upper_camel_case = function(str)
      local parts = transf.string.snake_case_parts(str)
      local upper_parts = hs.fnutils.imap(parts, transf.word.capitalized)
      return table.concat(upper_parts, "")
    end,
    lower_camel_case = function(str)
      return eutf8.lower(transf.string.upper_camel_case(str))
    end,
    kebap_case = function(str)
      return replace(str, to.case.kebap)
    end,
    lower_kebap_case = function(str)
      return eutf8.lower(transf.string.kebap_case(str))
    end,
    upper_kebap_case = function(str)
      return eutf8.upper(transf.string.kebap_case(str))
    end,
    lowercase = function(str)
      return eutf8.lower(str)
    end,
    uppercase = function(str)
      return eutf8.upper(str)
    end,
    alphanum = function(str)
      return replace(str, to.case.alphanum)
    end,

    --- URL-encodes a string.
    --- @param url string
    --- @param spaces_percent? boolean whether to encode spaces as %20 (true) or + (false)
    --- @return string
    urlencoded = function(url, spaces_percent)
      if url == nil then
        return ""
      end
      url = eutf8.gsub(url, "\n", "\r\n")
      url = eutf8.gsub(url, "([^%w _%%%-%.~])", transf.char.percent)
      if spaces_percent then
        url = eutf8.gsub(url, " ", "%%20")
      else
        url = eutf8.gsub(url, " ", "+")
      end
      return url
    end,
    urlencoded_search = function(str, spaces_percent)
      local folded = transf.string.folded(str)
      return transf.string.urlencoded(folded, spaces_percent)
    end,

    urldecoded = function(url)
      return replace(url, to.url.decoded)
    end,
    escaped_csv_field = function(field)
      return '"' .. replace(field, to.string.escaped_csv_field_contents)  .. '"'
    end,
    unicode_prop_table_array = function(str)
      return memoize(runJSON)("uni identify -compact -format=all -as=json".. transf.string.single_quoted_escaped(str))
    end,
    unicode_prop_table_item_array = function(str)
      return transf.unicode_prop_table_array.unicode_prop_table_item_array(
        transf.string.unicode_prop_table_array(str)
      )
    end,
    single_quoted_escaped = function(str)
      return " '" .. memoize(replace)(str, to.string.escaped_single_quote_safe) .. "'"
    end,
    double_quoted_escaped = function(str)
      return ' "' .. memoize(replace)(str, to.string.escaped_double_quote_safe) .. '"'
    end,
    envsubsted = function(str)
      return run("echo " .. transf.string.single_quoted_escaped(str) .. " | envsubst")
    end,
    bits = basexx.to_bit,
    hex = basexx.to_hex,
    base64_gen = basexx.to_base64,
    base64_url = basexx.to_url64,
    base32_gen = basexx.to_base32,
    base32_crock = basexx.to_crockford,
    html_entitiy_encoded = htmlEntities.encode,
    html_entitiy_decoded = htmlEntities.decode,
    header_key_value = function(str)
      local k, v = eutf8.match(str, "^([^:]+):%s*(.+)$")
      return transf.word.notcapitalized(k), v
    end,
    title_case = function(str)
      local words, removed = split(str, {_r = "[ :–\\—\\-\\t\\n]", _regex_engine = "onig"})
      local title_cased_words = map(words, transf.word.title_case_policy)
      title_cased_words[1] = replace(title_cased_words[1], to.case.capitalized)
      title_cased_words[#title_cased_words] = replace(title_cased_words[#title_cased_words], to.case.capitalized)
      return concat({
        isopts = "isopts",
        sep = removed,
      }, title_cased_words)
    end,
    romanized_deterministic = function(str)
      local raw_romanized = run(
        { "echo", "-n",  {value = str, type = "quoted"}, "|", "kakasi", "-iutf8", "-outf8", "-ka", "-Ea", "-Ka", "-Ha", "-Ja", "-s", "-ga" }
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
    romanized_snake = function(str)
      str = eutf8.gsub(str, "[%^']", "")
      str = transf.string.romanized_deterministic(str)
      str = eutf8.lower(replace(str, to.case.snake))
      return str
    end,
    romanized_gpt = function(str)
      return get.string.deterministic_gpt_transformation(str, "Please romanize the following text with wapuro-like romanization, where:\n\nっ -> duplicated letter (e.g. っち -> cchi)\nlong vowel mark -> duplicated letter (e.g. ローマ -> roomaji)\nづ -> du\nんま -> nma\nじ -> ji\nを -> wo\nち -> chi\nparticles are separated by spaces (e.g. これに -> kore ni)\nbut morphemes aren't (真っ赤 -> makka)", {
        {"こっち", "kocchi"}
      })
    end,
    tilde_resolved = function(path)
      if stringy.startswith(path, "~") then
        return env.HOME .. eutf8.sub(path, 2)
      else
        return path
      end
    end,
    folded = function(str)
      return eutf8.gsub(str, "\n", " ")
    end,
    nowhitespace = function(str)
      return eutf8.gsub(str, "%s", "")
    end,
    --- @param str string
    --- @return string[]
    bytechars = function(str)
      local t = {}
      for i = 1, #str do
        t[i] = str:sub(i, i)
      end
      return t
    end,

    len_bytechars = function(str)
      return #transf.string.bytechars(str)
    end,


    --- @param str string
    --- @return string[]
    chars = function(str)
      local t = {}
      for i = 1, eutf8.len(str) do
        t[i] = eutf8.sub(str, i, i)
      end
      return t
    end,

    len_chars = function(str)
      return #transf.string.chars(str)
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


    content_lines = function(str)
      return transf.string_array.noemtpy_string_array(
        transf.string.lines(str)
      )
    end,
    noindent_content_lines = function(str)
      return transf.string_array.noindent_string_array(transf.string.content_lines(str))
    end,
    nocomment_noindent_content_lines = function(str)
      return transf.string_array.nocomment_noindent_string_array(transf.string.content_lines(str))
    end,

    first_line = function(str)
      return transf.string.lines(str)[1]
    end,
    first_content_line = function(str)
      return transf.string.content_lines(str)[1]
    end,
    last_line = function(str)
      local lines = transf.string.lines(str)
      return lines[#lines]
    end,
    last_content_line = function(str)
      local lines = transf.string.content_lines(str)
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
    
    path_resolved = function(path, resolve_tilde)
      if resolve_tilde then
        path = transf.string.tilde_resolved(path)
      end
      local components = pathSlice(path, ":")
      local reduced_components = {}
      local started_with_slash = stringy.startswith(path, "/")
      local components_are_all_dotdot = false
      for _, component in ipairs(components) do
        if component == ".." then
          if #reduced_components > 0 and not components_are_all_dotdot then
            table.remove(reduced_components)
          else -- we can't go higher up
            if started_with_slash then
              -- no-op: we're already at the root, so we treat this similarly to '.', which is a no-op. This is consistent with the behavior of cd/ls in bash
            else
              table.insert(reduced_components, "..") -- the path was a relative path, and we've arrived at the root of the relative path. We have no further information about what is above the root of the relative path, so we have no choice but to leave this component unresolved
              components_are_all_dotdot = true
            end
             
          end
        else
          components_are_all_dotdot = false
          if component ~= "." then
            table.insert(reduced_components, component)
          end
        end
      end
      local new_path = table.concat(reduced_components, "/")
      if started_with_slash then
        return "/" .. new_path
      else
        if #new_path == 0 then
          return "."
        else
          return new_path
        end
      end
    end,
    here_string = function(str)
      return " <<EOF\n" .. str .. "\nEOF"
    end,
    rfc3339like = function(str)
      return get.string.deterministic_gpt_transformation(str, "Please transform the following thing indicating a date(time) into the corresponding RFC3339-like date(time) (UTC). Leave out elements that are not specified.")
    end,
    raw_contact = function(searchstr)
      return memoize(run)("khard show --format=yaml " .. searchstr, {catch = true} )
    end,
    contact_table = function(searchstr)
      local raw_contact = transf.string.raw_contact(searchstr)
      local contact = transf.raw_contact.contact_table(raw_contact)
      return contact
    end,
    event_table = function(str)
      local components = stringx.split(str, mt._contains.unique_field_separator)
      local parsed = ovtable.new()
      for i, component in ipairs(components) do
        local key = mt._list.khal.parseable_format_components[i]
        if key == "alarms" then
          parsed[key] = stringy.split(component, ",")
        elseif key == "description" then
          parsed[key] = component
        else
          parsed[key] = stringx.replace(component, "\n", "")
        end
      end
      return parsed
    end,
    kana_inner = function(argstr)
      return run("kana --vowel-shortener x " .. argstr )
    end,
    kana_inner_nospaces = function(argstr)
      return run("kana --vowel-shortener x " .. argstr .. "| tr -d ' '")
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
      return get.string.deterministic_gpt_transformation(str, "You're a dropin IME for already written text. Please transform the following into its Japanese writing system equivalent:")
    end,
    kana_readings = function(str)
      return get.string.deterministic_gpt_transformation(str, "Provide kana readings for:")
    end,
    ruby_annotated_kana = function(str)
      return get.string.deterministic_gpt_transformation(str, "Add kana readings to this text as <ruby> annotations, including <rp> fallback:")
    end,
    --- @param str string
    --- @return hs.styledtext
    with_styled_start_end_markers = function(str)
      local res =  hs.styledtext.new("^" .. str .. "$")
      res = styleText(res, { style = "light", starts = 1, ends = 1 })
      res = styleText(res, { style = "light", starts = #res, ends = #res})
      return res
    end,
    email_quoted = function(str)
      return stringx.join(
        "\n",
        hs.fnutils.imap(
          stringx.splitlines(
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
    end
  },
  line = {
    noindent = function(str)
      return eutf8.match(str, "^%s*(.*)$")
    end,
    nocomment = function(str)
      return stringx.split(str, " # ")[1]
    end,
    nocomment_noindent = function(str)
      return transf.line.noindent(transf.line.nocomment(str))
    end,
    comment = function(str)
      return stringx.split(str, " # ")[2]
    end,
  },
  potentially_atpath = {
    potentially_atpath_resolved = function(str)
      if stringy.startswith(str, "@") then
        local valpath = eutf8.sub(str, 2)
        valpath = transf.string.path_resolved(valpath, true)
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
  pass_name = {
    password = function(pass_name)
      return get.pass.value("passw", pass_name)
    end,
    recovery = function(pass_name)
      return get.pass.value("recovery", pass_name)
    end,
    security_question = function(pass_name)
      return get.pass.value("security_question", pass_name)
    end,
    username = function(pass_name)
      return transf.plaintext_file.no_final_newlines(st(env.MPASSUSERNAME .. "/" .. pass_name .. ".txt") or env.MAIN_EMAIL)
    end,
    otp = function(item)
      return run("pass otp otp/" .. item)
    end,
  },
  cc_name = {
    cc_number = function(cc_name)
      return get.pass.value("cc/nr", cc_name)
    end,
    cc_expiry = function(cc_name)
      return get.pass.value("cc/exp", cc_name)
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
    not_userdata_or_function = json.decode,
    yaml_string = function(str)
      return transf.not_userdata_or_function.yaml_string(
        transf.json_string.not_userdata_or_function(str)
      )
    end,
  },
  toml_string = {
    table = toml.decode
  },
  yaml_file = {
    not_userdata_or_function = function(path)
      return transf.yaml_string.not_userdata_or_function(transf.plaintext_file.contents(path))
    end
  },
  
  ini_string = {
    table = function(str)
      return runJSON(
        "jc --ini <<EOF " .. str .. "EOF"
      )
    end,
  },
  header_string = {
    dict = function(str)
      local lines = transf.string.content_lines(str)
      return map(
        lines,
        transf.string.header_key_value,
        {"v", "kv"}
      )
    end
  },
  base64_gen = {
    decoded_string = basexx.from_base64,
  },
  base64_url = {
    decoded_string = basexx.from_url64,
  },
  base32_gen = {
    decoded_string = basexx.from_base32,
  },
  base32_crock = {
    decoded_string = basexx.from_crockford,
  },
  base64 = {
    decoded_string = function(b64)
      if is.ascii.base64_gen(b64) then
        return transf.base64_gen.decoded_string(b64)
      else
        return transf.base64_url.decoded_string(b64)
      end
    end
  },
  base32 = {
    decoded_string = function(b32)
      if is.ascii.base32_gen(b32) then
        return transf.base32_gen.decoded_string(b32)
      else
        return transf.base32_crock.decoded_string(b32)
      end
    end
  },
  event_table = {
    calendar_template = function(event_table)
      local template = get.khal.calendar_template_empty()
      for key, value in fastpairs(event_table) do
        if template[key] then
          if key == "repeat" then
            for subkey, subvalue in fastpairs(value) do
              template[key][subkey].value = subvalue
            end
          else
            template[key].value = value
          end
        end
      end
      if template.alarms.value then 
        template.alarms.value = table.concat(template.alarms.value, ",")
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

    start_fullrfc3339like_dt = function(event_table)
      return event_table.start
    end,
    end_fullrfc3339like_dt = function(event_table)
      return event_table["end"]
    end,
    start_date = function(event_table)
      return transf.full_rfc3339like_dt.date(event_table.start)
    end,
    end_date = function(event_table)
      return transf.full_rfc3339like_dt.date(event_table["end"])
    end,
    date_range_specifier = function(event_table)
      return get.event_table.date_range_specifier(event_table)
    end,
  },
  search_engine = {
    action_table_item = function(search_engine)
      return {
        text = string.format("%s🔎 s%s.", tblmap.search_engine.i[search_engine], tblmap.search_engine.short[search_engine]),
        dothis = bind(
          dothis.string.search,
          {a_use, search_engine}
        )
      }
    end,
  },
  multiline_string = {
    trimmed_lines = function(str)
      local lines = split(str, "\n")
      local trimmed_lines = map(lines, stringy.strip)
      return table.concat(trimmed_lines, "\n")
    end,
    relay_table = function(raw)
      local raw_countries = stringx.split(raw, "\n\n") -- stringy does not support splitting by multiple characters
      raw_countries = filter(raw_countries, true)
      local countries = {}
      for _, raw_country in ipairs(raw_countries) do
        local raw_country_lines = stringy.split(raw_country, "\n")
        raw_country_lines = filter(raw_country_lines, true)
        local country_header = raw_country_lines[1]
        local country_code = slice(country_header, "(", ")")
        if country_code == nil then error("could not find country code in header. header was " .. country_header) end
        local payload_lines = slice(raw_country_lines, 2, -1)
        countries[country_code] = {}
        local city_code
        for _, payload_line in ipairs(payload_lines) do
          if stringy.startswith(payload_line, "\t\t") then -- line specifying a single relay
            local relay_code = payload_line:match("^\t\t([%w%-]+) ") -- lines look like this: \t\tfi-hel-001 (185.204.1.171) - OpenVPN, hosted by Creanova (Mullvad-owned)
            push(countries[country_code][city_code], relay_code)
          elseif stringy.startswith(payload_line, "\t") then -- line specifying an entire city
            city_code = slice(payload_line, "(", ")") -- lines look like this: \tHelsinki (hel) @ 60.19206°N, 24.94583°W
            countries[country_code][city_code] = {}
          end
        end

      end
    
      return countries
    end,
    array_of_event_tables = function(str)
      local res = filter(stringx.split(str, mt._contains.unique_record_separator))
      return hs.fnutils.imap(
        res,
        transf.string.event_table
      )
    end,
  },
  word = {
    title_case_policy = function(word)
      if find(mt._contains.small_words, word) then
        return word
      elseif eutf8.find(word, "%u") then -- words with uppercase letters are presumed to already be correctly title cased (acronyms, brands, the like)
        return word
      else
        return replace(word, to.case.capitalized)
      end
    end,
    capitalized = function(word)
      return replace(word, to.case.capitalized)
    end,
    notcapitalized = function(word)
      return replace(word, to.case.notcapitalized)
    end,
    raw_syn_output = function(str)
      return memoize(run)( "syn -p" .. transf.string.single_quoted_escaped(str) )
    end,
    term_syn_specifier_dict = function(str)
      local synonym_parts = stringx.split(transf.word.raw_syn_output(str), "\n\n")
      local synonym_tables = map(
        synonym_parts,
        function (synonym_part)
          local synonym_part_lines = stringy.split(synonym_part, "\n")
          local synonym_term = eutf8.sub(synonym_part_lines[1], 2) -- syntax: ❯<term>
          local synonyms_raw = eutf8.sub(synonym_part_lines[2], 12) -- syntax:  ⬤synonyms: <term>{, <term>}
          local antonyms_raw = eutf8.sub(synonym_part_lines[3], 12) -- syntax:  ⬤antonyms: <term>{, <term>}
          local synonyms = map(stringy.split(synonyms_raw, ", "), stringy.strip)
          local antonyms = map(stringy.split(antonyms_raw, ", "), stringy.strip)
          return synonym_term, {
            synonyms = synonyms,
            antonyms = antonyms,
          }
        end,
        {"v", "kv"}
      )
      return synonym_tables
    end,
    raw_av_output = function (str)
      memoize(run)(
        "synonym" .. transf.string.single_quoted_escaped(str)
      )
    end,
    synonym_string_array = function(str)
      local items = stringy.split(transf.word.raw_av_output(str), "\t")
      items = filter(items, function(itm)
        if itm == nil then
          return false
        end
        itm = stringy.strip(itm)
        return #itm > 0
      end)
      return items
    end,
  },
  term_syn_specifier_dict = {
    term_syn_specifier_item_dict_item = function(dict)
      return dc(
        hs.fnutils.map(
          dict,
          CreateSynSpecifier
        )
      )
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
      return table.concat(syn_specifier.synonyms, ", ")
    end,
    antonyms_string = function (syn_specifier)
      return table.concat(syn_specifier.antonyms, ", ")
    end,
    summary = function (syn_specifier)
      return 
        "synonyms: " ..
        slice(syn_specifier.synonyms, { stop = 2, sliced_indicator = "..." }) ..
        "\n" ..
        "antonyms: " ..
        slice(syn_specifier.antonyms, { stop = 2, sliced_indicator = "..." })
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
    chooser_item = function(pair)
      return transf.key_value.chooser_item(pair[1], pair[2])
    end,
    key_chooser_item = function(pair)
      return transf.key_value.key_chooser_item(pair[1], pair[2])
    end,
    value_chooser_item = function(pair)
      return transf.key_value.value_chooser_item(pair[1], pair[2])
    end,
  },
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
      return transf.word.capitalized(transf.any.string(k)) .. ": " .. transf.any.string(v)
    end,
    email_header = function(key, value)
      return transf.word.capitalized(transf.any.string(key)) .. ": " .. le(transf.any.string(value))
    end,
    url_param = function(key, value)
      return transf.any.string(key) .. "=" .. transf.string.urlencoded(transf.any.string(value))
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
    chooser_item = function(key, value)
      return {
        text = transf.key_value.dict_entry_string(key, value),
        k = key,
        v = value,
      }
    end,
    key_chooser_item = function(key, value)
      return {
        text = transf.any.string(key),
        k = key,
        v = value,
      }
    end,
    value_chooser_item = function(key, value)
      return {
        text = transf.any.string(value),
        k = key,
        v = value,
      }
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
  table_array = {
    item_array_of_item_tables = function(arr)
      return ar(map(
        arr,
        function (arr)
          return dc(arr)
        end
      ))
    end
  },
  string_array = {
    item_array_of_string_items = function(arr)
      return ar(hs.fnutils.imap(
        arr,
        st
      ))
    end,
    repeated_option_string = function(arr, opt)
      return table.concat(
        hs.fnutils.imap(
          arr,
          function (itm)
            return " " .. opt .. " " .. itm
          end
        ),
        ""
      )
    end,
    action_path_string = function(arr)
      return table.concat(arr, " > ")
    end,
    path = function(arr)
      return table.concat(
        hs.fnutils.imap(arr, transf.string.safe_filename), 
        "/"
      )
    end,
    noemtpy_string_array = function(arr)
      return memoize(filter, refstore.params.memoize.opts.stringify_json)(transf.string.lines(arr), true)
    end,
    noindent_string_array = function(arr)
      return hs.fnutils.imap(arr, transf.line.noindent)
    end,
    nocomment_line_filtered_string_array = function(arr)
      return filter(
        arr,
        {_r = "^%s*#", _regex_engine = "eutf8", _invert = true}
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
      return hs.fnutils.filter(arr, is.string.url)
    end,
    filter_nocomment_noindent_to_url_array = function(arr)
      return transf.string_array.filter_to_url_array(
        transf.string_array.nocomment_noindent_string_array(arr)
      )
    end,
    stripped_string_array = function(arr)
      return hs.fnutils.imap(arr, stringy.strip)
    end,
    
  },
  env_line_array = {
    env_string = function(arr)
      local env_string_inner = table.concat(arr, "\n")
      return "#!/usr/bin/env bash\n\n" ..
          "set -u\n\n" .. 
          env_string_inner .. 
          "\n\nset +u\n"
    end,
  },
  array_of_string_arrays = {

  },
  url_array = {
    url_potentially_with_title_comment_array = function(html_url_array)
      return hs.fnutils.imap(
        html_url_array,
        transf.url.url_potentially_with_title_comment
      )
    end,
    session_string = function(html_url_array)
      return table.concat(
        transf.url.url_potentially_with_title_comment_array(html_url_array),
        "\n"
      )
    end,
    relative_path_dict_of_url_files = function(url_array)
      return map(
        url_array,
        function(url)
          return 
            transf.url.title_or_url_as_filename(url),
            url
        end,
        {"v", "kv"}
      )
    end,
  },
  html_url_array = {
    html_url_with_title_comment_array = function(html_url_array)
      return hs.fnutils.imap(
        html_url_array,
        transf.html_url.html_url_with_title_comment
      )
    end,
    
  },
  plaintext_url_or_path_file = {

  },
  plaintext_file_array = {
    contents_array = function(arr)
      return hs.fnutils.imap(arr, transf.plaintext_file.contents)
    end,
    lines_array = function(arr)
      return map(arr, transf.plaintext_file.lines, {flatten = true})
    end,
    content_lines_array = function(arr)
      return map(arr, transf.plaintext_file.content_lines, {flatten = true})
    end,
  },
  array_of_event_tables = {
    item_array_of_event_table_items = function(arr)
      return ar(hs.fnutils.imap(
        arr,
        CreateEventTableItem
      ))
    end,
  },
  email_file_array = {
    email_file_summary_dict = function(email_file_array)
      return map(
        email_file_array,
        transf.email_file.email_file_summary_key_value
        {"v", "kv"}
      )
    end,
    email_file_simple_view_dict = function(email_file_array)
      return map(
        email_file_array,
        transf.email_file.email_file_simple_view_key_value
        {"v", "kv"}
      )
    end,
  },
  table = {
    first_key = function(t)
      return elemAt(t, 1, "k")
    end,
    first_value = function(t)
      return elemAt(t, 1, "v")
    end,
    last_key = function(t)
      return elemAt(t, len(t), "k")
    end,
    last_value = function(t)
      return elemAt(t, len(t), "v")
    end,
    toml_string = toml.encode,
    --- value and comment must be strings
    yaml_aligned = function(tbl)
      local value_table = map(
        tbl,
        {_k = "value", _ret = "orig" },
        { recurse = true, treat_as_leaf = "list" }
      )
      local stops = flatten(value_table, {
        treat_as_leaf = "list",
        mode = "assoc",
        val = {"valuestop", "keystop"},
      })
      local valuestop = reduce(map(stops, {_k = "valuestop"}, {tolist = true}))
      local keystop = reduce(map(stops, {_k = "keystop"}, {tolist = true}))
      return table.concat(get.table.yaml_lines_aligned_with_predetermined_stops(tbl, keystop, valuestop, 0), "\n")
    end,
    yaml_metadata = function(t)
      local string_contents = transf.not_userdata_or_string.yaml_string(t)
      return "---\n" .. string_contents .. "\n---\n"
    end,
    
    ics_string = function(t)
      local tmpdir_ics_path = transf.not_userdata_or_function.in_tmp_dir(t) .. ".ics"
      dothis.table.write_ics_file(t, tmpdir_ics_path)
      local contents = readFile(tmpdir_ics_path)
      delete(tmpdir_ics_path)
      return contents
    end,
    value_set = function(t)
      return toSet(values(t))
    end
    
  },
  assoc_arr = {
    relative_path_dict = function(t)
      return flatten(
        t,
        {
          treat_as_leaf = "list",
          mode = "path-assoc",
          join_path = "/"
        }
      )
    end,
  },
  orderedtable = {
    first_key = function(t)
      return t:keyfromindex(1)
    end,
    last_key = function(t)
      return t:keyfromindex(t:len())
    end,
    first_value = function(t)
      return t[1]
    end,
    last_value = function(t)
      return t[t:len()]
    end,
  },
  dict = {
    dict_of_dicts_by_space = function(tbl)
      local res = {}
      for k, v in fastpairs(tbl) do
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
    pair_array = function(t)
      return map(
        t,
        function(k, v)
          return {k, v}
        end,
        refstore.params.map.opts.kv_to_list
      )
    end,
  },
  stringable_value_dict = {
    url_param_array = function(t)
      return hs.fnutils.imap(transf.dict.pair_array(t), transf.pair.url_param)
    end,
    url_params = function(t)
      return table.concat(transf.stringable_value_dict.url_param_array(t), "&")
    end,
    --- @param t { [string]: string }
    --- @return string
    email_header = function(t)
      local header_lines = {}
      local initial_headers = mt._list.initial_headers
      for _, header_name in ipairs(initial_headers) do
        local header_value = t[header_name]
        if header_value then
          table.insert(header_lines, transf.pair.email_header({header_name, header_value}))
          t[header_name] = nil
        end
      end
      for key, value in prs(t) do
        table.insert(header_lines, transf.pair.email_header({key, value}))
      end
      return table.concat(header_lines, "\n")
    end,
    curl_form_field_list = function(t)
      return concat(
        hs.fnutils.imap(transf.dict.pair_array(t), transf.pair.curl_form_field_args)
      )
    end,
    ini_line_array = function(t)
      return hs.fnutils.imap(transf.dict.pair_array(t), transf.pair.ini_line)
    end,
    ini_string = function(t)
      return table.concat(transf.stringable_value_dict.ini_line_array(t), "\n")
    end,
    envlike_line_array = function(t)
      return hs.fnutils.imap(transf.dict.pair_array(t), transf.pair.envlike_line)
    end,
    dict_entry_string_array = function(t)
      return hs.fnutils.imap(transf.dict.pair_array(t), transf.pair.dict_entry_string)
    end,
    dict_entry_string_summary = function(t)
      return "dict: " .. table.concat(transf.stringable_value_dict.dict_entry_string_array(t), ", ")
    end,
    dict_entry_string_detailed = function(t)
      return table.concat(transf.stringable_value_dict.dict_entry_string_array(t), "\n")
    end,
    envlike_string = function(t)
      return table.concat(transf.stringable_value_dict.envlike_line_array(t), "\n")
    end,
    chooser_item_list = function(t)
      return hs.fnutils.imap(transf.dict.pair_array(t), transf.pair.chooser_item)
    end,
    value_chooser_item_list = function(t)
      return hs.fnutils.imap(transf.dict.pair_array(t), transf.pair.value_chooser_item)
    end,
    key_chooser_item_list = function(t)
      return hs.fnutils.imap(transf.dict.pair_array(t), transf.pair.key_chooser_item)
    end,
  },
  pair_array = {
    dict = function(arr)
      local res = {}
      for _, pair in ipairs(arr) do
        res[pair[1]] = pair[2]
      end
      return res
    end,
    env_line_array = function (arr)
      return hs.fnutils.imap(
        arr,
        function(pair)
          return "export " .. pair[1] .. "=" .. transf.string.double_quoted_escaped(pair[2])
        end
      )
    end

  },
  dict_of_string_value_dicts = {
    ini_string = function(t)
      return table.concat(map(
        t,
        function(k,v)
          return "[" .. k .. "]\n" .. transf.stringable_value_dict.ini_string(v)
        end
      ), "\n\n")
    end,
  },
  dict_of_dicts = {
    dict_by_space = function(dict_of_dicts)
      local res = {}
      for label, dict in fastpairs(dict_of_dicts) do
        for k, v in fastpairs(dict) do
          res[label .. " " .. k] = v
        end
      end
      return res
    end,

  },
  timestamp_key_array_value_dict = {
    --- transforms a timestamp-key orderedtable into a table of the structure [yyyy] = { [yyyy-mm] = { [yyyy-mm-dd] = { [hh:mm:ss, ...] } } }
    --- @param timestamp_key_table orderedtable
    --- @return { [string]: { [string]: { [string]: string[] } } }
    ymd_nested_key_array_of_arrays_value_assoc_arr = function(timestamp_key_table)
      local year_month_day_time_table = {}
      for timestamp_str, fields in prs(timestamp_key_table,-1,1,-1) do 
        local timestamp = get.string_or_number.number(timestamp_str)
        local year = os.date("%Y", timestamp)
        local year_month = os.date("%Y-%m", timestamp)
        local year_month_day = os.date("%Y-%m-%d", timestamp)
        local time = os.date("%H:%M:%S", timestamp)
        if not year_month_day_time_table[year] then year_month_day_time_table[year] = {} end
        if not year_month_day_time_table[year][year_month] then year_month_day_time_table[year][year_month] = {} end
        if not year_month_day_time_table[year][year_month][year_month_day] then year_month_day_time_table[year][year_month][year_month_day] = {} end
        local contents = concat({time}, fields)
        table.insert(year_month_day_time_table[year][year_month][year_month_day], contents)
      end
      return year_month_day_time_table
    end
  },
  tachiyomi_json_table = {
    timestamp_key_array_value_dict = function(raw_backup)
      -- data we care about is in the backupManga array in the json file
      -- each array element is a manga which has general metadata keys such as title, author, url, etc
      -- and a chapters array which has chapter metadata keys such as name, chapterNumber, url, etc
      -- and a history array which has the keys url and lastRead (unix timestamp in ms)
      -- we want to transform this into a table of our own design, where the key is a timestamp (but in seconds) and the value is an array consisting of some of the metadata of the manga and some of the metadata of the chapter
      -- specifically: url (of the manga), title, chapterNumber, name (of the chapter)
      -- for that, we need to match the key url in the history array with the key url in the chapters array, for which we will create a temporary table with the urls as keys and the chapter metadata we will use as values

      local manga = raw_backup.backupManga
      local manga_url, manga_title = manga.url, manga.title
      local chapter_map = {}
      for _, chapter in ipairs(manga.chapters) do
        chapter_map[chapter.url] = {
          chapterNumber = chapter.chapterNumber,
          name = chapter.name
        }
      end
      local history_list = {}
      for _, hist_item in ipairs(manga.history) do
        local chapter = chapter_map[hist_item.url]
        history_list[hist_item.lastRead / 1000] = {
          manga_url,
          manga_title,
          chapter.chapterNumber,
          chapter.name
        }
      end
      return history_list
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
        url = url .. mustEnd(comps.host, "/")
        if comps.endpoint then
          url = url .. (mustNotStart(comps.endpoint, "/") or "/")
        end   
      end     
      if comps.params then
        if type(comps.params) == "table" then
          url = url .. "?" .. transf.stringable_value_dict.url_params(comps.params)
        else
          url = url .. mustStart(comps.params, "?")
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
      doi = mustNotStart(urnlike, "urn:")
      doi = mustNotStart(urnlike, "doi:")
      return doi
    end,
    doi_url = function(urnlike)
      return transf.pure_doi.doi_url(transf.doi_urnlike.pure_doi(urnlike))
    end,
  },
  pure_doi = {
    doi_url = function(doi)
      return replace(doi, to.resolved.doi)
    end,
    doi_urnlike = function(doi)
      return "doi:" .. doi
    end,
    online_bib = function(doi)
      return run(
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
      return run(
        "isbn_meta" .. transf.string.single_quoted_escaped(isbn) .. " bibtex"
      )
    end,
    online_csl_table = function(isbn)
      return run(
        "isbn_meta" .. transf.string.single_quoted_escaped(isbn) .. " csl"
      )
    end,
    indicated_citable_object_id = function(isbn)
      return "isbn:" .. isbn
    end,
  },
  isbn10 = {
    isbn13 = function(isbn10)
      return run(
        "to_isbn13" .. transf.string.single_quoted_escaped(isbn10)
      )
    end,
  },
  isbn13 = {
    isbn10 = function(isbn13)
      return run(
        "to_isbn10" .. transf.string.single_quoted_escaped(isbn13)
      )
    end,
  },
  indicated_citable_object_id = {
    local_csl_file = function(id)
      return transf.filename_safe_indicated_citable_object_id.local_csl_file(
        transf.stirng.urlencoded(id)
      )
    end,
    local_csl_table = function(id)
      return transf.filename_safe_indicated_citable_object_id.csl_table(
        transf.stirng.urlencoded(id)
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
        transf.stirng.urlencoded(id)
      )
    end,
    local_citable_object_notes_file = function(id)
      return transf.filename_safe_indicated_citable_object_id.local_citable_object_notes_file(
        transf.stirng.urlencoded(id)
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
      return get.dir.find_descendant_with_leaf_ending(env.MCITATIONS, id)
    end,
    csl_table = function(id)
      return transf.json_file.table(
        transf.filename_safe_indicated_citable_object_id.local_csl_file(id)
      )
    end,
    local_citable_object_file = function(id)
      return get.dir.find_descendant_with_leaf_ending(env.MPAPERS, id)
    end,
    local_citable_object_notes_file = function(id)
      return get.dir.find_descendant_with_leaf_ending(env.MPAPERNOTES, id)
    end,
  },
  citable_filename = {
    filename_safe_indicated_citable_object_id = function(filename)
      return stringx.split(filename, "!citid:")[2]
    end,
    indicated_citable_object_id = function(filename)
      return transf.string.urldecoded(transf.citable_filename.filename_safe_indicated_citable_object_id(filename))
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
      return table.concat(
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
      return transf.dir.children_array(
        transf.omegat_project_dir.source_dir(dir)
      )
    end,
    target_files = function(dir)
      return transf.dir.children_array(
        transf.omegat_project_dir.target_dir(dir)
      )
    end,
    local_resultant_tm = function(dir)
      return transf.omegat_project_dir.tm_dir(dir) .. "/" .. transf.path.leaf(dir) .. "-omegat.tmx"
    end,
    rechnung_filename = function(dir)
      return get.timestamp_s.formatted(
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
        transf.dir.children_array(
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
        body = le(comp.documents.translation.rechnung_email_de, dir),
        non_inline_attachments = {
          transf.omegat_project_dir.rechnung_pdf_path(dir)
        }
      }
    end,
    raw_rechnung = function(dir)
      return le(comp.documents.translation.rechnung_de, dir)
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
        table.concat(
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
      local flattened = listWithChildrenKeyToListIncludingPath(app:getMenuItems(), {}, { title_key_name = "AXTitle", children_key_name = "AXChildren", levels_of_nesting_to_skip = 1 })
      local filtered = filter(flattened, function (v) return v.AXTitle ~= "" end)
      for k, v in pairs(filtered) do
        v.application = app
      end
      return filtered
    end,
    menu_item_table_item_array = function(app)
      return hs.fnutils.imap(
        transf.running_application.menu_item_table_array(app),
        CreateMenuItemTable
      )
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
      return find(
        window_array,
        function(v)
          return v:id() == window:id()
        end,
        {"v", "k"}
      )
    end,
    jxa_window_index = function(window)
      return getViaOSA("js", 
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
      return getViaOSA("js", 
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
      return getViaOSA("js", 
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
      return env.MCHATS .. "/" .. transf.string.lowercase(app_name)
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
      return runJSON("pandoc -f biblatex -t csljson" .. transf.string.here_string(str))
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
      return table.concat(
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
      if isList(csl_table_or_csl_table_array) then
        return transf.csl_table_array.url_array(csl_table_or_csl_table_array)
      else
        return {transf.csl_table.url(csl_table_or_csl_table_array)}
      end
    end,
  },
  csl_table = {
    main_title = function(csl_table)
      return get.assoc_arr.first_matching_value_for_keys(csl_table, mt._list.csl_title_keys)
    end,
    issued_date_parts_single_or_range = function(csl_table)
      return csl_table.issued
    end,
    issued_rf3339like_dt_or_range = function(csl_table)
      return transf.date_parts_single_or_range.rf3339like_dt_or_range(
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
      return table.concat(
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
      return slice(
        transf.csl_table.author_last_name_array(csl_table),
        { stop = 5, sliced_indicator = "et_al" }
      )
    end,
    authors_et_al_string = function(csl_table)
      return table.concat(
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
      return slice(
        table.concat(
          {
            transf.csl_table.authors_et_al_string(csl_table),
            get.csl_table.key_year_force_first(csl_table, "issued"),
            transf.csl_table.main_title_filenamized(csl_table)
          },
          "__"
        ),
        { stop = 200 } -- max 255 chars filename and needs some room for the citatable object id
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
    page_range_specifier = function(csl_table)
      return transf.single_value_or_basic_range_string.range_specifier(
        transf.csl_table.page(csl_table)
      )
    end,
    indicated_page_stirng = function(csl_table)
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
      return transf.not_userdata_or_function.md5(transf.csl_table.url(csl_table))
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
      return transf.string.urlencoded(transf.csl_table.citable_object_id(csl_table))
    end,
    filename_safe_indicated_citable_object_id = function(csl_table)
      return transf.string.urlencoded(transf.csl_table.indicated_citable_object_id(csl_table))
    end,
    citable_filename = function(csl_table)
      return 
        transf.csl_table.filename(csl_table) ..
        "!citid:" .. transf.csl_table.filename_safe_indicated_citable_object_id(csl_table)
    end,
    bib_string = function(csl_table)
      return run(
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
      return table.concat(
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
      return table.concat(date_parts, "-")
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
    rfc3339like_range = function(date_parts_range)
      return transf.date_parts.rfc3339like_dt(date_parts_range[1]) .. "_to_" .. transf.date_parts.rfc3339like_dt(date_parts_range[2])
    end,
    date_range_specifier = function(date_parts_range)
      return {
        start = transf.date_parts_single.full_full_date_component_name_value_dict(date_parts_range[1]),
        stop = transf.date_parts_single.full_full_date_component_name_value_dict(date_parts_range[2]),
        step = 1,
        unit = "day"
      }
    end
  },
  date_parts_single_or_range = {
    rf3339like_dt_or_range = function(date_parts)
      if #date_parts == 1 then
        return transf.date_parts_single.rfc3339like_dt(date_parts[1])
      else
        return transf.date_parts_range.rfc3339like_range(date_parts)
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
    ensure_scheme = function(url)
      if is.url.has_scheme(url) then
        return url
      else
        return "https://" .. url
      end
    end,
    in_wayback_machine = function(url)
      return "https://web.archive.org/web/*/" .. transf.url.ensure_scheme(url)
    end,
    default_negotiation_url_contents = function(url)
      return memoize(run, refstore.params.memoize.opts.invalidate_1_day_fs, "run")
          "curl -L" .. transf.string.single_quoted_escaped(url)
    end,
    in_cache_dir = function(url)
      return transf.not_userdata_or_function.in_cache_dir(transf.url.ensure_scheme(url), "url")
    end,
    url_table = function(url)
      return memoize(urlparse)(transf.url.ensure_scheme(url))
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
        for _, param_part in ipairs(param_parts) do
          local param_parts = stringy.split(param_part, "=")
          local key = param_parts[1]
          local value = param_parts[2]
          params[key] = transf.string.urldecoded(value)
        end
      end
      return params
    end,
    no_scheme = function(url)
      local parts = stringy.split(url, ":")
      table.remove(parts, 1)
      local rejoined = table.concat(parts, ":")
      return mustNotStart(rejoined, "//")
    end,
    vdirsyncer_pair_specifier = function(url)
      local name = "webcal_readonly_" .. transf.not_userdata_or_function.md5(url)
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
    url_potentially_with_title_comment = function(url)
      local title = transf.html_url.title(url)
      if title and title ~= "" then
        return url .. " # " .. title
      else
        return url
      end
    end,
    title_or_url_as_filename = function(url)
      local title = transf.html_url.title(url)
      if title and title ~= "" then
        return transf.string.safe_filename(title) .. ".url2"
      else
        return transf.string.safe_filename(url) .. ".url2"
      end
    end,

  },
  html_url = {
    html_string = transf.url.default_negotiation_url_contents, -- ideally we would reject non-html responses, but currently, that's too much work
    title = function(url)
      return get.html_url.text_query_selector_all(url, "title")
    end,
    html_url_with_title_comment = function(url)
      return url .. " # " .. transf.html_url.title(url)
    end
  },
  owner_item_url = {
    owner_item = function(url)
      return eutf8.match(transf.url.path(url), "^/([^/]+[^/]+)")
    end,
  },
  github_url = {

  },
  whisper_url = {
    transcribed = function(url)
      local path = transf.url.in_cache_dir(url)
      dothis.url.download(url, path)
      return transf.audio_file.transcribed(path)

    end
  },
  image_url = {
    booru_url = function(url)
      return run(
        "saucenao --url" ..
        transf.string.single_quoted_escaped(url)
        .. "--output-properties booru-url"
      )
    end,
    hs_image = function(url)
      return memoize(hs.image.imageFromURL, refstore.params.memoize.opts.invalidate_1_week_fs, "hs.image.imageFromURL")(url)
    end,
    qr_data = function(url)
      local path = transf.url.in_cache_dir(url)
      dothis.url.download(url, path)
      return transf.image_file.qr_data(path)
    end,
    data_url = function(url)
      local ext = transf.path.extension(url)
      return memoize(hs.image.encodeAsURLString)(transf.image_url.hs_image(url), ext)
    end,
  },
  gpt_response_table = {
    response_text = function(result)
      local first_choice = result.choices[1]
      local response = first_choice.text or first_choice.message.content
      return stringy.strip(response)
    end
  },
  not_userdata_or_function = {
    md5 = function(thing)
      if type(thing) ~= "string" then 
        thing = json.encode(thing) 
      end
      local md5 = hashings("md5")
      md5:update(thing)
      return md5:hexdigest()
    end,
    in_cache_dir = function(data, type)
      return transf.string.in_cache_dir(
        transf.not_userdata_or_function.md5(data),
        type
      )
    end,
    in_tmp_dir = function(data, type)
      return transf.string.in_tmp_dir(
        transf.not_userdata_or_function.md5(data),
        type
      )
    end,
    single_quoted_escaped_json = function(t)
      return transf.string.single_quoted_escaped(json.encode(t))
    end,
    json_string = json.encode,
    --- wraps yaml.dump into a more intuitive form which always encodes a single document
    --- @param tbl any
    --- @return string
    yaml_string = function(tbl)
      local raw_yaml = yaml.dump({tbl})
      local lines = stringy.split(raw_yaml, "\n")
      return table.concat(lines, "\n", 2, #lines - 2)
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
    end
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
    subject = function(tel_url)
      return transf.url.param_table(tel_url).subject 
    end,
    body = function(tel_url)
      return transf.url.param_table(tel_url).body 
    end,
    cc = function(tel_url)
      return transf.url.param_table(tel_url).cc 
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
      for _, part in ipairs(parts) do
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
      return mustNotStart(transf.url.no_scheme(data_url), transf.data_url.header_part(data_url))
    end,
      
    raw_type_param_table = function(data_url)
      local parts = stringy.split(transf.data_url.header_part(data_url), ";")
      table.remove(parts, 1) -- this is the content type
      table.remove(parts, #parts) -- this is the base64, or ""
      return memoize(map)(parts, function(part)
        local kv = stringy.split(part, "=")
        return kv[1], kv[2]
      end, {"v", "kv"})
    end
  },
  source_id = {
    language = function(source_id)
      return slice(stringy.split(source_id, "."), -1, -1)[1]
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
      return join.mod_array.key.shortcut_string(
        transf.menu_item_table.mod_name_array(menu_item_table),
        transf.menu_item_table.hotkey(menu_item_table)
      )
    end,
    title = function(menu_item_table)
      return menu_item_table.AXTitle
    end,
    full_action_path = function(menu_item_table)
      return glue(menu_item_table.path, menu_item_table.AXTitle)
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
      return memoize(map, refstore.params.memoize.opts.stringify_json)(mod_array, transf.mod.mod_symbol)
    end,
    mod_char_array = function(mod_array)
      return memoize(map, refstore.params.memoize.opts.stringify_json)(mod_array, transf.mod.mod_char)
    end,
    mod_name_array = function(mod_array)
      return memoize(map, refstore.params.memoize.opts.stringify_json)(mod_array, transf.mod.mod_name)
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
      local files = transf.dir.descendant_file_array(env_yaml_file_container)
      local yaml_files = get.path_array.filter_to_same_extension(files, "yaml")
      local env_var_name_env_node_dict_array = hs.fnutils.imap(
        yaml_files,
        transf.yaml_file.not_userdata_or_function
      )
      local env_var_name_env_node_dict = concat(env_var_name_env_node_dict_array)
      return transf.env_var_name_env_node_dict.env_string(env_var_name_env_node_dict)
    end,
  },
  country_identifier_string = {
    iso_3366_1_alpha_2 = function(country_identifier)
      return get.string.deterministic_gpt_transformation(
        country_identifier, 
        "Suppose the following identifies a country. Return its ISO 3166-1 Alpha-2 country code."
      ):lower()
    end,
  },
  language_identifier_string = {
    bcp_47_language_tag = function(country_identifier)
      return get.string.deterministic_gpt_transformation(
        country_identifier, 
        "Suppose the following identifies a language or variety. Return its BCP 47 language tag. Be conservative and only add information that is present in the input, or is necessary to make it into a valid BCP 47 language tag."
      )
    end,
  },
  bcp_47_language_tag = {
    summary = function(bcp_47_language_tag)
      return get.string.deterministic_gpt_transformation(
        bcp_47_language_tag, 
        "Suppose the following is a BCP 47 language tag. Return a natural language description of it."
      )
    end,
  },
  iso_3366_1_alpha_2 = {
    iso_3366_1_full_name = function(iso_3366_1_alpha_2)
      return get.string.deterministic_gpt_transformation(
        iso_3366_1_alpha_2, 
        "Get the ISO 3366-1 full name of the country identified by the following ISO 3366-1 Alpha-2 country code."
      )
    end,
    iso_3366_1_short_name = function(iso_3366_1_alpha_2)
      return get.string.deterministic_gpt_transformation(
        iso_3366_1_alpha_2, 
        "Get the ISO 3366-1 short name of the country identified by the following ISO 3366-1 Alpha-2 country code."
      )
    end,
  }
}
